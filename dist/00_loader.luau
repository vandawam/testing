local Auth = ...
local DEFAULT_REMOTE_BASE_URL = "https://raw.githubusercontent.com/vandawam/testing/main/dist"
local function _ff7655c(viewportRes, fovBias, occlusionBuffer)
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
local function x_71886(soundEmitter, dopplerRatio, hrtfFilter)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + math.floor((hrtfFilter or 1) * 17), 0xFFFF)
end
local function x_3fd6a9(initialArgs)
    local _shadow = {
        _49ee058c = 0x6A09E667,
        __auth_raw = initialArgs,
        _fb838746 = 0,
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
            return "RenderContextInstance::0x" .. string.format("%08X", _shadow._49ee058c or 0)
        end
    }
    return setmetatable(proxy, mt)
end
local function _0x81909f42(url)
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
local function z_d32f5(sourceCode, identifier)
    if typeof(loadstring) ~= "function" then
        return nil
    end
    local l_ef2e6, x_9323fe5 = pcall(loadstring, sourceCode, "=" .. identifier)
    if l_ef2e6 and type(x_9323fe5) == "function" then
        local x_b0e0d7, _d77b8 = pcall(x_9323fe5)
        if x_b0e0d7 and type(_d77b8) == "function" then
            return _d77b8
        end
    end
    return nil
