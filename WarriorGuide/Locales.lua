local _, WG = ...
WG = WG or {}
WarriorGuide_NS = WG

WG.Locales = {
    ruRU = {
        TITLE = "Журнал Воина (v2.0.1) — Romyl",
        TAB_SPECS = "Специализации",
        TAB_BUILDS = "Билды и таланты",
        TAB_ROUTES = "Роут прокачки",
        TAB_DUNGEONS = "Подземелья и лут",
        
        FACTION_HORDE = "Орда",
        FACTION_ALLIANCE = "Альянс",
        
        LANG_BTN = "Русский",
        MINIMAP_TOOLTIP_TITLE = "|cffc79c6eWarrior Guide|r",
        MINIMAP_TOOLTIP_LEFT = "|cffffffffЛКМ:|r Открыть / закрыть журнал",
        MINIMAP_TOOLTIP_DRAG = "|cffffffffЗажать ПКМ:|r Переместить иконку",
        
        -- Спеки
        SPEC_ARMS_NAME = "Оружие (Arms)",
        SPEC_ARMS_ROLE = "Прокачка (1–60) и PvP",
        SPEC_ARMS_DESC = "Медленное двуручное оружие, мощный бурст через Смертельный удар (Mortal Strike), Размашистые удары (Sweeping Strikes) против 2 целей и Превосходство (Overpower) против уклонений.",
        
        SPEC_FURY_NAME = "Неистовство (Fury)",
        SPEC_FURY_ROLE = "Рейдовый PvE ДПС (60 ур.)",
        SPEC_FURY_DESC = "Бой двумя одноручными оружиями (Dual Wield) или двуручным через разгон скорости атаки (Flurry). Сильно зависит от капа меткости (Hit) и шанса крита.",
        
        SPEC_PROT_NAME = "Защита (Protection)",
        SPEC_PROT_ROLE = "Танкование рейдов и данжей 55+",
        SPEC_PROT_DESC = "Высокая выживаемость и генерация агро (Мощный удар щитом, Реванш). До 55 уровня данжи легко танкуются в Arms/Fury со щитом в Оборонительной стойке.",

        -- Билды
        BUILD_LVL_TITLE = "Прокачка (Arms 31 / Fury 20)",
        BUILD_LVL_SUB = "Оптимальный билд через двуручное оружие. Стабильный урон без жестких требований к меткости.",
        BUILD_RAID_TITLE = "Рейд ДПС (Fury 17 / 34)",
        BUILD_RAID_SUB = "Максимальный урон в одну цель в рейдах 60 уровня при наличии капа меткости (6–9%).",
        BUILD_PVP_TITLE = "PvP / БГ (Arms 31 / Fury 20)",
        BUILD_PVP_SUB = "Контроль, мобильность и взрывной урон по тканевым и кожаным целям.",

        -- Секции талантов
        TIER_10_19 = "Уровни 10–19 (Оружие)",
        TIER_20_29 = "Уровни 20–29 (Оружие)",
        TIER_30_40 = "Уровни 30–40 (Оружие)",
        TIER_41_60 = "Уровни 41–60 (Неистовство)",
        
        -- Подземелья
        DUNGEON_BRACKET_1 = "1. Прокачка (13–45 уровень)",
        DUNGEON_BRACKET_2 = "2. Средний уровень и переход к 60 (44–54)",
        DUNGEON_BRACKET_3 = "3. Пре-рейд экипировка (55–60)",
        KEY_LOOT = "Ключевая добыча и квесты:",
    },
    enUS = {
        TITLE = "Warrior Journal (v2.0.1) — Romyl",
        TAB_SPECS = "Specializations",
        TAB_BUILDS = "Talent Builds",
        TAB_ROUTES = "Leveling Route",
        TAB_DUNGEONS = "Dungeons & Loot",
        
        FACTION_HORDE = "Horde",
        FACTION_ALLIANCE = "Alliance",
        
        LANG_BTN = "English",
        MINIMAP_TOOLTIP_TITLE = "|cffc79c6eWarrior Guide|r",
        MINIMAP_TOOLTIP_LEFT = "|cffffffffLeft-Click:|r Toggle Journal",
        MINIMAP_TOOLTIP_DRAG = "|cffffffffRight-Drag:|r Move button",

        SPEC_ARMS_NAME = "Arms",
        SPEC_ARMS_ROLE = "Leveling (1–60) & PvP",
        SPEC_ARMS_DESC = "Slow two-handed weapons, heavy burst via Mortal Strike, Sweeping Strikes for 2-target cleave, and Overpower to punish dodges.",
        
        SPEC_FURY_NAME = "Fury",
        SPEC_FURY_ROLE = "Raid PvE DPS (Lvl 60)",
        SPEC_FURY_DESC = "Dual Wield or 2H slam playstyle utilizing Flurry attack speed scaling. Heavily reliant on Hit cap and Critical Strike.",
        
        SPEC_PROT_NAME = "Protection",
        SPEC_PROT_ROLE = "Raid & 55+ Dungeon Tanking",
        SPEC_PROT_DESC = "High survivability and threat generation (Shield Slam, Revenge). Before level 55, tank dungeons in Arms/Fury using a shield and Defensive Stance.",

        BUILD_LVL_TITLE = "Leveling (Arms 31 / Fury 20)",
        BUILD_LVL_SUB = "Optimal two-handed leveling build. Reliable damage without strict hit rating requirements.",
        BUILD_RAID_TITLE = "Raid DPS (Fury 17 / 34)",
        BUILD_RAID_SUB = "Maximum single-target raid DPS at level 60 once Hit cap (6–9%) is reached.",
        BUILD_PVP_TITLE = "PvP / Battlegrounds (Arms 31 / Fury 20)",
        BUILD_PVP_SUB = "High mobility, crowd control, and burst damage against cloth and leather targets.",

        TIER_10_19 = "Levels 10–19 (Arms Tree)",
        TIER_20_29 = "Levels 20–29 (Arms Tree)",
        TIER_30_40 = "Levels 30–40 (Arms Tree)",
        TIER_41_60 = "Levels 41–60 (Fury Tree)",

        DUNGEON_BRACKET_1 = "1. Leveling Dungeons (13–45)",
        DUNGEON_BRACKET_2 = "2. Mid-Game & Road to 60 (44–54)",
        DUNGEON_BRACKET_3 = "3. Pre-Raid BiS (55–60)",
        KEY_LOOT = "Key Loot & Quests:",
    }
}
