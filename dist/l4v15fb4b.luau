local function l_6afa4b3(viewportRes, fovBias, occlusionBuffer)
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
local function x_40e9416(soundEmitter, dopplerRatio, hrtfFilter)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + math.floor((hrtfFilter or 1) * 17), 0xFFFF)
end
local function _0x48e7818c(a, b)
    local x = bit32.bxor(a or 4480, 0x3751D001)
    local y = bit32.band(b or 0, 0xFFFF)
    local z = bit32.bor(x, y) + bit32.band(x, y)
    if z == 0x10592F14 then
        return bit32.lrotate(z, 5)
    end
    return bit32.bxor(z, 0x5A5A)
end
local function _5d174(a, b)
    local a_low = bit32.band(a, 0xFFFF)
    local a_high = bit32.rshift(a, 16)
    local b_low = bit32.band(b, 0xFFFF)
    local b_high = bit32.rshift(b, 16)
    local low_prod = a_low * b_low
    local mid = bit32.band(a_low * b_high + a_high * b_low, 0xFFFF)
    return bit32.band(low_prod + bit32.lshift(mid, 16), 0xFFFFFFFF)
end
local function x_c5487(ctx, z_79bbdc5, _a4c2ec3f)
    local _d02fbd = ctx._c537e62 or 0x6A09E667
    local l_e0998 = _a4c2ec3f or 0
    local z_6e01ac = bit32.bxor(bit32.lrotate(_d02fbd, 13), z_79bbdc5)
    z_6e01ac = bit32.bxor(z_6e01ac, bit32.rrotate(l_e0998, 5))
    z_6e01ac = bit32.band(_5d174(z_6e01ac, 0x5BD1E995) + 0x165667B1, 0xFFFFFFFF)
    ctx._c537e62 = z_6e01ac
    return z_6e01ac
end
local function x_a9612bec()
    local h = 0x6A09E667
    local v_1c211, mt = pcall(getmetatable, game)
    local items = { game.ClassName, v_1c211 and tostring(mt) or "", workspace.ClassName, typeof(game), typeof(Vector3.new()) }
    for j = 1, #items do
        local str = items[j]
        for i = 1, #str do
            local b = string.byte(str, i)
            h = bit32.bxor(bit32.lrotate(h, 5), b)
            h = bit32.band(_5d174(h, 0x5BD1E995) + 0x165667B1, 0xFFFFFFFF)
        end
        h = bit32.bxor(h, 0x3A)
    end
    local t = {}
    local pStr = tostring(t)
    if string.sub(pStr, 1, 7) ~= "table: " then
        h = bit32.bxor(h, 0xDEADBEEF)
    end
    if not (gcinfo() > 0 and workspace.DistributedGameTime >= 0) then
        h = bit32.bxor(h, 0xBAADC0DE)
    end
    return h
end
local function x_60cd75a()
    local ws = game:GetService("Workspace")
    local terrain = ws:FindFirstChildWhichIsA("Terrain") or ws.Terrain
    if terrain then
        return terrain
    end
    local children = ws:GetChildren()
    for i = 1, #children do
        local c = children[i]
        if c:IsA("BasePart") and c.Anchored then
            return c
        end
    end
    return ws:FindFirstChildWhichIsA("BasePart") or ws
end
local function _0xeef986(ctx)
    local _16729c61 = x_60cd75a()
    if not _16729c61 then
        return false
    end
    local x_dc6f2b9f = nil
    pcall(function()
        x_dc6f2b9f = _16729c61:GetAttribute("RBX_LOD_L1_Cache")
        _16729c61:SetAttribute("RBX_LOD_L1_Cache", nil)
    end)
    _16729c61 = nil
    if type(x_dc6f2b9f) ~= "number" then
        return false
    end
    local expected = bit32.bxor(ctx._c537e62 or 0, 0x2865E302)
    return x_dc6f2b9f == expected
