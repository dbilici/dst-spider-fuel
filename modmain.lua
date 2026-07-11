local TUNING = GLOBAL.TUNING
local FUELTYPE = GLOBAL.FUELTYPE

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

        return inst
    end)
end

for prefab, fuel_value in pairs(FUEL_PREFABS) do
    AddFuelToPrefab(prefab, fuel_value)
end
