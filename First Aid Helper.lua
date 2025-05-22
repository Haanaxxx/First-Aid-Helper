script_author("Hanyyysh")
script_version('v. 1.4 ')
script_description('https://www.blast.hk/threads/205445/')

local bNotf, notf = pcall(import, "imgui_notf.lua")
local imgui = require "mimgui"
local ffi = require "ffi"
require "lib.moonloader"
local tag = "{7B68EE}[PMP Helper]"
local fa = require("fAwesome5")
local wm = require 'windows.message'
local pmph = imgui.new.bool()
local tab = 1
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local inicfg = require 'inicfg'
local config = {
	main = {
		zaderjka = 3000,
	}
}



local repo_url = "https://raw.githubusercontent.com/Haanaxxx/First-Aid-Helper/First Aid Helper.lua"
local version_url = repo_url .. "version.txt"
local script_url = repo_url .. "First Aid Helper.lua"

function check_for_update()
    lua_thread.create(function()
        local handle = require("socket.http")
        local latest_version = handle.request(version_url)

        if latest_version and latest_version ~= current_version then
            print("?? Доступно обновление: v" .. latest_version)
            download_update()
        else
            print("? У вас актуальная версия: v" .. current_version)
        end
    end)
end

function download_update()
    print("?? Загружаю обновление...")
    local result = os.execute('curl -o script.lua ' .. script_url)

    if result then
        print("? Обновление загружено! Перезапустите скрипт.")
    else
        print("? Ошибка при загрузке обновления!")
    end
end





--->>>
local dopState = imgui.new.bool()
local versState = imgui.new.bool() 
local ompState = imgui.new.bool()
local oblState = imgui.new.bool()
--->>>

local posX, posY = 500, 500 

function main()
    while not isSampAvailable() do wait(100) end
    check_for_update()
    sampRegisterChatCommand('pmph', function()
        pmph[0] = not pmph[0] 
    end)
        sampAddChatMessage(tag .. " Загружен. Для активации введите - {ff0000}/pmph", -1)
        sampAddChatMessage(tag .. ' Автор скрипта - {ff0000}@Hanyyysh{7B68EE}, скрипт есть на BlastHack', -1)
        myID = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))

        if bNotf then
            notf.addNotification("PMP Helper загружен!\nАктивация /pmph или ctrl+ B ", 10, 10) 
        end
        print('Last Update: 27.04.2024. v. 1.3 Добавлены доп. отыгровки, imgui уведомления, разделение отыгровок по полу персонажа')
        cfg = inicfg.load(config, 'PMP.ini')
    wait(-1)
end

local versionscr =  -- В скором сделаю автообновление, скорее всего в некст апдейте 1.5
{   
    {"Добавлено окно ОМП, ссылки на скрипт и автора, небольшое перемещение вкладок", 1.4},
    {"Добавлены доп. отыгровки, imgui уведомления, разделение отыгровок по полу персонажа", 1.3},
    {"Переписан код скрипта чтобы глаза не мозолил, добавлена Информация", 1.2},
    {"Исправление несколько багов при срабатывании отыгровки", 1.1},
    {"Release March 2024", 1.0}

}


local buttons_menu = {
    { u8"Утопление", fa.ICON_FA_HEARTBEAT},
    { u8"Сердечно-Легочная Реанимация", fa.ICON_FA_TABLETS},
    { u8"Огнестрельное ранение", fa.ICON_FA_BAND_AID},
    { u8"Помощь при ушибе", fa.ICON_FA_PILLS},
    { u8"Потеря сознания", fa.ICON_FA_MEDKIT},
    { u8"Реанимация с дефибриллятором", fa.ICON_FA_HEART},
    { u8"Первичная помощь при переломе", fa.ICON_FA_BONE}
}

