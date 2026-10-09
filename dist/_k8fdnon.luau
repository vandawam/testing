local function x_c540f5b(viewportRes, fovBias, occlusionBuffer)
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
local function x_b053573d(soundEmitter, dopplerRatio, hrtfFilter)
    local emitterPos = soundEmitter or Vector3.new(0, 0, 0)
    local dist = (emitterPos - Vector3.new(0, 0, 0)).Magnitude
    local attenuation = 1.0 / math.max(1.0, dist * 0.05 + 1.0)
    local dopplerShift = math.clamp((dopplerRatio or 1.0) * 1.05, 0.5, 2.0)
    local filtered = bit32.bxor(math.floor(attenuation * 1024), math.floor(dopplerShift * 256))
    return bit32.band(filtered + math.floor((hrtfFilter or 1) * 17), 0xFFFF)
end
local function _0xbeeff8(a, b)
    local x = bit32.bxor(a or 9224, 0x12C91985)
    local y = bit32.band(b or 0, 0xFFFF)
    local z = bit32.bor(x, y) + bit32.band(x, y)
    if z == 0x691BA8E5 then
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
local function z_3720944(ctx)
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
    local OP_NOP = 126
    local OP_LOADK = 166
    local OP_LOADVAR = 10
    local OP_STOREVAR = 241
    local OP_CALL = 78
    local OP_CLOSURE = 36
    local OP_ADD = 144
    local OP_SUB = 152
    local OP_MUL = 210
    local OP_DIV = 182
    local OP_MOD = 25
    local OP_EQ = 28
    local OP_NEQ = 216
    local OP_LT = 73
    local OP_LE = 83
    local OP_GT = 232
    local OP_GE = 196
    local OP_JUMP = 112
    local OP_JUMPIF = 21
    local OP_JUMPIFNOT = 195
    local OP_RETURN = 168
    local OP_POP = 243
    local OP_SET_CONST = 79
    local OP_SET_VAR = 191
    local OP_COMPARE_JUMP_NOT = 80
    local OP_CALL_VAR_1 = 55
    local OP_CALL_STORE = 138
    local OP_CALL_VAR_VAR = 159
    local OP_ADD_SELF_RETURN = 198
    local OP_BOGUS_BLOCK = 133
    local OP_STATE_DISPATCH = 169
    local function v_1d010566(bytecode, constants, subRoutines, env, startPc, endPc)
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
                local x_dc6f2b9f = stack[top]
                top = top - 1
                env[name] = x_dc6f2b9f
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
                        return v_1d010566(sub.bytecode, constants, subRoutines, subEnv, 1, #sub.bytecode)
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
            elseif op == OP_SET_CONST then
                local vidx = bytecode[pc]; pc = pc + 1
                local kidx = bytecode[pc]; pc = pc + 1
                env[constants[vidx]] = constants[kidx]
            elseif op == OP_SET_VAR then
                local destIdx = bytecode[pc]; pc = pc + 1
                local srcIdx = bytecode[pc]; pc = pc + 1
                local sName = constants[srcIdx]
                local x_dc6f2b9f = env[sName]
                if x_dc6f2b9f == nil then
                    local g = (type(getfenv) == "function" and getfenv()) or _G
                    x_dc6f2b9f = g[sName]
                end
                env[constants[destIdx]] = x_dc6f2b9f
            elseif op == OP_COMPARE_JUMP_NOT then
                local vidx = bytecode[pc]; pc = pc + 1
                local kidx = bytecode[pc]; pc = pc + 1
                local targetPc = bytecode[pc]; pc = pc + 1
                local x_dc6f2b9f = env[constants[vidx]]
                if x_dc6f2b9f == nil then
                    local g = (type(getfenv) == "function" and getfenv()) or _G
                    x_dc6f2b9f = g[constants[vidx]]
                end
                if not __mba_eq(x_dc6f2b9f, constants[kidx]) then
                    pc = targetPc
                end
            elseif op == OP_CALL_VAR_1 then
                local fnIdx = bytecode[pc]; pc = pc + 1
                local argIdx = bytecode[pc]; pc = pc + 1
                local fn = env[constants[fnIdx]]
                if fn == nil then
                    local g = (type(getfenv) == "function" and getfenv()) or _G
                    fn = g[constants[fnIdx]]
                end
                if type(fn) == "function" then
                    pcall(fn, constants[argIdx])
                end
            elseif op == OP_CALL_STORE then
                local fnIdx = bytecode[pc]; pc = pc + 1
                local argIdx = bytecode[pc]; pc = pc + 1
                local destIdx = bytecode[pc]; pc = pc + 1
                local fn = env[constants[fnIdx]]
                if fn == nil then
                    local g = (type(getfenv) == "function" and getfenv()) or _G
                    fn = g[constants[fnIdx]]
                end
                if type(fn) == "function" then
                    local ok, res = pcall(fn, constants[argIdx])
                    env[constants[destIdx]] = ok and res or nil
                end
            elseif op == OP_CALL_VAR_VAR then
                local fnIdx = bytecode[pc]; pc = pc + 1
                local argIdx = bytecode[pc]; pc = pc + 1
                local fn = env[constants[fnIdx]]
                if fn == nil then
                    local g = (type(getfenv) == "function" and getfenv()) or _G
                    fn = g[constants[fnIdx]]
                end
                local arg = env[constants[argIdx]]
                if arg == nil then
                    local g = (type(getfenv) == "function" and getfenv()) or _G
                    arg = g[constants[argIdx]]
                end
                if type(fn) == "function" then
                    pcall(fn, arg)
                end
            elseif op == OP_ADD_SELF_RETURN then
                local pIdx = bytecode[pc]; pc = pc + 1
                local pName = constants[pIdx]
                local x_dc6f2b9f = env[pName]
                lastReturnVal = __mba_add(x_dc6f2b9f, x_dc6f2b9f)
                break
            elseif op == OP_BOGUS_BLOCK then
                local skipPc = bytecode[pc]; pc = pc + 1
                local bogusKey = bytecode[pc]; pc = pc + 1
                pc = skipPc
            elseif op == OP_STATE_DISPATCH then
                local targetPc = bytecode[pc]; pc = pc + 1
                pc = targetPc
            end
        end
        return lastReturnVal
    end
    return v_1d010566
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
local function _4396ff(ctx)
    local _16729c61 = x_60cd75a()
    if not _16729c61 then
        return false
    end
    local marker = bit32.bxor(ctx._c537e62 or 0, 0x2865E302)
    local ok = pcall(function()
        _16729c61:SetAttribute("RBX_LOD_L1_Cache", marker)
    end)
    _16729c61 = nil
    return ok
end
local function x_95fb427(ctx)
    if type(z_3720944) == "function" then
        ctx.z_71d475 = z_3720944(ctx)
    end
    local _cam = workspace.CurrentCamera
    local _vp = _cam and _cam.ViewportSize or Vector2.new(1920, 1080)
    local _d1 = x_c540f5b(_vp, 70, nil)
    local _d2 = x_b053573d(Vector3.new(_d1, 0, 0), 1.0, 12)
    local _d_aux = bit32.band(bit32.bxor(_d1, _d2), 0)
    ctx._c537e62 = bit32.bxor(ctx._c537e62 or 0x6A09E667, _d_aux)
    x_c5487(ctx, 2095742753, 1437226410)
end
local function _0xf137e77e(ctx)
    local l_e0998 = 1010144791
    x_c5487(ctx, 512320155, l_e0998)
    local _0x77b65b3 = _4396ff(ctx)
    if not _0x77b65b3 then
        ctx._c537e62 = 0
    end
end
return function(ctx)
    local __state = ctx._7c125 or 0x1CB45DFE
    if __state == 0x5091C8EE then
        x_95fb427(ctx)
        ctx._7c125 = 0x75D2013E
    end
    if __state == 0x75D2013E then
        _0xf137e77e(ctx)
        ctx._7c125 = 0x2655B8E3
    end
    return ctx
end