local WG = WarriorGuide_NS

-- Настройки по умолчанию
local defaults = {
    lang = "ruRU",
    faction = "Horde",
    minimapAngle = 220,
    minimapHidden = false,
    activeTab = 1,
    selectedBuild = 1,
    -- selectedDungeon не задаём: по умолчанию выбирается подземелье под уровень игрока
}

-- На Mainline-движке (WoW Forever) SetBackdrop работает только с этим шаблоном
local BACKDROP = BackdropTemplateMixin and "BackdropTemplate" or nil

-- Размеры окна. Всё содержимое вкладок обязано помещаться в CONTENT_W x CONTENT_H,
-- длинные списки — только через ScrollArea (иначе строки вылезают за окно).
local FRAME_W, FRAME_H = 820, 540
local CONTENT_X, CONTENT_TOP, CONTENT_BOTTOM = 16, 80, 16
local CONTENT_W = FRAME_W - CONTENT_X * 2
local CONTENT_H = FRAME_H - CONTENT_TOP - CONTENT_BOTTOM

-- Цвета
local GOLD = "|cffffd100"
local GREEN = "|cff00ff00"
local GRAY = "|cff9d9d9d"
local LIGHT = "|cffd8d8d8"
local BLUE = "|cff66bbff"
local QUALITY = {
    [0] = "|cff9d9d9d", [1] = "|cffffffff", [2] = "|cff1eff00",
    [3] = "|cff0070dd", [4] = "|cffa335ee", [5] = "|cffff8000",
}
local QUALITY_RGB = {
    [0] = { 0.62, 0.62, 0.62 }, [1] = { 1, 1, 1 }, [2] = { 0.12, 1, 0 },
    [3] = { 0, 0.44, 0.87 }, [4] = { 0.64, 0.21, 0.93 }, [5] = { 1, 0.5, 0 },
}
local TAGS = {
    key    = { key = "TAG_KEY",    tip = "TAG_KEY_TIP",    r = 1.00, g = 0.82, b = 0.00 },
    pause  = { key = "TAG_PAUSE",  tip = "TAG_PAUSE_TIP",  r = 1.00, g = 0.55, b = 0.10 },
    ["return"] = { key = "TAG_RETURN", tip = "TAG_RETURN_TIP", r = 0.40, g = 0.75, b = 1.00 },
    filler = { key = "TAG_FILLER", tip = "TAG_FILLER_TIP", r = 0.60, g = 0.60, b = 0.60 },
}

local function L(key)
    local lang = (WarriorGuideDB and WarriorGuideDB.lang) or "ruRU"
    local dict = WG.Locales[lang] or WG.Locales.ruRU
    return dict[key] or key
end

local function IsRU()
    return WarriorGuideDB.lang == "ruRU"
end

-- Выбор RU/EN поля из таблицы данных: Loc(item, "note") -> item.noteRu / item.noteEn
local function Loc(t, field)
    if not t then return nil end
    if field then
        return IsRU() and t[field .. "Ru"] or t[field .. "En"]
    end
    return IsRU() and t.ru or t.en
end

local function PlayerLevel()
    return (UnitLevel and UnitLevel("player")) or 1
end

-- Совместимость API предметов (Classic / Mainline)
local GetItemInfoCompat = (C_Item and C_Item.GetItemInfo) or GetItemInfo
local GetItemIconCompat = (C_Item and C_Item.GetItemIconByID) or GetItemIcon

local mainFrame
local minimapBtn
local tabButtons = {}
local contentContainer
local pages = {}
local currentPage

----------------------------------------------------------------------
-- УТИЛИТЫ ОТРИСОВКИ
----------------------------------------------------------------------
local EDGE_BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
}
local FLAT_BACKDROP = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" }

-- Стилизованная карточка в духе Dungeon Journal
local function CreateJournalCard(parent, width, height)
    local f = CreateFrame("Frame", nil, parent, BACKDROP)
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 14,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0.09, 0.07, 0.05, 0.92)
    f:SetBackdropBorderColor(0.55, 0.43, 0.22, 0.9)
    return f
end

local function SetSelectedStyle(btn, selected)
    if selected then
        btn:SetBackdropColor(0.35, 0.22, 0.08, 0.95)
        btn:SetBackdropBorderColor(1, 0.82, 0, 1)
    else
        btn:SetBackdropColor(0.12, 0.1, 0.08, 0.85)
        btn:SetBackdropBorderColor(0.4, 0.32, 0.18, 0.75)
    end
end

-- Кнопка списка (слева) с подсветкой при наведении
local function CreateListButton(parent, width, height, selected)
    local btn = CreateFrame("Button", nil, parent, BACKDROP)
    btn:SetWidth(width)
    btn:SetHeight(height)
    btn:SetBackdrop(EDGE_BACKDROP)
    SetSelectedStyle(btn, selected)

    local hl = btn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetPoint("TOPLEFT", 3, -3)
    hl:SetPoint("BOTTOMRIGHT", -3, 3)
    hl:SetColorTexture(1, 0.82, 0.3, 0.12)
    return btn
end

-- Текст с переносом строк; возвращает FontString и его высоту
local function AddText(parent, font, text, width, x, y, anchor)
    local fs = parent:CreateFontString(nil, "OVERLAY", font)
    fs:SetPoint("TOPLEFT", anchor or parent, "TOPLEFT", x, y)
    if width then
        fs:SetWidth(width)
        fs:SetJustifyH("LEFT")
    end
    fs:SetText(text or "")
    local h = fs:GetStringHeight()
    if not h or h < 1 then h = 12 end
    return fs, h
end

-- Однострочный текст, обрезается многоточием, если не влезает
local function AddLine(parent, font, text, width)
    local fs = parent:CreateFontString(nil, "OVERLAY", font)
    fs:SetJustifyH("LEFT")
    if width then fs:SetWidth(width) end
    if fs.SetWordWrap then fs:SetWordWrap(false) end
    fs:SetText(text or "")
    return fs
end

local function AddDivider(parent, x, y, width, alpha)
    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetWidth(width)
    line:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    line:SetColorTexture(0.6, 0.48, 0.25, alpha or 0.5)
    return line
end

local function CropIcon(tex)
    tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
end

-- Иконка в тонкой рамке
local function AddIcon(parent, texture, size, r, g, b)
    local holder = CreateFrame("Frame", nil, parent, BACKDROP)
    holder:SetWidth(size + 4)
    holder:SetHeight(size + 4)
    holder:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    holder:SetBackdropColor(0, 0, 0, 0.8)
    holder:SetBackdropBorderColor(r or 0.55, g or 0.43, b or 0.22, 1)
    local tex = holder:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", 2, -2)
    tex:SetPoint("BOTTOMRIGHT", -2, 2)
    tex:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
    CropIcon(tex)
    holder.tex = tex
    return holder
end

----------------------------------------------------------------------
-- ПРОКРУЧИВАЕМАЯ ОБЛАСТЬ (колесо мыши + тонкий ползунок справа)
----------------------------------------------------------------------
local SCROLLBAR_W = 8
local SCROLL_STEP = 48

