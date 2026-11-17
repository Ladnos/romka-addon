local WG = WarriorGuide_NS

-- Настройки по умолчанию
local defaults = {
    lang = "ruRU",
    faction = "Horde",
    minimapAngle = 220,
    activeTab = 1,
    selectedBuild = 1,
    selectedDungeon = 1,
}

-- На Mainline-движке (WoW Forever) SetBackdrop работает только с этим шаблоном
local BACKDROP = BackdropTemplateMixin and "BackdropTemplate" or nil

local function L(key)
    local lang = (WarriorGuideDB and WarriorGuideDB.lang) or "ruRU"
    local dict = WG.Locales[lang] or WG.Locales.ruRU
    return dict[key] or key
end

local mainFrame
local minimapBtn
local tabButtons = {}
local contentContainer

-- Утилита создания стилизованной карточки в духе Dungeon Journal
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

-- Очистка контейнера перед перерисовкой вкладки
local function ClearContainer()
    local children = { contentContainer:GetChildren() }
    for _, child in ipairs(children) do
        child:Hide()
        child:SetParent(nil)
    end
    local regions = { contentContainer:GetRegions() }
    for _, reg in ipairs(regions) do
        reg:Hide()
    end
end

----------------------------------------------------------------------
-- ОТРИСОВКА ВКЛАДКИ 1: СПЕЦИАЛИЗАЦИИ (3 ГРАФИЧЕСКИЕ КАРТОЧКИ)
----------------------------------------------------------------------
local function RenderSpecsTab()
    ClearContainer()
    local lang = WarriorGuideDB.lang
    local cardW = 242
    local cardH = 385

    for i, spec in ipairs(WG.Data.Specs) do
        local card = CreateJournalCard(contentContainer, cardW, cardH)
        card:SetPoint("TOPLEFT", contentContainer, "TOPLEFT", (i - 1) * (cardW + 10), 0)

        -- Фоновый арт ветки талантов (полупрозрачный как в окне талантов)
        local bg = card:CreateTexture(nil, "BACKGROUND")
        bg:SetPoint("TOPLEFT", 4, -4)
        bg:SetPoint("BOTTOMRIGHT", -4, 4)
        bg:SetTexture(spec.banner)
        bg:SetAlpha(0.22)

        -- Иконка спека в круглой/золотой рамке
        local iconFrame = CreateFrame("Frame", nil, card, BACKDROP)
        iconFrame:SetWidth(48)
        iconFrame:SetHeight(48)
        iconFrame:SetPoint("TOP", card, "TOP", 0, -16)

        local icon = iconFrame:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexture(spec.icon)

        local border = iconFrame:CreateTexture(nil, "OVERLAY")
        border:SetWidth(64)
        border:SetHeight(64)
        border:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
        border:SetTexture("Interface\\Buttons\\UI-Quickslot2")

        -- Название спека
        local title = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", iconFrame, "BOTTOM", 0, -10)
        title:SetText(L(spec.nameKey))

        -- Бейдж роли
        local role = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        role:SetPoint("TOP", title, "BOTTOM", 0, -4)
        role:SetText("|cff00ff00" .. L(spec.roleKey) .. "|r")

        -- Разделитель
        local line = card:CreateTexture(nil, "ARTWORK")
        line:SetHeight(1)
        line:SetPoint("TOPLEFT", card, "TOPLEFT", 14, -112)
        line:SetPoint("TOPRIGHT", card, "TOPRIGHT", -14, -112)
        line:SetColorTexture(0.6, 0.48, 0.25, 0.5)

        -- Описание
        local desc = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        desc:SetPoint("TOPLEFT", card, "TOPLEFT", 14, -122)
        desc:SetWidth(cardW - 28)
        desc:SetJustifyH("LEFT")
        desc:SetText(L(spec.descKey))

        -- Блок ключевых способностей с иконками
        local spellHeader = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        spellHeader:SetPoint("TOPLEFT", card, "TOPLEFT", 14, -245)
        spellHeader:SetText(lang == "ruRU" and "|cffffd100Ключевые способности:|r" or "|cffffd100Core Abilities:|r")

        for sIdx, spell in ipairs(spec.keySpells) do
            local sIcon = card:CreateTexture(nil, "ARTWORK")
            sIcon:SetWidth(24)
            sIcon:SetHeight(24)
            sIcon:SetPoint("TOPLEFT", card, "TOPLEFT", 16, -240 - (sIdx * 28))
            sIcon:SetTexture(spell.icon)

            local sText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            sText:SetPoint("LEFT", sIcon, "RIGHT", 8, 0)
            sText:SetText(lang == "ruRU" and spell.ru or spell.en)
        end

        -- Плашка статов внизу карточки
        local statBox = CreateFrame("Frame", nil, card, BACKDROP)
        statBox:SetHeight(36)
        statBox:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 8, 8)
        statBox:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -8, 8)
        statBox:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
        statBox:SetBackdropColor(0, 0, 0, 0.65)

        local statText = statBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statText:SetPoint("CENTER", statBox, "CENTER", 0, 0)
        statText:SetWidth(cardW - 24)
        statText:SetText(spec.stats[lang])
    end