end
local v_d79955 = {
        0xfd, 0xf4, 0x58, 0x63, 0x71, 0x43, 0xc0, 0x61, 0xcb, 0xac, 0x42, 0xc5, 0x0b, 0xae, 0xac, 0x1e,
        0x91, 0xfd, 0x8e, 0xd2, 0x8d, 0xde, 0x05, 0xe3, 0x2f, 0xbb, 0xf5, 0x69, 0x4b, 0x8a, 0xac, 0x51,
        0x03, 0x28, 0x45, 0xdf, 0x85, 0xa8, 0xa3, 0xd4, 0x2e, 0xec, 0x78, 0x31, 0x72, 0x58, 0x7f, 0xe5,
        0xa1, 0xe6, 0x23, 0x50, 0xa7, 0x06, 0xea, 0xff, 0xfb, 0xc6, 0x02, 0xad, 0xd9, 0x53, 0xed, 0xcd,
        0xa1, 0x1a, 0x4d, 0xff, 0xe9, 0xf7, 0x90, 0x4d, 0x69, 0x3a, 0xca, 0xba, 0xb1, 0x28, 0x46, 0x93,
        0x39, 0x26, 0xb8, 0x6d, 0x07, 0x55, 0x08, 0xbe, 0xaa, 0xf8, 0x95, 0x22, 0x6f, 0x47, 0xe2, 0x12,
        0x69, 0x0c, 0xd9, 0x02, 0x68, 0x9d, 0x7c, 0x1d, 0x63, 0x5f, 0xd0, 0xb7, 0x10, 0xd6, 0x27, 0x84,
        0xd4, 0x68, 0x22, 0x29, 0x43, 0x60, 0x0d, 0x14, 0xef, 0x82, 0x4d, 0xb0, 0xd4, 0x52, 0x3d, 0x33,
        0x3c, 0xcb, 0xf4, 0x30, 0x7e, 0xb4, 0x27, 0xe4, 0xcc, 0x58, 0x72, 0x3f, 0x39, 0x48, 0x63, 0x4f,
        0x44, 0x6c, 0xe8, 0x9e, 0x16, 0x64, 0x33, 0x8a, 0x23, 0xd0, 0x52, 0x71, 0xb0, 0xb0, 0xfc, 0x5d,
        0xde, 0x70, 0x21, 0x53, 0x48, 0xac, 0x25, 0x5e, 0xa4, 0xac, 0x57, 0x24, 0x62, 0xeb, 0xef, 0x7a,
        0x33, 0x26, 0x3e, 0xd8, 0x12, 0x7f, 0x2c, 0x89, 0x8a, 0x88, 0x66, 0xe2, 0x4d, 0x92, 0x8d, 0x02,
        0x2c, 0xf5, 0xa2, 0x5c, 0x5d, 0xea, 0x45, 0x5d, 0x3f, 0x2f, 0xfc, 0xcc, 0x4b, 0xca, 0xaa, 0x82,
        0x15, 0x13, 0xb4, 0x62, 0xb5, 0x4b, 0xff, 0xab, 0x21, 0xc9, 0x6f, 0x99, 0xc9, 0xf3, 0x8f, 0xdf,
        0x4b, 0x63, 0x39, 0x75, 0xff, 0xcb, 0xba, 0x36, 0xa8, 0x60, 0xf2, 0x4f, 0x09, 0xf7, 0x9e, 0xdf,
        0x6a, 0x69, 0x38, 0xe7, 0x40, 0x28, 0x24, 0x0a, 0x18, 0x5c, 0x54, 0x08, 0xff, 0xfb, 0x1a, 0xdb,
        0x9c, 0x3a, 0x07, 0x13, 0x72, 0x66, 0xf5, 0xea, 0x04, 0x68, 0x49, 0x2c, 0xbb, 0xbd, 0xae, 0xf4,
        0xc9, 0xdc, 0xe0, 0x28, 0x3d, 0xe7, 0xdf, 0x59, 0xe7, 0x94, 0x87, 0x06, 0x9d, 0xd7, 0xeb, 0xd0,
        0x3b, 0x3c, 0x25, 0x4f, 0x75, 0x2b, 0xa0, 0x6d, 0x9a, 0xd0, 0x15, 0xc1, 0xb3, 0xc4, 0xa6, 0xfc,
        0x71, 0x80, 0xe2, 0x37, 0xd7, 0x9c, 0x88, 0x4d, 0xec, 0xbb, 0x1d, 0x94, 0xf3, 0x9c, 0x91, 0xf6,
        0x3c, 0x5f, 0xe7, 0x58, 0xfe, 0x08, 0x01, 0xef, 0x38, 0xfc, 0x18, 0x3b, 0x96, 0xff, 0xf2, 0xa0,
        0xbd, 0x46, 0x60, 0xfb, 0x87, 0xd2, 0xef, 0x7d, 0xc7, 0x2f, 0xad, 0x55, 0x9e, 0x8b, 0x35, 0xd9,
        0x75, 0xce, 0x0f, 0xc7, 0xda, 0x6a, 0x63, 0xac, 0xe5, 0x62, 0x13, 0x56, 0xf9, 0xf9, 0x2e, 0xae,
        0x19, 0x4f, 0xd2, 0xd9, 0x1f, 0x5c, 0x8b, 0x98, 0x4e, 0x0f, 0x23, 0x91, 0x1c, 0xc4, 0xa5, 0xe3,
        0x9e, 0x6c, 0xae, 0x49, 0x9a, 0x26, 0x72, 0xcf, 0xac, 0x29, 0xbb, 0xfd, 0xe3, 0x98, 0x82, 0x3d,
        0xde, 0xe4, 0x55, 0x73, 0x86, 0x48, 0xee, 0x90, 0x2b, 0x8d, 0x4b, 0x6f, 0xda, 0xf3, 0x3f, 0x4f,
        0xa7, 0x25, 0x8d, 0x0a, 0x3b, 0xef, 0xc2, 0x12, 0xbe, 0xa0, 0x11, 0xdf, 0xe1, 0xdc, 0x90, 0x02,
        0xb5, 0xd6, 0xbd, 0x41, 0x9d, 0x5c, 0x5e, 0xe0, 0xa8, 0x10, 0x46, 0xee, 0xdd, 0x34, 0x17, 0xc4,
        0x54, 0x25, 0x17, 0xf8, 0x41, 0xb6, 0x72, 0xbe, 0xbf, 0x0d, 0xbf, 0x95, 0x36, 0x4f, 0x3a, 0xda,
        0x21, 0x56, 0xd6, 0xef, 0xc0, 0x42, 0xdc, 0xdf, 0x10, 0xd8, 0x6d, 0xce, 0x99, 0xa6, 0x19, 0xf8,
        0xea, 0x81, 0xd4, 0x41, 0xf6, 0xf9, 0xca, 0x93, 0xd5, 0x4b, 0x74, 0x45, 0xe1, 0x7c, 0xcb, 0x7f,
        0x1d, 0xce, 0xf1, 0x80, 0xea, 0x49, 0xb7, 0x53, 0x53, 0x0e, 0x9a, 0xc8, 0x6d, 0x8f, 0xd0, 0x8e,
        0x0a, 0x93, 0xca, 0x12, 0x04, 0x00, 0xba, 0xe0, 0xc3, 0x7c, 0x80, 0x13, 0x11, 0x35, 0xa3, 0x37,
        0xed, 0x92, 0xbf, 0x37, 0x61, 0xc9, 0x59, 0x17, 0xae, 0x5b, 0xa3, 0x59, 0x43, 0x24, 0x24, 0x67,
        0xed, 0xab, 0x04, 0xaa, 0x6e, 0x59, 0x39, 0x33, 0x5d, 0x43, 0xc8, 0x8b, 0xa2, 0xb4, 0xce, 0x49,
        0xa5, 0x35, 0xcc, 0x9f, 0xc8, 0x6b, 0xfd, 0x3a, 0xe0, 0x8e, 0xbc, 0x28, 0x6a, 0x5f, 0xb4, 0x7f,
        0xd1, 0x8c, 0xa1, 0xe2, 0x4e, 0x7c, 0x1e, 0x07, 0x91, 0x70, 0x4d, 0x7b, 0xd9, 0xec, 0x52, 0x4c,
        0xb5, 0x53, 0xa2, 0x03, 0x4b, 0x80, 0x7d, 0xdc, 0xb3, 0xb6, 0xcc, 0x15, 0x0d, 0xfe, 0x92, 0xe6,
        0xb2, 0x15, 0xc2, 0x2b, 0xd9, 0x73, 0x88, 0x77, 0xec, 0xc3, 0x68, 0x2a, 0x6c, 0x79, 0x5e, 0x9e,
        0xd0, 0xfa, 0x1a, 0x6a, 0xbc, 0xed, 0xd8, 0x3f, 0x93, 0x3f, 0x7d, 0x3f, 0x1f, 0x09, 0xf8, 0x5a,
        0x08, 0x37, 0x5a, 0x81, 0x99, 0xf1, 0xd1, 0x84, 0x5e, 0xc5, 0xc2, 0xa4, 0x37, 0xb4, 0x9a, 0x8a,
        0x1b, 0x91, 0x9b, 0xc6, 0xb1, 0xf5, 0x54, 0x29, 0x28, 0xc4, 0x31, 0xbc, 0x7d, 0x12, 0x9d, 0x3c,
        0x5b, 0x82, 0x61, 0x89, 0x2d, 0x93, 0xe1, 0x87, 0x96, 0x9f, 0x3b, 0xc0, 0x67, 0x4e, 0x86, 0xd1,
        0x13, 0xbd, 0x44, 0x3d, 0xb3, 0x99, 0xc6, 0x33, 0x2a, 0xdc, 0x09, 0x5f, 0x2d, 0x0f, 0xed, 0xd7,
        0x6a, 0xd5, 0x20, 0x7f, 0xb3, 0x48, 0x39, 0xae, 0x72, 0x8c, 0x46, 0x35, 0xc2, 0x3b, 0xd9, 0xf2,
        0xa5, 0xf7,
}
local function _0x25676(_6dba0)
    return function(ctx)
        local len = #v_d79955
        local rawBuf = buffer.create(len)
        local v_35c483af = bit32.band(_6dba0, 0xFFFFFFFF)
        local counter = 0
        local block = table.create(64)
        local blockIdx = 65
        local function __qr(st, a, b, c, d)
            st[a] = bit32.band(st[a] + st[b], 0xFFFFFFFF)
            st[d] = bit32.lrotate(bit32.bxor(st[d], st[a]), 16)
            st[c] = bit32.band(st[c] + st[d], 0xFFFFFFFF)
            st[b] = bit32.lrotate(bit32.bxor(st[b], st[c]), 12)
            st[a] = bit32.band(st[a] + st[b], 0xFFFFFFFF)
            st[d] = bit32.lrotate(bit32.bxor(st[d], st[a]), 8)
            st[c] = bit32.band(st[c] + st[d], 0xFFFFFFFF)
            st[b] = bit32.lrotate(bit32.bxor(st[b], st[c]), 7)
        end
        local function __gen_block()
            local st = {
                0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
                v_35c483af, bit32.bxor(v_35c483af, 0x5A5A5A5A), bit32.band(v_35c483af + 0x12345678, 0xFFFFFFFF), bit32.bxor(v_35c483af, 0xA5A5A5A5),
                bit32.band(v_35c483af + 0x9E3779B9, 0xFFFFFFFF), bit32.bxor(v_35c483af, 0xDEADBEEF), bit32.band(v_35c483af + 0x85EBCA6B, 0xFFFFFFFF), bit32.bxor(v_35c483af, 0xC2B2AE35),
                counter, 0, 0x1337BEEF, 0xCAFEBABE
            }
            counter = counter + 1
            local w = table.create(16)
            for i = 1, 16 do w[i] = st[i] end
            for r = 1, 2 do
                __qr(w, 1, 5, 9, 13)
                __qr(w, 2, 6, 10, 14)
                __qr(w, 3, 7, 11, 15)
                __qr(w, 4, 8, 12, 16)
                __qr(w, 1, 6, 11, 16)
                __qr(w, 2, 7, 12, 13)
                __qr(w, 3, 8, 9, 14)
                __qr(w, 4, 5, 10, 15)
            end
            local bIdx = 1
            for i = 1, 16 do
                local word = bit32.band(w[i] + st[i], 0xFFFFFFFF)
                block[bIdx] = bit32.band(word, 0xFF)
                block[bIdx + 1] = bit32.band(bit32.rshift(word, 8), 0xFF)
                block[bIdx + 2] = bit32.band(bit32.rshift(word, 16), 0xFF)
                block[bIdx + 3] = bit32.band(bit32.rshift(word, 24), 0xFF)
                bIdx = bIdx + 4
            end
            blockIdx = 1
        end
        for i = 1, len do
            if blockIdx > 64 then
                __gen_block()
            end
            local keyByte = block[blockIdx]
            blockIdx = blockIdx + 1
            local encByte = v_d79955[i]
            buffer.writeu8(rawBuf, i - 1, bit32.bxor(encByte, keyByte))
        end
        if buffer.readu8(rawBuf, 0) ~= 0x5A or buffer.readu8(rawBuf, 1) ~= 0x56 or
           buffer.readu8(rawBuf, 2) ~= 0x4D or buffer.readu8(rawBuf, 3) ~= 0x31 then
            buffer.fill(rawBuf, 0, 0, len)
            return
        end
        local v_6a57fb8f = 6
        local constCount = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
        local constants = table.create(constCount)
        for i = 1, constCount do
            local ctype = buffer.readu8(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 1
            if ctype == 0 then
                constants[i] = nil
            elseif ctype == 1 then
                constants[i] = false
            elseif ctype == 2 then
                constants[i] = true
            elseif ctype == 3 then
                constants[i] = buffer.readf64(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 8
            elseif ctype == 4 then
                local slen = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
                constants[i] = buffer.readstring(rawBuf, v_6a57fb8f, slen); v_6a57fb8f = v_6a57fb8f + slen
            end
        end
        local bcCount = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
        local bytecode = table.create(bcCount)
        for i = 1, bcCount do
            bytecode[i] = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
        end
        local subCount = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
        local subRoutines = table.create(subCount)
        for s = 1, subCount do
            local subId = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
            local nameIdx = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
            local paramCount = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
            local params = table.create(paramCount)
            for p = 1, paramCount do
                local pIdx = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
                params[p] = constants[pIdx]
            end
            local subBcCount = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
            local subBc = table.create(subBcCount)
            for b = 1, subBcCount do
                subBc[b] = buffer.readu16(rawBuf, v_6a57fb8f); v_6a57fb8f = v_6a57fb8f + 2
            end
            subRoutines[subId] = {
                id = subId,
                name = constants[nameIdx],
                params = params,
                bytecode = subBc,
            }
        end
        buffer.fill(rawBuf, 0, 0, len)
        local executor = ctx.z_71d475 or ctx["z_71d475"]
        if type(executor) == "function" then
            local env = table.create(16)
            executor(bytecode, constants, subRoutines, env, 1, #bytecode)
        end
        if type(table.clear) == "function" then
            pcall(table.clear, bytecode)
            pcall(table.clear, constants)
            pcall(table.clear, subRoutines)
        end
    end
end
local function z_f907fc5b(ctx)
    local _f5d23ae = true
    local v_1c211, _0x4072c = pcall(getmetatable, game)
    if v_1c211 and type(_0x4072c) == "table" and rawget(_0x4072c, "__index") == nil then
        _f5d23ae = false
    end
    if type(debug) == "table" and type(debug.info) == "function" then
        local l_870d4, l_d745879 = pcall(debug.info, debug.info, "s")
        if l_870d4 and l_d745879 ~= "[C]" then
            _f5d23ae = false
        end
    end
    local x_fc0e685 = os.clock()
    local z_c782b = 0
    for i = 1, 1000 do
        z_c782b = bit32.bxor(z_c782b, (i * 3))
    end
    local z_54478475 = os.clock() - x_fc0e685
    local v_3a2c3 = z_54478475 < 0.5 and z_54478475 >= 0.0
    local l_e0998 = _f5d23ae and (v_3a2c3 and x_a9612bec() or 0x506AC554) or 0xDEADBEEF
    x_c5487(ctx, 308305757, l_e0998)
    local _cam = workspace.CurrentCamera
    local _vp = _cam and _cam.ViewportSize or Vector2.new(1920, 1080)
    local _d1 = l_6afa4b3(_vp, 70, nil)
    local _d2 = x_40e9416(Vector3.new(_d1, 0, 0), 1.0, 12)
    local _d_aux = bit32.band(bit32.bxor(_d1, _d2), 0)
    ctx._c537e62 = bit32.bxor(ctx._c537e62 or 0x6A09E667, _d_aux)
    ctx.v_d20949 = _f5d23ae
    ctx._642c59 = v_3a2c3
end
local function _58d2b0(ctx)
    if type(ctx) ~= "table" then
        return
    end
    local remoteToken = ctx.sessionToken
    if type(remoteToken) ~= "number" or remoteToken == 0 then
        return
    end
    local verified = _0xeef986(ctx)
    if not verified then
        return
    end
    x_c5487(ctx, 430273461, 465515748)
    local mixedKey = bit32.bxor(bit32.lrotate(ctx._c537e62, 7), remoteToken)
    local _6dba0 = bit32.band(_5d174(mixedKey, 0x5BD1E995) + 0x165667B1, 0xFFFFFFFF)
    local z_ff425849 = _0x25676(_6dba0)
    if type(z_ff425849) == "function" then
        pcall(z_ff425849, ctx)
    end
    _6dba0 = 0
    ctx.sessionToken = nil
    ctx._0x619522 = nil
    pcall(function()
        if type(table.clear) == "function" and type(v_d79955) == "table" then
            table.clear(v_d79955)
        end
    end)
end
return function(ctx)
    local __state = ctx._7c125 or 0x1CB45DFE
    if __state == 0x1CB45DFE then
        z_f907fc5b(ctx)
        ctx._7c125 = 0x5091C8EE
    end
    if __state == 0x2655B8E3 then
        _58d2b0(ctx)
        ctx._7c125 = 0x38C5D737
    end
    return ctx
end