local http = require "resty.http"

local M = {}

M.UPDATE_URL    = "https://raw.githubusercontent.com/zerxfox/DexOptimizer/main/update.json"
M.CHANGELOG_URL = "https://raw.githubusercontent.com/zerxfox/DexOptimizer/main/changelog.md"
M.ZIP_FILE      = "/data/local/tmp/dex_optimizer.zip"

local MAX_REDIRECTS = 5

local function absolute_url(base, location)
    if location:match("^https?://") then
        return location
    end
    local origin = base:match("^(https?://[^/]+)")
    if location:sub(1, 1) == "/" then
        return origin .. location
    end
    local dir = base:match("^(https?://[^?#]*/)") or (origin .. "/")
    return dir .. location
end

function M.get(url, timeout_ms)
    for _ = 0, MAX_REDIRECTS do
        local httpc = http.new()
        httpc:set_timeout(timeout_ms or 15000)

        local res, err = httpc:request_uri(url, {
            method = "GET",
            ssl_verify = false,
            headers = { ["User-Agent"] = "DexOptimizer" },
        })
        if not res then
            return nil, err
        end

        local loc = res.headers["Location"]
        if res.status >= 300 and res.status < 400 and loc then
            url = absolute_url(url, loc)
        else
            return res
        end
    end
    return nil, "too many redirects"
end

function M.fetch_info()
    local res, err = M.get(M.UPDATE_URL, 10000)
    if not res then
        return nil, err
    end
    if res.status ~= 200 then
        return nil, "HTTP " .. res.status
    end

    local body = res.body or ""
    local version = body:match('"version"%s*:%s*"([^"]+)"')
    local zip_url = body:match('"zipUrl"%s*:%s*"([^"]+)"')
    if not version or not zip_url then
        return nil, "invalid update.json"
    end

    zip_url = zip_url:gsub("\\/", "/")
    return { version = version, zipUrl = zip_url }
end

function M.download(zip_url)
    local res, err = M.get(zip_url, 120000)
    if not res then
        return nil, err
    end
    if res.status ~= 200 then
        return nil, "HTTP " .. res.status
    end

    local body = res.body
    if not body or #body == 0 then
        return nil, "empty response"
    end
    if body:sub(1, 2) ~= "PK" then
        return nil, "not a zip file"
    end

    local tmp = M.ZIP_FILE .. ".part"
    local f, ferr = io.open(tmp, "wb")
    if not f then
        return nil, ferr
    end
    local ok, werr = f:write(body)
    f:close()
    if not ok then
        os.remove(tmp)
        return nil, werr
    end

    os.remove(M.ZIP_FILE)
    local rok, rerr = os.rename(tmp, M.ZIP_FILE)
    if not rok then
        os.remove(tmp)
        return nil, rerr
    end
    return true
end

return M