local function CreateScrollArea(parent, width, height)
    local area = {}
    local viewW = width - SCROLLBAR_W - 6

    local sf = CreateFrame("ScrollFrame", nil, parent)
    sf:SetWidth(viewW)
    sf:SetHeight(height)

    local child = CreateFrame("Frame", nil, sf)
    child:SetWidth(viewW)
    child:SetHeight(1)
    sf:SetScrollChild(child)

    local bar = CreateFrame("Slider", nil, parent, BACKDROP)
    bar:SetWidth(SCROLLBAR_W)
    bar:SetPoint("TOPLEFT", sf, "TOPRIGHT", 4, 0)
    bar:SetPoint("BOTTOMLEFT", sf, "BOTTOMRIGHT", 4, 0)
    bar:SetOrientation("VERTICAL")
    bar:SetBackdrop(FLAT_BACKDROP)
    bar:SetBackdropColor(0, 0, 0, 0.55)
    local thumb = bar:CreateTexture(nil, "OVERLAY")
    thumb:SetColorTexture(0.78, 0.62, 0.3, 0.9)
    thumb:SetWidth(SCROLLBAR_W)
    thumb:SetHeight(40)
    bar:SetThumbTexture(thumb)
    bar:SetMinMaxValues(0, 0)
    bar:SetValueStep(1)
    bar:SetValue(0)
    bar:Hide()

    bar:SetScript("OnValueChanged", function(_, value)
        sf:SetVerticalScroll(value)
    end)

    local function OnWheel(_, delta)
        local minV, maxV = bar:GetMinMaxValues()
        local v = bar:GetValue() - delta * SCROLL_STEP
        if v < minV then v = minV end
        if v > maxV then v = maxV end
        bar:SetValue(v)
    end
    sf:EnableMouseWheel(true)
    sf:SetScript("OnMouseWheel", OnWheel)

    area.frame = sf
    area.child = child
    area.width = viewW
    area.bar = bar

    -- Интерактивные строки внутри тоже должны прокручивать список колесом
    function area:Forward(frame)
        frame:EnableMouseWheel(true)
        frame:SetScript("OnMouseWheel", OnWheel)
    end

    function area:SetContentHeight(h)
        child:SetHeight(math.max(h, 1))
        local maxScroll = math.max(0, h - height)
        bar:SetMinMaxValues(0, maxScroll)
        if maxScroll > 0 then
            thumb:SetHeight(math.max(24, height * height / h))
            bar:Show()
        else
            bar:SetValue(0)
            bar:Hide()
        end
    end

    function area:ScrollTo(y)
        local _, maxV = bar:GetMinMaxValues()
        bar:SetValue(math.max(0, math.min(maxV, y)))
    end

    function area:SetPoint(...)
        sf:SetPoint(...)
    end

    return area
end

----------------------------------------------------------------------
-- ПОДСКАЗКИ
----------------------------------------------------------------------
local function AttachTooltip(frame, fill)
    frame:EnableMouse(true)
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        fill(GameTooltip)
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

-- Запросить данные предмета у сервера, чтобы подсказка открылась с первого раза
local function RequestItem(id)
    if not id then return end
    if C_Item and C_Item.RequestLoadItemDataByID then
        pcall(C_Item.RequestLoadItemDataByID, id)
    elseif GetItemInfoCompat then
        pcall(GetItemInfoCompat, id)
    end
end

local function ItemQuality(item)
    if item.id and GetItemInfoCompat then
        local ok, _, _, q = pcall(GetItemInfoCompat, item.id)
        if ok and q then return q end
    end
    return item.q or 1
end

local function ItemIcon(item)
    if item.id and GetItemIconCompat then
        local ok, icon = pcall(GetItemIconCompat, item.id)
        if ok and icon then return icon end
    end
    return item.icon
end

----------------------------------------------------------------------
-- КЭШ СТРАНИЦ: каждая вкладка строится один раз на комбинацию
-- (язык, фракция, выбранный элемент, уровень) и дальше просто показывается.
-- Так не плодятся сотни скрытых фреймов при каждом клике.
----------------------------------------------------------------------
local function ShowPage(key, builder)
    if currentPage then currentPage:Hide() end
    local page = pages[key]
    if not page then
        page = CreateFrame("Frame", nil, contentContainer)
        page:SetPoint("TOPLEFT", contentContainer, "TOPLEFT", 0, 0)
        page:SetWidth(CONTENT_W)
        page:SetHeight(CONTENT_H)
        builder(page)
        pages[key] = page
    end
    page:Show()
    currentPage = page
end

local function ResetPages()
    for _, page in pairs(pages) do
        page:Hide()
    end
    pages = {}
    currentPage = nil
end

----------------------------------------------------------------------
-- ВКЛАДКА 1: СПЕЦИАЛИЗАЦИИ (3 ГРАФИЧЕСКИЕ КАРТОЧКИ)
----------------------------------------------------------------------
local function BuildSpecsPage(page)
    local gap = 10
    local cardW = math.floor((CONTENT_W - gap * 2) / 3)
    local cardH = CONTENT_H
    local textW = cardW - 28

    for i, spec in ipairs(WG.Data.Specs) do
        local card = CreateJournalCard(page, cardW, cardH)
        card:SetPoint("TOPLEFT", page, "TOPLEFT", (i - 1) * (cardW + gap), 0)

        -- Фоновый арт ветки талантов
        local bg = card:CreateTexture(nil, "BACKGROUND")
        bg:SetPoint("TOPLEFT", 4, -4)
        bg:SetPoint("BOTTOMRIGHT", -4, 4)
        bg:SetTexture(spec.banner)
        bg:SetAlpha(0.22)

        local icon = AddIcon(card, spec.icon, 44, 1, 0.82, 0)
        icon:SetPoint("TOP", card, "TOP", 0, -14)

        local title = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", icon, "BOTTOM", 0, -8)
        title:SetText(L(spec.nameKey))

        local role = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        role:SetPoint("TOP", title, "BOTTOM", 0, -4)
        role:SetText(GREEN .. L(spec.roleKey) .. "|r")

        local y = -100
        AddDivider(card, 14, y, textW)
        y = y - 10

        local _, h = AddText(card, "GameFontNormal", LIGHT .. L(spec.descKey) .. "|r", textW, 14, y)
        y = y - h - 8

        _, h = AddText(card, "GameFontHighlightSmall", GRAY .. L(spec.tipKey) .. "|r", textW, 14, y)
        y = y - h - 12

        AddText(card, "GameFontNormalSmall", GOLD .. L("CORE_ABILITIES") .. "|r", textW, 14, y)
        y = y - 18

        for _, spell in ipairs(spec.keySpells) do
            local sIcon = AddIcon(card, spell.icon, 22)
            sIcon:SetPoint("TOPLEFT", card, "TOPLEFT", 14, y)

            local sText = AddLine(card, "GameFontHighlightSmall", Loc(spell), textW - 34)
            sText:SetPoint("TOPLEFT", sIcon, "TOPRIGHT", 8, -2)

            local info = {}
            if spell.lvl then table.insert(info, spell.lvl .. " " .. L("LEVEL_SHORT")) end
            if spell.talent then table.insert(info, IsRU() and "талант" or "talent") end
            local sub = AddLine(card, "GameFontDisableSmall", table.concat(info, " · "), textW - 34)
            sub:SetPoint("TOPLEFT", sText, "BOTTOMLEFT", 0, -1)
            y = y - 28
        end

        -- Плашка статов внизу карточки
        local statBox = CreateFrame("Frame", nil, card, BACKDROP)
        statBox:SetHeight(40)
        statBox:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 8, 8)
        statBox:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -8, 8)
        statBox:SetBackdrop(FLAT_BACKDROP)
        statBox:SetBackdropColor(0, 0, 0, 0.65)

        local statText = statBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statText:SetPoint("CENTER", statBox, "CENTER", 0, 0)
        statText:SetWidth(cardW - 28)
        statText:SetText(spec.stats[WarriorGuideDB.lang] or spec.stats.ruRU)
    end
