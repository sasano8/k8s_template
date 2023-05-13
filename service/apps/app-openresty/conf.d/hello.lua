local http = require "resty.http"
local httpc = http.new()

-- nginx は dnsは起動時しか更新しない
-- 動かない
local resp, err = httpc:request_uri("https://jsonplaceholder.typicode.com/users", {
    method = "GET",
    headers = {
        ["Content-Type"] = "application/json"
    },
})

if not resp then
    ngx.status = 502
    ngx.say("Failed to request: ")
    ngx.log(ngx.ERR, "Failed to request: ", err)
    return
else
    ngx.status = resp.status
    ngx.say(resp.body)
    return
end

