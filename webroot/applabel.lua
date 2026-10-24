local M = {}

M.CACHE_FILE    = "/data/adb/modules/dex_optimizer/webroot/labels.cache"
M.FRAMEWORK_APK = "/system/framework/framework-res.apk"
M.STATE_FILE     = "/data/adb/modules/dex_optimizer/webroot/labels.state"
M.SYNC_MIN_GAP  = 120
M.SYNC_STALE    = 60

local MAX_MANIFEST = 8 * 1024 * 1024
local MAX_INFLATE  = 24 * 1024 * 1024
local MAX_LABEL    = 120

local byte, char, sub, concat = string.byte, string.char, string.sub, table.concat
local floor, min = math.floor, math.min
local unpack = table.unpack or unpack

local function u16s(s, i)
  local a, b = byte(s, i, i + 1)
  if not b then error("eof") end
  return a + b * 256
end

local function u32s(s, i)
  local a, b, c, d = byte(s, i, i + 3)
  if not d then error("eof") end
  return a + b * 256 + c * 65536 + d * 16777216
end

local function memsrc(str)
  local n = #str
  return {
    size = n,
    get = function(off, len)
      if off < 0 or len < 0 or off + len > n then return nil end
      return sub(str, off + 1, off + len)
    end,
  }
end

local function filesrc(f, base, size)
  return {
    size = size,
    get = function(off, len)
      if off < 0 or len < 0 or off + len > size then return nil end
      f:seek("set", base + off)
      return f:read(len)
    end,
  }
end

local function need(src, off, len)
  local s = src.get(off, len)
  if not s or #s < len then error("eof") end
  return s
end

local function R8(src, off)  return byte(need(src, off, 1)) end
local function R16(src, off) return u16s(need(src, off, 2), 1) end
local function R32(src, off) return u32s(need(src, off, 4), 1) end

local pow2 = {}
for i = 0, 24 do pow2[i] = 2 ^ i end

local LBASE = {3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258}
local LEXT  = {0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0}
local DBASE = {1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577}
local DEXT  = {0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13}
local CLORDER = {16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15}

local function construct(length, n)
  local count = {}
  for l = 0, 15 do count[l] = 0 end
  for s = 0, n - 1 do count[length[s]] = count[length[s]] + 1 end
  local offs = { [1] = 0 }
  for l = 1, 14 do offs[l + 1] = offs[l] + count[l] end
  local symbol = {}
  for s = 0, n - 1 do
    local l = length[s]
    if l ~= 0 then symbol[offs[l]] = s; offs[l] = offs[l] + 1 end
  end
  return { count = count, symbol = symbol }
end

local fixed_len, fixed_dist
local function fixed_tables()
  if not fixed_len then
    local l = {}
    for i = 0, 143 do l[i] = 8 end
    for i = 144, 255 do l[i] = 9 end
    for i = 256, 279 do l[i] = 7 end
    for i = 280, 287 do l[i] = 8 end
    fixed_len = construct(l, 288)
    local d = {}
    for i = 0, 29 do d[i] = 5 end
    fixed_dist = construct(d, 30)
  end
  return fixed_len, fixed_dist
end