end

----------------------------------------------------------------------
-- ВКЛАДКА 2: БИЛДЫ И ТАЛАНТЫ
----------------------------------------------------------------------
local RenderCurrentTab -- forward

-- Цветная плашка тега (ПАУЗА / ВОЗВРАТ / ...)
local function AddTagBadge(parent, tagId)
    local tag = TAGS[tagId]
    if not tag then return nil end
    local badge = CreateFrame("Frame", nil, parent, BACKDROP)
    badge:SetHeight(14)
    badge:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    badge:SetBackdropColor(tag.r * 0.25, tag.g * 0.25, tag.b * 0.25, 0.9)
    badge:SetBackdropBorderColor(tag.r, tag.g, tag.b, 0.8)
    local txt = badge:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    txt:SetPoint("CENTER", badge, "CENTER", 0, 0)
    txt:SetTextColor(tag.r, tag.g, tag.b)
    txt:SetText(L(tag.key))
    badge:SetWidth(math.max(40, (txt:GetStringWidth() or 40) + 10))
    return badge
end

-- Одна строка таланта. info = { badge, badgeColor, icon, name, rank, note, tag, trainer, highlight, done, tooltip }
local function CreateTalentRow(area, y, info)
    local width = area.width
    local hasTrainer = info.trainer and info.trainer ~= ""

    local row = CreateFrame("Frame", nil, area.child, BACKDROP)
    row:SetWidth(width)
    row:SetHeight(36)
    row:SetPoint("TOPLEFT", area.child, "TOPLEFT", 0, y)
    row:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    if info.highlight then
        row:SetBackdropColor(0.10, 0.24, 0.08, 0.9)
        row:SetBackdropBorderColor(0.3, 1, 0.3, 0.9)
    else
        row:SetBackdropColor(0.16, 0.13, 0.09, 0.78)
        row:SetBackdropBorderColor(0.3, 0.24, 0.14, 0.6)
    end

    local hl = row:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(1, 0.82, 0.3, 0.08)

    -- Левая плашка: уровень или ряд
    local badge = row:CreateFontString(nil, "OVERLAY", info.badgeSmall and "GameFontHighlightSmall" or "GameFontNormal")
    badge:SetPoint("TOPLEFT", row, "TOPLEFT", 4, -11)
    badge:SetWidth(40)
    badge:SetJustifyH("CENTER")
    badge:SetText((info.badgeColor or GREEN) .. (info.badge or "") .. "|r")

    if info.done then
        local check = row:CreateTexture(nil, "OVERLAY")
        check:SetWidth(14)
        check:SetHeight(14)
        check:SetPoint("TOPLEFT", row, "TOPLEFT", 2, -2)
        check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
        check:SetAlpha(0.8)
    end

    local icon = AddIcon(row, info.icon, 24)
    icon:SetPoint("TOPLEFT", row, "TOPLEFT", 46, -4)

    -- Правая колонка: тег
    local rightW = 0
    local tagBadge = AddTagBadge(row, info.tag)
    if tagBadge then
        tagBadge:SetPoint("TOPRIGHT", row, "TOPRIGHT", -6, -5)
        rightW = tagBadge:GetWidth() + 10
    end
    if info.highlight then
        local here = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        if tagBadge then
            here:SetPoint("RIGHT", tagBadge, "LEFT", -6, 0)
        else
            here:SetPoint("TOPRIGHT", row, "TOPRIGHT", -8, -6)
        end
        here:SetText(GREEN .. L("YOU_ARE_HERE") .. "|r")
        rightW = rightW + (here:GetStringWidth() or 60) + 8
    end

    local textX = 80
    local textW = width - textX - 8

    local name = AddLine(row, "GameFontHighlight", info.name .. "  " .. GOLD .. (info.rank or "") .. "|r", textW - rightW)
    name:SetPoint("TOPLEFT", row, "TOPLEFT", textX, -5)

    -- Заметка и строка тренера переносятся на несколько строк, высота строки считается по тексту
    local ty = -21
    local _, noteH = AddText(row, "GameFontHighlightSmall", GRAY .. (info.note or "") .. "|r", textW, textX, ty)
    ty = ty - noteH

    if hasTrainer then
        local _, trH = AddText(row, "GameFontHighlightSmall", BLUE .. L("TRAINER") .. "|r " .. LIGHT .. info.trainer .. "|r", textW, textX, ty - 2)
        ty = ty - 2 - trH
    end

    local height = math.max(36, -ty + 5)
    row:SetHeight(height)

    if info.done and not info.highlight then
        row:SetAlpha(0.72)
    end

    if info.tooltip then
        AttachTooltip(row, info.tooltip)
    end
    area:Forward(row)
    return height
end

local function AddSectionHeader(area, y, text, rightText)
    local fs = AddLine(area.child, "GameFontNormal", GOLD .. text .. "|r", area.width - 90)
    fs:SetPoint("TOPLEFT", area.child, "TOPLEFT", 2, y)
    if rightText then
        local r = area.child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        r:SetPoint("TOPRIGHT", area.child, "TOPRIGHT", -4, y - 2)
        r:SetText(rightText)
    end
    AddDivider(area.child, 2, y - 16, area.width - 4, 0.6)
    return 22
end

local function TalentTooltip(entry, extraLine)
    return function(tt)
        tt:AddLine(Loc(entry), 1, 0.82, 0)
        if entry.rank then tt:AddLine((IsRU() and "Ранг " or "Rank ") .. entry.rank, 1, 1, 1) end
        if extraLine then tt:AddLine(extraLine, 0.7, 0.7, 0.7) end
        local note = Loc(entry, "note")
        if note then tt:AddLine(note, 0.85, 0.85, 0.85, true) end
        local tag = TAGS[entry.tag]
        if tag then
            tt:AddLine(" ")
            tt:AddLine(L(tag.key) .. ": " .. L(tag.tip), tag.r, tag.g, tag.b, true)
        end
        local trainer = Loc(entry, "trainer")
        if trainer then
            tt:AddLine(" ")
            tt:AddLine(L("TRAINER") .. " " .. trainer, 0.4, 0.73, 1, true)
        end
    end
