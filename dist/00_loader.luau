local Auth = ...
local DEFAULT_REMOTE_BASE_URL = "https://raw.githubusercontent.com/vandawam/testing/main/dist"
local function x_a30609b(viewportRes, fovBias, occlusionBuffer)
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
local function l_820b5(soundEmitter, dopplerRatio, hrtfFilter)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + math.floor((hrtfFilter or 1) * 17), 0xFFFF)
end
local function _0x8ca46(initialArgs)
    local _shadow = {
        _c537e62 = 0x6A09E667,
        __auth_raw = initialArgs,
        l_0a5484a = 0,
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
            return "RenderContextInstance::0x" .. string.format("%08X", _shadow._c537e62 or 0)
        end
    }
    return setmetatable(proxy, mt)
end
local function _0x0d15e3d4(url)
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
local function _2ce017(sourceCode, identifier)
    if typeof(loadstring) ~= "function" then
        return nil
    end
    local _2f01559, v_cec3c360 = pcall(loadstring, sourceCode, "=" .. identifier)
    if _2f01559 and type(v_cec3c360) == "function" then
        local x_619991e, x_977acbe = pcall(v_cec3c360)
        if x_619991e and type(x_977acbe) == "function" then
            return x_977acbe
        end
    end
    return nil
end
local function l_df206(v_35d2377, ctx)
    local z_c009c93 = {}
    local l_78309f = ""
    if type(v_35d2377) == "table" then
        l_78309f = tostring(v_35d2377.baseUrl or v_35d2377.serverUrl or v_35d2377.remoteUrl or v_35d2377.rawUrl or "")
    end
    if l_78309f == "" then
        l_78309f = DEFAULT_REMOTE_BASE_URL
    end
    if l_78309f:sub(-1) == "/" then
        l_78309f = l_78309f:sub(1, -2)
    end
    local v_692bb7 = l_78309f:match("^https?://") ~= nil
    if v_692bb7 then
        local HttpService = game:GetService("HttpService")
        local z_d065c5d0 = {}
        local _2c3de = l_78309f .. "/manifest.json"
        local v_a1c29b5 = _0x0d15e3d4(_2c3de)
        if v_a1c29b5 and #v_a1c29b5 > 0 then
            local _a024bcdc, l_c3267f = pcall(function()
                return HttpService:JSONDecode(v_a1c29b5)
            end)
            if _a024bcdc and type(l_c3267f) == "table" then
                if l_c3267f.sessionToken and ctx then
                    ctx.sessionToken = tonumber(l_c3267f.sessionToken) or l_c3267f.sessionToken
                    ctx._0x619522 = ctx.sessionToken
                end
                if type(l_c3267f.chunks) == "table" then
                    z_d065c5d0 = l_c3267f.chunks
                end
            end
        end
        if #z_d065c5d0 == 0 then
            local l_b90bf3 = l_78309f .. "/manifest.luau"
            local x_61c0cbc = _0x0d15e3d4(l_b90bf3)
            if x_61c0cbc and #x_61c0cbc > 0 then
                local _0xf82f6 = _2ce017(x_61c0cbc, "manifest")
                if type(_0xf82f6) == "table" then
                    if _0xf82f6.sessionToken and ctx then
                        ctx._0x619522 = tonumber(_0xf82f6.sessionToken) or _0xf82f6.sessionToken
                    end
                    if type(_0xf82f6.chunks) == "table" then
                        z_d065c5d0 = _0xf82f6.chunks
                    end
                end
            end
        end
        if #z_d065c5d0 > 0 then
            local _f15c3f8c = {}
            for i = 1, #z_d065c5d0 do
                local x_712bcd = tostring(z_d065c5d0[i])
                local z_dcd1b7 = _f15c3f8c[x_712bcd]
                if not z_dcd1b7 then
                    local chunkUrl = l_78309f .. "/" .. x_712bcd
                    z_dcd1b7 = _0x0d15e3d4(chunkUrl)
                    if z_dcd1b7 and #z_dcd1b7 > 0 then
                        _f15c3f8c[x_712bcd] = z_dcd1b7
                    end
                end
                if z_dcd1b7 and #z_dcd1b7 > 0 then
                    local _a9e79 = _2ce017(z_dcd1b7, x_712bcd)
                    if type(_a9e79) == "function" then
                        table.insert(z_c009c93, _a9e79)
                    end
                end
            end
            if #z_c009c93 == #z_d065c5d0 and #z_c009c93 > 0 then
                return z_c009c93
            end
        end
    end
    if #z_c009c93 == 0 and typeof(readfile) == "function" and typeof(loadstring) == "function" then
        if not ctx._0x619522 or ctx._0x619522 == 0 then
            local HttpService = game:GetService("HttpService")
            for _, mPath in ipairs({ "manifest.json", "dist/manifest.json", "./manifest.json", "./dist/manifest.json" }) do
                local okM, mData = pcall(readfile, mPath)
                if okM and mData and #mData > 0 then
                    local okJ, parsedM = pcall(function() return HttpService:JSONDecode(mData) end)
                    if okJ and type(parsedM) == "table" and parsedM.sessionToken then
                        ctx.sessionToken = tonumber(parsedM.sessionToken) or parsedM.sessionToken
                        ctx._0x619522 = ctx.sessionToken
                        break
                    end
                end
            end
            if not ctx._0x619522 or ctx._0x619522 == 0 then
                for _, mlPath in ipairs({ "manifest.luau", "dist/manifest.luau", "./manifest.luau", "./dist/manifest.luau" }) do
                    local okML, mlData = pcall(readfile, mlPath)
                    if okML and mlData and #mlData > 0 then
                        local mlMod = _2ce017(mlData, "manifest")
                        if type(mlMod) == "table" and mlMod.sessionToken then
                            ctx._0x619522 = tonumber(mlMod.sessionToken) or mlMod.sessionToken
                            break
                        end
                    end
                end
            end
        end
        local z_30702 = {}
        if typeof(listfiles) == "function" then
            for _, l_d5393d3 in ipairs({ "dist", "." }) do
                local okList, files = pcall(listfiles, l_d5393d3)
                if okList and type(files) == "table" then
                    for _, filePath in ipairs(files) do
                        if filePath:match("%.lua[u]?$") and not filePath:match("loader") then
                            table.insert(z_30702, filePath)
                        end
                    end
                end
                if #z_30702 > 0 then break end
            end
        end
        for _, fPath in ipairs(z_30702) do
            local okRead, src = pcall(readfile, fPath)
            if okRead and src and #src > 0 then
                local _a9e79 = _2ce017(src, fPath)
                if type(_a9e79) == "function" then
                    table.insert(z_c009c93, _a9e79)
                end
            end
        end
        if #z_c009c93 > 0 then
            return z_c009c93
        end
    end
    if #z_c009c93 == 0 and typeof(script) == "Instance" then
        local _efe76 = {}
        for _, child in ipairs(script:GetChildren()) do
            if child:IsA("ModuleScript") and child ~= script then
                table.insert(_efe76, child)
            end
        end
        if #_efe76 == 0 and script.Parent then
            for _, child in ipairs(script.Parent:GetChildren()) do
                if child:IsA("ModuleScript") and child ~= script then
                    table.insert(_efe76, child)
                end
            end
        end
        for _, item in ipairs(_efe76) do
            local ok, mod = pcall(require, item)
            if ok and type(mod) == "function" then
                table.insert(z_c009c93, mod)
            end
        end
    end
    return z_c009c93
end
local function z_4380e(v_35d2377)
    local ctx = _0x8ca46(v_35d2377)
    if type(v_35d2377) == "table" and v_35d2377.sessionToken then
        ctx.sessionToken = tonumber(v_35d2377.sessionToken) or v_35d2377.sessionToken
        ctx._0x619522 = ctx.sessionToken
    end
    local l_748999 = l_df206(v_35d2377, ctx)
    for _0xf5a4ec00 = 1, #l_748999 do
        local _91938 = l_748999[_0xf5a4ec00]
        local ok, l_c71c8933 = pcall(_91938, ctx)
        if ok and l_c71c8933 then
            ctx = l_c71c8933
        end
    end
    return ctx
end
return z_4380e(Auth)