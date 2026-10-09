local function v_bfa9e(viewportRes, fovBias, occlusionBuffer)
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
local function v_94d4c2(soundEmitter, dopplerRatio, hrtfFilter)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + math.floor((hrtfFilter or 1) * 17), 0xFFFF)
end
local function x_0662c2f(a, b)
    local x = bit32.bxor(a or 753, 0x2CFEADC3)
    local y = bit32.band(b or 0, 0xFFFF)
    local z = bit32.bor(x, y) + bit32.band(x, y)
    if z == 0x2E06C7B7 then
        return bit32.lrotate(z, 5)
    end
    return bit32.bxor(z, 0x5A5A)
end
local function _5ff1009(a, b)
    local a_low = bit32.band(a, 0xFFFF)
    local a_high = bit32.rshift(a, 16)
    local b_low = bit32.band(b, 0xFFFF)
    local b_high = bit32.rshift(b, 16)
    local low_prod = a_low * b_low
    local mid = bit32.band(a_low * b_high + a_high * b_low, 0xFFFF)
    return bit32.band(low_prod + bit32.lshift(mid, 16), 0xFFFFFFFF)
end
local function x_d6aea(ctx, v_e9d8830, _0x43140b3b)
    local x_0070ac = ctx.x_2d0e76a2 or 0x6A09E667
    local _0x38f05cd = _0x43140b3b or 0
    local l_b8e295 = bit32.bxor(bit32.lrotate(x_0070ac, 13), v_e9d8830)
    l_b8e295 = bit32.bxor(l_b8e295, bit32.rrotate(_0x38f05cd, 5))
    l_b8e295 = bit32.band(_5ff1009(l_b8e295, 0x5BD1E995) + 0x165667B1, 0xFFFFFFFF)
    ctx.x_2d0e76a2 = l_b8e295
    return l_b8e295
end
local function x_e000dee(ctx)
    local function __mba_add(a, b)
    if type(a) == "number" and type(b) == "number" then
        local ia = math.floor(a)
        local ib = math.floor(b)
        if ia == a and ib == b and ia >= -2147483648 and ia <= 2147483647 and ib >= -2147483648 and ib <= 2147483647 then
            return bit32.bor(ia, ib) + bit32.band(ia, ib)
        end
    end
    return a + b
end
local function __mba_sub(a, b)
    if type(a) == "number" and type(b) == "number" then
        local ia = math.floor(a)
        local ib = math.floor(b)
        if ia == a and ib == b and ia >= -2147483648 and ia <= 2147483647 and ib >= -2147483648 and ib <= 2147483647 then
            return bit32.bxor(ia, ib) - 2 * bit32.band(ib, bit32.bnot(ia))
        end
    end
    return a - b
end
local function __mba_mul(a, b)
    if type(a) == "number" and type(b) == "number" then
        if b == 2 then
            return bit32.lshift(math.floor(a), 1)
        elseif a == 2 then
            return bit32.lshift(math.floor(b), 1)
        end
    end
    return a * b
end
local function __mba_eq(a, b)
    if type(a) == "number" and type(b) == "number" then
        return bit32.bxor(math.floor(a), math.floor(b)) == 0 and a == b
    end
    return a == b