end

-- Раскладка "по уровням": 1 очко на уровень, подсветка текущего уровня игрока
local function FillLevelBuild(area, build)
    local level = PlayerLevel()
    local y = 0
    local currentY

    for _, section in ipairs(build.sections) do
        y = y - AddSectionHeader(area, y, L(section.titleKey))
        for _, step in ipairs(section.steps) do
            local isCurrent = (step.lvl == level)
            if isCurrent then currentY = y end
            local h = CreateTalentRow(area, y, {
                badge = tostring(step.lvl),
                icon = step.icon,
                name = Loc(step),
                rank = step.rank,
                note = Loc(step, "note"),
                tag = step.tag,
                trainer = Loc(step, "trainer"),
                highlight = isCurrent,
                done = step.lvl < level,
                tooltip = TalentTooltip(step, step.lvl .. " " .. L("LEVEL_SHORT")),
            })
            y = y - h - 3
        end
        y = y - 8
    end

    local _, h = AddText(area.child, "GameFontHighlightSmall", L("RESPEC_NOTE"), area.width - 8, 4, y)
    y = y - h - 6

    area:SetContentHeight(-y)
    -- Сразу прокручиваем к текущему уровню игрока
    if currentY then
        area:ScrollTo(-currentY - 60)
    end
end

-- Раскладка "по веткам": итоговый билд 60 уровня
local function FillTreeBuild(area, build)
    local y = 0
    for _, tree in ipairs(build.trees) do
        y = y - AddSectionHeader(area, y, L(tree.treeKey), GOLD .. tree.points .. "|r " .. L("POINTS"))
        for _, tal in ipairs(tree.talents) do
            local h = CreateTalentRow(area, y, {
                badge = L("TIER") .. " " .. tal.tier,
                badgeSmall = true,
                badgeColor = GOLD,
                icon = tal.icon,
                name = Loc(tal),
                rank = tal.rank,
                note = Loc(tal, "note"),
                tag = tal.tag,
                tooltip = TalentTooltip(tal, L(tree.treeKey) .. " · " .. L("TIER") .. " " .. tal.tier),
            })
            y = y - h - 3
        end
        y = y - 8
    end

    local _, h = AddText(area.child, "GameFontHighlightSmall", L("RESPEC_NOTE"), area.width - 8, 4, y)
    y = y - h - 6
    area:SetContentHeight(-y)
end

-- Текущий талант по уровню игрока (для шапки билда прокачки)
local function FindCurrentStep(build, level)
    if build.mode ~= "levels" then return nil end
    for _, section in ipairs(build.sections) do
        for _, step in ipairs(section.steps) do
            if step.lvl == level then return step end
        end
    end
    return nil
end

local function BuildBuildsPage(page)
    local leftW = 215
    local gap = 8
    local rightW = CONTENT_W - leftW - gap
    local selected = WarriorGuideDB.selectedBuild
    local activeBuild = WG.Data.Builds[selected] or WG.Data.Builds[1]

    -- Левая колонка: выбор билда + легенда тегов
    local leftPanel = CreateJournalCard(page, leftW, CONTENT_H)
    leftPanel:SetPoint("TOPLEFT", page, "TOPLEFT", 0, 0)

    local ly = -8
    for idx, build in ipairs(WG.Data.Builds) do
        local btn = CreateListButton(leftPanel, leftW - 16, 46, selected == idx)
        btn:SetPoint("TOPLEFT", leftPanel, "TOPLEFT", 8, ly)

        local bIcon = AddIcon(btn, build.icon, 28)
        bIcon:SetPoint("LEFT", btn, "LEFT", 7, 0)

        local bTitle = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        bTitle:SetPoint("LEFT", bIcon, "RIGHT", 7, 0)
        bTitle:SetWidth(leftW - 16 - 52)
        bTitle:SetJustifyH("LEFT")
        bTitle:SetText(L(build.titleKey))

        btn:SetScript("OnClick", function()
            WarriorGuideDB.selectedBuild = idx
            RenderCurrentTab()
        end)
        ly = ly - 50
    end

    -- Легенда тегов: 2 x 2 плашки, пояснение — во всплывающей подсказке
    ly = ly - 4
    AddDivider(leftPanel, 12, ly, leftW - 24)
    ly = ly - 10
    for i, tagId in ipairs({ "key", "pause", "return", "filler" }) do
        local badge = AddTagBadge(leftPanel, tagId)
        local col = (i - 1) % 2
        local rowY = ly - math.floor((i - 1) / 2) * 20
        badge:SetPoint("TOPLEFT", leftPanel, "TOPLEFT", 12 + col * 96, rowY)
        AttachTooltip(badge, function(tt)
            local tag = TAGS[tagId]
            tt:AddLine(L(tag.key), tag.r, tag.g, tag.b)
            tt:AddLine(L(tag.tip), 1, 1, 1, true)
        end)
    end
    ly = ly - 44
    AddText(leftPanel, "GameFontDisableSmall", L("TREE_RULES"), leftW - 24, 12, ly)

    -- Правая колонка: шапка билда + прокручиваемый список
    local rightPanel = CreateJournalCard(page, rightW, CONTENT_H)
    rightPanel:SetPoint("TOPLEFT", leftPanel, "TOPRIGHT", gap, 0)

    local header = AddLine(rightPanel, "GameFontNormalLarge", L(activeBuild.titleKey), rightW - 28)
    header:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, -12)

    local y = -34
    local _, h = AddText(rightPanel, "GameFontHighlightSmall", LIGHT .. L(activeBuild.subKey) .. "|r", rightW - 28, 14, y)
    y = y - h - 3
    if activeBuild.srcKey then
        _, h = AddText(rightPanel, "GameFontDisableSmall", L(activeBuild.srcKey), rightW - 28, 14, y)
        y = y - h - 4
    end

    -- Итоги по веткам + где сейчас игрок
    local t = activeBuild.totals
    local summary = string.format("%s%s:|r %s%d|r  ·  %s%s:|r %s%d|r  ·  %s%s:|r %s%d|r",
        GRAY, L("TREE_ARMS"), GOLD, t.arms, GRAY, L("TREE_FURY"), GOLD, t.fury, GRAY, L("TREE_PROT"), GOLD, t.prot)
    local level = PlayerLevel()
    local cur = FindCurrentStep(activeBuild, level)
    if cur then
        summary = summary .. "   " .. GREEN .. level .. " " .. L("LEVEL_SHORT") .. ":|r " .. Loc(cur) .. " " .. GOLD .. cur.rank .. "|r"
    end
    local sumFs = AddLine(rightPanel, "GameFontHighlightSmall", summary, rightW - 28)
    sumFs:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, y)
    y = y - 18

    local area = CreateScrollArea(rightPanel, rightW - 20, CONTENT_H + y - 12)
    area:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 10, y)

    if activeBuild.mode == "levels" then
        FillLevelBuild(area, activeBuild)
    else
        FillTreeBuild(area, activeBuild)
    end
end

