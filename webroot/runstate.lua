local M = {}

M.LOCK_DIR = "/data/adb/modules/dex_optimizer/webroot/.run.lock"
M.LOG_FILE = "/data/adb/modules/dex_optimizer/webroot/script_logs.out"
M.BOOT_ID  = "/proc/sys/kernel/random/boot_id"
M.PROC     = "/proc"

local function first_line(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*l")
  f:close()
  return s
end

local function exists(path)
  local f = io.open(path, "r")
  if f then f:close(); return true end
  return false
end

function M.state(opts)
  opts = opts or {}
  local lock = opts.lock_dir or M.LOCK_DIR
  local pid = first_line(lock .. "/pid")
  if not pid or not pid:match("^%d+$") then return { running = false } end

  local saved = first_line(lock .. "/boot")
  local now   = first_line(opts.boot_id or M.BOOT_ID)
  if saved and now and saved ~= now then return { running = false } end

  if not exists((opts.proc or M.PROC) .. "/" .. pid .. "/stat") then
    return { running = false }                 
  end

  local kind = (first_line(lock .. "/kind") or ""):match("^[%w_-]+$") or ""
  return {
    running = true,
    kind    = kind,
    since   = tonumber(first_line(lock .. "/since")) or 0,
    ready   = exists(lock .. "/ready"),
  }
end

function M.to_json(st)
  if not st.running then return '{"running":false}' end
  return string.format('{"running":true,"kind":"%s","since":%d,"ready":%s}',
    st.kind or "", st.since or 0, st.ready and "true" or "false")
end

local function log_id(f)
  f:seek("set", 0)
  local line = f:read("*l")
  if line and #line < 80 and line:sub(1, 7) == "@BEGIN|" then return line end
  return nil
end

local function unescape(s)
  return (s:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

function M.read_log(path, offset, id)
  if type(id) == "string" and id:find("%%") then id = unescape(id) end
  offset = tonumber(offset) or 0
  if offset < 0 then offset = 0 end
  local f = io.open(path or M.LOG_FILE, "rb")
  if not f then return nil, offset, false, nil end
  local size = f:seek("end")
  local lid = log_id(f)
  local reset = false
  if offset > size or (id and id ~= "" and lid and id ~= lid) then offset, reset = 0, true end
  f:seek("set", offset)
  local data = size > offset and f:read(size - offset) or ""
  f:close()
  return data, offset + #data, reset, lid
end

return M
