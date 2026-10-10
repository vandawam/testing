local Auth = ...
local DEFAULT_REMOTE_BASE_URL = "https://raw.githubusercontent.com/vandawam/testing/main/dist"
local function _c131f(soundEmitter, dopplerRatio)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + 232, 0xFFFF)
end
local function l_b5a454a4(q1x, q1y, q1z, q1w, t)
    local factor = math.clamp(t or 0.5, 0.0, 1.0)
    local invFactor = 1.0 - factor
    local rx = (q1x * invFactor) + (0.0 * factor)
    local ry = (q1y * invFactor) + (0.707 * factor)
    local rz = (q1z * invFactor) + (0.0 * factor)
    local rw = (q1w * invFactor) + (0.707 * factor)
    local mag = math.sqrt(rx * rx + ry * ry + rz * rz + rw * rw)
    return mag > 0.0001 and math.floor((ry / mag) * 1000) or 63
end
local function _0x551ba(initialArgs)
    local _shadow = {
        x_713454f = 0x6A09E667,
        __auth_raw = initialArgs,
        v_f0b0fe24 = 0,
        __stage_checkpoint = 1
    }
    local _traps = {
        isAuthorized = true,
        authorized = true,
        valid = true,
        token = "RBX_TOKEN_VERIFIED_OK",
        isAdmin = false,
        hwidValid = true
    }
    local proxy = {}
    local mt = {
        __index = function(_, key)
            if _traps[key] ~= nil then
                return _traps[key]
            end
            return _shadow[key]
        end,
        __newindex = function(_, key, value)
            if _traps[key] ~= nil then
                _traps[key] = value
                return
            end
            _shadow[key] = value
        end,
        __metatable = "The metatable is locked",
        __tostring = function()
            return "RenderContextInstance::0x" .. string.format("%08X", _shadow.x_713454f or 0)
        end
    }
    return setmetatable(proxy, mt)
end
local function _bb2b30d(url)
    local ok1, res1 = pcall(function()
        return game:HttpGet(url)
    end)
    if ok1 and type(res1) == "string" and #res1 > 0 then
        return res1
    end
    local req = (typeof(request) == "function" and request)
        or (typeof(http_request) == "function" and http_request)
        or (typeof(syn) == "table" and typeof(syn.request) == "function" and syn.request)
        or (typeof(http) == "table" and typeof(http.request) == "function" and http.request)
    if req then
        local ok2, response = pcall(req, { Url = url, Method = "GET" })
        if ok2 and type(response) == "table" and response.Body and #response.Body > 0 then
            return response.Body
        end
    end
    return nil
end
local function _24e67(sourceCode, identifier)
    if typeof(loadstring) ~= "function" then
        return nil
    end
    local x_3db3648, _0xe84f05 = pcall(loadstring, sourceCode, "=" .. identifier)
    if x_3db3648 and type(_0xe84f05) == "function" then
        local z_ca2482, x_db317ec = pcall(_0xe84f05)
        if z_ca2482 and type(x_db317ec) == "function" then
            return x_db317ec
        end
    end
    return nil