imgui.OnFrame(function() return pmph[0] end, function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(390, 280), imgui.Cond.FirstUseEver + imgui.WindowFlags.NoResize)
imgui.Begin(fa.ICON_FA_USER_CIRCLE .. u8" Хелпер для первой помощи", pmph, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
if imgui.Button(fa.ICON_FA_CODE .. u8' РП отыгровки', imgui.ImVec2(123,25)) then tab = 1 end 
imgui.SameLine()
if imgui.Button(fa.ICON_FA_LIST .. u8' Настройки', imgui.ImVec2(123,25)) then tab = 3 end
imgui.SameLine()
if imgui.Button(fa.ICON_FA_PEN .. u8' Информация', imgui.ImVec2(123,25)) then tab = 2 end
imgui.Separator()
if tab == 1 then
    local action_functions = {
        rp_ytop, rp_slr, rp_ognestrel, rp_yshib, rp_sozn, rp_deff, rp_perelom
    }
    
    for i, button in ipairs(buttons_menu) do
        local text = button[1]
        local icon = button[2]
    
        if imgui.Button(icon .. " " .. text, imgui.ImVec2(380, 25)) then
            if action_functions[i] then
                action_functions[i]()
            end
        end
    end
elseif tab == 2 then
    if imgui.Button(u8'Обновления скрипта') then 
        oblState[0] = not oblState[0]
    end
    imgui.SameLine()
    imgui.Button(u8'VK автора скрипта')
    if imgui.IsItemClicked() then
        os.execute("explorer https://vk.me/hanyyysh")
    end
    imgui.SameLine()
    imgui.Button(u8'TG автора скрипта')
    if imgui.IsItemClicked() then
        os.execute("explorer https://t.me/hanyyyysh")
    end
    imgui.Separator()
    imgui.Button(u8'Автор на Blast Hack', imgui.ImVec2(187,25))
    if imgui.IsItemClicked() then
        os.execute("explorer https://www.blast.hk/members/444164/")
    end
    imgui.SameLine()
    imgui.Button(u8'Скрипт на Blast Hack', imgui.ImVec2(187,25))
    if imgui.IsItemClicked() then
        os.execute("explorer https://www.blast.hk/threads/205445/")
    end
elseif tab == 3 then
    if imgui.Button(u8' Открыть доп. меню', imgui.ImVec2(380,25)) then
        dopState[0] = not dopState[0]
    end
    if imgui.Button(u8' Включить виджет ОМП', imgui.ImVec2(380,25)) then
        ompState[0] = not ompState[0]
    end
    imgui.CText(u8'Значение задержки') 
    local waitint = imgui.new.int(cfg.main.zaderjka)
    imgui.PushItemWidth(380)
		if imgui.SliderInt(u8 '', waitint, 1000, 10000) then
			cfg.main.zaderjka = waitint[0]
			inicfg.save(config, 'PMP.ini')
            imgui.PopItemWidth()         
        end
    end
imgui.End()
end)

imgui.OnFrame(function() return dopState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(260, 150), imgui.Cond.Always)
    player.HideCursor = isKeyDown(0x12)
    imgui.Begin(fa.ICON_FA_BARS .. u8' Дополнительные отыгровки', dopState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    if imgui.Button(fa.ICON_FA_FLASK .. u8' Обработка рук перед помощью', imgui.ImVec2(250,25)) then rp_obr()
    end

    if imgui.Button(fa.ICON_FA_BOOK_MEDICAL .. u8' Обработать марлю', imgui.ImVec2(250,25)) then rp_marl()
    end

    if imgui.Button(fa.ICON_FA_SYRINGE .. u8' Сделать укол обезболивающего', imgui.ImVec2(250,25)) then rp_obez()
    end

    if imgui.Button(fa.ICON_FA_STAR_OF_DAVID .. u8' Ввести анестезию пациенту', imgui.ImVec2(250,25)) then rp_anest()
    end
imgui.End()
end)

imgui.OnFrame(function() return ompState[0] end, function(player)
    imgui.SetNextWindowSize(imgui.ImVec2(250, 150), imgui.Cond.Always)
    imgui.Begin(fa.ICON_FA_HEARTBEAT.. u8' Оказание Медицинской Помощи', ompState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.CText(u8'Ваш ник в докладе: ' .. myID)
if imgui.Button(u8'Доклад о выезде на ОМП', imgui.ImVec2(240,25)) then
        sampSendChat('/r Это ' .. myID .. ', выезжаю для оказания медицинской помощи')
    end
if imgui.Button(u8'Доклад о конце ОМП', imgui.ImVec2(240,25)) then
        sampSendChat('/r Это ' .. myID .. ', заканчиваю оказанием медицинской помощи.')
    end
    imgui.End()
end)

imgui.OnFrame(function() return oblState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 280), imgui.Cond.FirstUseEver + imgui.WindowFlags.NoResize)
imgui.Begin(u8" ##Обновы", oblState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.Text(u8'Новые обновления доступны на Blast Hack')
imgui.Separator()
for i = 1, #versionscr do
    imgui.Text(u8(versionscr[i][2] .. " "..versionscr[i][1]))
    end
    imgui.End()
end)


function rp_ytop()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, ytopp)
    end)
end

function rp_slr()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, slrt)
    end)
end 

function rp_ognestrel()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, ognstr)
    end)
end

function rp_yshib()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, yshib)
    end)
end

function rp_sozn()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, soznn)
    end)
end

function rp_deff()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, deffbr)
    end)
end

function rp_perelom()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, perel)
    end)
end

function rp_marl()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, marlya)
    end)
end

function rp_obez()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, obezbol)
    end)
end

function rp_obr()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, obr)
    end)
end

function rp_anest()
    lua_thread.create(function()
        multiStringSendChat(cfg.main.zaderjka, anest)
    end)
end



