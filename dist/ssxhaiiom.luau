local function _0x863534(viewportRes, fovBias, occlusionBuffer)
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
local function z_fbd0276(soundEmitter, dopplerRatio, hrtfFilter)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + math.floor((hrtfFilter or 1) * 17), 0xFFFF)
end
local function z_e2ddae(a, b)
    local x = bit32.bxor(a or 1282, 0x3DFA3FD7)
    local y = bit32.band(b or 0, 0xFFFF)
    local z = bit32.bor(x, y) + bit32.band(x, y)
    if z == 0x48E9568E then
        return bit32.lrotate(z, 5)
    end
    return bit32.bxor(z, 0x5A5A)
end
local function v_3ad4f44(a, b)
    local a_low = bit32.band(a, 0xFFFF)
    local a_high = bit32.rshift(a, 16)
    local b_low = bit32.band(b, 0xFFFF)
    local b_high = bit32.rshift(b, 16)
    local low_prod = a_low * b_low
    local mid = bit32.band(a_low * b_high + a_high * b_low, 0xFFFF)
    return bit32.band(low_prod + bit32.lshift(mid, 16), 0xFFFFFFFF)
end
local function v_3f0b4a2(ctx, z_df45cd5, z_b9d05d5c)
    local _a44654 = ctx._49ee058c or 0x6A09E667
    local l_99a5a6 = z_b9d05d5c or 0
    local _0xc47352 = bit32.bxor(bit32.lrotate(_a44654, 13), z_df45cd5)
    _0xc47352 = bit32.bxor(_0xc47352, bit32.rrotate(l_99a5a6, 5))
    _0xc47352 = bit32.band(v_3ad4f44(_0xc47352, 0x5BD1E995) + 0x165667B1, 0xFFFFFFFF)
    ctx._49ee058c = _0xc47352
    return _0xc47352
end
local function v_0bbbd8()
    local h = 0x6A09E667
    local x_483df, mt = pcall(getmetatable, game)
    local items = { game.ClassName, x_483df and tostring(mt) or "", workspace.ClassName, typeof(game), typeof(Vector3.new()) }
    for j = 1, #items do
        local str = items[j]
        for i = 1, #str do
            local b = string.byte(str, i)
            h = bit32.bxor(bit32.lrotate(h, 5), b)
            h = bit32.band(v_3ad4f44(h, 0x5BD1E995) + 0x165667B1, 0xFFFFFFFF)
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
local function l_df2f71a6()
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
local function v_2161dcce(ctx)
    local z_8d70e5 = l_df2f71a6()
    if not z_8d70e5 then
        return false
    end
    local marker = bit32.bxor(ctx._49ee058c or 0, 0x44507C69)
    local ok = pcall(function()
        z_8d70e5:SetAttribute("RBX_LOD_L1_Cache", marker)
    end)
    z_8d70e5 = nil
    return ok
end
local function v_5bff9ef(ctx)
    local _dc91dd92 = true
    local x_483df, _0xde9932d = pcall(getmetatable, game)
    if x_483df and type(_0xde9932d) == "table" and rawget(_0xde9932d, "__index") == nil then
        _dc91dd92 = false
    end
    if type(debug) == "table" and type(debug.info) == "function" then
        local _0x09fbb8, _0x3eace = pcall(debug.info, debug.info, "s")
        if _0x09fbb8 and _0x3eace ~= "[C]" then
            _dc91dd92 = false
        end
    end
    local x_a1dc9102 = os.clock()
    local _0x3ec9a = 0
    for i = 1, 1000 do
        _0x3ec9a = bit32.bxor(_0x3ec9a, (i * 3))
    end
    local _52ddf6 = os.clock() - x_a1dc9102
    local x_7dfff9f = _52ddf6 < 0.5 and _52ddf6 >= 0.0
    local l_99a5a6 = _dc91dd92 and (x_7dfff9f and v_0bbbd8() or 0x11BBCA6D) or 0xDEADBEEF
    v_3f0b4a2(ctx, 502903838, l_99a5a6)
    local _cam = workspace.CurrentCamera
    local _vp = _cam and _cam.ViewportSize or Vector2.new(1920, 1080)
    local _d1 = _0x863534(_vp, 70, nil)
    local _d2 = z_fbd0276(Vector3.new(_d1, 0, 0), 1.0, 12)
    local _d_aux = bit32.band(bit32.bxor(_d1, _d2), 0)
    ctx._49ee058c = bit32.bxor(ctx._49ee058c or 0x6A09E667, _d_aux)
    ctx.l_fb7b841 = _dc91dd92
    ctx.v_448554 = x_7dfff9f
end
local function l_52f6443(ctx)
    local l_99a5a6 = 1707483078
    v_3f0b4a2(ctx, 793189639, l_99a5a6)
    local v_1093dc8e = v_2161dcce(ctx)
    if not v_1093dc8e then
        ctx._49ee058c = 0
    end
end
return function(ctx)
    local __state = ctx._8ce11 or 0x41072E74
    if __state == 0x41072E74 then
        v_5bff9ef(ctx)
        ctx._8ce11 = 0x327E2CF6
    end
    if __state == 0x62D91BDB then
        l_52f6443(ctx)
        ctx._8ce11 = 0x1283B07B
    end
    return ctx
end