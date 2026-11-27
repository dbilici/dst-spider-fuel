local TUNING = GLOBAL.TUNING
local FUELTYPE = GLOBAL.FUELTYPE
local VERSION = "1.2.0-beta.1"
local DEBUG_MODE = GetModConfigData("debug_logging")
-- Accept old boolean configuration values.
if DEBUG_MODE == true then DEBUG_MODE = "log" end
if DEBUG_MODE ~= "log" and DEBUG_MODE ~= "announce" then DEBUG_MODE = "off" end
local tostring = GLOBAL.tostring

local function WriteLog(message)
    if GLOBAL.print ~= nil then
        GLOBAL.print("[Spider Fuel " .. VERSION .. "] " .. tostring(message))
    end
end

local function DebugLog(message)
    if DEBUG_MODE ~= "off" then
        WriteLog(message)
    end
end

local FUEL_VALUE_BY_SIZE = {
    tiny = TUNING.TINY_FUEL,
    small = TUNING.SMALL_FUEL,
    medium = TUNING.MED_FUEL,
}

local function GetConfiguredFuelValue(option_name, fallback)
    local size = GetModConfigData(option_name)
    return FUEL_VALUE_BY_SIZE[size] or fallback
end

local FUEL_PREFABS = {
    spidergland = GetConfiguredFuelValue("spidergland_fuel_value", TUNING.TINY_FUEL),
    silk = GetConfiguredFuelValue("silk_fuel_value", TUNING.SMALL_FUEL),
}

local function AddFuelToPrefab(prefab, fuel_value)
    AddPrefabPostInit(prefab, function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return inst
        end

        if inst.components.fuel == nil then
            inst:AddComponent("fuel")
        end

        inst.components.fuel.fueltype = FUELTYPE.BURNABLE
        inst.components.fuel.fuelvalue = fuel_value
        inst._spider_fuel_patched = true

        return inst
    end)
end

for prefab, fuel_value in GLOBAL.pairs(FUEL_PREFABS) do
    AddFuelToPrefab(prefab, fuel_value)
end

local function Status()
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
        WriteLog("Use the remote server console for diagnostics.")
        return
    end
    local player = GLOBAL.ConsoleCommandPlayer ~= nil and GLOBAL.ConsoleCommandPlayer() or nil
    WriteLog("status: debug_mode=" .. tostring(DEBUG_MODE))
    local chat = {}

    for prefab, configured_value in GLOBAL.pairs(FUEL_PREFABS) do
        local spawned = 0
        local patched = 0
        local mismatched = 0

        for _, inst in GLOBAL.pairs(GLOBAL.Ents or {}) do
            if inst.prefab == prefab then
                spawned = spawned + 1
                if inst._spider_fuel_patched then
                    patched = patched + 1
                end
                local fuel = inst.components ~= nil and inst.components.fuel or nil
                if fuel == nil
                    or fuel.fueltype ~= FUELTYPE.BURNABLE
                    or fuel.fuelvalue ~= configured_value
                then
                    mismatched = mismatched + 1
                end
            end
        end

        local message = "prefab=" .. tostring(prefab)
            .. ", configured_value=" .. tostring(configured_value)
            .. ", spawned=" .. tostring(spawned)
            .. ", patched=" .. tostring(patched)
            .. ", mismatched=" .. tostring(mismatched)
        WriteLog(message)
        chat[#chat + 1] = prefab .. ": " .. tostring(patched) .. "/" .. tostring(spawned) .. " patched, " .. tostring(mismatched) .. " mismatched"
    end
    if DEBUG_MODE == "announce" and player ~= nil and player.components ~= nil
        and player.components.talker ~= nil then
        player.components.talker:Say(GLOBAL.table.concat(chat, "\n"))
    end
end

GLOBAL.c_sf = Status
GLOBAL.SPIDER_FUEL_DEBUG = Status

DebugLog(
    "loaded: spidergland=" .. tostring(FUEL_PREFABS.spidergland)
    .. ", silk=" .. tostring(FUEL_PREFABS.silk)
)