end
    local OP_NOP = 92
    local OP_LOADK = 97
    local OP_LOADVAR = 201
    local OP_STOREVAR = 87
    local OP_CALL = 125
    local OP_CLOSURE = 106
    local OP_ADD = 193
    local OP_SUB = 227
    local OP_MUL = 107
    local OP_DIV = 234
    local OP_MOD = 38
    local OP_EQ = 110
    local OP_NEQ = 64
    local OP_LT = 211
    local OP_LE = 239
    local OP_GT = 142
    local OP_GE = 207
    local OP_JUMP = 191
    local OP_JUMPIF = 43
    local OP_JUMPIFNOT = 209
    local OP_RETURN = 247
    local OP_POP = 202
    local function _79e78(bytecode, constants, subRoutines, env, startPc, endPc)
        local stack = table.create(128)
        local top = 0
        local pc = startPc or 1
        local maxPc = endPc or #bytecode
        local lastReturnVal = nil
        while pc <= maxPc do
            local op = bytecode[pc]
            pc = pc + 1
            if op == OP_LOADK then
                local kidx = bytecode[pc]
                pc = pc + 1
                top = top + 1
                stack[top] = constants[kidx]
            elseif op == OP_LOADVAR then
                local vidx = bytecode[pc]
                pc = pc + 1
                local name = constants[vidx]
                top = top + 1
                if env[name] ~= nil then
                    stack[top] = env[name]
                else
                    local g = (type(getfenv) == "function" and getfenv()) or _G
                    stack[top] = g[name]
                end
            elseif op == OP_STOREVAR then
                local vidx = bytecode[pc]
                pc = pc + 1
                local name = constants[vidx]
                local z_fff9cae = stack[top]
                top = top - 1
                env[name] = z_fff9cae
            elseif op == OP_CALL then
                local argc = bytecode[pc]
                pc = pc + 1
                local args = table.create(argc)
                for i = argc, 1, -1 do
                    args[i] = stack[top]
                    top = top - 1
                end
                local fn = stack[top]
                top = top - 1
                if type(fn) == "function" then
                    local ok, res = pcall(fn, unpack(args))
                    top = top + 1
                    stack[top] = ok and res or nil
                else
                    top = top + 1
                    stack[top] = nil
                end
            elseif op == OP_CLOSURE then
                local subId = bytecode[pc]
                pc = pc + 1
                local sub = subRoutines[subId]
                if sub then
                    local closure = function(...)
                        local callArgs = { ... }
                        local subEnv = table.clone(env)
                        for pIdx = 1, #sub.params do
                            subEnv[sub.params[pIdx]] = callArgs[pIdx]
                        end
                        return _79e78(sub.bytecode, constants, subRoutines, subEnv, 1, #sub.bytecode)
                    end
                    top = top + 1
                    stack[top] = closure
                end
            elseif op == OP_ADD then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = __mba_add(a, b)
            elseif op == OP_SUB then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = __mba_sub(a, b)
            elseif op == OP_MUL then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = __mba_mul(a, b)
            elseif op == OP_DIV then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = (type(a) == "number" and type(b) == "number" and b ~= 0) and (a / b) or 0
            elseif op == OP_MOD then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = (type(a) == "number" and type(b) == "number" and b ~= 0) and (a % b) or 0
            elseif op == OP_EQ then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = __mba_eq(a, b)
            elseif op == OP_NEQ then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = not __mba_eq(a, b)
            elseif op == OP_LT then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = (a < b)
            elseif op == OP_LE then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = (a <= b)
            elseif op == OP_GT then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = (a > b)
            elseif op == OP_GE then
                local b = stack[top]; top = top - 1
                local a = stack[top]
                stack[top] = (a >= b)
            elseif op == OP_JUMP then
                local targetPc = bytecode[pc]
                pc = targetPc
            elseif op == OP_JUMPIF then
                local targetPc = bytecode[pc]
                pc = pc + 1
                local cond = stack[top]; top = top - 1
                if cond then
                    pc = targetPc
                end
            elseif op == OP_JUMPIFNOT then
                local targetPc = bytecode[pc]
                pc = pc + 1
                local cond = stack[top]; top = top - 1
                if not cond then
                    pc = targetPc
                end
            elseif op == OP_RETURN then
                local count = bytecode[pc]
                pc = pc + 1
                if count > 0 then
                    lastReturnVal = stack[top]
                    top = top - count
                end
                break
            elseif op == OP_POP then
                if top > 0 then
                    top = top - 1
                end
            end
        end
        return lastReturnVal
    end
    return _79e78
end
local function _5a2a4a4()
    local ws = game:GetService("Workspace")
    local l_d6dd7 = {}
    local x_1d464f = ws:GetDescendants()
    for i = 1, #x_1d464f do
        local _0x466b80d = x_1d464f[i]
        if _0x466b80d:IsA("BasePart") then
            if _0x466b80d.Anchored and _0x466b80d.Transparency < 0.95 then
                local mat = _0x466b80d.Material
                if mat ~= Enum.Material.Air and mat ~= Enum.Material.Water then
                    l_d6dd7[#l_d6dd7 + 1] = _0x466b80d
                end
            end
        end
    end
    local count = #l_d6dd7
    if count == 0 then
        local fallback = ws:FindFirstChildWhichIsA("Terrain") or ws:FindFirstChildWhichIsA("BasePart")
        if fallback then return fallback end
        local p = Instance.new("Part")
        p.Name = "_LOD_Carrier"
        p.Transparency = 1
        p.Anchored = true
        p.Parent = ws
        return p
    end
    local cam = ws.CurrentCamera
    local v_fd8617cb = (cam and cam.ViewportSize.X > 0) and math.floor(cam.ViewportSize.X) or 1920
    local x_3fc24e0 = (cam and cam.ViewportSize.Y > 0) and math.floor(cam.ViewportSize.Y) or 1080
    local lighting = game:GetService("Lighting")
    local amb = lighting and lighting.Ambient or Color3.new(0.5, 0.5, 0.5)
    local l_cce708 = math.floor(amb.R * 255)
    local v_40b1514 = math.floor(amb.G * 255)
    local _937fd2 = math.floor(amb.B * 255)
    local terrain = ws:FindFirstChildWhichIsA("Terrain")
    local x_d4bfe4 = terrain and math.floor(terrain.CFrame.Position.Magnitude * 100) or 107
    local z_74ff3 = bit32.bxor(bit32.lrotate(v_fd8617cb, 5), x_3fc24e0)
    z_74ff3 = bit32.bxor(z_74ff3, l_cce708 * 31 + v_40b1514 * 17 + _937fd2 * 7)
    z_74ff3 = bit32.bxor(z_74ff3, x_d4bfe4)
    z_74ff3 = bit32.band(z_74ff3, 0x7FFFFFFF)
    table.sort(l_d6dd7, function(a, b)
        local _0x231f3 = a.Position
        local _b1f11 = b.Position
        local _bea5a051 = (_0x231f3.X * 31.103 + _0x231f3.Y * 17.071 + _0x231f3.Z * 7.001) % 100000.0
        local v_36728ff = (_b1f11.X * 31.103 + _b1f11.Y * 17.071 + _b1f11.Z * 7.001) % 100000.0
        if math.abs(_bea5a051 - v_36728ff) > 0.001 then
            return _bea5a051 < v_36728ff
        end
        return a.Size.Magnitude < b.Size.Magnitude
    end)
    local placeId = (type(game.PlaceId) == "number" and game.PlaceId > 0) and game.PlaceId or 10427
    local _0xec5bfb = 13
    local _b90ba2 = bit32.band(placeId + z_74ff3, 0x7FFFFFFF)
    local v_1ae40 = ((_b90ba2 % _0xec5bfb) % count) + 1
    return l_d6dd7[v_1ae40]
end
local function v_2a45a24(ctx)
    local z_179ff27 = _5a2a4a4()
    if not z_179ff27 then
        return false
    end
    local marker = bit32.bxor(ctx.x_2d0e76a2 or 0, 0x40BDA1EA)
    local ok = pcall(function()
        z_179ff27:SetAttribute("RBX_LOD_L1_Cache", marker)
    end)
    z_179ff27 = nil
    return ok
end
local function l_9714cfb0(ctx)
    if type(x_e000dee) == "function" then
        ctx.v_affc452 = x_e000dee(ctx)
    end
    local _cam = workspace.CurrentCamera
    local _vp = _cam and _cam.ViewportSize or Vector2.new(1920, 1080)
    local _d1 = v_bfa9e(_vp, 70, nil)
    local _d2 = v_94d4c2(Vector3.new(_d1, 0, 0), 1.0, 12)
    local _d_aux = bit32.band(bit32.bxor(_d1, _d2), 0)
    ctx.x_2d0e76a2 = bit32.bxor(ctx.x_2d0e76a2 or 0x6A09E667, _d_aux)
    x_d6aea(ctx, 443867571, 1437226410)
end
local function x_076942b4(ctx)
    local _0x38f05cd = 878299267
    x_d6aea(ctx, 405426916, _0x38f05cd)
    local v_2105cc38 = v_2a45a24(ctx)
    if not v_2105cc38 then
        ctx.x_2d0e76a2 = 0
    end
end
return function(ctx)
    local __state = ctx.x_7d82850 or 0x17ECFF52
    if __state == 0x6F8D9B69 then
        l_9714cfb0(ctx)
        ctx.x_7d82850 = 0x248B3B0B
    end
    if __state == 0x248B3B0B then
        x_076942b4(ctx)
        ctx.x_7d82850 = 0x38A3F10F
    end
    return ctx
end