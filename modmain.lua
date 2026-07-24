local TUNING = GLOBAL.TUNING
local FUELTYPE = GLOBAL.FUELTYPE
local VERSION = "1.1.2"
local DEBUG_ENABLED = GetModConfigData("debug_logging") == true
local tostring = GLOBAL.tostring

local function WriteLog(message)
    if GLOBAL.print ~= nil then
        GLOBAL.print("[Spider Fuel " .. VERSION .. "] " .. tostring(message))
    end
end

local function DebugLog(message)
    if DEBUG_ENABLED then
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

        DebugLog("patched prefab=" .. tostring(prefab) .. ", fuelvalue=" .. tostring(fuel_value))

        return inst
    end)
end

for prefab, fuel_value in pairs(FUEL_PREFABS) do
    AddFuelToPrefab(prefab, fuel_value)
end

GLOBAL.SPIDER_FUEL_DEBUG = function()
    WriteLog("status: debug_logging=" .. tostring(DEBUG_ENABLED))

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

        WriteLog(
            "prefab=" .. tostring(prefab)
            .. ", configured_value=" .. tostring(configured_value)
            .. ", spawned=" .. tostring(spawned)
            .. ", patched=" .. tostring(patched)
            .. ", mismatched=" .. tostring(mismatched)
        )
    end
end

DebugLog(
    "loaded: spidergland=" .. tostring(FUEL_PREFABS.spidergland)
    .. ", silk=" .. tostring(FUEL_PREFABS.silk)
)
