local QBCore = exports['qb-core']:GetCoreObject()
local SearchedObject = {}

RegisterNetEvent('ns-loot:RemoveItem', function(item,amount)
    if not amount then amount = 1 end
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(item,amount)
end)

QBCore.Functions.CreateCallback('ns-loot:GetObject', function(_, cb, entity)
    local currentTime = os.time()
    if SearchedObject[entity] ~= nil then
        if SearchedObject[entity].Time ~= nil then
            if SearchedObject[entity].Type ~= nil then
                local cooldown = Config.Objects[SearchedObject[entity].Type].Cooldown * 1000
                local time = SearchedObject[entity].Time
                if currentTime >= (time + cooldown) then
                    cb(false)
                else
                    cb(true)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('ns-loot:GetSlotItems', function(source, cb, items)
    local retval = false
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    DebugCode("CID: "..cid)

    -- Retrieve both primary and secondary inventories at the beginning
    local primary = exports['core_inventory']:getInventory('primary-' .. cid)
    local secondary = exports['core_inventory']:getInventory('secondry-' .. cid)

    -- Check each item against both inventories
    for _, item in pairs(items) do
        DebugCode("ITEM: "..tostring(item))
        
        -- Function to check for the item in a given inventory
        local function checkInventory(inventory)
            if inventory ~= nil then
                for _, v in pairs(inventory) do
                    if v ~= nil and v.name == item then
                        DebugCode("Found in inventory: "..item)
                        return item
                    end
                end
            else
                DebugCode("Inventory Returned Nil")
            end
            return false
        end

        -- Check primary inventory
        retval = checkInventory(primary)
        if retval then break end

        -- Check secondary inventory
        retval = checkInventory(secondary)
        if retval then break end
    end

    DebugCode("Final GetSlots: Retval: "..tostring(retval))
    cb(retval)
end)

RegisterNetEvent('ns-loot:SearchObject', function(Type, entity, success)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local settings = Config.Objects[Type]
    if not settings.IsPed then
        SearchedObject[entity] = {}
        SearchedObject[entity].Time = os.time()
        SearchedObject[entity].Type = Type
    end
    local rewardpool = Config.Rewards[settings.RewardList]
    local chance = math.random(1,100)
    local GotSkill = nil
    local SkillMultiplier = nil
    if Config.CoreSkills then
        if settings.SkillsAffected then
            local skills = exports['core_skills']:getPlayerSkills(source)
            for k,v in ipairs(settings.SkillsAffected) do
                for d,j in pairs(skills) do
                    if j == v.Skill then
                        GotSkill = settings.SkillsAffected[k]
                        break
                    end
                end
            end
        end
        if GotSkill ~= nil then
            SkillMultiplier = GotSkill.BonusAmount
        end
    end
    if success then
        DebugCode("Chance: "..tostring(chance))
        if chance <= settings.RewardChance then
            for i = 1, settings.RewardAmount, 1 do
                local pick = rewardpool[math.random(1, #rewardpool)]
                if SkillMultiplier ~= nil then
                    local addedvalue = 1 + (SkillMultiplier / 100)
                    pick.amount = pick.amount * addedvalue
                    pick.amount = math.floor(pick.amount)
                end
                Player.Functions.AddItem(pick.item, pick.amount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[pick.item], 'add', pick.amount)
                Wait(500) 
            end
        else
            SendNotify(src,"Looting", "You Found Nothing", 'error')
        end
    end
end)

function SendNotify(src, title, msg, type, time)
    if not title then title = "Looting" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then DebugCode("SendNotify Server Triggered With No Message") return end
    if Config.NotifyScript == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, msg, type, time)
    elseif Config.NotifyScript == 'okok' then
        TriggerClientEvent('okokNotify:Alert', src, title, msg, time, type, false)
    elseif Config.NotifyScript == 'qs' then
        TriggerClientEvent('qs-notify:Alert', src, msg, time, type)
    elseif Config.NotifyScript == 'other' then
        --add your notify event here
    end
end

function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end