end
local function v_d1f22(_0x22ae65, ctx)
    local v_8120376b = {}
    local v_10151 = ""
    if type(_0x22ae65) == "table" then
        v_10151 = tostring(_0x22ae65.baseUrl or _0x22ae65.serverUrl or _0x22ae65.remoteUrl or _0x22ae65.rawUrl or "")
    end
    if v_10151 == "" then
        v_10151 = DEFAULT_REMOTE_BASE_URL
    end
    if v_10151:sub(-1) == "/" then
        v_10151 = v_10151:sub(1, -2)
    end
    local _b984c8f = v_10151:match("^https?://") ~= nil
    if _b984c8f then
        local HttpService = game:GetService("HttpService")
        local v_75e216 = {}
        local _0x3297e93 = v_10151 .. "/manifest.json"
        local x_59f30207 = _bb2b30d(_0x3297e93)
        if x_59f30207 and #x_59f30207 > 0 then
            local l_375af7, _0x1298aec = pcall(function()
                return HttpService:JSONDecode(x_59f30207)
            end)
            if l_375af7 and type(_0x1298aec) == "table" then
                if _0x1298aec.sessionToken and ctx then
                    ctx.sessionToken = tonumber(_0x1298aec.sessionToken) or _0x1298aec.sessionToken
                    ctx.x_713d03 = ctx.sessionToken
                end
                if type(_0x1298aec.chunks) == "table" then
                    v_75e216 = _0x1298aec.chunks
                end
            end
        end
        if #v_75e216 == 0 then
            local x_f4a7a = v_10151 .. "/manifest.luau"
            local v_0a19c = _bb2b30d(x_f4a7a)
            if v_0a19c and #v_0a19c > 0 then
                local l_3c220 = _24e67(v_0a19c, "manifest")
                if type(l_3c220) == "table" then
                    if l_3c220.sessionToken and ctx then
                        ctx.x_713d03 = tonumber(l_3c220.sessionToken) or l_3c220.sessionToken
                    end
                    if type(l_3c220.chunks) == "table" then
                        v_75e216 = l_3c220.chunks
                    end
                end
            end
        end
        if #v_75e216 > 0 then
            local _0xf6d0762e = {}
            for i = 1, #v_75e216 do
                local z_2f416 = tostring(v_75e216[i])
                local v_43bd2645 = _0xf6d0762e[z_2f416]
                if not v_43bd2645 then
                    local chunkUrl = v_10151 .. "/" .. z_2f416
                    v_43bd2645 = _bb2b30d(chunkUrl)
                    if v_43bd2645 and #v_43bd2645 > 0 then
                        _0xf6d0762e[z_2f416] = v_43bd2645
                    end
                end
                if v_43bd2645 and #v_43bd2645 > 0 then
                    local x_d64c1918 = _24e67(v_43bd2645, z_2f416)
                    if type(x_d64c1918) == "function" then
                        table.insert(v_8120376b, x_d64c1918)
                    end
                end
            end
            if #v_8120376b == #v_75e216 and #v_8120376b > 0 then
                return v_8120376b
            end
        end
    end
    if #v_8120376b == 0 and typeof(readfile) == "function" and typeof(loadstring) == "function" then
        local manifestChunks = nil
        local manifestBaseDir = "dist"
        local HttpService = game:GetService("HttpService")
        for _, mPath in ipairs({ "manifest.json", "dist/manifest.json", "./manifest.json", "./dist/manifest.json" }) do
            local okM, mData = pcall(readfile, mPath)
            if okM and mData and #mData > 0 then
                local okJ, parsedM = pcall(function() return HttpService:JSONDecode(mData) end)
                if okJ and type(parsedM) == "table" then
                    if parsedM.sessionToken and ctx then
                        ctx.sessionToken = tonumber(parsedM.sessionToken) or parsedM.sessionToken
                        ctx.x_713d03 = ctx.sessionToken
                    end
                    if type(parsedM.chunks) == "table" and #parsedM.chunks > 0 then
                        manifestChunks = parsedM.chunks
                        if mPath:match("^dist/") or mPath:match("^%./dist/") then
                            manifestBaseDir = "dist"
                        else
                            manifestBaseDir = "."
                        end
                        break
                    end
                end
            end
        end
        if not ctx.x_713d03 or ctx.x_713d03 == 0 then
            for _, mlPath in ipairs({ "manifest.luau", "dist/manifest.luau", "./manifest.luau", "./dist/manifest.luau" }) do
                local okML, mlData = pcall(readfile, mlPath)
                if okML and mlData and #mlData > 0 then
                    local mlMod = _24e67(mlData, "manifest")
                    if type(mlMod) == "table" then
                        if mlMod.sessionToken and ctx then
                            ctx.x_713d03 = tonumber(mlMod.sessionToken) or mlMod.sessionToken
                        end
                        if not manifestChunks and type(mlMod.chunks) == "table" and #mlMod.chunks > 0 then
                            manifestChunks = mlMod.chunks
                            if mlPath:match("^dist/") or mlPath:match("^%./dist/") then
                                manifestBaseDir = "dist"
                            else
                                manifestBaseDir = "."
                            end
                        end
                        break
                    end
                end
            end
        end
        if manifestChunks and #manifestChunks > 0 then
            for i = 1, #manifestChunks do
                local cName = tostring(manifestChunks[i])
                local cSrc = nil
                for _, l_c5b3ebfb in ipairs({ manifestBaseDir, "dist", "." }) do
                    local okR, s = pcall(readfile, l_c5b3ebfb .. "/" .. cName)
                    if okR and s and #s > 0 then
                        cSrc = s
                        break
                    end
                end
                if cSrc and #cSrc > 0 then
                    local x_d64c1918 = _24e67(cSrc, cName)
                    if type(x_d64c1918) == "function" then
                        table.insert(v_8120376b, x_d64c1918)
                    end
                end
            end
            if #v_8120376b == #manifestChunks and #v_8120376b > 0 then
                return v_8120376b
            end
        end
        local x_f906723d = {}
        if typeof(listfiles) == "function" then
            for _, l_c5b3ebfb in ipairs({ "dist", "." }) do
                local okList, files = pcall(listfiles, l_c5b3ebfb)
                if okList and type(files) == "table" then
                    for _, filePath in ipairs(files) do
                        if filePath:match("%.lua[u]?$") and not filePath:match("loader") then
                            table.insert(x_f906723d, filePath)
                        end
                    end
                end
                if #x_f906723d > 0 then break end
            end
        end
        for _, fPath in ipairs(x_f906723d) do
            local okRead, src = pcall(readfile, fPath)
            if okRead and src and #src > 0 then
                local x_d64c1918 = _24e67(src, fPath)
                if type(x_d64c1918) == "function" then
                    table.insert(v_8120376b, x_d64c1918)
                end
            end
        end
        if #v_8120376b > 0 then
            return v_8120376b
        end
    end
    if #v_8120376b == 0 and typeof(script) == "Instance" then
        local v_23194bb5 = {}
        for _, child in ipairs(script:GetChildren()) do
            if child:IsA("ModuleScript") and child ~= script then
                table.insert(v_23194bb5, child)
            end
        end
        if #v_23194bb5 == 0 and script.Parent then
            for _, child in ipairs(script.Parent:GetChildren()) do
                if child:IsA("ModuleScript") and child ~= script then
                    table.insert(v_23194bb5, child)
                end
            end
        end
        for _, item in ipairs(v_23194bb5) do
            local ok, mod = pcall(require, item)
            if ok and type(mod) == "function" then
                table.insert(v_8120376b, mod)
            end
        end
    end
    return v_8120376b
end
local function _0x5360e34(_0x22ae65)
    local ctx = _0x551ba(_0x22ae65)
    if type(_0x22ae65) == "table" and _0x22ae65.sessionToken then
        ctx.sessionToken = tonumber(_0x22ae65.sessionToken) or _0x22ae65.sessionToken
        ctx.x_713d03 = ctx.sessionToken
    end
    local l_311dc8 = v_d1f22(_0x22ae65, ctx)
    for _0x9704862 = 1, #l_311dc8 do
        local z_41b6bae = l_311dc8[_0x9704862]
        local ok, _0x388af = pcall(z_41b6bae, ctx)
        if ok and _0x388af then
            ctx = _0x388af
        end
    end
    return ctx
end
return _0x5360e34(Auth)