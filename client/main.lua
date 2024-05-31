local QBCore = exports['qb-core']:GetCoreObject()

for k,v in pairs(Config.Objects) do
    if v.Models then
        for _,j in pairs(v.Models) do
            AddTargetModel(j,k,v)
        end
    end
end

function AddTargetModel(model, Type, settings)
    if Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetModel(model, {
            options = {
                {
                    action = function(entity) 
                        PrepSearchObject(Type,entity,settings.Require,settings.ActionTime) 
                    end,
                    canInteract = function(entity)
                        if not settings.IsPed then
                            return true
                        elseif settings.IsPed and IsEntityDead(entity) then
                            return true
                        else
                            return false
                        end
                    end,
                    icon = settings.Icon,
                    label = settings.Label,
                },
            },
            distance = 2.0
        })
    elseif Config.Target == 'ox' then --should work but not 100% sure
        exports.ox_target:addModel(model, {
                {
                    icon = settings.Icon, 
                    label = settings.Label,
                    onSelect = function(entity) 
                        PrepSearchObject(Type,entity,settings.Require,settings.ActionTime) 
                    end,
                    canInteract = function(entity)
                        if not settings.IsPed then
                            return true
                        elseif settings.IsPed and IsEntityDead(entity) then
                            return true
                        else
                            return false
                        end
                    end
                }
            }
        )
    end
end

local function CheckZone()
    local retval = true
    for k,v in pairs(Config.NoLootZones) do
        if #(GetEntityCoords(PlayerPedId()) - vec3(v.Coords.x,v.Coords.y,v.Coords.z)) < v.Radius then
            retval = false
            break
        end
    end
    return retval
end

function HasItem(items, cb)
    local retval = false

    if Config.CoreInventory then
        QBCore.Functions.TriggerCallback('ns-loot:GetSlotItems', function(result)
            if result then
                retval = result
                DebugCode("HasItem:Callback:" .. tostring(retval))
                cb(retval) 
            else
                DebugCode("Else Statement Running")
                for _,v in pairs(items) do
                    if QBCore.Functions.HasItem(v) then
                        retval = v
                        cb(retval)
                        return
                    end
                end
                cb(false)
            end
        end, items)
    else
        DebugCode("Else 2 Statement Running")
        for _,v in pairs(items) do
            if QBCore.Functions.HasItem(v) then
                retval = v
                cb(retval)
                return
            end
        end
        cb(false)
    end
end

function PrepSearchObject(Type, entity, required, time)
    local settings = Config.Objects[Type]
    QBCore.Functions.TriggerCallback('ns-loot:GetObject', function(searched)
        if not searched then
            if CheckZone() then
                if settings.Emote then
                    ExecuteCommand("e " .. settings.Emote)
                end
                if required and required.Item ~= nil then
                    HasItem(required.Item, function(ITEM)
                        if ITEM then
                            SearchObject(Type, entity, settings, ITEM)
                        else
                            SendNotify("Loot", "You Don't Have a Tool For This", "error")
                            Wait(500)
                            ClearPedTasks(PlayerPedId())
                        end
                    end)
                else
                    if not required then
                        DebugCode("v.required no item set")
                        SearchObject(Type, entity, settings)
                    end
                end
            else
                SendNotify(nil, "Cannot Loot This Area", 'error')
            end
        else
            SendNotify("Loot", "This Has Already Been Searched", "error")
        end
    end, entity)
end


function StartMinigame(Type)
    local MiniGame = Config.Objects[Type].MiniGame
    local retval = false
    if not MiniGame then return true end
    if MiniGame == 'ps-ui' then
        exports['ps-ui']:Circle(function(success)
            if success then
                retval = true
            else
                retval = false
            end
        end, 2, 20) -- NumberOfCircles, MS
    elseif MiniGame == 'skillpoint' then
        exports['ps-ui']:Circle(function(success)
            if success then
                retval = true
            else
                retval = false
            end
        end, 1, 30) -- NumberOfCircles, MS
    elseif MiniGame == 'custom' then
        DebugCode("put your own minigame export / event here")
    else
        DebugCode("Minigame applied to Object but no Valid Minigame Setup in Clint.lua")
    end
    return retval
end

