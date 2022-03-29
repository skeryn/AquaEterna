function AquaEterna:LoadDefaultProfile()
    return {
        profile = {
            enabled = true,
            lootFilter = {
                enabled = false,
                itemList = {}
            }
        },
    }
end

function AquaEterna:LoadOptions()
    return {
        name = "Aqua Eterna",
        handler = self,
        type = "group",
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                desc = "Enable/disable the addon",
                descStyle = "inline",
                width = "full",
                get = "IsEnabled",
                set = "SetEnabled"
            },
            lootFilter = {
                type = "group",
                width = "full",
                name = "Loot filter",
                args = {
                    enabled = {
                        type = "toggle",
                        name = "Enabled",
                        set = "SetLootFilterEnabled",
                        get = "IsLootFilterEnabled"
                    },
                    items = {
                        type = "multiselect",
                        name = "Whitelist",
                        values = "LoadLootFilterList",
                        get = "IsLootItemActivated",
                        set = "SetLootItemActivated"
                    },
                    add  = {
                        type = "input",
                        name = "Add",
                        get = function ()
                            return ""
                        end,
                        set = "AddLootItem"

                        
                    },
                    delete = {
                        type = "select",
                        name = "Delete",
                        values = "LoadLootFilterList",
                        get = "GetLootItem",
                        set = "DeleteLootItem"
                    }
                }
            }
        },
    }
end

function AquaEterna:IsEnabled()
    return self.db.profile.enabled
end

function AquaEterna:SetEnabled(_, value)
    self.db.profile.enabled = value
    
    if (value == true) then
        self:Enable()
    else
        self:Disable()
    end
end

