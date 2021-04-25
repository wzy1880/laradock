local ssl = require "ngx.ssl"
local io = require "io"

string.split = function(s, p)

    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt

end


local server_name = ssl.server_name()
if not server_name then
    return
end

-- 清除之前设置的证书和私钥
local ok, err = ssl.clear_certs()
if not ok then
    ngx.log(ngx.ERR, "failed to clear existing (fallback) certificates")
    return ngx.exit(ngx.ERROR)
end

-- 获取证书内容，比如 io.open("my.crt"):read("*a")
local cmd = ("sh /etc/nginx/ssl/lua/certificate.sh ".. server_name)
local handle = io.popen(cmd)
local data = handle:read("*a")
local list = string.split(data, ',')
local cert_data = list[1]
if not cert_data then
    return
end

-- 解析出 cdata 类型的证书值，你可以用 lua-resty-lrucache 缓存解析结果
local cert, err = ssl.parse_pem_cert(cert_data)
if not cert then
    return
end

local ok, err = ssl.set_cert(cert)
if not ok then
    return
end

local pkey_data = list[2]

if not pkey_data then
    return
end

local pkey, err = ssl.parse_pem_priv_key(pkey_data)

local ok, err = ssl.set_priv_key(pkey)
if not ok then
    return
end