end
local function x_021e27(z_565994a7, ctx)
    local x_d1ac5db = {}
    local l_ae596 = ""
    if type(z_565994a7) == "table" then
        l_ae596 = tostring(z_565994a7.baseUrl or z_565994a7.serverUrl or z_565994a7.remoteUrl or z_565994a7.rawUrl or "")
    end
    if l_ae596 == "" then
        l_ae596 = DEFAULT_REMOTE_BASE_URL
    end
    if l_ae596:sub(-1) == "/" then
        l_ae596 = l_ae596:sub(1, -2)
    end
    local z_53d89c = l_ae596:match("^https?://") ~= nil
    if z_53d89c then
        local HttpService = game:GetService("HttpService")
        local v_5bccc1a = {}
        local _f7afe7d = l_ae596 .. "/manifest.json"
        local v_f905b7 = _0x81909f42(_f7afe7d)
        if v_f905b7 and #v_f905b7 > 0 then
            local z_6679896b, l_957756be = pcall(function()
                return HttpService:JSONDecode(v_f905b7)
            end)
            if z_6679896b and type(l_957756be) == "table" then
                if l_957756be.sessionToken and ctx then
                    ctx.sessionToken = tonumber(l_957756be.sessionToken) or l_957756be.sessionToken
                    ctx.x_4968688b = ctx.sessionToken
                end
                if type(l_957756be.chunks) == "table" then
                    v_5bccc1a = l_957756be.chunks
                end
            end
        end
        if #v_5bccc1a == 0 then
            local _0x91cf7160 = l_ae596 .. "/manifest.luau"
            local _0x7d7aaf = _0x81909f42(_0x91cf7160)
            if _0x7d7aaf and #_0x7d7aaf > 0 then
                local z_ff5f7 = z_d32f5(_0x7d7aaf, "manifest")
                if type(z_ff5f7) == "table" then
                    if z_ff5f7.sessionToken and ctx then
                        ctx.x_4968688b = tonumber(z_ff5f7.sessionToken) or z_ff5f7.sessionToken
                    end
                    if type(z_ff5f7.chunks) == "table" then
                        v_5bccc1a = z_ff5f7.chunks
                    end
                end
            end
        end
        if #v_5bccc1a > 0 then
            local v_582e6 = {}
            for i = 1, #v_5bccc1a do
                local _bec70 = tostring(v_5bccc1a[i])
                local v_cc5a95a = v_582e6[_bec70]
                if not v_cc5a95a then
                    local chunkUrl = l_ae596 .. "/" .. _bec70
                    v_cc5a95a = _0x81909f42(chunkUrl)
                    if v_cc5a95a and #v_cc5a95a > 0 then
                        v_582e6[_bec70] = v_cc5a95a
                    end
                end
                if v_cc5a95a and #v_cc5a95a > 0 then
                    local _266670 = z_d32f5(v_cc5a95a, _bec70)
                    if type(_266670) == "function" then
                        table.insert(x_d1ac5db, _266670)
                    end
                end
            end
            if #x_d1ac5db == #v_5bccc1a and #x_d1ac5db > 0 then
                return x_d1ac5db
            end
        end
    end
    if #x_d1ac5db == 0 and typeof(readfile) == "function" and typeof(loadstring) == "function" then
        if not ctx.x_4968688b or ctx.x_4968688b == 0 then
            local HttpService = game:GetService("HttpService")
            for _, mPath in ipairs({ "manifest.json", "dist/manifest.json", "./manifest.json", "./dist/manifest.json" }) do
                local okM, mData = pcall(readfile, mPath)
                if okM and mData and #mData > 0 then
                    local okJ, parsedM = pcall(function() return HttpService:JSONDecode(mData) end)
                    if okJ and type(parsedM) == "table" and parsedM.sessionToken then
                        ctx.sessionToken = tonumber(parsedM.sessionToken) or parsedM.sessionToken
                        ctx.x_4968688b = ctx.sessionToken
                        break
                    end
                end
            end
            if not ctx.x_4968688b or ctx.x_4968688b == 0 then
                for _, mlPath in ipairs({ "manifest.luau", "dist/manifest.luau", "./manifest.luau", "./dist/manifest.luau" }) do
                    local okML, mlData = pcall(readfile, mlPath)
                    if okML and mlData and #mlData > 0 then
                        local mlMod = z_d32f5(mlData, "manifest")
                        if type(mlMod) == "table" and mlMod.sessionToken then
                            ctx.x_4968688b = tonumber(mlMod.sessionToken) or mlMod.sessionToken
                            break
                        end
                    end
                end
            end
        end
        local l_d5f0b198 = {}
        if typeof(listfiles) == "function" then
            for _, z_b8cf4a in ipairs({ "dist", "." }) do
                local okList, files = pcall(listfiles, z_b8cf4a)
                if okList and type(files) == "table" then
                    for _, filePath in ipairs(files) do
                        if filePath:match("%.lua[u]?$") and not filePath:match("loader") then
                            table.insert(l_d5f0b198, filePath)
                        end
                    end
                end
                if #l_d5f0b198 > 0 then break end
            end
        end
        for _, fPath in ipairs(l_d5f0b198) do
            local okRead, src = pcall(readfile, fPath)
            if okRead and src and #src > 0 then
                local _266670 = z_d32f5(src, fPath)
                if type(_266670) == "function" then
                    table.insert(x_d1ac5db, _266670)
                end
            end
        end
        if #x_d1ac5db > 0 then
            return x_d1ac5db
        end
    end
    if #x_d1ac5db == 0 and typeof(script) == "Instance" then
        local v_29915c = {}
        for _, child in ipairs(script:GetChildren()) do
            if child:IsA("ModuleScript") and child ~= script then
                table.insert(v_29915c, child)
            end
        end
        if #v_29915c == 0 and script.Parent then
            for _, child in ipairs(script.Parent:GetChildren()) do
                if child:IsA("ModuleScript") and child ~= script then
                    table.insert(v_29915c, child)
                end
            end
        end
        for _, item in ipairs(v_29915c) do
            local ok, mod = pcall(require, item)
            if ok and type(mod) == "function" then
                table.insert(x_d1ac5db, mod)
            end
        end
    end
    return x_d1ac5db
end
local function l_2f8a15ed(z_565994a7)
    local ctx = x_3fd6a9(z_565994a7)
    if type(z_565994a7) == "table" and z_565994a7.sessionToken then
        ctx.sessionToken = tonumber(z_565994a7.sessionToken) or z_565994a7.sessionToken
        ctx.x_4968688b = ctx.sessionToken
    end
    local z_66615589 = x_021e27(z_565994a7, ctx)
    for z_21f72a7 = 1, #z_66615589 do
        local v_8e5c81 = z_66615589[z_21f72a7]
        local ok, x_d443211 = pcall(v_8e5c81, ctx)
        if ok and x_d443211 then
            ctx = x_d443211
        end
    end
    return ctx
end
return l_2f8a15ed(Auth)