local function inflate(s, maxout)
  local ip, bitbuf, bitcnt = 1, 0, 0
  local out, on = {}, 0

  local function getbit()
    if bitcnt == 0 then
      local b = byte(s, ip)
      if not b then error("inflate: eof") end
      ip = ip + 1; bitbuf = b; bitcnt = 8
    end
    local b = bitbuf % 2
    bitbuf = (bitbuf - b) / 2
    bitcnt = bitcnt - 1
    return b
  end

  local function bits(n)
    local v = 0
    for i = 0, n - 1 do v = v + getbit() * pow2[i] end
    return v
  end

  local function decode(h)
    local count, symbol = h.count, h.symbol
    local code, first, index = 0, 0, 0
    for len = 1, 15 do
      code = code + getbit()
      local c = count[len]
      if code - c < first then return symbol[index + (code - first)] end
      index = index + c
      first = (first + c) * 2
      code = code * 2
    end
    error("inflate: bad code")
  end

  local function codes(lencode, distcode)
    while true do
      local sym = decode(lencode)
      if sym == nil then error("inflate: bad symbol") end
      if sym < 256 then
        on = on + 1; out[on] = sym
      elseif sym == 256 then
        return
      else
        sym = sym - 257
        if sym >= 29 then error("inflate: bad length") end
        local len = LBASE[sym + 1] + bits(LEXT[sym + 1])
        local ds = decode(distcode)
        if ds == nil or ds >= 30 then error("inflate: bad dist") end
        local dist = DBASE[ds + 1] + bits(DEXT[ds + 1])
        if dist > on then error("inflate: dist too far") end
        for i = 1, len do out[on + i] = out[on + i - dist] end
        on = on + len
      end
      if on > maxout then error("inflate: too big") end
    end
  end

  repeat
    local last = getbit()
    local typ = bits(2)
    if typ == 0 then
      bitcnt = 0; bitbuf = 0
      local len, nlen = u16s(s, ip), u16s(s, ip + 2)
      if len + nlen ~= 65535 then error("inflate: bad stored") end
      ip = ip + 4
      for i = 0, len - 1 do
        local b = byte(s, ip + i)
        if not b then error("inflate: eof") end
        out[on + 1 + i] = b
      end
      ip = ip + len; on = on + len
      if on > maxout then error("inflate: too big") end
    elseif typ == 1 then
      local lc, dc = fixed_tables()
      codes(lc, dc)
    elseif typ == 2 then
      local nlen = bits(5) + 257
      local ndist = bits(5) + 1
      local ncode = bits(4) + 4
      local lengths = {}
      for i = 0, 18 do lengths[i] = 0 end
      for i = 1, ncode do lengths[CLORDER[i]] = bits(3) end
      local clcode = construct(lengths, 19)
      local ll, idx = {}, 0
      while idx < nlen + ndist do
        local sym = decode(clcode)
        if sym < 16 then
          ll[idx] = sym; idx = idx + 1
        else
          local len, rep = 0, 0
          if sym == 16 then
            if idx == 0 then error("inflate: no previous length") end
            len = ll[idx - 1]; rep = 3 + bits(2)
          elseif sym == 17 then
            rep = 3 + bits(3)
          else
            rep = 11 + bits(7)
          end
          for _ = 1, rep do ll[idx] = len; idx = idx + 1 end
        end
      end
      local dl = {}
      for i = 0, ndist - 1 do dl[i] = ll[nlen + i] end
      codes(construct(ll, nlen), construct(dl, ndist))
    else
      error("inflate: bad block type")
    end
  until last == 1

  local parts = {}
  for i = 1, on, 4096 do
    parts[#parts + 1] = char(unpack(out, i, min(i + 4095, on)))
  end
  return concat(parts)
end

M._inflate = inflate

local function zip_parse(f)
  local z = { f = f }
  local fsize = f:seek("end")
  local tlen = min(fsize, 65557)
  f:seek("set", fsize - tlen)
  local tail = f:read(tlen)
  local pos
  for i = #tail - 21, 1, -1 do
    if sub(tail, i, i + 3) == "PK\5\6" then pos = i; break end
  end
  if not pos then error("no eocd") end
  local total  = u16s(tail, pos + 10)
  local cdsize = u32s(tail, pos + 12)
  local cdoff  = u32s(tail, pos + 16)
  f:seek("set", cdoff)
  local cd = f:read(cdsize)
  local entries, p = {}, 1
  for _ = 1, total do
    if sub(cd, p, p + 3) ~= "PK\1\2" then break end
    local nl, el, cl = u16s(cd, p + 28), u16s(cd, p + 30), u16s(cd, p + 32)
    local name = sub(cd, p + 46, p + 45 + nl)
    if name == "AndroidManifest.xml" or name == "resources.arsc" then
      entries[name] = {
        method = u16s(cd, p + 10),
        csize  = u32s(cd, p + 20),
        usize  = u32s(cd, p + 24),
        loff   = u32s(cd, p + 42),
      }
    end
    p = p + 46 + nl + el + cl
  end
  z.entries = entries
  return z
end

local function zip_open(path)
  local f = io.open(path, "rb")
  if not f then error("open failed") end
  local ok, z = pcall(zip_parse, f)
  if not ok then f:close(); error(z, 0) end
  return z
end

local function zip_data_start(z, e)
  z.f:seek("set", e.loff)
  local lh = z.f:read(30)
  if not lh or sub(lh, 1, 4) ~= "PK\3\4" then error("bad local header") end
  return e.loff + 30 + u16s(lh, 27) + u16s(lh, 29)
end

local function zip_string(z, name, limit)
  local e = z.entries[name]
  if not e then return nil end
  if e.usize > limit then error("entry too big") end
  local ds = zip_data_start(z, e)
  z.f:seek("set", ds)
  if e.method == 0 then
    return z.f:read(e.usize)
  elseif e.method == 8 then
    return inflate(z.f:read(e.csize), limit)
  end
  error("unsupported zip method")
end

local function zip_source(z, name)
  local e = z.entries[name]
  if not e then return nil end
  if e.method == 0 then
    return filesrc(z.f, zip_data_start(z, e), e.usize)
  end
  return memsrc(zip_string(z, name, MAX_INFLATE))
end

local function utf8enc(c)
  if c < 0x80 then return char(c)
  elseif c < 0x800 then return char(192 + floor(c / 64), 128 + c % 64)
  elseif c < 0x10000 then
    return char(224 + floor(c / 4096), 128 + floor(c / 64) % 64, 128 + c % 64)
  end
  return char(240 + floor(c / 262144), 128 + floor(c / 4096) % 64,
              128 + floor(c / 64) % 64, 128 + c % 64)
end

local function utf16le_to_utf8(s)
  local out, i, n = {}, 1, #s
  while i < n do
    local c = byte(s, i) + byte(s, i + 1) * 256
    i = i + 2
    if c >= 0xD800 and c < 0xDC00 and i < n then
      local d = byte(s, i) + byte(s, i + 1) * 256
      if d >= 0xDC00 and d < 0xE000 then
        c = 0x10000 + (c - 0xD800) * 1024 + (d - 0xDC00)
        i = i + 2
      end
    end
    out[#out + 1] = utf8enc(c)
  end
  return concat(out)
end

local function pool_info(src, off)
  local flags = R32(src, off + 16)
  return {
    off    = off,
    count  = R32(src, off + 8),
    utf8   = floor(flags / 256) % 2 == 1,
    sstart = R32(src, off + 20),
    cache  = {},
  }
end

local function pool_get(src, pool, idx)
  if idx < 0 or idx >= pool.count then return nil end
  local c = pool.cache[idx]
  if c ~= nil then return c or nil end
  local o = R32(src, pool.off + 28 + idx * 4)
  local p = pool.off + pool.sstart + o
  local res
  if pool.utf8 then
    local h = need(src, p, 4)
    local cl = (byte(h, 1) >= 128) and 2 or 1
    local f = byte(h, cl + 1)
    local bl, blen
    if f >= 128 then bl = 2; blen = (f - 128) * 256 + byte(h, cl + 2)
    else bl = 1; blen = f end
    res = need(src, p + cl + bl, blen)
  else
    local l = R16(src, p)
    local hdr = 2
    if l >= 0x8000 then
      l = (l - 0x8000) * 65536 + R16(src, p + 2)
      hdr = 4
    end
    if l > 4096 then l = 4096 end
    res = utf16le_to_utf8(need(src, p + hdr, l * 2))
  end
  pool.cache[idx] = res
  return res
end

local RES_LABEL = 0x01010001
local RES_NAME  = 0x01010003

local function parse_manifest(m)
  local src = memsrc(m)
  local pool, resmap
  local pos, fsize = 8, #m
  local app_label, launcher_label
  local in_activity, act_label = false, nil

  local function str(i) return pool and pool_get(src, pool, i) or nil end

  local function attr_kind(nameidx)
    local rid = resmap and resmap[nameidx]
    if rid and rid ~= 0 then
      if rid == RES_LABEL then return "label" end
      if rid == RES_NAME then return "name" end
      return nil
    end
    local n = str(nameidx)
    if n == "label" or n == "name" then return n end
    return nil
  end

  local function value_of(a)
    local dtype, data = byte(m, a + 16), u32s(m, a + 17)
    if dtype == 3 then
      local s = str(data)
      if s then return { kind = "string", text = s } end
    elseif dtype == 1 then
      return { kind = "ref", id = data }
    end
    return nil
  end

  while pos + 8 <= fsize do
    local ctype, csize = u16s(m, pos + 1), u32s(m, pos + 5)
    if csize < 8 then break end
    if ctype == 0x0001 then
      if not pool then pool = pool_info(src, pos) end
    elseif ctype == 0x0180 then
      resmap = {}
      local hs = u16s(m, pos + 3)
      for i = 0, floor((csize - hs) / 4) - 1 do
        resmap[i] = u32s(m, pos + hs + i * 4 + 1)
      end
    elseif ctype == 0x0102 and pool then
      local ename = str(u32s(m, pos + 21))
      local astart = u16s(m, pos + 25)
      local asize  = u16s(m, pos + 27)
      local acount = u16s(m, pos + 29)
      local label, nm
      for i = 0, acount - 1 do
        local a = pos + 16 + astart + i * asize
        local k = attr_kind(u32s(m, a + 5))
        if k == "label" then label = value_of(a)
        elseif k == "name" then nm = value_of(a) end
      end
      if ename == "application" then
        app_label = label
      elseif ename == "activity" or ename == "activity-alias" then
        in_activity, act_label = true, label
      elseif ename == "category" and in_activity then
        if nm and nm.kind == "string" and nm.text == "android.intent.category.LAUNCHER"
           and act_label and not launcher_label then
          launcher_label = act_label
        end
      end
    elseif ctype == 0x0103 and pool then
      local ename = str(u32s(m, pos + 21))
      if ename == "activity" or ename == "activity-alias" then in_activity = false end
    end
    pos = pos + csize
  end
  return app_label or launcher_label
end

local ALIAS = { he = "iw", iw = "he", id = "in", ["in"] = "id", yi = "ji", ji = "yi" }

local function config_score(src, off, lang, country)
  local size = R32(src, off)
  local c = need(src, off, min(size, 52))
  local n = #c
  local function nz(a, b)
    for i = a + 1, min(b, n) do
      if byte(c, i) ~= 0 then return true end
    end
    return false
  end

  if nz(4, 8) or nz(12, 24) or nz(28, 36) or nz(40, 48) then return nil end
  local score = 10
  local l1, l2 = byte(c, 9), byte(c, 10)
  local c1, c2 = byte(c, 11), byte(c, 12)
  if l1 ~= 0 or l2 ~= 0 then
    if l1 >= 128 then return nil end
    local cl = char(l1, l2)
    if cl ~= lang and ALIAS[lang] ~= cl then
      if cl ~= "en" then return nil end
      return 4
    end
    score = 50
    if c1 ~= 0 or c2 ~= 0 then
      if char(c1, c2) == country then score = 100 else return nil end
    end
  elseif c1 ~= 0 or c2 ~= 0 then
    return nil
  end
  if nz(36, 40) then return nil end
  return score
end

local function parse_arsc(src)
  local a = { src = src, packages = {} }
  local pos = R16(src, 2)
  while pos + 8 <= src.size do
    local h = need(src, pos, 8)
    local ctype, chs, csize = u16s(h, 1), u16s(h, 3), u32s(h, 5)
    if csize < 8 then break end
    if ctype == 0x0001 then
      if not a.gpool then a.gpool = pool_info(src, pos) end
    elseif ctype == 0x0200 then
      a.packages[R32(src, pos + 8)] = { off = pos, hs = chs, size = csize }
    end
    pos = pos + csize
  end
  return a
end

local function arsc_value(a, id, lang, country)
  local src = a.src
  local pkg = a.packages[floor(id / 16777216)]
  if not pkg then return nil end
  local type_id = floor(id / 65536) % 256
  local entry = id % 65536
  local best, best_score
  local p, pend = pkg.off + pkg.hs, pkg.off + pkg.size
  while p + 8 <= pend do
    local h = need(src, p, 8)
    local ctype, chs, csize = u16s(h, 1), u16s(h, 3), u32s(h, 5)
    if csize < 8 then break end
    if ctype == 0x0201 and R8(src, p + 8) == type_id then
      local flags  = R8(src, p + 9)
      local ecount = R32(src, p + 12)
      local estart = R32(src, p + 16)
      local score = config_score(src, p + 20, lang, country)
      if score and (not best_score or score > best_score) then
        local eoff
        if flags % 2 == 1 then
          local arr = need(src, p + chs, ecount * 4)
          for i = 0, ecount - 1 do
            if u16s(arr, i * 4 + 1) == entry then
              eoff = u16s(arr, i * 4 + 3) * 4
              break
            end
          end
        elseif floor(flags / 2) % 2 == 1 then
          if entry < ecount then
            local v = R16(src, p + chs + entry * 2)
            if v ~= 0xFFFF then eoff = v * 4 end
          end
        elseif entry < ecount then
          local v = R32(src, p + chs + entry * 4)
          if v ~= 0xFFFFFFFF then eoff = v end
        end
        if eoff then
          local epos = p + estart + eoff
          local e = need(src, epos, 8)
          local esize, eflags = u16s(e, 1), u16s(e, 3)
          if eflags % 2 == 0 and floor(eflags / 8) % 2 == 0 then
            local v = need(src, epos + esize, 8)
            best_score = score
            best = { dtype = byte(v, 4), data = u32s(v, 5) }
          end
        end
      end
    end
    p = p + csize
  end
  if not best then return nil end
  if best.dtype == 3 and a.gpool then
    local s = pool_get(src, a.gpool, best.data)
    if s then return "string", s end
  elseif best.dtype == 1 then
    return "ref", best.data
  end
  return nil
end

local function resolve_ref(ctx, id)
  for _ = 1, 6 do
    local a = ctx.arsc_for(floor(id / 16777216))
    if not a then return nil end
    local kind, v = arsc_value(a, id, ctx.lang, ctx.country)
    if kind == "string" then return v end
    if kind ~= "ref" then return nil end
    id = v
  end
  return nil
end

local function clean(s)
  if not s then return nil end
  s = s:gsub("%c", " "):gsub("^%s+", ""):gsub("%s+$", "")
  if s == "" then return nil end
  if #s > MAX_LABEL then s = sub(s, 1, MAX_LABEL) end
  return s
end

function M.label_from_apk(path, lang, country)
  lang, country = lang or "en", country or ""
  local opened = {}
  local function close_all()
    for _, z in ipairs(opened) do pcall(function() z.f:close() end) end
  end

  local ok, res = pcall(function()
    local z = zip_open(path); opened[#opened + 1] = z
    local manifest = zip_string(z, "AndroidManifest.xml", MAX_MANIFEST)
    if not manifest then return nil end
    local desc = parse_manifest(manifest)
    if not desc then return nil end
    if desc.kind == "string" then return clean(desc.text) end

    local app_arsc, fw_arsc
    local ctx = { lang = lang, country = country }
    ctx.arsc_for = function(pkg_id)
      if app_arsc == nil then
        local src = zip_source(z, "resources.arsc")
        app_arsc = src and parse_arsc(src) or false
      end
      if app_arsc and app_arsc.packages[pkg_id] then return app_arsc end
      if pkg_id == 1 then
        if fw_arsc == nil then
          local okf, fz = pcall(zip_open, M.FRAMEWORK_APK)
          if okf then
            opened[#opened + 1] = fz
            local src = zip_source(fz, "resources.arsc")
            fw_arsc = src and parse_arsc(src) or false
          else
            fw_arsc = false
          end
        end
        if fw_arsc and fw_arsc.packages[1] then return fw_arsc end
      end
      return nil
    end
    return clean(resolve_ref(ctx, desc.id))
  end)
  close_all()
  if ok then return res end
  return nil, tostring(res)
end

function M.device_locale()
  local cmds = { "getprop persist.sys.locale", "getprop ro.product.locale",
                 "settings get system system_locales" }
  for _, cmd in ipairs(cmds) do
    local h = io.popen(cmd .. " 2>/dev/null")
    if h then
      local s = h:read("*l")
      h:close()
      if s and s ~= "" and s ~= "null" then
        local first = s:match("^[^,]+")
        local lang = first and first:match("^(%a%a%a?)")
        if lang then
          local country = ""
          for part in first:gmatch("[-_](%a+)") do
            if #part == 2 and part == part:upper() then country = part; break end
          end
          return lang:lower(), country
        end
      end
    end
  end
  return "en", ""
end

local function file_size(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local n = f:seek("end")
  f:close()
  return n
end

local function load_cache(file)
  local cache = {}
  local f = io.open(file, "r")
  if not f then return cache end
  for line in f:lines() do
    local pkg, loc, size, path, label = line:match("^([^\t]+)\t([^\t]*)\t(%d+)\t([^\t]+)\t(.*)$")
    if pkg then cache[pkg] = { loc = loc, size = tonumber(size), path = path, label = label } end
  end
  f:close()
  return cache
end

local function save_cache(file, cache)
  local tmp = file .. ".tmp"
  local f = io.open(tmp, "w")
  if not f then return end
  for pkg, e in pairs(cache) do
    f:write(pkg, "\t", e.loc, "\t", tostring(e.size), "\t", e.path, "\t", e.label, "\n")
  end
  f:close()
  os.rename(tmp, file)
end

local function save_merged(file, updates, removed)
  local cur = load_cache(file)
  for pkg in pairs(removed or {}) do cur[pkg] = nil end
  for pkg, e in pairs(updates or {}) do cur[pkg] = e end
  save_cache(file, cur)
end

local function list_paths()
  local paths = {}
  local h = io.popen("pm list packages -f 2>/dev/null")
  if not h then return paths end
  for line in h:lines() do
    local path, pkg = line:match("^package:(.*)=([^=]+)$")
    if path then paths[pkg] = path end
  end
  h:close()
  return paths
end

function M.resolve(pkgs, opts)
  opts = opts or {}
  local lang, country = opts.lang, opts.country
  if not lang then lang, country = M.device_locale() end
  local loc = lang .. "-" .. (country or "")
  local file = opts.cache_file or M.CACHE_FILE

  local cache = load_cache(file)
  local result, misses = {}, {}
  for _, pkg in ipairs(pkgs) do
    local e = cache[pkg]
    if e and e.loc == loc and file_size(e.path) == e.size then
      if e.label ~= "" then result[pkg] = e.label end
    else
      misses[#misses + 1] = pkg
    end
  end

  if #misses > 0 then
    local paths = opts.paths or list_paths()
    local deadline = os.time() + (opts.budget or 12)
    local updates, dirty = {}, false
    for _, pkg in ipairs(misses) do
      if os.time() > deadline then break end
      local path = paths[pkg]
      local size = path and file_size(path)
      if size then
        local label = M.label_from_apk(path, lang, country)
        updates[pkg] = { loc = loc, size = size, path = path, label = label or "" }
        dirty = true
        if label then result[pkg] = label end
      end
    end
    if dirty then save_merged(file, updates, nil) end
  end
  return result
end

local function now() return os.time() end

local function read_state()
  local f = io.open(M.STATE_FILE, "r")
  if not f then return "idle", 0 end
  local line = f:read("*l") or ""
  f:close()
  local kind, ts = line:match("^(%a+)\t(%d+)$")
  return kind or "idle", tonumber(ts) or 0
end

local function write_state(kind)
  local f = io.open(M.STATE_FILE, "w")
  if f then f:write(kind, "\t", tostring(now()), "\n"); f:close() end
end

function M.sync_state()
  local kind, ts = read_state()
  if kind == "running" then
    if now() - ts < M.SYNC_STALE then return { running = true, last = 0 } end
    return { running = false, last = 0 }
  end
  return { running = false, last = ts }
end

function M.begin_sync(force)
  local st = M.sync_state()
  if st.running then return false end
  if not force and st.last > 0 and now() - st.last < M.SYNC_MIN_GAP then return false end
  write_state("running")
  return true
end

function M.sync(opts)
  opts = opts or {}
  local yield = opts.yield or function() end
  local file = opts.cache_file or M.CACHE_FILE
  local ok, err = pcall(function()
    local lang, country = opts.lang, opts.country
    if not lang then lang, country = M.device_locale() end
    local loc = lang .. "-" .. (country or "")
    local paths = opts.paths or list_paths()
    if next(paths) == nil then return end

    local cache = load_cache(file)
    local updates, removed, todo = {}, {}, {}
    for pkg in pairs(cache) do
      if not paths[pkg] then removed[pkg] = true end
    end
    for pkg, path in pairs(paths) do
      local e = cache[pkg]
      if not e then
        updates[pkg] = { loc = "", size = 0, path = path, label = "" }
        todo[#todo + 1] = pkg
      elseif not (e.loc == loc and e.size > 0 and e.path == path and file_size(path) == e.size) then
        todo[#todo + 1] = pkg
      end
    end
    if next(updates) or next(removed) then
      save_merged(file, updates, removed)
      updates, removed = {}, {}
    end
    table.sort(todo, function(a, b)
      local ua = paths[a]:find("^/data/app") and 0 or 1
      local ub = paths[b]:find("^/data/app") and 0 or 1
      if ua ~= ub then return ua < ub end
      return a < b
    end)

    local pending = 0
    for _, pkg in ipairs(todo) do
      local path = paths[pkg]
      local size = file_size(path)
      if size then
        local label = M.label_from_apk(path, lang, country)
        updates[pkg] = { loc = loc, size = size, path = path, label = label or "" }
        pending = pending + 1
      end
      write_state("running")
      if pending >= 15 then
        save_merged(file, updates, nil); updates, pending = {}, 0
      end
      yield()
    end
    if next(updates) then save_merged(file, updates, nil) end
  end)
  write_state("idle")
  return ok, (not ok) and tostring(err) or nil
end

function M.index(cache_file)
  local cache = load_cache(cache_file or M.CACHE_FILE)
  local list = {}
  for pkg, e in pairs(cache) do list[#list + 1] = { pkg, e.label } end
  table.sort(list, function(a, b) return a[1] < b[1] end)
  return list
end

function M.index_json(cache_file, syncing)
  local function esc(str)
    return (str:gsub('[%c"\\]', function(c)
      if c == '"' then return '\\"' end
      if c == "\\" then return "\\\\" end
      return string.format("\\u%04x", byte(c))
    end))
  end
  local parts = {}
  for _, it in ipairs(M.index(cache_file)) do
    parts[#parts + 1] = '["' .. esc(it[1]) .. '","' .. esc(it[2]) .. '"]'
  end
  return '{"syncing":' .. (syncing and "true" or "false") .. ',"apps":[' .. concat(parts, ",") .. ']}'
end

function M.matches(pkgs, query, cache_file)
  local q = (query or ""):lower()
  local cache = load_cache(cache_file or M.CACHE_FILE)
  local out = {}
  for _, pkg in ipairs(pkgs) do
    local e = cache[pkg]
    local label = e and e.label or ""
    if pkg:lower():find(q, 1, true)
       or (label ~= "" and (label:lower():find(q, 1, true) or label:find(query, 1, true))) then
      out[#out + 1] = pkg
    end
  end
  return out
end

function M.to_json(map)
  local function esc(s)
    return (s:gsub('[%c"\\]', function(c)
      if c == '"' then return '\\"' end
      if c == "\\" then return "\\\\" end
      return string.format("\\u%04x", byte(c))
    end))
  end
  local parts = {}
  for k, v in pairs(map) do
    parts[#parts + 1] = '"' .. esc(k) .. '":"' .. esc(v) .. '"'
  end
  table.sort(parts)
  return "{" .. concat(parts, ",") .. "}"
end

return M