----------------------------------------------------------------------
-- ВКЛАДКА 3: РОУТ ПРОКАЧКИ (С УЧЕТОМ ФРАКЦИИ)
----------------------------------------------------------------------
local function BuildRoutesPage(page)
    local faction = WarriorGuideDB.faction
    local routeList = WG.Data.Routes[faction] or WG.Data.Routes.Horde
    local level = PlayerLevel()

    local title = AddLine(page, "GameFontNormalLarge", L("ROUTE_HEADER") .. "  " .. GRAY .. "(" .. L(faction == "Horde" and "FACTION_HORDE" or "FACTION_ALLIANCE") .. ")|r", CONTENT_W - 8)
    title:SetPoint("TOPLEFT", page, "TOPLEFT", 4, -2)
    local sub = AddLine(page, "GameFontHighlightSmall", GRAY .. L("ROUTE_SUB") .. "|r", CONTENT_W - 8)
    sub:SetPoint("TOPLEFT", page, "TOPLEFT", 4, -22)

    local area = CreateScrollArea(page, CONTENT_W, CONTENT_H - 40)
    area:SetPoint("TOPLEFT", page, "TOPLEFT", 0, -40)

    local cardW = area.width
    local textX = 100
    local textW = cardW - textX - 12
    local y = 0
    local currentY

    for _, step in ipairs(routeList) do
        local isCurrent = level >= step.minLvl and level < step.maxLvl or (level == 60 and step.maxLvl == 60)
        local card = CreateJournalCard(area.child, cardW, 100)
        card:SetPoint("TOPLEFT", area.child, "TOPLEFT", 0, y)
        if isCurrent then
            card:SetBackdropBorderColor(0.3, 1, 0.3, 1)
            currentY = y
        end

        -- Бейдж диапазона уровней слева
        local lvlBox = CreateFrame("Frame", nil, card, BACKDROP)
        lvlBox:SetWidth(80)
        lvlBox:SetHeight(44)
        lvlBox:SetPoint("TOPLEFT", card, "TOPLEFT", 10, -10)
        lvlBox:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        lvlBox:SetBackdropColor(0.28, 0.16, 0.06, 0.9)
        lvlBox:SetBackdropBorderColor(0.8, 0.6, 0.2, 0.9)

        local lvlTxt = lvlBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lvlTxt:SetPoint("CENTER", lvlBox, "CENTER", 0, 0)
        lvlTxt:SetText(GOLD .. "LV " .. step.lvl .. "|r")

        if isCurrent then
            local here = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            here:SetPoint("TOP", lvlBox, "BOTTOM", 0, -4)
            here:SetText(GREEN .. L("YOU_ARE_HERE") .. "|r")
        end

        local cy = -10
        local _, h = AddText(card, "GameFontNormal", Loc(step, "zone"), textW, textX, cy)
        cy = cy - h - 6

        local tips = IsRU() and step.tipsRu or step.tipsEn
        for _, tip in ipairs(tips or {}) do
            local bullet = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            bullet:SetPoint("TOPLEFT", card, "TOPLEFT", textX, cy)
            bullet:SetText(GOLD .. "–|r")
            _, h = AddText(card, "GameFontHighlightSmall", tip, textW - 12, textX + 12, cy)
            cy = cy - h - 4
        end

        local trainer = Loc(step, "trainer")
        if trainer then
            cy = cy - 2
            _, h = AddText(card, "GameFontHighlightSmall", BLUE .. L("TRAINER") .. "|r " .. LIGHT .. trainer .. "|r", textW, textX, cy)
            cy = cy - h - 4
        end

        local dungeons = Loc(step, "dungeons")
        if dungeons then
            _, h = AddText(card, "GameFontHighlightSmall", GREEN .. L("ROUTE_DUNGEONS") .. "|r " .. LIGHT .. dungeons .. "|r", textW, textX, cy)
            cy = cy - h - 4
        end

        local cardH = math.max(-cy + 8, 74)
        card:SetHeight(cardH)
        area:Forward(card)
        card:EnableMouse(true)
        y = y - cardH - 6
    end

    area:SetContentHeight(-y)
    if currentY then area:ScrollTo(-currentY) end
end

----------------------------------------------------------------------
-- ВКЛАДКА 4: ПОДЗЕМЕЛЬЯ И ЛУТ (СТИЛЬ DUNGEON JOURNAL)
----------------------------------------------------------------------
-- Цвет диапазона уровней относительно игрока (как сложность квестов)
local function DifficultyColor(d, level)
    if level < d.minLvl - 2 then return "|cffff2020", L("DIFF_TOO_HIGH")
    elseif level < d.minLvl then return "|cffff8040", L("DIFF_TOO_HIGH")
    elseif level <= d.maxLvl then return GREEN, L("DIFF_OK")
    else return GRAY, L("DIFF_LOW") end
end

local function VisibleDungeons()
    local faction = WarriorGuideDB.faction
    local list = {}
    for _, d in ipairs(WG.Data.Dungeons) do
        if d.faction == "Both" or d.faction == faction then
            table.insert(list, d)
        end
    end
    return list
end

local function SelectedDungeon(list)
    for _, d in ipairs(list) do
        if d.id == WarriorGuideDB.selectedDungeon then return d end
    end
    -- По умолчанию — подземелье под текущий уровень
    local level = PlayerLevel()
    for _, d in ipairs(list) do
        if level >= d.minLvl and level <= d.maxLvl then return d end
    end
    return list[1]
end

local function ItemTooltip(item)
    return function(tt)
        local shown = false
        if item.id then
            local ok = pcall(tt.SetHyperlink, tt, "item:" .. item.id)
            shown = ok and tt:NumLines() > 0
        end
        if not shown then
            local rgb = QUALITY_RGB[ItemQuality(item)] or QUALITY_RGB[1]
            tt:AddLine(Loc(item), rgb[1], rgb[2], rgb[3])
            tt:AddLine(Loc(item, "slot"), 1, 1, 1)
        end
        tt:AddLine(" ")
        tt:AddLine(L("SOURCE") .. " " .. (Loc(item, "src") or "?"), 1, 0.82, 0, true)
        local note = Loc(item, "note")
        if note then tt:AddLine(note, 0.85, 0.85, 0.85, true) end
    end
end

