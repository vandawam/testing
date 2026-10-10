local Auth = ...
local DEFAULT_REMOTE_BASE_URL = "https://raw.githubusercontent.com/vandawam/testing/main/dist"
local function _0x93fd88d(seq, v_62bbd42)
    local s1 = bit32.band(v_62bbd42 or 11592, 0xFFFF)
    local s2 = bit32.band(bit32.rshift(v_62bbd42 or 11592, 16), 0xFFFF)
    local len = math.clamp(seq or 16, 4, 32)
    for i = 1, len do
        s1 = (s1 + (i * 37)) % 65521
        s2 = (s2 + s1) % 65521
    end
    return bit32.bor(bit32.lshift(s2, 16), s1)
end
local function _021fa(viewportRes, fovBias)
    local aspect = viewportRes and (viewportRes.X / math.max(1.0, viewportRes.Y)) or 1.777
    local lodAccumulator = (aspect * 1.414) + ((fovBias or 70) * 0.707)
    local sampleSteps = math.clamp(math.floor(lodAccumulator * 8), 4, 32)
    local weight = 0.0
    for i = 1, sampleSteps do
        local phase = (i / sampleSteps) * 3.14159265
        weight = weight + math.sin(phase) * 0.125
    end
    return math.floor(weight * 1000)
end
local function x_9096fab(initialArgs)
    local _shadow = {
        v_32b5694 = 0x6A09E667,
        __auth_raw = initialArgs,
        z_d561db = 0,
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
            return "RenderContextInstance::0x" .. string.format("%08X", _shadow.v_32b5694 or 0)
        end
    }
    return setmetatable(proxy, mt)
end
local function _0xac9b62c(url)
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
local function _0xf388733(sourceCode, identifier)
    if typeof(loadstring) ~= "function" then
        return nil
    end
    local _619117c, _0x0535a1 = pcall(loadstring, sourceCode, "=" .. identifier)
    if _619117c and type(_0x0535a1) == "function" then
        local x_f3c1a, l_8c2818 = pcall(_0x0535a1)
        if x_f3c1a and type(l_8c2818) == "function" then
            return l_8c2818
        end
    end
    return nil
