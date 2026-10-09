--!strict
-- =============================================================================
-- [00_loader.luau] ZEROIN CRYPTOGRAPHIC PIPELINE ORCHESTRATOR (EVERGREEN)
-- Static bootstrap orchestrator: Remains immutable across script updates.
-- Dynamically fetches & executes pipeline chunks from remote server (GitHub Raw)
-- or local fallback environments without requiring any updates to this loader.
-- =============================================================================

local Auth = ...

-- Default remote server base URL (e.g. GitHub Raw endpoint)
-- Can be dynamically overridden by passing Auth.baseUrl or Auth.serverUrl
local DEFAULT_REMOTE_BASE_URL = "https://raw.githubusercontent.com/vandawam/testing/main/dist"

-- [[ ENGINE DECOY: RENDER CASCADE OPTIMIZER ]]
local function rbxComputeLODCascade(viewportRes: Vector2, fovBias: number, occlusionBuffer: any): number
    local aspect = viewportRes.X / math.max(1.0, viewportRes.Y)
    local lodAccumulator = (aspect * 1.414) + (fovBias * 0.707)
    local sampleSteps = math.clamp(math.floor(lodAccumulator * 8), 4, 32)
    local weight = 0.0
    for i = 1, sampleSteps do
        local phase = (i / sampleSteps) * 3.14159265
        weight = weight + math.sin(phase) * 0.125
    end
    return math.floor(weight * 1000)
end

-- [[ OPAQUE STATE INTERLEAVING CONTEXT ]]
-- Isolated closure proxy context table; bypasses _G/shared and defeats static variable tracking
local function __create_opaque_context(initialArgs: any): any
    local _shadow = {
        __ratchet_state = 0x6A09E667,
        __auth_raw = initialArgs,
        __entropy_seed = 0,
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
                -- Honeypot trap: return synthetic plausible values to mislead dumpers
                return _traps[key]
            end
            return _shadow[key]
        end,
        
        __newindex = function(_, key, value)
            if _traps[key] ~= nil then
                -- Silently discard modifications to honeypot trap keys
                _traps[key] = value
                return
            end
            _shadow[key] = value
        end,
        
        __metatable = "The metatable is locked",
        
        __tostring = function()
            return "RenderContextInstance::0x" .. string.format("%08X", _shadow.__ratchet_state or 0)
        end
    }
    
    return setmetatable(proxy, mt)
end

-- [[ UNIVERSAL HTTP GET FETCHER ]]
-- Works across all Roblox executors (game:HttpGet, request, http_request, syn.request)
local function __http_get(url: string): string?
    -- Method A: Standard executor game:HttpGet
    local ok1, res1 = pcall(function()
        return game:HttpGet(url)
    end)
    if ok1 and type(res1) == "string" and #res1 > 0 then
        return res1
    end
    
    -- Method B: Universal request / http_request table interface
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

-- [[ DYNAMIC CHUNK COMPILER ]]
-- Compiles raw Luau code string into executable module function
local function __compile_chunk(sourceCode: string, identifier: string): any?
    if typeof(loadstring) ~= "function" then
        return nil
    end
    local okLoad, chunkFactory = pcall(loadstring, sourceCode, "=" .. identifier)
    if okLoad and type(chunkFactory) == "function" then
        local okExec, callable = pcall(chunkFactory)
        if okExec and type(callable) == "function" then
            return callable
        end
    end
    return nil
end

