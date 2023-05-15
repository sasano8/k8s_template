local http = require "resty.http"
local httpc = http.new()


if false then

    -- nginx は dnsは起動時しか更新しない？また、docker はビルド時に /etc/hosts 編集不可
    local res, err = httpc:request_uri("http://jsonplaceholder.typicode.com/users", {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/json"
        },
        -- ssl_verify = false
    })

    if not res then
        ngx.status = 502
        ngx.say("Failed to request: ")
        ngx.log(ngx.ERR, "Failed to request: ", err)
        return
    else
        ngx.header['Content-Type'] = 'application/json'
        ngx.header['Content-Length'] = res.headers['Content-Length']

        for k,v in pairs(res.headers) do
            ngx.header[k] = v
        end

        ngx.status = res.status
        ngx.print(res.body)  -- print は改行なし。say は改行あり
        return
    end
end

-- 接続を開始します
local ok, err = httpc:connect("jsonplaceholder.typicode.com", 80)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

-- リクエストを送信します
local res, err = httpc:request({
    path = "/users",
    method = "GET",
    headers = {
        ["Content-Type"] = "application/json",
    }
})
if not res then
    ngx.say("failed to request: ", err)
    return
end

-- レスポンスヘッダーを読み取ります
ngx.status = res.status
for k, v in pairs(res.headers) do
    ngx.header[k] = v
end

-- レスポンスボディを読み取ります
-- local body, err = res:read_body()
-- if not body then
--     ngx.say("failed to read body: ", err)
--     return
-- end
-- ngx.say(body)

-- -- 接続を閉じます
-- local ok, err = httpc:set_keepalive()
-- if not ok then
--     ngx.say("failed to set keepalive: ", err)
--     return
-- end


local reader = res.body_reader
local buffer_size = 8192


-- request_uri & read_body は一度にメモリに読み込んでしまう
-- ただし、content-length を自動で計算してくれないなど、非互換な処理を考慮しなければいけない
while true do
    local chunk, err = reader(buffer_size)  -- チャンクサイズをバイトで指定します
    if err then
        ngx.say("failed to read chunk: ", err)
        return
    end

    if chunk then
        ngx.print(chunk) -- print は改行なし。say は改行あり
    else
        break
    end
end


-- 接続を閉じます
local ok, err = httpc:set_keepalive()
if not ok then
    ngx.log(ngx.ERR, "failed to set keepalive: ", err)
    return
end