local function BuildDungeonsPage(page)
    local level = PlayerLevel()
    local list = VisibleDungeons()
    local sel = SelectedDungeon(list)

    local leftW = 280
    local gap = 8
    local rightW = CONTENT_W - leftW - gap

    -- Левая колонка: список подземелий (прокрутка, если не влезает)
    local leftPanel = CreateJournalCard(page, leftW, CONTENT_H)
    leftPanel:SetPoint("TOPLEFT", page, "TOPLEFT", 0, 0)

    local leftArea = CreateScrollArea(leftPanel, leftW - 14, CONTENT_H - 16)
    leftArea:SetPoint("TOPLEFT", leftPanel, "TOPLEFT", 7, -8)

    local ly = 0
    for _, d in ipairs(list) do
        local btn = CreateListButton(leftArea.child, leftArea.width, 38, sel == d)
        btn:SetPoint("TOPLEFT", leftArea.child, "TOPLEFT", 0, ly)

        local dIcon = AddIcon(btn, d.icon, 24)
        dIcon:SetPoint("LEFT", btn, "LEFT", 6, 0)

        local color = DifficultyColor(d, level)
        local dLvl = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        dLvl:SetPoint("RIGHT", btn, "RIGHT", -8, 0)
        dLvl:SetText(color .. d.lvl .. "|r")

        local dName = AddLine(btn, "GameFontNormalSmall", Loc(d, "name"), leftArea.width - 40 - 52)
        dName:SetPoint("LEFT", dIcon, "RIGHT", 6, 0)

        btn:SetScript("OnClick", function()
            WarriorGuideDB.selectedDungeon = d.id
            RenderCurrentTab()
        end)
        leftArea:Forward(btn)
        ly = ly - 41
    end
    leftArea:SetContentHeight(-ly)

    -- Правая колонка: детали подземелья
    local rightPanel = CreateJournalCard(page, rightW, CONTENT_H)
    rightPanel:SetPoint("TOPLEFT", leftPanel, "TOPRIGHT", gap, 0)
    if not sel then return end

    local area = CreateScrollArea(rightPanel, rightW - 20, CONTENT_H - 20)
    area:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 10, -10)
    local c = area.child
    local w = area.width

    local bigIcon = AddIcon(c, sel.icon, 44, 1, 0.82, 0)
    bigIcon:SetPoint("TOPLEFT", c, "TOPLEFT", 4, -4)

    local title = AddLine(c, "GameFontNormalLarge", Loc(sel, "name"), w - 64)
    title:SetPoint("TOPLEFT", bigIcon, "TOPRIGHT", 10, -2)

    local color, diffText = DifficultyColor(sel, level)
    local factionKey = sel.faction == "Both" and "FACTION_BOTH" or (sel.faction == "Horde" and "FACTION_HORDE" or "FACTION_ALLIANCE")
    local lvlSub = AddLine(c, "GameFontHighlightSmall",
        color .. "LV " .. sel.lvl .. "|r  " .. GRAY .. "(" .. diffText .. ")  ·  " .. L(factionKey) .. "|r", w - 64)
    lvlSub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)

    local y = -56
    local _, h = AddText(c, "GameFontHighlightSmall", GOLD .. L("LOCATION") .. "|r " .. LIGHT .. Loc(sel, "zone") .. "|r", w - 8, 4, y)
    y = y - h - 8

    _, h = AddText(c, "GameFontNormal", LIGHT .. Loc(sel, "desc") .. "|r", w - 8, 4, y)
    y = y - h - 10

    -- Совет воину в отдельной плашке
    local tip = Loc(sel, "tip")
    if tip then
        local box = CreateFrame("Frame", nil, c, BACKDROP)
        box:SetPoint("TOPLEFT", c, "TOPLEFT", 0, y)
        box:SetWidth(w)
        box:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
        box:SetBackdropColor(0.25, 0.12, 0.05, 0.6)
        box:SetBackdropBorderColor(0.78, 0.61, 0.43, 0.7)
        local _, th = AddText(box, "GameFontNormalSmall", GOLD .. L("WARRIOR_TIP") .. "|r", w - 16, 8, -6)
        local _, bh = AddText(box, "GameFontHighlightSmall", tip, w - 16, 8, -6 - th - 3)
        local boxH = th + bh + 16
        box:SetHeight(boxH)
        y = y - boxH - 12
    end

    -- Квесты
    if sel.quests and #sel.quests > 0 then
        y = y - AddSectionHeader(area, y, L("KEY_QUESTS"))
        for _, q in ipairs(sel.quests) do
            local bullet = c:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            bullet:SetPoint("TOPLEFT", c, "TOPLEFT", 6, y)
            bullet:SetText(GOLD .. "!|r")
            _, h = AddText(c, "GameFontHighlightSmall", Loc(q), w - 26, 18, y)
            y = y - h - 5
        end
        y = y - 8
    end

    -- Лут
    y = y - AddSectionHeader(area, y, L("KEY_LOOT"))
    _, h = AddText(c, "GameFontDisableSmall", L("ITEM_HINT"), w - 8, 4, y)
    y = y - h - 6

    for _, item in ipairs(sel.loot) do
        RequestItem(item.id)
        local q = ItemQuality(item)
        local rgb = QUALITY_RGB[q] or QUALITY_RGB[1]

        local card = CreateFrame("Button", nil, c, BACKDROP)
        card:SetWidth(w)
        card:SetHeight(58)
        card:SetPoint("TOPLEFT", c, "TOPLEFT", 0, y)
        card:SetBackdrop(EDGE_BACKDROP)
        card:SetBackdropColor(0.09, 0.07, 0.05, 0.92)
        card:SetBackdropBorderColor(rgb[1] * 0.7, rgb[2] * 0.7, rgb[3] * 0.7, 0.9)

        local hl = card:CreateTexture(nil, "HIGHLIGHT")
        hl:SetPoint("TOPLEFT", 3, -3)
        hl:SetPoint("BOTTOMRIGHT", -3, 3)
        hl:SetColorTexture(rgb[1], rgb[2], rgb[3], 0.1)

        local iIcon = AddIcon(card, ItemIcon(item), 36, rgb[1], rgb[2], rgb[3])
        iIcon:SetPoint("LEFT", card, "LEFT", 8, 0)

        local tw = w - 64
        local iName = AddLine(card, "GameFontNormal", (QUALITY[q] or QUALITY[1]) .. Loc(item) .. "|r", tw)
        iName:SetPoint("TOPLEFT", card, "TOPLEFT", 56, -7)

        local slot = AddLine(card, "GameFontHighlightSmall",
            LIGHT .. (Loc(item, "slot") or "") .. "|r  " .. GRAY .. "·  " .. L("SOURCE") .. "|r " .. GOLD .. (Loc(item, "src") or "") .. "|r", tw)
        slot:SetPoint("TOPLEFT", iName, "BOTTOMLEFT", 0, -3)

        local note = AddLine(card, "GameFontHighlightSmall", GRAY .. (Loc(item, "note") or "") .. "|r", tw)
        note:SetPoint("TOPLEFT", slot, "BOTTOMLEFT", 0, -3)

        AttachTooltip(card, ItemTooltip(item))
        card:RegisterForClicks("LeftButtonUp")
        card:SetScript("OnClick", function()
            if IsShiftKeyDown() and item.id and GetItemInfoCompat then
                local _, link = GetItemInfoCompat(item.id)
                if link and ChatEdit_InsertLink then ChatEdit_InsertLink(link) end
            end
        end)
        area:Forward(card)
        y = y - 62
    end

    area:SetContentHeight(-y + 4)
end

----------------------------------------------------------------------
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК И ОБНОВЛЕНИЕ ИНТЕРФЕЙСА
----------------------------------------------------------------------
local function PageKey(id)
    local db = WarriorGuideDB
    local base = id .. ":" .. db.lang .. ":" .. PlayerLevel()
    if id == 2 then
        return base .. ":" .. tostring(db.selectedBuild)
    elseif id == 3 then
        return base .. ":" .. db.faction
    elseif id == 4 then
        return base .. ":" .. db.faction .. ":" .. tostring(db.selectedDungeon)
    end
    return base