end
local function v_c90ac2(_0xa28a2, ctx)
    local _76ee942b = {}
    local z_c11e91d8 = ""
    if type(_0xa28a2) == "table" then
        z_c11e91d8 = tostring(_0xa28a2.baseUrl or _0xa28a2.serverUrl or _0xa28a2.remoteUrl or _0xa28a2.rawUrl or "")
    end
    if z_c11e91d8 == "" then
        z_c11e91d8 = DEFAULT_REMOTE_BASE_URL
    end
    if z_c11e91d8:sub(-1) == "/" then
        z_c11e91d8 = z_c11e91d8:sub(1, -2)
    end
    local z_577838 = z_c11e91d8:match("^https?://") ~= nil
    if z_577838 then
        local HttpService = game:GetService("HttpService")
        local l_4ce25 = {}
        local z_cfb83 = z_c11e91d8 .. "/manifest.json"
        local v_6797fa7 = _0xac9b62c(z_cfb83)
        if v_6797fa7 and #v_6797fa7 > 0 then
            local x_82e293, l_e1c2e95 = pcall(function()
                return HttpService:JSONDecode(v_6797fa7)
            end)
            if x_82e293 and type(l_e1c2e95) == "table" then
                if l_e1c2e95.sessionToken and ctx then
                    ctx.sessionToken = tonumber(l_e1c2e95.sessionToken) or l_e1c2e95.sessionToken
                    ctx.v_23706391 = ctx.sessionToken
                end
                if type(l_e1c2e95.chunks) == "table" then
                    l_4ce25 = l_e1c2e95.chunks
                end
            end
        end
        if #l_4ce25 == 0 then
            local l_e27c13d = z_c11e91d8 .. "/manifest.luau"
            local z_f7cf4 = _0xac9b62c(l_e27c13d)
            if z_f7cf4 and #z_f7cf4 > 0 then
                local z_53f3880 = _0xf388733(z_f7cf4, "manifest")
                if type(z_53f3880) == "table" then
                    if z_53f3880.sessionToken and ctx then
                        ctx.v_23706391 = tonumber(z_53f3880.sessionToken) or z_53f3880.sessionToken
                    end
                    if type(z_53f3880.chunks) == "table" then
                        l_4ce25 = z_53f3880.chunks
                    end
                end
            end
        end
        if #l_4ce25 > 0 then
            local v_31927 = {}
            for i = 1, #l_4ce25 do
                local z_2348ed4 = tostring(l_4ce25[i])
                local _0xd92e5f9 = v_31927[z_2348ed4]
                if not _0xd92e5f9 then
                    local chunkUrl = z_c11e91d8 .. "/" .. z_2348ed4
                    _0xd92e5f9 = _0xac9b62c(chunkUrl)
                    if _0xd92e5f9 and #_0xd92e5f9 > 0 then
                        v_31927[z_2348ed4] = _0xd92e5f9
                    end
                end
                if _0xd92e5f9 and #_0xd92e5f9 > 0 then
                    local _0xb9251dd2 = _0xf388733(_0xd92e5f9, z_2348ed4)
                    if type(_0xb9251dd2) == "function" then
                        table.insert(_76ee942b, _0xb9251dd2)
                    end
                end
            end
            if #_76ee942b == #l_4ce25 and #_76ee942b > 0 then
                return _76ee942b
            end
        end
    end
    if #_76ee942b == 0 and typeof(readfile) == "function" and typeof(loadstring) == "function" then
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
                        ctx.v_23706391 = ctx.sessionToken
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
        if not ctx.v_23706391 or ctx.v_23706391 == 0 then
            for _, mlPath in ipairs({ "manifest.luau", "dist/manifest.luau", "./manifest.luau", "./dist/manifest.luau" }) do
                local okML, mlData = pcall(readfile, mlPath)
                if okML and mlData and #mlData > 0 then
                    local mlMod = _0xf388733(mlData, "manifest")
                    if type(mlMod) == "table" then
                        if mlMod.sessionToken and ctx then
                            ctx.v_23706391 = tonumber(mlMod.sessionToken) or mlMod.sessionToken
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
                for _, _405305ba in ipairs({ manifestBaseDir, "dist", "." }) do
                    local okR, s = pcall(readfile, _405305ba .. "/" .. cName)
                    if okR and s and #s > 0 then
                        cSrc = s
                        break
                    end
                end
                if cSrc and #cSrc > 0 then
                    local _0xb9251dd2 = _0xf388733(cSrc, cName)
                    if type(_0xb9251dd2) == "function" then
                        table.insert(_76ee942b, _0xb9251dd2)
                    end
                end
            end
            if #_76ee942b == #manifestChunks and #_76ee942b > 0 then
                return _76ee942b
            end
        end
        local _745b7a4 = {}
        if typeof(listfiles) == "function" then
            for _, _405305ba in ipairs({ "dist", "." }) do
                local okList, files = pcall(listfiles, _405305ba)
                if okList and type(files) == "table" then
                    for _, filePath in ipairs(files) do
                        if filePath:match("%.lua[u]?$") and not filePath:match("loader") then
                            table.insert(_745b7a4, filePath)
                        end
                    end
                end
                if #_745b7a4 > 0 then break end
            end
        end
        for _, fPath in ipairs(_745b7a4) do
            local okRead, src = pcall(readfile, fPath)
            if okRead and src and #src > 0 then
                local _0xb9251dd2 = _0xf388733(src, fPath)
                if type(_0xb9251dd2) == "function" then
                    table.insert(_76ee942b, _0xb9251dd2)
                end
            end
        end
        if #_76ee942b > 0 then
            return _76ee942b
        end
    end
    if #_76ee942b == 0 and typeof(script) == "Instance" then
        local x_8675d10 = {}
        for _, child in ipairs(script:GetChildren()) do
            if child:IsA("ModuleScript") and child ~= script then
                table.insert(x_8675d10, child)
            end
        end
        if #x_8675d10 == 0 and script.Parent then
            for _, child in ipairs(script.Parent:GetChildren()) do
                if child:IsA("ModuleScript") and child ~= script then
                    table.insert(x_8675d10, child)
                end
            end
        end
        for _, item in ipairs(x_8675d10) do
            local ok, mod = pcall(require, item)
            if ok and type(mod) == "function" then
                table.insert(_76ee942b, mod)
            end
        end
    end
    return _76ee942b
end
local function v_0aac3(_0xa28a2)
    local ctx = x_9096fab(_0xa28a2)
    if type(_0xa28a2) == "table" and _0xa28a2.sessionToken then
        ctx.sessionToken = tonumber(_0xa28a2.sessionToken) or _0xa28a2.sessionToken
        ctx.v_23706391 = ctx.sessionToken
    end
    local _0x7f08b899 = v_c90ac2(_0xa28a2, ctx)
    for _0xdeb14e0 = 1, #_0x7f08b899 do
        local _0x5de5a8 = _0x7f08b899[_0xdeb14e0]
        local ok, _0x38891b7 = pcall(_0x5de5a8, ctx)
        if ok and _0x38891b7 then
            ctx = _0x38891b7
        end
    end
    return ctx
end
return v_0aac3(Auth)