end

----------------------------------------------------------------------
-- ОТРИСОВКА ВКЛАДКИ 2: БИЛДЫ И ТАЛАНТЫ (MASTER-DETAIL + ИКОНКИ)
----------------------------------------------------------------------
local function RenderBuildsTab()
    ClearContainer()
    local lang = WarriorGuideDB.lang

    -- Левая колонка: выбор билда (как боссы/подземелья в Dungeon Journal)
    local leftPanel = CreateJournalCard(contentContainer, 215, 385)
    leftPanel:SetPoint("TOPLEFT", contentContainer, "TOPLEFT", 0, 0)

    for idx, build in ipairs(WG.Data.Builds) do
        local btn = CreateFrame("Button", nil, leftPanel, BACKDROP)
        btn:SetWidth(199)
        btn:SetHeight(56)
        btn:SetPoint("TOPLEFT", leftPanel, "TOPLEFT", 8, -10 - (idx - 1) * 62)

        btn:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        if WarriorGuideDB.selectedBuild == idx then
            btn:SetBackdropColor(0.35, 0.22, 0.08, 0.95)
            btn:SetBackdropBorderColor(1, 0.82, 0, 1)
        else
            btn:SetBackdropColor(0.12, 0.1, 0.08, 0.8)
            btn:SetBackdropBorderColor(0.4, 0.32, 0.18, 0.7)
        end

        local bIcon = btn:CreateTexture(nil, "ARTWORK")
        bIcon:SetWidth(36)
        bIcon:SetHeight(36)
        bIcon:SetPoint("LEFT", btn, "LEFT", 10, 0)
        bIcon:SetTexture(build.icon)

        local bTitle = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        bTitle:SetPoint("LEFT", bIcon, "RIGHT", 8, 0)
        bTitle:SetWidth(135)
        bTitle:SetJustifyH("LEFT")
        bTitle:SetText(L(build.titleKey))

        btn:SetScript("OnClick", function()
            WarriorGuideDB.selectedBuild = idx
            RenderBuildsTab()
        end)
    end

    -- Правая колонка: визуальная сетка шагов прокачки талантов
    local rightPanel = CreateJournalCard(contentContainer, 522, 385)
    rightPanel:SetPoint("TOPLEFT", leftPanel, "TOPRIGHT", 8, 0)

    local activeBuild = WG.Data.Builds[WarriorGuideDB.selectedBuild] or WG.Data.Builds[1]

    local header = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    header:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, -12)
    header:SetText(L(activeBuild.titleKey))

    local sub = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
    sub:SetWidth(490)
    sub:SetJustifyH("LEFT")
    sub:SetText(L(activeBuild.subKey))

    local yOffset = -56
    for _, step in ipairs(activeBuild.steps) do
        local tierLabel = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tierLabel:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, yOffset)
        tierLabel:SetText("|cffffd100" .. L(step.tierKey) .. "|r")
        yOffset = yOffset - 16

        for _, tal in ipairs(step.talents) do
            local row = CreateFrame("Frame", nil, rightPanel, BACKDROP)
            row:SetWidth(494)
            row:SetHeight(28)
            row:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, yOffset)
            row:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
            row:SetBackdropColor(0.16, 0.13, 0.09, 0.75)

            -- Бейдж уровня
            local lvlBadge = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            lvlBadge:SetPoint("LEFT", row, "LEFT", 6, 0)
            lvlBadge:SetWidth(42)
            lvlBadge:SetJustifyH("LEFT")
            lvlBadge:SetText("|cff00ff00" .. tal.lvl .. "|r")

            -- Иконка таланта с каунтером очков (как в окне талантов)
            local tIcon = row:CreateTexture(nil, "ARTWORK")
            tIcon:SetWidth(22)
            tIcon:SetHeight(22)
            tIcon:SetPoint("LEFT", lvlBadge, "RIGHT", 4, 0)
            tIcon:SetTexture(tal.icon)

            local ptsBadge = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            ptsBadge:SetPoint("LEFT", tIcon, "RIGHT", 6, 0)
            ptsBadge:SetWidth(28)
            ptsBadge:SetText("|cffffd100" .. tal.pts .. "|r")

            -- Название и краткая суть
            local tName = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            tName:SetPoint("LEFT", ptsBadge, "RIGHT", 4, 0)
            tName:SetText(lang == "ruRU" and tal.ru or tal.en)

            local tNote = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            tNote:SetPoint("RIGHT", row, "RIGHT", -8, 0)
            tNote:SetText("|cffaaaaaa" .. (lang == "ruRU" and tal.noteRu or tal.noteEn) .. "|r")

            yOffset = yOffset - 30
        end
        yOffset = yOffset - 6
    end