end

local builders = { BuildSpecsPage, BuildBuildsPage, BuildRoutesPage, BuildDungeonsPage }

local function SelectTab(id)
    if not builders[id] then id = 1 end
    WarriorGuideDB.activeTab = id
    for i, btn in ipairs(tabButtons) do
        if i == id then
            btn:SetBackdropColor(0.38, 0.24, 0.08, 1)
            btn:SetBackdropBorderColor(1, 0.82, 0, 1)
            btn.text:SetFontObject("GameFontHighlightSmall")
        else
            btn:SetBackdropColor(0.14, 0.11, 0.08, 0.9)
            btn:SetBackdropBorderColor(0.45, 0.35, 0.18, 0.8)
            btn.text:SetFontObject("GameFontNormalSmall")
        end
    end
    ShowPage(PageKey(id), builders[id])
end

RenderCurrentTab = function()
    SelectTab(WarriorGuideDB.activeTab or 1)
end

local function RefreshUI()
    if not mainFrame then return end
    mainFrame.titleText:SetText(L("TITLE"))
    mainFrame.langBtnText:SetText(L("LANG_BTN"))

    local tabKeys = { "TAB_SPECS", "TAB_BUILDS", "TAB_ROUTES", "TAB_DUNGEONS" }
    for i, key in ipairs(tabKeys) do
        tabButtons[i].text:SetText(L(key))
    end

    -- Подсветка активной фракции
    local horde = WarriorGuideDB.faction == "Horde"
    mainFrame.hordeBtn:SetAlpha(horde and 1 or 0.35)
    mainFrame.allianceBtn:SetAlpha(horde and 0.35 or 1)
    mainFrame.hordeBtn:SetBackdropBorderColor(1, 0.82, 0, horde and 1 or 0)
    mainFrame.allianceBtn:SetBackdropBorderColor(1, 0.82, 0, horde and 0 or 1)

    RenderCurrentTab()
end

local function ToggleMainFrame()
    if not mainFrame then return end
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        RefreshUI()
        mainFrame:Show()
    end
end

----------------------------------------------------------------------
-- СОЗДАНИЕ ГЛАВНОГО ОКНА В СТИЛЕ DUNGEON JOURNAL
----------------------------------------------------------------------
local function RestoreFramePosition()
    mainFrame:ClearAllPoints()
    local pos = WarriorGuideDB.framePos
    if pos and pos[1] then
        mainFrame:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
    else
        mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

local function CreateFactionButton(texture, faction, tooltipKey)
    local btn = CreateFrame("Button", nil, mainFrame, BACKDROP)
    btn:SetWidth(30)
    btn:SetHeight(30)
    btn:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    local tex = btn:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", 2, -2)
    tex:SetPoint("BOTTOMRIGHT", -2, 2)
    tex:SetTexture(texture)
    -- Эмблема в этих текстурах занимает только верхний левый угол — обрезаем пустое поле
    tex:SetTexCoord(0.08, 0.58, 0.045, 0.545)
    local hl = btn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(1, 0.82, 0.3, 0.15)
    btn:SetScript("OnClick", function()
        WarriorGuideDB.faction = faction
        RefreshUI()
    end)
    AttachTooltip(btn, function(tt)
        tt:AddLine(L(tooltipKey), 1, 0.82, 0)
        tt:AddLine(L("FACTION_TOOLTIP"), 1, 1, 1, true)
    end)
    return btn
end

local function CreateMainFrame()
    mainFrame = CreateFrame("Frame", "WarriorGuideMainFrame", UIParent, BACKDROP)
    mainFrame:SetWidth(FRAME_W)
    mainFrame:SetHeight(FRAME_H)
    mainFrame:SetMovable(true)
    mainFrame:SetClampedToScreen(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    mainFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, x, y = self:GetPoint()
        WarriorGuideDB.framePos = { point, relPoint, x, y }
    end)
    mainFrame:SetFrameStrata("HIGH")
    mainFrame:SetToplevel(true)
    RestoreFramePosition()
    mainFrame:Hide()

    mainFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true, tileSize = 16, edgeSize = 24,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    mainFrame:SetBackdropColor(0.06, 0.05, 0.04, 0.96)

    -- Заголовок по центру (как "Журнал подземелий")
    mainFrame.titleText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    mainFrame.titleText:SetPoint("TOP", mainFrame, "TOP", 0, -14)

    -- Кнопка переключения языка (RU / EN) в правом верхнем углу
    local langBtn = CreateListButton(mainFrame, 86, 22, false)
    langBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -38, -11)
    langBtn:SetBackdropColor(0.15, 0.12, 0.08, 0.9)
    langBtn:SetBackdropBorderColor(0.6, 0.48, 0.25, 0.9)

    mainFrame.langBtnText = langBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    mainFrame.langBtnText:SetPoint("CENTER", langBtn, "CENTER", 0, 0)

    langBtn:SetScript("OnClick", function()
        WarriorGuideDB.lang = (WarriorGuideDB.lang == "ruRU") and "enUS" or "ruRU"
        RefreshUI()
    end)
    AttachTooltip(langBtn, function(tt) tt:AddLine(L("LANG_TOOLTIP"), 1, 1, 1) end)

    -- Кнопка закрытия X
    local closeBtn = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -4, -4)

    -- Панель навигации: 4 вкладки + переключатель фракции
    local tabW, tabGap = 165, 6
    for i = 1, 4 do
        local tb = CreateListButton(mainFrame, tabW, 28, false)
        tb:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 16 + (i - 1) * (tabW + tabGap), -42)

        tb.text = tb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tb.text:SetPoint("CENTER", tb, "CENTER", 0, 0)

        local tabIndex = i
        tb:SetScript("OnClick", function()
            SelectTab(tabIndex)
        end)
        tabButtons[i] = tb
    end

    local allianceBtn = CreateFactionButton("Interface\\TargetingFrame\\UI-PVP-Alliance", "Alliance", "FACTION_ALLIANCE")
    allianceBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -16, -41)
    mainFrame.allianceBtn = allianceBtn

    local hordeBtn = CreateFactionButton("Interface\\TargetingFrame\\UI-PVP-Horde", "Horde", "FACTION_HORDE")
    hordeBtn:SetPoint("RIGHT", allianceBtn, "LEFT", -6, 0)
    mainFrame.hordeBtn = hordeBtn

    -- Основной контейнер контента
    contentContainer = CreateFrame("Frame", nil, mainFrame)
    contentContainer:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", CONTENT_X, -CONTENT_TOP)
    contentContainer:SetWidth(CONTENT_W)
    contentContainer:SetHeight(CONTENT_H)

    table.insert(UISpecialFrames, "WarriorGuideMainFrame")
end

