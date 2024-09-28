local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("inventory:server:OpenInventory", function(_type, inventoryName, exploitableItemsList)
    if _type == "shop" then
        exports['qb-inventory']:CreateShop({
            name = inventoryName,
            label = exploitableItemsList.label,
            slots = #exploitableItemsList.items,
            items = exploitableItemsList.items
        })
        return exports['qb-inventory']:OpenShop(source, inventoryName)
    end
    exports['qb-inventory']:OpenInventory(source, inventoryName)
end)