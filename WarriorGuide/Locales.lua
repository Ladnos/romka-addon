local _, WG = ...
WG = WG or {}
WarriorGuide_NS = WG

WG.VERSION = "2.1.0"

WG.Locales = {
    ruRU = {
        TITLE = "Журнал Воина (v" .. WG.VERSION .. ") — Romyl",
        TAB_SPECS = "Специализации",
        TAB_BUILDS = "Билды и таланты",
        TAB_ROUTES = "Роут прокачки",
        TAB_DUNGEONS = "Подземелья и лут",

        FACTION_HORDE = "Орда",
        FACTION_ALLIANCE = "Альянс",
        FACTION_BOTH = "Обе фракции",
        FACTION_TOOLTIP = "Показывать роут и подземелья для этой фракции",

        LANG_BTN = "Русский",
        LANG_TOOLTIP = "Сменить язык (RU / EN)",
        MINIMAP_TOOLTIP_TITLE = "|cffc79c6eWarrior Guide|r",
        MINIMAP_TOOLTIP_LEFT = "|cffffffffЛКМ:|r Открыть / закрыть журнал",
        MINIMAP_TOOLTIP_DRAG = "|cffffffffЗажать ПКМ:|r Переместить иконку",

        -- Спеки
        SPEC_ARMS_NAME = "Оружие (Arms)",
        SPEC_ARMS_ROLE = "Прокачка (1–60) и PvP",
        SPEC_ARMS_DESC = "Медленное двуручное оружие, мощный бурст через Смертельный удар (Mortal Strike), Размашистые удары (Sweeping Strikes) против 2 целей и Превосходство (Overpower) против уклонений.",
        SPEC_ARMS_TIP = "Лучший выбор для соло-прокачки: один медленный двуручник с высоким уроном важнее любых статов.",

        SPEC_FURY_NAME = "Неистовство (Fury)",
        SPEC_FURY_ROLE = "Рейдовый PvE ДПС (60 ур.)",
        SPEC_FURY_DESC = "Бой двумя одноручными оружиями (Dual Wield) или двуручным через разгон скорости атаки (Flurry). Сильно зависит от капа меткости (Hit) и шанса крита.",
        SPEC_FURY_TIP = "До 60 уровня играть тяжело: мало ярости и много промахов. Переходите после пре-рейд сета.",

        SPEC_PROT_NAME = "Защита (Protection)",
        SPEC_PROT_ROLE = "Танкование рейдов и данжей 55+",
        SPEC_PROT_DESC = "Высокая выживаемость и генерация агро (Мощный удар щитом, Реванш). До 55 уровня данжи легко танкуются в Arms/Fury со щитом в Оборонительной стойке.",
        SPEC_PROT_TIP = "Держите в сумке щит и одноручное оружие с 10 уровня — танк нужен в любой группе.",

        CORE_ABILITIES = "Ключевые способности:",

        -- Билды
        BUILD_LVL_TITLE = "Прокачка (Arms 31 / Fury 20)",
        BUILD_LVL_SUB = "Пошаговая раскладка: 1 очко на каждый уровень с 10 по 60. Некоторые таланты специально не докачиваются сразу — к ним возвращаются позже (метки ПАУЗА / ВОЗВРАТ).",
        BUILD_RAID_TITLE = "Рейд ДПС (Arms 17 / Fury 34)",
        BUILD_RAID_SUB = "Максимальный урон в одну цель в рейдах 60 уровня. Берите после 6–9% меткости (Hit) и пре-рейд сета. Сброс талантов — у классового тренера.",
        BUILD_PVP_TITLE = "PvP / БГ (Arms 31 / Fury 20)",
        BUILD_PVP_SUB = "Контроль, мобильность и взрывной урон. Смертельный удар режет исцеление цели на 50%.",

        LVL_SECTION_1 = "Уровни 10–19 · Оружие: первые 10 очков, открываем 3-й ряд",
        LVL_SECTION_2 = "Уровни 20–29 · Оружие: ярость, кровотечения, урон двуручника",
        LVL_SECTION_3 = "Уровни 30–40 · Оружие: Размашистые удары → Смертельный удар",
        LVL_SECTION_4 = "Уровни 41–60 · Неистовство: крит и ярость",

        TREE_ARMS = "Оружие (Arms)",
        TREE_FURY = "Неистовство (Fury)",
        TREE_PROT = "Защита (Protection)",
        POINTS = "очк.",
        TIER = "Ряд",
        LEVEL_SHORT = "ур.",

        TAG_PAUSE = "ПАУЗА",
        TAG_RETURN = "ВОЗВРАТ",
        TAG_KEY = "КЛЮЧЕВОЙ",
        TAG_FILLER = "ЗАПОЛНИТЕЛЬ",
        TAG_PAUSE_TIP = "Талант не докачан: остальные очки вернём позже",
        TAG_RETURN_TIP = "Возвращаемся к таланту, который пропустили ранее",
        TAG_KEY_TIP = "Ключевой талант билда",
        TAG_FILLER_TIP = "Очко нужно только чтобы открыть следующий ряд",

        TRAINER = "Тренер:",
        YOU_ARE_HERE = "Вы здесь",
        NEXT_TALENT = "Следующий талант",
        TOTAL = "Итого",
        RESPEC_NOTE = "|cffffd100Сброс талантов:|r у классового тренера. Цена растет: 1з → 5з → 10з → … до 50з, и снижается со временем.",
        HOVER_HINT = "Наведите на строку — подробности. Колесо мыши — прокрутка.",

        -- Роуты
        ROUTE_HEADER = "Роут прокачки",
        ROUTE_SUB = "Зоны, ключевые квесты и чему учиться у тренера в каждом диапазоне уровней.",
        ROUTE_DUNGEONS = "Подземелья:",

        -- Подземелья
        KEY_LOOT = "Ключевая добыча",
        KEY_QUESTS = "Квесты",
        WARRIOR_TIP = "Совет воину",
        LOCATION = "Локация:",
        SOURCE = "Источник:",
        ITEM_HINT = "Наведите — полная подсказка предмета, Shift+ЛКМ — ссылка в чат.",
        DIFF_TOO_HIGH = "Рано",
        DIFF_OK = "Ваш уровень",
        DIFF_LOW = "Пройдено",

        SLASH_HELP = "|cffc79c6eWarrior Guide:|r /wg — окно, /wg minimap — показать/скрыть иконку, /wg reset — сбросить позиции.",
        MINIMAP_HIDDEN = "|cffc79c6eWarrior Guide:|r иконка у миникарты скрыта. /wg minimap — вернуть.",
        MINIMAP_SHOWN = "|cffc79c6eWarrior Guide:|r иконка у миникарты показана.",
        RESET_DONE = "|cffc79c6eWarrior Guide:|r позиция окна и иконки сброшены.",
    },
    enUS = {
        TITLE = "Warrior Journal (v" .. WG.VERSION .. ") — Romyl",
        TAB_SPECS = "Specializations",
        TAB_BUILDS = "Talent Builds",
        TAB_ROUTES = "Leveling Route",
        TAB_DUNGEONS = "Dungeons & Loot",

        FACTION_HORDE = "Horde",
        FACTION_ALLIANCE = "Alliance",
        FACTION_BOTH = "Both factions",
        FACTION_TOOLTIP = "Show route and dungeons for this faction",

        LANG_BTN = "English",
        LANG_TOOLTIP = "Switch language (RU / EN)",
        MINIMAP_TOOLTIP_TITLE = "|cffc79c6eWarrior Guide|r",
        MINIMAP_TOOLTIP_LEFT = "|cffffffffLeft-Click:|r Toggle Journal",
        MINIMAP_TOOLTIP_DRAG = "|cffffffffRight-Drag:|r Move button",

        SPEC_ARMS_NAME = "Arms",
        SPEC_ARMS_ROLE = "Leveling (1–60) & PvP",
        SPEC_ARMS_DESC = "Slow two-handed weapons, heavy burst via Mortal Strike, Sweeping Strikes for 2-target cleave, and Overpower to punish dodges.",
        SPEC_ARMS_TIP = "Best solo leveling choice: one slow, hard-hitting two-hander matters more than any stat.",

        SPEC_FURY_NAME = "Fury",
        SPEC_FURY_ROLE = "Raid PvE DPS (Lvl 60)",
        SPEC_FURY_DESC = "Dual Wield or 2H slam playstyle utilizing Flurry attack speed scaling. Heavily reliant on Hit cap and Critical Strike.",
        SPEC_FURY_TIP = "Rough before 60: low rage and lots of misses. Switch once you have pre-raid gear.",

        SPEC_PROT_NAME = "Protection",
        SPEC_PROT_ROLE = "Raid & 55+ Dungeon Tanking",
        SPEC_PROT_DESC = "High survivability and threat generation (Shield Slam, Revenge). Before level 55, tank dungeons in Arms/Fury using a shield and Defensive Stance.",
        SPEC_PROT_TIP = "Carry a shield and a one-hander from level 10 — every group needs a tank.",

        CORE_ABILITIES = "Core Abilities:",

        BUILD_LVL_TITLE = "Leveling (Arms 31 / Fury 20)",
        BUILD_LVL_SUB = "Level-by-level plan: one point per level from 10 to 60. Some talents are intentionally left unfinished and revisited later (PAUSE / RETURN tags).",
        BUILD_RAID_TITLE = "Raid DPS (Arms 17 / Fury 34)",
        BUILD_RAID_SUB = "Maximum single-target raid DPS at level 60. Take it once you reach 6–9% Hit and pre-raid gear. Respec at your class trainer.",
        BUILD_PVP_TITLE = "PvP / Battlegrounds (Arms 31 / Fury 20)",
        BUILD_PVP_SUB = "Control, mobility and burst damage. Mortal Strike cuts target healing by 50%.",

        LVL_SECTION_1 = "Levels 10–19 · Arms: first 10 points, unlock tier 3",
        LVL_SECTION_2 = "Levels 20–29 · Arms: rage, bleeds, two-hander damage",
        LVL_SECTION_3 = "Levels 30–40 · Arms: Sweeping Strikes → Mortal Strike",
        LVL_SECTION_4 = "Levels 41–60 · Fury: crit and rage",

        TREE_ARMS = "Arms",
        TREE_FURY = "Fury",
        TREE_PROT = "Protection",
        POINTS = "pts",
        TIER = "Tier",
        LEVEL_SHORT = "lvl",

        TAG_PAUSE = "PAUSE",
        TAG_RETURN = "RETURN",
        TAG_KEY = "KEY",
        TAG_FILLER = "FILLER",
        TAG_PAUSE_TIP = "Talent left unfinished: the rest of the points come later",
        TAG_RETURN_TIP = "Coming back to a talent that was skipped earlier",
        TAG_KEY_TIP = "Core talent of the build",
        TAG_FILLER_TIP = "This point only unlocks the next tier",

        TRAINER = "Trainer:",
        YOU_ARE_HERE = "You are here",
        NEXT_TALENT = "Next talent",
        TOTAL = "Total",
        RESPEC_NOTE = "|cffffd100Respec:|r at your class trainer. Cost grows 1g → 5g → 10g → … up to 50g and decays over time.",
        HOVER_HINT = "Hover a row for details. Mouse wheel scrolls.",

        ROUTE_HEADER = "Leveling Route",
        ROUTE_SUB = "Zones, key quests and what to learn from your trainer in each level range.",
        ROUTE_DUNGEONS = "Dungeons:",

        KEY_LOOT = "Key Loot",
        KEY_QUESTS = "Quests",
        WARRIOR_TIP = "Warrior tip",
        LOCATION = "Location:",
        SOURCE = "Source:",
        ITEM_HINT = "Hover for the full item tooltip, Shift+Click to link in chat.",
        DIFF_TOO_HIGH = "Too early",
        DIFF_OK = "Your level",
        DIFF_LOW = "Outleveled",

        SLASH_HELP = "|cffc79c6eWarrior Guide:|r /wg — window, /wg minimap — toggle minimap icon, /wg reset — reset positions.",
        MINIMAP_HIDDEN = "|cffc79c6eWarrior Guide:|r minimap icon hidden. Type /wg minimap to restore.",
        MINIMAP_SHOWN = "|cffc79c6eWarrior Guide:|r minimap icon shown.",
        RESET_DONE = "|cffc79c6eWarrior Guide:|r window and icon positions reset.",
    }
}
