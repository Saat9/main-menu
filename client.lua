local screenW, screenH = guiGetScreenSize()

local backgroundColor = tocolor(0, 0, 0, 150)

-- Параметры кнопок
local buttonWidth, buttonHeight = 516, 90
local buttons = {
    {x = 0.2, y = 0.349, width = buttonWidth, height = buttonHeight, image = "images/continue.png", onClick = "closeMenu", category = "main"},
    {x = 0.2, y = 0.449, width = buttonWidth, height = buttonHeight, image = "images/reconnect.png", onClick = "Reconnect", category = "main"},
    {x = 0.2, y = 0.549, width = buttonWidth, height = buttonHeight, image = "images/settings.png", onClick = "openSettings", category = "main"},
    {x = 0.2, y = 0.649, width = buttonWidth, height = buttonHeight, image = "images/exit.png", onClick = "ExitGame", category = "main"},

    -- // Settings buttons ( categories ) \\ --
    {x = 0.2, y = 0.349, width = buttonWidth, height = buttonHeight, text = "ГРАФИКА", onClick = "openGraphicsSettings", category = "settings"},
    {x = 0.2, y = 0.449, width = buttonWidth, height = buttonHeight, text = "ЗВУК", onClick = "openSoundSettings", category = "settings"},
    {x = 0.2, y = 0.549, width = buttonWidth, height = buttonHeight, text = "МЫШЬ", onClick = "openMouseSettings", category = "settings"},
    {x = 0.2, y = 0.649, width = buttonWidth, height = buttonHeight, text = "УПРАВЛЕНИЕ", onClick = "openControlSettings", category = "settings"},
    
    -- Новые кнопки для управления
    {x = 0.2, y = 0.349, width = buttonWidth, height = buttonHeight, text = "Персонаж", category = "control", onClick = "openCharacterSettings"},
    {x = 0.2, y = 0.449, width = buttonWidth, height = buttonHeight, text = "Транспорт", category = "control"},
    -- // ------------------------------- \\ --
}


local hoverAnimations = {}
local hoverSpeed = 0.2

local animationStartTime = 0
local animationDuration = 350

for i, button in ipairs(buttons) do
    hoverAnimations[i] = {offset = 0, targetOffset = 0}
end

function closeMenu()
    showChat(true)
    showCursor(false)
    removeEventHandler("onClientRender", root, drawMenu)
    currentCategory = "main"
end


function toggleMenu()
    if isEventHandlerAdded('onClientRender', root, drawMenu) then
        closeMenu()
    else
        animationStartTime = getTickCount()
        showCursor(true)
        showChat(false)
        addEventHandler("onClientRender", root, drawMenu)
    end
end

function drawMenu()
    for i, anim in ipairs(hoverAnimations) do
        anim.offset = anim.offset + (anim.targetOffset - anim.offset) * hoverSpeed
    end

    local now = getTickCount()
    local elapsedTime = now - animationStartTime
    local progress = math.min(elapsedTime / animationDuration, 1)
    local alpha = interpolateBetween(0, 0, 0, 150, 0, 0, progress, "Linear")

    dxDrawRectangle(0, 0, screenW, screenH, tocolor(0, 0, 0, alpha))
    dxDrawImage(0, 0, screenW, screenH, "images/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

    for i, button in ipairs(buttons) do
        if button.category == currentCategory then
            local buttonX = screenW * button.x - button.width / 2 + hoverAnimations[i].offset
            local buttonY = screenH * button.y
            if button.text then
                dxDrawImage(buttonX, buttonY, button.width, button.height, "images/category.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
                dxDrawText(button.text, buttonX + 95, buttonY, buttonX + button.width, buttonY + button.height, tocolor(128,128,128, 255), 2, "default-bold", "left", "center")
            else
                dxDrawImage(buttonX, buttonY, button.width, button.height, button.image, 0, 0, 0, tocolor(255, 255, 255, alpha))
            end
        end
    end
    local characterButtons = {
        {
            id = "forwards",
            name = "Вперед",

            default_value = "arrow_u",
            default_value_second = "w",
        },
        {
            id = "backwards",
            name = "Назад",

            default_value = "arrow_d",
            default_value_second = "s",
        },
        {
            id = "left",
            name = "Влево",

            default_value = "arrow_l",
            default_value_second = "a",
        },
        {
            id = "right",
            name = "Вправо",

            default_value = "arrow_r",
            default_value_second = "d",
        },
        {
            id = "sprint",
            name = "Бег",

            default_value = "lshift",
            default_value_second = false,
        },
        {
            id = "jump",
            name = "Прыжок",

            default_value = "space",
            default_value_second = "rctrl",
        },
        {
            id = "crouch",
            name = "Присесть",

            default_value = "c",
            default_value_second = false,
        },
        {
            id = "walk",
            name = "Медленный шаг",

            default_value = "lalt",
            default_value_second = false,
        },
        {
            id = "enter_exit",
            name = "Сесть / покинуть транспорт",

            default_value = "enter",
            default_value_second = "f",
        },
        {
            id = "enter_passenger",
            name = "Сесть в транспорт на пассажирское место",

            default_value = "g",
            default_value_second = false,
        },
        {
            id = "change_camera",
            name = "Смена вида камеры",

            default_value = "v",
            default_value_second = "home",
        },
    }

    local main_width = 1789
    local main_height = 56
    local buttonX = screenW / 2 - main_width / 2.12
    local buttonY = screenH * 0.273
    local spacing = 5 -- Промежуток между кнопками

    if currentCategory == "control_character" then
        for i, v in ipairs(characterButtons) do
            local buttonX = screenW / 2 - main_width / 2.12
            local buttonY = screenH * 0.273 + (main_height + spacing) * (i - 1)

            dxDrawImage(buttonX, buttonY, main_width, main_height, "images/control/main.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
            dxDrawText(v.default_value, buttonX + 700, buttonY, buttonX + main_width, buttonY + main_height, tocolor(255, 255, 255, 255), 1.8, "default-bold", "left", "center")
            dxDrawText(v.name, buttonX + 20, buttonY, buttonX + main_width, buttonY + main_height, tocolor(255, 255, 255, 255), 1.8, "default-bold", "left", "center")
        end
    end
end

function drawControls()
    
end

function onClick(button, state, cx, cy)
    if state == "down" then
        for i, btn in ipairs(buttons) do
            if btn.category == currentCategory then
                local buttonX = screenW * btn.x - btn.width / 2 + hoverAnimations[i].offset
                local buttonY = screenH * btn.y
                if cx >= buttonX and cx <= buttonX + btn.width and cy >= buttonY and cy <= buttonY + btn.height then
                    if btn.onClick then
                        _G[btn.onClick]()
                    else
                        outputChatBox("Выбрана категория: " .. (btn.text or ""))
                    end
                    return
                end
            end
        end
    end
end
addEventHandler("onClientClick", root, onClick)

function onCursorMove(_, _, cx, cy)
    for i, button in ipairs(buttons) do
        local buttonX = screenW * button.x - button.width / 2 + hoverAnimations[i].offset
        local buttonY = screenH * button.y
        if cx >= buttonX and cx <= buttonX + button.width and cy >= buttonY and cy <= buttonY + button.height then
            hoverAnimations[i].targetOffset = 20
        else
            hoverAnimations[i].targetOffset = 0
        end
    end
end
addEventHandler("onClientCursorMove", root, onCursorMove)

function onKey(button, press)
    if button == "escape" and press then
        toggleMenu()
    end
end
addEventHandler("onClientKey", root, onKey)