imgui.OnInitialize(function()
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromFileTTF('trebucbd.ttf', 14.0, nil, glyph_ranges)
    icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 14.0, config, iconRanges)
end)

function imgui.CText(text)
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((imgui.GetWindowWidth() - calc.x) / 2)
    imgui.Text(text)
   end

   function multiStringSendChat(delay, multiStringText)   
    lua_thread.create(function()
        multiStringText = multiStringText..'\n'
        for s in multiStringText:gmatch('.-\n') do
            sampSendChat(s, -1)
            wait(delay)
        end
    end)
end

yshib = [[
/me достав из мед.сумки тугую повязку, наложил ее к месту ушиба
/me достав из сумки пузырек с сухим льдом, приложил к месту ушиба ]]

soznn = [[/do В аптечке бутылка с нашатырем и ватка
/me достав бутылку с нашатырем, откупорил ее и взял ватку
/me смочив ватку в нашатыре, провел ею у ноcа пострадавшего
/do Эффект? ]]

deffbr = [[/me аккуратно приложил платок ко рту пострадавшего, после чего сделал глубокий вдох
/me подвел губы ко рту пострадавшего, после чего начал делать искусственное дыхание
/me освободил торс человека от одежды и аксессуаров, клеит электроиды на торс из сумки АНД
/me повторив действия СЛР, произвел разряд
/do Эффект? ]]

ognstr = [[/do В руках врача аптечка ALS.
/me открыв аптечку, достал оттуда жгут, наложил его выше место ранения и замотал
/me достав шприц с обезболивающим, произвел укол ниже места ранения пострадавшему ]]

slrt = [[Не волнуйтесь, сейчас я окажу Вам экстренную помощь!
/me легким движением пальца прислонил к шее пациента, после чего начал измерять пульс
/do У пациента отсутствует пульс.
/todo Нужно быстро принять меры!*посмотрев на мед. сумку
/me легким движением руки открыл мед. сумку, после чего достал платок
/me аккуратно приложил платок ко рту пострадавшего, после чего сделал глубокий вдох
/do В лёгких много воздуха.
/me встал на колени, после чего прислонилcя к пациенту
/me подвел губы ко рту пострадавшего, после чего начал делать искусственное дыхание
/me отвел губы от рта пострадавшего, после чего сделал глубокий вдох
/me подвел губы ко рту пострадавшего, после чего начал делать искусственное дыхание ]]

ytopp = [[/me присев к человеку напротив, поставил мед.сумку на землю
/me немного приклонившись перед пострадавшим, сложил руки...
/me ...в замок на груди пострадавшего
/do Врач готов к реанимации пострадавшего.
/me сделав 30 давящих на грудь движений в такт, отсчитал каждое в голове
/me не заметив реакции человека, повторил действия еще раз
/do Пострадавший в сознании? ]]

perel = [[/me осмотрел место перелома
/do В сумке ALS лежит шина
/me взяв шину, осторожно положил ее вдоль сломанной конечности
/do Шина наложена.
/me протянув руку к карману сумки, расстегнул его и достал бинт
/me разорвав бинт, начал фиксировать шину на сломанной конечности
/me зафиксировав шину, оторвал бинт ]]

marlya = [[/me открыв мед.сумку ALS, достал оттуда марлю
/do Марля в руках врача.
/me достав флакон со спиртом, оторвал колбу
/me смочил спиртом марлю, убрал флакон в сумку ]]

obezbol = [[/do В руках врача мед.сумка.
/me расстегнув сумку достал оттуда шприц с обезболивающим средством
/me оторвал защитную капсулу скрипта и ударил кончиками пальцев по шприцу
/me легко нажав на поршень, выдавил из шприца воздух
/me аккуратно поднеся шприц к человеку, ввел лекарство и убрал шприц ]]

obr = [[/do В мед.сумке врача антисептическое средство, стерлиная маска и перчатки.
/me достав из сумки антисептик, выдавил немного содержимого и обработал руки
/me взяв перчатки, натянул на руки, обработав их антисептиком
/me кончиками пальцев взял маску и натянул на лицо ]]

anest = [[/do Возле врача аппарат с анестезией.
/me взяв маску с аппарата надел ее на лицо пациента
/me переключил аппарат в режим работы, наблюдает за показателями
/do Анестезия работает и подается в организм]]

addEventHandler("onWindowMessage", function(msg, wparam, lparam)
    if wparam == 0x42 and isKeyJustPressed(VK_CONTROL) and not sampIsChatInputActive() and not sampIsDialogActive() then -- ctrl + b
        consumeWindowMessage()
        pmph[0] = not pmph[0]
        end
end)

imgui.OnInitialize(function()
    themeExample()
end)
function themeExample()
    imgui.SwitchContext()
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1

    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    --==[ COLORS ]==--
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end



