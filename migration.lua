local function tableExists(tableName)
    local result = MySQL.query.await('SHOW TABLES LIKE ?', {tableName})
    return #result > 0
end

local function migrateStashData()

    if not tableExists('inventories') then
        MySQL.query.await([[CREATE TABLE IF NOT EXISTS `inventories` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(255) NOT NULL,
            `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`items`)),
            PRIMARY KEY (`identifier`),
            KEY `id` (`id`)
        ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;]])
    end
    
    if tableExists('trunkitems') then
        local trunkData = MySQL.query.await('SELECT `plate`, `items` FROM `trunkitems`')
        if trunkData then
            for i = 1, #trunkData do
                local row = trunkData[i]
                local identifier = "trunk-" .. row.plate
                
                MySQL.insert.await('INSERT INTO `inventories` (identifier, items) VALUES (?, ?)', {
                    identifier, row.items
                })
            end
        end
        MySQL.query.await('DROP TABLE IF EXISTS `trunkitems`')
    end

    if tableExists('gloveboxitems') then
        local gloveboxData = MySQL.query.await('SELECT `plate`, `items` FROM `gloveboxitems`')
        if gloveboxData then
            for i = 1, #gloveboxData do
                local row = gloveboxData[i]
                local identifier = "glovebox-" .. row.plate
                
                MySQL.insert.await('INSERT INTO `inventories` (identifier, items) VALUES (?, ?)', {
                    identifier, row.items
                })
            end
        end
        MySQL.query.await('DROP TABLE IF EXISTS `gloveboxitems`')
    end

    if tableExists('stashitems') then
        local stashData = MySQL.query.await('SELECT `stash`, `items` FROM `stashitems`')
        if stashData then
            for i = 1, #stashData do
                local row = stashData[i]
                
                MySQL.insert.await('INSERT INTO `inventories` (identifier, items) VALUES (?, ?)', {
                    row.stash, row.items
                })
            end
        end
        MySQL.query.await('DROP TABLE IF EXISTS `stashitems`')
    end
end

migrateStashData()