end

----------------------------------------------------------------------
-- ОТРИСОВКА ВКЛАДКИ 3: РОУТ ПРОКАЧКИ (С УЧЕТОМ ФРАКЦИИ)
----------------------------------------------------------------------
local function RenderRoutesTab()
    ClearContainer()
    local lang = WarriorGuideDB.lang
    local faction = WarriorGuideDB.faction
    local routeList = WG.Data.Routes[faction] or WG.Data.Routes.Horde

    for i, step in ipairs(routeList) do
        local card = CreateJournalCard(contentContainer, 745, 58)
        card:SetPoint("TOPLEFT", contentContainer, "TOPLEFT", 0, -(i - 1) * 64)

        -- Бейдж диапазона уровней слева
        local lvlBox = CreateFrame("Frame", nil, card, BACKDROP)
        lvlBox:SetWidth(76)
        lvlBox:SetHeight(42)
        lvlBox:SetPoint("LEFT", card, "LEFT", 8, 0)
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
        lvlTxt:SetText("|cffffd100LV " .. step.lvl .. "|r")

        -- Локации
        local zoneTxt = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        zoneTxt:SetPoint("TOPLEFT", lvlBox, "TOPRIGHT", 12, -2)
        zoneTxt:SetText(lang == "ruRU" and step.zoneRu or step.zoneEn)

        -- Ключевой совет
        local tipTxt = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        tipTxt:SetPoint("TOPLEFT", zoneTxt, "BOTTOMLEFT", 0, -4)
        tipTxt:SetWidth(630)
        tipTxt:SetJustifyH("LEFT")
        tipTxt:SetText(lang == "ruRU" and step.tipRu or step.tipEn)
    end
end