function SearchObject(Type, entity, settings, ITEM)
    if StartMinigame(Type) then
        QBCore.Functions.Progressbar("pickup_sla", settings.ActionLabel, settings.ActionTime * 1000, false, true, 
	    {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, 
	    {}, {}, {}, function() -- Done
            if settings.IsPed then
                DeleteEntity(entity)
            end
	    	TriggerServerEvent('ns-loot:SearchObject',Type,entity,true)
            ClearPedTasks(PlayerPedId())
	    end, function()
	    	SendNotify("Loot","Cancelled..", "error")
            ClearPedTasks(PlayerPedId())
	    end)
    else
        if settings.IsPed then
            DeleteEntity(entity)
        end
        if settings.OnFail then
            if settings.OnFail.ApplyDamage then
                local useArmour = true
                if settings.OnFail.IgnoreArmour then
                    useArmour = false
                end
                ApplyDamageToPed(PlayerPedId(),settings.OnFail.ApplyDamage,useArmour)
            end
            if settings.OnFail.Ragdoll then
                SetPedToRagdoll(PlayerPedId(), math.random(1000, 6000), math.random(1000, 6000), 0, false, false, false)
            end
            if settings.OnFail.Effect then
                ApplyEffectToPlayer(settings.OnFail.Effect)
            end
            if settings.OnFail.TriggerClientEvent then
                if settings.OnFail.EventArguments then
                    TriggerEvent(settings.OnFail.TriggerClientEvent,settings.OnFail.EventArguments)
                else
                    TriggerEvent(settings.OnFail.TriggerClientEvent)
                end
            end
            if settings.OnFail.TriggerServerEvent then
                if settings.OnFail.EventArguments then
                    TriggerServerEvent(settings.OnFail.TriggerServerEvent,settings.OnFail.EventArguments)
                else
                    TriggerServerEvent(settings.OnFail.TriggerServerEvent)
                end
            end

        end
        TriggerServerEvent('ns-loot:SearchObject',Type,entity,false)
        ClearPedTasks(PlayerPedId())
    end

    if ITEM then
        if settings.Require.BreakChance and ITEM then
            local chance = math.random(1,100)
            if chance < settings.Require.BreakChance then
                TriggerServerEvent('ns-loot:RemoveItem',ITEM)
            end
        end
    end

end

local PTFX_DICT = ''
local PTFX_ASSET = ''
local LOOP_AMOUNT = 0
local PTFX_DURATION = 0


-- Applies the particle effect to a ped
function ApplyEffectToPlayer(effectType)
    local settings = Config.OnFailEffects[effectType]
    if not settings then DebugCode("Invalid Effect Type") return end
    PTFX_DICT = settings.ParticleDictionary
    PTFX_ASSET = settings.ParticleAsset
    LOOP_AMOUNT = settings.LoopAmount
    PTFX_DURATION = settings.Duration * 1000
    
    local tgtPedId = PlayerPedId()
    CreateThread(function()
        if tgtPedId <= 0 or tgtPedId == nil then return end
        RequestNamedPtfxAsset(PTFX_DICT)

        -- Wait until it's done loading.
        while not HasNamedPtfxAssetLoaded(PTFX_DICT) do
            Wait(0)
        end

        local particleTbl = {}

        for i = 0, LOOP_AMOUNT do
            UseParticleFxAsset(PTFX_DICT)
            local partiResult = StartParticleFxLoopedOnEntity(PTFX_ASSET, tgtPedId, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, false, false, false)
            particleTbl[#particleTbl + 1] = partiResult
            Wait(0)
        end

        Wait(PTFX_DURATION)
        for _, parti in ipairs(particleTbl) do
            StopParticleFxLooped(parti, true)
        end
    end)
end

function SendNotify(title,msg,type,time)
    if Config.NotifyScript == nil then DebugCode("Looting: Config.NotifyScript Not Set!") return end
    if not title then title = "Looting" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then DebugCode("SendNotify Client Triggered With No Message") return end
    if Config.NotifyScript == 'qb' then
        QBCore.Functions.Notify(msg,type,time)
    elseif Config.NotifyScript == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, false)
    elseif Config.NotifyScript == 'qs' then
        exports['qs-notify']:Alert(msg, time, type)
    elseif Config.NotifyScript == 'other' then
        -- add your notify here
        exports['yournotifyscript']:Notify(msg,time,type)
    end
end

function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end