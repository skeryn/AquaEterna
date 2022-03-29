local lootFilterIcon = 133666
local Print = function (input)
    AquaEterna:Print(AquaEterna:DisplayIcon(lootFilterIcon) .. " " .. input)
end

function AquaEterna:RegisterLootFilter()
    if (not self:IsEnabled() or not self:IsLootFilterEnabled()) then
        self:UnregisterLootFilter()
        return
    end
    self:RegisterEvent('LOOT_OPENED')
    SetCVar("autoLootDefault", 0)
end

function AquaEterna:UnregisterLootFilter()
    self:UnregisterEvent('LOOT_OPENED')
    SetCVar("autoLootDefault", 1)
end

function AquaEterna:LOOT_OPENED()
    table.foreach(GetLootInfo(), function (lootIndex, lootArray)

        -- Looting money first
        if (lootArray['quantity'] == 0) then
            LootSlot(lootIndex)
            return
        end
        
        table.foreach(self.db.profile.lootFilter.itemList, function(savedIndex, savedArray)
            if (lootArray['item'] == savedArray['name']) then
                if (savedArray['enabled'] == true) then
                    Print('Looting : '.. self:DisplayIcon(lootArray['texture']) .. ' ' .. lootArray['item'])
                    LootSlot(lootIndex)
                else
                    Print('|cffff0000Ignoring|r : '.. self:DisplayIcon(lootArray['texture']) .. ' ' .. lootArray['item'] ..' |cffff0000(disabled)|r')
                end
            end
        end)
    end)

    CloseLoot()
end

function AquaEterna:SetLootFilterEnabled(_, value)
    self.db.profile.lootFilter.enabled = value

    if (not self:IsEnabled() or not value) then
        self:UnregisterLootFilter()
    end

    if (value == true) then
        self:RegisterLootFilter()
    end
end

function AquaEterna:IsLootFilterEnabled()
    return self.db.profile.lootFilter.enabled
end

function AquaEterna:LoadLootFilterList()

    local list = {}

    table.foreach(self.db.profile.lootFilter.itemList, function (k, v) 
        list[k] = self:DisplayIcon(v['icon']) .. " " .. v['name']
    end)

    return list
end

function AquaEterna:IsLootItemActivated(_, key)
    return self.db.profile.lootFilter.itemList[key].enabled
end

function AquaEterna:SetLootItemActivated(_, key, value)
    self.db.profile.lootFilter.itemList[key].enabled = value
end


function AquaEterna:GetLootItem(_, key)
    if (self.db.profile.lootFilter.itemList[key] ~= nil) then
        return self.db.profile.lootFilter.itemList[key]
    end
end

function AquaEterna:DeleteLootItem(_, key)
    local item = self.db.profile.lootFilter.itemList[key] or nil
    if (not item) then
        return
    end
    Print("Removing ".. self:DisplayIcon(item.icon) .." ".. item.name .." from list")
    self.db.profile.lootFilter.itemList[key] = nil
end

function AquaEterna:AddLootItem(_, input)
    local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(input) 

    if (itemID == nil) then
        Print('Invalid item ' .. input)
        return
    end
    
    local item = Item:CreateFromItemID(itemID)
    item:ContinueOnItemLoad(function()
        local name = item:GetItemName() 
        local icon = item:GetItemIcon()

        Print("Adding ".. self:DisplayIcon(icon) .." ".. name .." to list")

        self.db.profile.lootFilter.itemList[itemID] = {
            name = name,
            icon = icon,
            enabled = true
        }
    end)
end