----------------------------------------------------------------------
-- ОТРИСОВКА ВКЛАДКИ 4: ПОДЗЕМЕЛЬЯ И ЛУТ (СТИЛЬ DUNGEON JOURNAL)
----------------------------------------------------------------------
local function RenderDungeonsTab()
    ClearContainer()
    local lang = WarriorGuideDB.lang
    local faction = WarriorGuideDB.faction

    -- Фильтруем подземелья под выбранную фракцию
    local visibleDungeons = {}
    for _, d in ipairs(WG.Data.Dungeons) do
        if d.faction == "Both" or d.faction == faction then
            table.insert(visibleDungeons, d)
        end
    end

    if WarriorGuideDB.selectedDungeon > #visibleDungeons then
        WarriorGuideDB.selectedDungeon = 1
    end

    -- Левая колонка: карточки подземелий с уровнями
    local leftPanel = CreateJournalCard(contentContainer, 285, 385)
    leftPanel:SetPoint("TOPLEFT", contentContainer, "TOPLEFT", 0, 0)

    for idx, d in ipairs(visibleDungeons) do
        local btn = CreateFrame("Button", nil, leftPanel, BACKDROP)
        btn:SetWidth(269)
        btn:SetHeight(38)
        btn:SetPoint("TOPLEFT", leftPanel, "TOPLEFT", 8, -8 - (idx - 1) * 41)

        btn:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        if WarriorGuideDB.selectedDungeon == idx then
            btn:SetBackdropColor(0.35, 0.22, 0.08, 0.95)
            btn:SetBackdropBorderColor(1, 0.82, 0, 1)
        else
            btn:SetBackdropColor(0.12, 0.1, 0.08, 0.85)
            btn:SetBackdropBorderColor(0.38, 0.3, 0.16, 0.75)
        end

        local dIcon = btn:CreateTexture(nil, "ARTWORK")
        dIcon:SetWidth(26)
        dIcon:SetHeight(26)
        dIcon:SetPoint("LEFT", btn, "LEFT", 6, 0)
        dIcon:SetTexture(d.icon)

        local dName = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        dName:SetPoint("LEFT", dIcon, "RIGHT", 8, 0)
        dName:SetText(lang == "ruRU" and d.nameRu or d.nameEn)

        local dLvl = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        dLvl:SetPoint("RIGHT", btn, "RIGHT", -8, 0)
        dLvl:SetText("|cff00ff00LV " .. d.lvl .. "|r")

        btn:SetScript("OnClick", function()
            WarriorGuideDB.selectedDungeon = idx
            RenderDungeonsTab()
        end)
    end

    -- Правая колонка: детали выбранного подземелья и карточки лута
    local rightPanel = CreateJournalCard(contentContainer, 452, 385)
    rightPanel:SetPoint("TOPLEFT", leftPanel, "TOPRIGHT", 8, 0)

    local sel = visibleDungeons[WarriorGuideDB.selectedDungeon]
    if not sel then return end

    local bigIcon = rightPanel:CreateTexture(nil, "ARTWORK")
    bigIcon:SetWidth(48)
    bigIcon:SetHeight(48)
    bigIcon:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 16, -16)
    bigIcon:SetTexture(sel.icon)

    local title = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", bigIcon, "TOPRIGHT", 12, -2)
    title:SetText(lang == "ruRU" and sel.nameRu or sel.nameEn)

    local lvlSub = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    lvlSub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    lvlSub:SetText("|cff00ff00LV " .. sel.lvl .. "|r")

    local desc = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    desc:SetPoint("TOPLEFT", bigIcon, "BOTTOMLEFT", 0, -14)
    desc:SetWidth(420)
    desc:SetJustifyH("LEFT")
    desc:SetText(lang == "ruRU" and sel.descRu or sel.descEn)

    local lootHeader = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lootHeader:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -18)
    lootHeader:SetText("|cffffd100" .. L("KEY_LOOT") .. "|r")

    for lIdx, item in ipairs(sel.loot) do
        local itemCard = CreateJournalCard(rightPanel, 420, 44)
        itemCard:SetPoint("TOPLEFT", lootHeader, "BOTTOMLEFT", 0, -8 - (lIdx - 1) * 50)

        local iIcon = itemCard:CreateTexture(nil, "ARTWORK")
        iIcon:SetWidth(30)
        iIcon:SetHeight(30)
        iIcon:SetPoint("LEFT", itemCard, "LEFT", 8, 0)
        iIcon:SetTexture(item.icon)

        local iName = itemCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        iName:SetPoint("LEFT", iIcon, "RIGHT", 10, 0)
        iName:SetText("|cff0070dd" .. (lang == "ruRU" and item.ru or item.en) .. "|r")
    end
