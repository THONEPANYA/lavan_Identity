ESX = exports["es_extended"]:getSharedObject()
local guiEnabled = false
local identityChecked = false

-- ==========================================
-- ฟังก์ชันเปิด UI (ทำงานทันที)
-- ==========================================
function OpenLavanUI()
    if identityChecked then return end
    identityChecked = true

    print("[Lavan Identity] ⏳ กำลังดึงข้อมูล...")
    
    ESX.TriggerServerCallback('lavan_identity:getWhitelistData', function(data)
        if data then 
            EnableGui(true, data) 
        else 
            print("[Lavan Identity] ❌ ไม่พบข้อมูล Whitelist") 
        end
    end)
end

-- ==========================================
-- ดักจับที่ 1: ESX Core สั่งให้เปิด
-- ==========================================
RegisterNetEvent('esx_identity:showRegisterIdentity')
AddEventHandler('esx_identity:showRegisterIdentity', function()
    OpenLavanUI() -- เปิดทันที ไม่ต้อง Wait!
end)

-- ==========================================
-- ดักจับที่ 2: ตอนโหลดเข้าเกมเสร็จปุ๊บ
-- ==========================================
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    if identityChecked then return end 

    ESX.TriggerServerCallback('lavan_identity:checkAlreadyRegistered', function(hasIdentity)
        if not hasIdentity then
            -- ถ้ายังไม่มีชื่อ ให้เปิด UI เราทันที!
            OpenLavanUI()
        end
    end)
end)

-- ==========================================
-- ฟังก์ชันควบคุม UI
-- ==========================================
function EnableGui(state, data)
    SetNuiFocus(state, state)
    guiEnabled = state

    if state then
        FreezeEntityPosition(PlayerPedId(), true) 
        
        -- 🛑 บังคับปิดหน้าแต่งตัว (ถ้ามันแอบเด้งขึ้นมาซ้อน)
        TriggerEvent('skincraetor:closeMenu')
        TriggerEvent('esx_skin:closeSaveableMenu')
    else
        FreezeEntityPosition(PlayerPedId(), false)
    end

    SendNUIMessage({
        type = "enableui",
        enable = state,
        data = data
    })
end

-- ==========================================
-- เมื่อกดยืนยันจาก UI
-- ==========================================
RegisterNUICallback('register', function(data, cb)
    TriggerServerEvent('lavan_identity:saveIdentity', data)
    cb('ok')
end)

-- ==========================================
-- บันทึกสำเร็จ ค่อยส่งไปแต่งตัว!
-- ==========================================
RegisterNetEvent('lavan_identity:registerSuccess')
AddEventHandler('lavan_identity:registerSuccess', function()
    EnableGui(false)
    identityChecked = false 
    
    -- ส่งสัญญาณบอก Core ว่าลงทะเบียนเสร็จแล้ว
    TriggerEvent('esx_identity:completedRegistration')
    
    DoScreenFadeOut(500)
    Wait(1000)
    
    -- ✅ อนุญาตให้หน้าแต่งตัวเด้งขึ้นมาได้!
    TriggerEvent('esx_skin:openSaveableMenu') 
    
    DoScreenFadeIn(500)
end)

RegisterCommand('test_ui', function()
    identityChecked = false
    OpenLavanUI()
end)