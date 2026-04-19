-- ==========================================
-- Lavan Identity - Server Side
-- ==========================================

local BotToken =""

-- 🎁 ตั้งค่าของเริ่มต้นสำหรับผู้เล่นใหม่ (Starter Pack)
local StarterPack = {
    giveMoney = true,         -- ต้องการแจกเงินไหม? (true/false)
    money = 5000,             -- เงินสดกระเป๋าเขียว
    bank = 50000,             -- เงินในธนาคาร
    
    giveItems = true,         -- ต้องการแจกไอเทมไหม? (true/false)
    items = {
        {name = 'phone', count = 1},   -- โทรศัพท์ 1 เครื่อง
        {name = 'bread', count = 5},   -- ขนมปัง 5 ชิ้น
        {name = 'water', count = 5},   -- น้ำเปล่า 5 ขวด
        -- {name = 'id_card', count = 1}, -- (ตัวอย่าง) บัตรประชาชน ถ้าเซิร์ฟมีสคิปต์บัตร
    }
}

ESX.RegisterServerCallback('lavan_identity:getWhitelistData', function(source, cb)
    local src = source
    local discordId = nil

    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end

    if not discordId then return cb(nil) end

    MySQL.query('SELECT * FROM lavan_whitelist WHERE discord_id = ?', {discordId}, function(result)
        if result and result[1] then
            local dbData = result[1]
            local safeData = {
                discord_name = dbData.discord_name or "Unknown",
                firstname = dbData.firstname or "",
                lastname = dbData.lastname or "",
                dob = tostring(dbData.dob) or "",
                gender = dbData.gender or "m",
                height = dbData.height or 170
            }
            
            PerformHttpRequest("https://discord.com/api/v10/users/" .. discordId, function(err, text, headers)
                local avatarUrl = "https://cdn.discordapp.com/embed/avatars/0.png"
                if err == 200 and text then
                    local avatarHash = string.match(text, '"avatar"%s*:%s*"([^"]+)"')
                    if avatarHash then
                        avatarUrl = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. avatarHash .. ".png?size=512"
                    end
                end
                
                safeData.avatarUrl = avatarUrl
                cb(safeData)
            end, 'GET', '', { ['Authorization'] = BotToken })
        else
            cb(nil)
        end
    end)
end)

-- ส่วนบันทึกข้อมูลและแจกของ
RegisterNetEvent('lavan_identity:saveIdentity')
AddEventHandler('lavan_identity:saveIdentity', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        MySQL.update('UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ? WHERE identifier = ?', {
            data.firstname, data.lastname, data.dob, data.gender, data.height, xPlayer.identifier
        }, function(affectedRows)
            if affectedRows > 0 then
                -- 1. เซ็ตชื่อในเกม
                xPlayer.setName(('%s %s'):format(data.firstname, data.lastname))
                xPlayer.set('firstName', data.firstname)
                xPlayer.set('lastName', data.lastname)
                xPlayer.set('dateofbirth', data.dob)
                xPlayer.set('sex', data.gender)
                xPlayer.set('height', data.height)

                -- ==========================================
                -- 🎁 2. ระบบแจกของ Starter Pack (Lavan Custom)
                -- ==========================================
                
                -- แจกเงินสดและเงินธนาคาร
                if StarterPack.giveMoney then
                    if StarterPack.money > 0 then
                        xPlayer.addMoney(StarterPack.money)
                    end
                    if StarterPack.bank > 0 then
                        xPlayer.addAccountMoney('bank', StarterPack.bank)
                    end
                end

                -- แจกไอเทม
                if StarterPack.giveItems then
                    for i=1, #StarterPack.items do
                        local item = StarterPack.items[i]
                        xPlayer.addInventoryItem(item.name, item.count)
                    end
                end
                
                print("^2[Lavan Identity] 💾 บันทึกข้อมูลและแจก Starter Pack ให้ " .. data.firstname .. " สำเร็จ!^0")
                TriggerClientEvent('lavan_identity:registerSuccess', src)
            end
        end)
    end
end)

ESX.RegisterServerCallback('lavan_identity:checkAlreadyRegistered', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local fName = xPlayer.get('firstName')
        if not fName or fName == '' then cb(false) else cb(true) end
    else
        cb(false)
    end
end)