end

----------------------------------------------------------------------
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК И ОБНОВЛЕНИЕ ИНТЕРФЕЙСА
----------------------------------------------------------------------
local function SelectTab(id)
    WarriorGuideDB.activeTab = id
    for i, btn in ipairs(tabButtons) do
        if i == id then
            btn:SetBackdropColor(0.38, 0.24, 0.08, 1)
            btn:SetBackdropBorderColor(1, 0.82, 0, 1)
        else
            btn:SetBackdropColor(0.14, 0.11, 0.08, 0.9)
            btn:SetBackdropBorderColor(0.45, 0.35, 0.18, 0.8)
        end
    end

    if id == 1 then RenderSpecsTab()
    elseif id == 2 then RenderBuildsTab()
    elseif id == 3 then RenderRoutesTab()
    elseif id == 4 then RenderDungeonsTab()
    end
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
    if WarriorGuideDB.faction == "Horde" then
        mainFrame.hordeBtn:SetAlpha(1.0)
        mainFrame.allianceBtn:SetAlpha(0.35)
    else
        mainFrame.hordeBtn:SetAlpha(0.35)
        mainFrame.allianceBtn:SetAlpha(1.0)
    end

    SelectTab(WarriorGuideDB.activeTab or 1)
end

----------------------------------------------------------------------
-- СОЗДАНИЕ ГЛАВНОГО ОКНА В СТИЛЕ DUNGEON JOURNAL
----------------------------------------------------------------------
local function CreateMainFrame()
    mainFrame = CreateFrame("Frame", "WarriorGuideMainFrame", UIParent, BACKDROP)
    mainFrame:SetWidth(780)
    mainFrame:SetHeight(495)
    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    mainFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    mainFrame:SetFrameStrata("HIGH")
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
    local langBtn = CreateFrame("Button", nil, mainFrame, BACKDROP)
    langBtn:SetWidth(86)
    langBtn:SetHeight(22)
    langBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -38, -11)
    langBtn:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    langBtn:SetBackdropColor(0.15, 0.12, 0.08, 0.9)
    langBtn:SetBackdropBorderColor(0.6, 0.48, 0.25, 0.9)

    mainFrame.langBtnText = langBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    mainFrame.langBtnText:SetPoint("CENTER", langBtn, "CENTER", 0, 0)

    langBtn:SetScript("OnClick", function()
        WarriorGuideDB.lang = (WarriorGuideDB.lang == "ruRU") and "enUS" or "ruRU"
        RefreshUI()
    end)

    -- Кнопка закрытия X
    local closeBtn = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -4, -4)

    -- Панель навигации: 4 широкие вкладки + переключатель фракции иконками (без наложений!)
    local tabKeys = { "TAB_SPECS", "TAB_BUILDS", "TAB_ROUTES", "TAB_DUNGEONS" }
    for i = 1, 4 do
        local tb = CreateFrame("Button", nil, mainFrame, BACKDROP)
        tb:SetWidth(152)
        tb:SetHeight(28)
        tb:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 16 + (i - 1) * 158, -42)
        tb:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        tb.text = tb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tb.text:SetPoint("CENTER", tb, "CENTER", 0, 0)

        local tabIndex = i
        tb:SetScript("OnClick", function()
            SelectTab(tabIndex)
        end)
        tabButtons[i] = tb
    end

    -- Иконка фракции: Орда
    local hordeBtn = CreateFrame("Button", nil, mainFrame, BACKDROP)
    hordeBtn:SetWidth(28)
    hordeBtn:SetHeight(28)
    hordeBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -50, -42)
    local hTex = hordeBtn:CreateTexture(nil, "ARTWORK")
    hTex:SetAllPoints()
    hTex:SetTexture("Interface\\TargetingFrame\\UI-PVP-Horde")
    hordeBtn:SetScript("OnClick", function()
        WarriorGuideDB.faction = "Horde"
        RefreshUI()
    end)
    mainFrame.hordeBtn = hordeBtn

    -- Иконка фракции: Альянс
    local allianceBtn = CreateFrame("Button", nil, mainFrame, BACKDROP)
    allianceBtn:SetWidth(28)
    allianceBtn:SetHeight(28)
    allianceBtn:SetPoint("LEFT", hordeBtn, "RIGHT", 4, 0)
    local aTex = allianceBtn:CreateTexture(nil, "ARTWORK")
    aTex:SetAllPoints()
    aTex:SetTexture("Interface\\TargetingFrame\\UI-PVP-Alliance")
    allianceBtn:SetScript("OnClick", function()
        WarriorGuideDB.faction = "Alliance"
        RefreshUI()
    end)
    mainFrame.allianceBtn = allianceBtn

    -- Основной контейнер контента
    contentContainer = CreateFrame("Frame", nil, mainFrame, BACKDROP)
    contentContainer:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 16, -80)
    contentContainer:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -16, 16)

    table.insert(UISpecialFrames, "WarriorGuideMainFrame")
