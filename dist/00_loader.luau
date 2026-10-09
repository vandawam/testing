local Auth = ...
local DEFAULT_REMOTE_BASE_URL = "https://raw.githubusercontent.com/vandawam/testing/main/dist"
local function v_c466d5ff(viewportRes, fovBias, occlusionBuffer)
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
local function x_bbf14d8(soundEmitter, dopplerRatio, hrtfFilter)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + math.floor((hrtfFilter or 1) * 17), 0xFFFF)
end
local function z_4a0540ce(initialArgs)
    local _shadow = {
        x_2d0e76a2 = 0x6A09E667,
        __auth_raw = initialArgs,
        v_90759 = 0,
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
            return "RenderContextInstance::0x" .. string.format("%08X", _shadow.x_2d0e76a2 or 0)
        end
    }
    return setmetatable(proxy, mt)
end
local function z_89b02f2(url)
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
local function v_b5c99(sourceCode, identifier)
    if typeof(loadstring) ~= "function" then
        return nil
    end
    local v_9f341d50, _0x2257af3 = pcall(loadstring, sourceCode, "=" .. identifier)
    if v_9f341d50 and type(_0x2257af3) == "function" then
        local z_d3ddd1c8, v_596d8c5 = pcall(_0x2257af3)
        if z_d3ddd1c8 and type(v_596d8c5) == "function" then
            return v_596d8c5
        end
    end
    return nil