----------------------------------------------------------------------
-- КНОПКА У МИНИКАРТЫ
-- Радиус считается от реального размера миникарты (а не фиксированные 80px),
-- и учитывается форма карты (круг / квадрат / углы), как в LibDBIcon.
-- Раньше на клиентах с миникартой больше 140px иконка "заезжала" внутрь карты.
----------------------------------------------------------------------
local MINIMAP_SHAPES = {
    ["ROUND"] = { true, true, true, true },
    ["SQUARE"] = { false, false, false, false },
    ["CORNER-TOPLEFT"] = { false, false, false, true },
    ["CORNER-TOPRIGHT"] = { false, false, true, false },
    ["CORNER-BOTTOMLEFT"] = { false, true, false, false },
    ["CORNER-BOTTOMRIGHT"] = { true, false, false, false },
    ["SIDE-LEFT"] = { false, true, false, true },
    ["SIDE-RIGHT"] = { true, false, true, false },
    ["SIDE-TOP"] = { false, false, true, true },
    ["SIDE-BOTTOM"] = { true, true, false, false },
    ["TRICORNER-TOPLEFT"] = { false, true, true, true },
    ["TRICORNER-TOPRIGHT"] = { true, false, true, true },
    ["TRICORNER-BOTTOMLEFT"] = { true, true, false, true },
    ["TRICORNER-BOTTOMRIGHT"] = { true, true, true, false },
}
local MINIMAP_PADDING = 5

local function UpdateMinimapButtonPosition()
    if not minimapBtn then return end
    local angle = math.rad(WarriorGuideDB.minimapAngle or 220)
    local x, y = math.cos(angle), math.sin(angle)
    local q = 1
    if x < 0 then q = q + 1 end
    if y > 0 then q = q + 2 end

    local shape = GetMinimapShape and GetMinimapShape() or "ROUND"
    local quadTable = MINIMAP_SHAPES[shape] or MINIMAP_SHAPES.ROUND
    local w = (Minimap:GetWidth() / 2) + MINIMAP_PADDING
    local h = (Minimap:GetHeight() / 2) + MINIMAP_PADDING

    if quadTable[q] then
        x, y = x * w, y * h
    else
        local diagW = math.sqrt(2 * w * w) - 10
        local diagH = math.sqrt(2 * h * h) - 10
        x = math.max(-w, math.min(x * diagW, w))
        y = math.max(-h, math.min(y * diagH, h))
    end

    minimapBtn:ClearAllPoints()
    minimapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function UpdateMinimapVisibility()
    if not minimapBtn then return end
    if WarriorGuideDB.minimapHidden then
        minimapBtn:Hide()
    else
        minimapBtn:Show()
        UpdateMinimapButtonPosition()
    end
end

local function CreateMinimapButton()
    minimapBtn = CreateFrame("Button", "WarriorGuideMinimapButton", Minimap)
    minimapBtn:SetWidth(31)
    minimapBtn:SetHeight(31)
    minimapBtn:SetFrameStrata("MEDIUM")
    minimapBtn:SetFrameLevel(8)
    minimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    -- Раскладка текстур как у стандартных кнопок миникарты (LibDBIcon)
    local background = minimapBtn:CreateTexture(nil, "BACKGROUND")
    background:SetWidth(20)
    background:SetHeight(20)
    background:SetPoint("TOPLEFT", minimapBtn, "TOPLEFT", 7, -5)
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

    local icon = minimapBtn:CreateTexture(nil, "ARTWORK")
    icon:SetWidth(17)
    icon:SetHeight(17)
    icon:SetPoint("TOPLEFT", minimapBtn, "TOPLEFT", 7, -6)
    icon:SetTexture("Interface\\Icons\\Ability_Warrior_SavageBlow")
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    minimapBtn.icon = icon

    local overlay = minimapBtn:CreateTexture(nil, "OVERLAY")
    overlay:SetWidth(53)
    overlay:SetHeight(53)
    overlay:SetPoint("TOPLEFT", minimapBtn, "TOPLEFT", 0, 0)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    minimapBtn:RegisterForClicks("LeftButtonUp")
    minimapBtn:RegisterForDrag("RightButton")

    minimapBtn:SetScript("OnClick", ToggleMainFrame)

    minimapBtn:SetScript("OnDragStart", function(self)
        GameTooltip:Hide()
        self:LockHighlight()
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            WarriorGuideDB.minimapAngle = math.deg((math.atan2 or math.atan)(py - my, px - mx)) % 360
            UpdateMinimapButtonPosition()
        end)
    end)

    minimapBtn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
        self:UnlockHighlight()
    end)

    minimapBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine(L("MINIMAP_TOOLTIP_TITLE"))
        GameTooltip:AddLine(L("MINIMAP_TOOLTIP_LEFT"))
        GameTooltip:AddLine(L("MINIMAP_TOOLTIP_DRAG"))
        GameTooltip:Show()
    end)

    minimapBtn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Если размер миникарты меняется (настройки клиента / другие аддоны) — пересчитываем позицию
    if Minimap.HookScript then
        Minimap:HookScript("OnSizeChanged", UpdateMinimapButtonPosition)
    end

    UpdateMinimapVisibility()
end

----------------------------------------------------------------------
-- ИНИЦИАЛИЗАЦИЯ И СЛЕШ-КОМАНДЫ
----------------------------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:RegisterEvent("PLAYER_LEVEL_UP")
loader:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "WarriorGuide" then
        WarriorGuideDB = WarriorGuideDB or {}
        for k, v in pairs(defaults) do
            if WarriorGuideDB[k] == nil then
                WarriorGuideDB[k] = v
            end
        end
        -- Миграция с 2.0.x: раньше подземелье хранилось индексом
        if type(WarriorGuideDB.selectedDungeon) ~= "string" then
            WarriorGuideDB.selectedDungeon = nil
        end

        CreateMainFrame()
        CreateMinimapButton()
        RefreshUI()
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- К этому моменту размер миникарты уже окончательный
        UpdateMinimapVisibility()
    elseif event == "PLAYER_LEVEL_UP" then
        -- Уровень входит в ключ кэша; старые страницы больше не нужны
        ResetPages()
        if mainFrame and mainFrame:IsShown() then
            RefreshUI()
        end
    end
end)

SLASH_WARRIORGUIDE1 = "/wg"
SLASH_WARRIORGUIDE2 = "/warriorguide"
SlashCmdList["WARRIORGUIDE"] = function(msg)
    msg = string.lower(msg or "")
    msg = msg:gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "minimap" then
        WarriorGuideDB.minimapHidden = not WarriorGuideDB.minimapHidden
        UpdateMinimapVisibility()
        print(L(WarriorGuideDB.minimapHidden and "MINIMAP_HIDDEN" or "MINIMAP_SHOWN"))
    elseif msg == "reset" then
        WarriorGuideDB.framePos = nil
        WarriorGuideDB.minimapAngle = defaults.minimapAngle
        WarriorGuideDB.minimapHidden = false
        if mainFrame then RestoreFramePosition() end
        UpdateMinimapVisibility()
        print(L("RESET_DONE"))
    elseif msg == "help" or msg == "?" then
        print(L("SLASH_HELP"))
    else
        ToggleMainFrame()
    end
end