end

----------------------------------------------------------------------
-- КНОПКА У МИНИКАРТЫ (С ПЕРЕТАСКИВАНИЕМ ПО ОКРУЖНОСТИ)
----------------------------------------------------------------------
local function UpdateMinimapButtonPosition()
    local angle = math.rad(WarriorGuideDB.minimapAngle or 220)
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    minimapBtn:ClearAllPoints()
    minimapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function CreateMinimapButton()
    minimapBtn = CreateFrame("Button", "WarriorGuideMinimapButton", Minimap, BACKDROP)
    minimapBtn:SetWidth(31)
    minimapBtn:SetHeight(31)
    minimapBtn:SetFrameStrata("MEDIUM")
    minimapBtn:SetFrameLevel(8)
    minimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local icon = minimapBtn:CreateTexture(nil, "BACKGROUND")
    icon:SetWidth(20)
    icon:SetHeight(20)
    icon:SetPoint("CENTER", minimapBtn, "CENTER", 0, 1)
    icon:SetTexture("Interface\\Icons\\Ability_Warrior_SavageBlow")

    local overlay = minimapBtn:CreateTexture(nil, "OVERLAY")
    overlay:SetWidth(52)
    overlay:SetHeight(52)
    overlay:SetPoint("TOPLEFT", minimapBtn, "TOPLEFT", 0, 0)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    minimapBtn:RegisterForClicks("LeftButtonUp")
    minimapBtn:RegisterForDrag("RightButton")

    minimapBtn:SetScript("OnClick", function()
        if mainFrame:IsShown() then
            mainFrame:Hide()
        else
            RefreshUI()
            mainFrame:Show()
        end
    end)

    minimapBtn:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            WarriorGuideDB.minimapAngle = math.deg((math.atan2 or math.atan)(py - my, px - mx))
            UpdateMinimapButtonPosition()
        end)
    end)

    minimapBtn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
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

    UpdateMinimapButtonPosition()
end

----------------------------------------------------------------------
-- ИНИЦИАЛИЗАЦИЯ И СЛЕШ-КОМАНДЫ
----------------------------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "WarriorGuide" then
        WarriorGuideDB = WarriorGuideDB or {}
        for k, v in pairs(defaults) do
            if WarriorGuideDB[k] == nil then
                WarriorGuideDB[k] = v
            end
        end

        CreateMainFrame()
        CreateMinimapButton()
        RefreshUI()
    end
end)

SLASH_WARRIORGUIDE1 = "/wg"
SLASH_WARRIORGUIDE2 = "/warriorguide"
SlashCmdList["WARRIORGUIDE"] = function()
    if not mainFrame then return end
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        RefreshUI()
        mainFrame:Show()
    end
end