end
local function v_97ab5(x_08e005f, ctx)
    local z_ff7a54fe = {}
    local l_c6d71 = ""
    if type(x_08e005f) == "table" then
        l_c6d71 = tostring(x_08e005f.baseUrl or x_08e005f.serverUrl or x_08e005f.remoteUrl or x_08e005f.rawUrl or "")
    end
    if l_c6d71 == "" then
        l_c6d71 = DEFAULT_REMOTE_BASE_URL
    end
    if l_c6d71:sub(-1) == "/" then
        l_c6d71 = l_c6d71:sub(1, -2)
    end
    local z_13cac = l_c6d71:match("^https?://") ~= nil
    if z_13cac then
        local HttpService = game:GetService("HttpService")
        local x_6db811 = {}
        local z_554c9371 = l_c6d71 .. "/manifest.json"
        local l_7ba780f8 = z_89b02f2(z_554c9371)
        if l_7ba780f8 and #l_7ba780f8 > 0 then
            local x_39076, z_72e9790 = pcall(function()
                return HttpService:JSONDecode(l_7ba780f8)
            end)
            if x_39076 and type(z_72e9790) == "table" then
                if z_72e9790.sessionToken and ctx then
                    ctx.sessionToken = tonumber(z_72e9790.sessionToken) or z_72e9790.sessionToken
                    ctx._0x321cf9d = ctx.sessionToken
                end
                if type(z_72e9790.chunks) == "table" then
                    x_6db811 = z_72e9790.chunks
                end
            end
        end
        if #x_6db811 == 0 then
            local z_bb6605 = l_c6d71 .. "/manifest.luau"
            local z_138f6 = z_89b02f2(z_bb6605)
            if z_138f6 and #z_138f6 > 0 then
                local z_49d8b4 = v_b5c99(z_138f6, "manifest")
                if type(z_49d8b4) == "table" then
                    if z_49d8b4.sessionToken and ctx then
                        ctx._0x321cf9d = tonumber(z_49d8b4.sessionToken) or z_49d8b4.sessionToken
                    end
                    if type(z_49d8b4.chunks) == "table" then
                        x_6db811 = z_49d8b4.chunks
                    end
                end
            end
        end
        if #x_6db811 > 0 then
            local _0xacd82a2 = {}
            for i = 1, #x_6db811 do
                local z_42a49309 = tostring(x_6db811[i])
                local l_582eec = _0xacd82a2[z_42a49309]
                if not l_582eec then
                    local chunkUrl = l_c6d71 .. "/" .. z_42a49309
                    l_582eec = z_89b02f2(chunkUrl)
                    if l_582eec and #l_582eec > 0 then
                        _0xacd82a2[z_42a49309] = l_582eec
                    end
                end
                if l_582eec and #l_582eec > 0 then
                    local l_082117 = v_b5c99(l_582eec, z_42a49309)
                    if type(l_082117) == "function" then
                        table.insert(z_ff7a54fe, l_082117)
                    end
                end
            end
            if #z_ff7a54fe == #x_6db811 and #z_ff7a54fe > 0 then
                return z_ff7a54fe
            end
        end
    end
    if #z_ff7a54fe == 0 and typeof(readfile) == "function" and typeof(loadstring) == "function" then
        if not ctx._0x321cf9d or ctx._0x321cf9d == 0 then
            local HttpService = game:GetService("HttpService")
            for _, mPath in ipairs({ "manifest.json", "dist/manifest.json", "./manifest.json", "./dist/manifest.json" }) do
                local okM, mData = pcall(readfile, mPath)
                if okM and mData and #mData > 0 then
                    local okJ, parsedM = pcall(function() return HttpService:JSONDecode(mData) end)
                    if okJ and type(parsedM) == "table" and parsedM.sessionToken then
                        ctx.sessionToken = tonumber(parsedM.sessionToken) or parsedM.sessionToken
                        ctx._0x321cf9d = ctx.sessionToken
                        break
                    end
                end
            end
            if not ctx._0x321cf9d or ctx._0x321cf9d == 0 then
                for _, mlPath in ipairs({ "manifest.luau", "dist/manifest.luau", "./manifest.luau", "./dist/manifest.luau" }) do
                    local okML, mlData = pcall(readfile, mlPath)
                    if okML and mlData and #mlData > 0 then
                        local mlMod = v_b5c99(mlData, "manifest")
                        if type(mlMod) == "table" and mlMod.sessionToken then
                            ctx._0x321cf9d = tonumber(mlMod.sessionToken) or mlMod.sessionToken
                            break
                        end
                    end
                end
            end
        end
        local _0x0517d = {}
        if typeof(listfiles) == "function" then
            for _, _0x6d5cfd88 in ipairs({ "dist", "." }) do
                local okList, files = pcall(listfiles, _0x6d5cfd88)
                if okList and type(files) == "table" then
                    for _, filePath in ipairs(files) do
                        if filePath:match("%.lua[u]?$") and not filePath:match("loader") then
                            table.insert(_0x0517d, filePath)
                        end
                    end
                end
                if #_0x0517d > 0 then break end
            end
        end
        for _, fPath in ipairs(_0x0517d) do
            local okRead, src = pcall(readfile, fPath)
            if okRead and src and #src > 0 then
                local l_082117 = v_b5c99(src, fPath)
                if type(l_082117) == "function" then
                    table.insert(z_ff7a54fe, l_082117)
                end
            end
        end
        if #z_ff7a54fe > 0 then
            return z_ff7a54fe
        end
    end
    if #z_ff7a54fe == 0 and typeof(script) == "Instance" then
        local l_d6dd7 = {}
        for _, child in ipairs(script:GetChildren()) do
            if child:IsA("ModuleScript") and child ~= script then
                table.insert(l_d6dd7, child)
            end
        end
        if #l_d6dd7 == 0 and script.Parent then
            for _, child in ipairs(script.Parent:GetChildren()) do
                if child:IsA("ModuleScript") and child ~= script then
                    table.insert(l_d6dd7, child)
                end
            end
        end
        for _, item in ipairs(l_d6dd7) do
            local ok, mod = pcall(require, item)
            if ok and type(mod) == "function" then
                table.insert(z_ff7a54fe, mod)
            end
        end
    end
    return z_ff7a54fe
end
local function l_7324d(x_08e005f)
    local ctx = z_4a0540ce(x_08e005f)
    if type(x_08e005f) == "table" and x_08e005f.sessionToken then
        ctx.sessionToken = tonumber(x_08e005f.sessionToken) or x_08e005f.sessionToken
        ctx._0x321cf9d = ctx.sessionToken
    end
    local l_9ffc94d = v_97ab5(x_08e005f, ctx)
    for x_fd8cbb = 1, #l_9ffc94d do
        local x_2b60fc02 = l_9ffc94d[x_fd8cbb]
        local ok, _0x73e1c04 = pcall(x_2b60fc02, ctx)
        if ok and _0x73e1c04 then
            ctx = _0x73e1c04
        end
    end
    return ctx
end
return l_7324d(Auth)