-- [[ EVERGREEN DYNAMIC CHUNK DISCOVERY & FETCHING ENGINE ]]
-- Resolves chunks via: (1) Remote Server Manifest -> (2) Remote Probing -> (3) Local FS -> (4) Studio Hierarchy
local function __discover_pipeline_chunks(rawAuth: any): { (ctx: any) -> any }
    local callables = {}
    
    -- Determine target remote base URL (Auth override has highest priority)
    local targetBaseUrl = ""
    if type(rawAuth) == "table" then
        targetBaseUrl = tostring(rawAuth.baseUrl or rawAuth.serverUrl or rawAuth.remoteUrl or rawAuth.rawUrl or "")
    end
    if targetBaseUrl == "" then
        targetBaseUrl = DEFAULT_REMOTE_BASE_URL
    end
    
    -- Clean trailing slashes
    if targetBaseUrl:sub(-1) == "/" then
        targetBaseUrl = targetBaseUrl:sub(1, -2)
    end

    local isRemoteUrl = targetBaseUrl:match("^https?://") ~= nil

    -- =========================================================================
    -- STRATEGY 1: REMOTE SERVER FETCHING (GitHub Raw / Custom Server)
    -- =========================================================================
    if isRemoteUrl then
        local HttpService = game:GetService("HttpService")
        local chunkList = {}
        
        -- 1A. Fetch remote manifest.json
        local manifestUrl = targetBaseUrl .. "/manifest.json"
        local manifestRaw = __http_get(manifestUrl)
        
        if manifestRaw and #manifestRaw > 0 then
            local okJson, parsed = pcall(function()
                return HttpService:JSONDecode(manifestRaw)
            end)
            if okJson and type(parsed) == "table" and type(parsed.chunks) == "table" then
                chunkList = parsed.chunks
            end
        end
        
        -- 1B. Fallback: Fetch remote manifest.luau if JSON decode was unavailable
        if #chunkList == 0 then
            local manifestLuauUrl = targetBaseUrl .. "/manifest.luau"
            local manifestLuauRaw = __http_get(manifestLuauUrl)
            if manifestLuauRaw and #manifestLuauRaw > 0 then
                local parsedMod = __compile_chunk(manifestLuauRaw, "manifest")
                if type(parsedMod) == "table" and type(parsedMod.chunks) == "table" then
                    chunkList = parsedMod.chunks
                end
            end
        end
        
        -- Download each chunk listed in manifest from remote server
        if #chunkList > 0 then
            for i = 1, #chunkList do
                local chunkFilename = tostring(chunkList[i])
                local chunkUrl = targetBaseUrl .. "/" .. chunkFilename
                local chunkSource = __http_get(chunkUrl)
                
                if chunkSource and #chunkSource > 0 then
                    local chunkCallable = __compile_chunk(chunkSource, chunkFilename)
                    if type(chunkCallable) == "function" then
                        table.insert(callables, chunkCallable)
                    end
                end
            end
            
            -- If successfully fetched all chunks from remote server, return immediately!
            if #callables == #chunkList and #callables > 0 then
                return callables
            end
        end
    end

    -- =========================================================================
    -- STRATEGY 2: LOCAL EXECUTOR FILESYSTEM FALLBACK (readfile / listfiles)
    -- =========================================================================
    if #callables == 0 and typeof(readfile) == "function" and typeof(loadstring) == "function" then
        local foundFiles = {}
        
        if typeof(listfiles) == "function" then
            for _, dir in ipairs({ "dist", "." }) do
                local okList, files = pcall(listfiles, dir)
                if okList and type(files) == "table" then
                    for _, filePath in ipairs(files) do
                        local basename = filePath:match("([^/\]+)%.lua[u]?$")
                        local numStr = basename and basename:match("^(%d%d)_")
                        local num = tonumber(numStr)
                        if num and num > 0 then
                            table.insert(foundFiles, { idx = num, path = filePath })
                        end
                    end
                end
                if #foundFiles > 0 then break end
            end
        end
        
        table.sort(foundFiles, function(a, b) return a.idx < b.idx end)
        for _, f in ipairs(foundFiles) do
            local okRead, src = pcall(readfile, f.path)
            if okRead and src and #src > 0 then
                local chunkCallable = __compile_chunk(src, f.path)
                if type(chunkCallable) == "function" then
                    table.insert(callables, chunkCallable)
                end
            end
        end
        
        if #callables > 0 then
            return callables
        end
    end

    -- =========================================================================
    -- STRATEGY 3: ROBLOX STUDIO HIERARCHY FALLBACK (ModuleScripts)
    -- =========================================================================
    if #callables == 0 and typeof(script) == "Instance" then
        local candidates = {}
        for _, child in ipairs(script:GetChildren()) do
            if child:IsA("ModuleScript") and child ~= script then
                table.insert(candidates, child)
            end
        end
        if #candidates == 0 and script.Parent then
            for _, child in ipairs(script.Parent:GetChildren()) do
                if child:IsA("ModuleScript") and child ~= script then
                    table.insert(candidates, child)
                end
            end
        end
        
        local indexed = {}
        for _, inst in ipairs(candidates) do
            local numStr = inst.Name:match("^(%d%d)_")
            local num = tonumber(numStr)
            if num and num > 0 then
                table.insert(indexed, { idx = num, inst = inst })
            end
        end
        table.sort(indexed, function(a, b) return a.idx < b.idx end)
        
        for _, item in ipairs(indexed) do
            local ok, mod = pcall(require, item.inst)
            if ok and type(mod) == "function" then
                table.insert(callables, mod)
            end
        end
    end

    return callables
end

-- [[ PIPELINE ORCHESTRATION DISPATCHER ]]
local function __execute_pipeline(rawAuth: any)
    -- 1. Initialize Opaque Metatable Closure Context (bypasses _G and shared)
    local ctx = __create_opaque_context(rawAuth)
    
    -- 2. Dynamically discover & fetch all pipeline chunks (Remote Server -> Local Fallback)
    local stages = __discover_pipeline_chunks(rawAuth)
    
    -- 3. Sequentially execute chunks passing the opaque context along
    for stageIndex = 1, #stages do
        local stageCallable = stages[stageIndex]
        local ok, updatedCtx = pcall(stageCallable, ctx)
        if ok and updatedCtx then
            ctx = updatedCtx
        end
    end
    
    return ctx
end

-- Launch the pipeline with passed authentication payload
return __execute_pipeline(Auth)
