local sizes = {"tiny", "small", "medium"}
local values = {tiny=7.5,small=15,medium=45}
local function run(gland,silk,debugmode)
    local hooks, logs, messages, ents = {}, {}, {}, {}
    local player={components={talker={Say=function(_,msg) messages[#messages+1]=msg end}}}
    local env=setmetatable({}, {__index=_G})
    env.GLOBAL={
        TUNING={TINY_FUEL=7.5,SMALL_FUEL=15,MED_FUEL=45},
        FUELTYPE={BURNABLE="BURNABLE"}, tostring=tostring,pairs=pairs,table=table,
        TheWorld={ismastersim=true}, Ents=ents,
        print=function(msg) logs[#logs+1]=msg end,
        ConsoleCommandPlayer=function() return player end,
    }
    env.GetModConfigData=function(key)
        return ({spidergland_fuel_value=gland,silk_fuel_value=silk,debug_logging=debugmode})[key]
    end
    env.AddPrefabPostInit=function(name,fn) hooks[name]=fn end
    local chunk=assert(loadfile("modmain.lua")); setfenv(chunk,env); chunk()
    local function item(name,existing)
        local original={}
        local inst={prefab=name,components={}}
        inst.components[name=="silk" and "upgrader" or "healer"]=original
        local adds=0
        if existing then inst.components.fuel={ontaken=original} end
        function inst:AddComponent(key) assert(key=="fuel"); adds=adds+1; self.components[key]={} end
        hooks[name](inst)
        assert(inst.components.fuel.fueltype=="BURNABLE")
        assert(inst.components.fuel.fuelvalue==(name=="silk" and (values[silk] or 15) or (values[gland] or 7.5)))
        assert(inst.components[name=="silk" and "upgrader" or "healer"]==original)
        assert(inst._spider_fuel_patched)
        assert(adds==(existing and 0 or 1))
        if existing then assert(inst.components.fuel.ontaken==original) end
        ents[#ents+1]=inst
        return inst
    end
    local initial=#logs
    item("silk",false); item("spidergland",true)
    assert(#logs==initial,"spawn logging must remain quiet")
    assert(env.GLOBAL.c_sf==env.GLOBAL.SPIDER_FUEL_DEBUG)
    env.GLOBAL.c_sf()
    assert(#logs==initial+3)
    assert(logs[#logs]:find("mismatched=0",1,true))
    assert(#messages==(debugmode=="announce" and 1 or 0))
    ents[1].components.fuel.fuelvalue=-1
    env.GLOBAL.c_sf()
    assert(table.concat(logs,"\n"):find("mismatched=1",1,true))
    env.GLOBAL.TheWorld.ismastersim=false
    local client={components={}}
    hooks.silk(client)
    assert(not client.components.fuel and not client._spider_fuel_patched)
    env.GLOBAL.c_sf()
    assert(logs[#logs]:find("remote server console",1,true))
    assert(initial==((debugmode==true or debugmode=="log" or debugmode=="announce") and 1 or 0))
end
for _,g in ipairs(sizes) do
    for _,s in ipairs(sizes) do run(g,s,"off") end
end
run(nil,"invalid",false)
run("tiny","small",true)
run("tiny","small","log")
run("tiny","small","announce")
print("Spider Fuel regression tests passed")
