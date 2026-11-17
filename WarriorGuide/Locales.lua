local _, WG = ...
WG = WG or {}
WarriorGuide_NS = WG

WG.VERSION = "2.2.0"

WG.Locales = {
    ruRU = {
        TITLE = "Журнал Воина · WoW Forever (v" .. WG.VERSION .. ") — Romyl",
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
        SPEC_ARMS_ROLE = "PvP и групповая игра",
        SPEC_ARMS_DESC = "Медленное двуручное оружие, бурст через Смертельный удар и Превосходство. В Forever ветка получила Weaponmaster (бонус по типу оружия), Bloodthrill (Превосходство по целям с Кровопусканием) и Spearing Strike на 16 очков.",
        SPEC_ARMS_TIP = "Смертельный удар режет исцеление на 50% — главный аргумент для PvP. Для соло-прокачки в Forever обычно выбирают Защиту или Неистовство.",

        SPEC_FURY_NAME = "Неистовство (Fury)",
        SPEC_FURY_ROLE = "Рейдовый ДПС и прокачка с 2 оружиями",
        SPEC_FURY_DESC = "Бой двумя оружиями: Кровожадность, Вихрь (в Forever всегда бьёт обоими оружиями), Шквал (3 ранга). Новые таланты: Reckless Swings (ярость за здоровье), Improved Whirlwind, Furious Precision (меткость левой руки), Lingering Rage.",
        SPEC_FURY_TIP = "Главная беда раннего Fury — промахи и нехватка ярости. Берите Необузданный гнев и Furious Precision как можно раньше.",

        SPEC_PROT_NAME = "Защита (Protection)",
        SPEC_PROT_ROLE = "Танк и самая популярная прокачка в Forever",
        SPEC_PROT_DESC = "Щит + одноручное оружие. Ярость с блоков (Специализация на щите), Master of Defense, Vanguard (Рывок в Оборонительной стойке), Focused Rage, Bastion (урон со щитом) и Мощный удар щитом на 40.",
        SPEC_PROT_TIP = "В Forever Защита качается соло быстро и безопасно, а в подземелья вас возьмут без очереди.",

        CORE_ABILITIES = "Ключевые способности:",

        -- Билды (WoW Forever)
        BUILD_LVL_PROT_TITLE = "Прокачка: Защита (Prot 32)",
        BUILD_LVL_PROT_SUB = "Самая популярная прокачка в Forever. 1 очко на уровень с 10 по 60; некоторые таланты не докачиваются сразу — к ним возвращаются позже (метки ПАУЗА / ВОЗВРАТ).",
        BUILD_LVL_PROT_SRC = "Основа 10–41: Icy Veins, Timesaver, Mobalytics, wowforever.gg (ноябрь 2026). 42–60 — гибкая часть.",
        BUILD_LVL_FURY_TITLE = "Прокачка: Неистовство (17/34)",
        BUILD_LVL_FURY_SUB = "Два оружия с 20 уровня. К 60 получается готовый рейдовый билд 17/34 — сброс не нужен.",
        BUILD_LVL_FURY_SRC = "Основа 10–40: Icy Veins, wow4evernews, Mobalytics (ноябрь 2026). 41–60 — под рейдовый билд 17/34.",
        BUILD_RAID_TITLE = "Рейд ДПС: Неистовство (17/34)",
        BUILD_RAID_SUB = "Максимальный урон в рейдах 60 уровня. Держите его во второй специализации (с 40 уровня).",
        BUILD_RAID_SRC = "По ConquestCapped и Mobalytics. Icy Veins даёт похожий 18/33.",
        BUILD_TANK_TITLE = "Танк 60 (Fury 5 / Prot 46)",
        BUILD_TANK_SUB = "Рейдовый и подземельный танк: все ключевые таланты Защиты + Жестокость.",
        BUILD_TANK_SRC = "Раскладка 0/5/46 по гайдам; заполнители (Железная воля) — по вкусу.",
        BUILD_PVP_TITLE = "PvP: Оружие (33/18)",
        BUILD_PVP_SUB = "Смертельный удар, Улучшенное подрезание и контроль. Смертельный удар режет исцеление цели на 50%.",
        BUILD_PVP_SRC = "Теорикрафт по гайдам (встречаются 31/20 и 33/18) — 60 уровень ещё мало кто проверил.",

        SEC_PROT_1 = "Уровни 10–19 · Защита: щит, Реванш, Удар грома",
        SEC_PROT_2 = "Уровни 20–29 · Защита: Last Stand, Master of Defense, Vanguard (16 очков)",
        SEC_PROT_3 = "Уровни 30–41 · Защита: Focused Rage, Bastion → Мощный удар щитом",
        SEC_PROT_4 = "Уровни 42–60 · Оружие и Неистовство",
        SEC_FURY_1 = "Уровни 10–19 · Неистовство: крит и ярость",
        SEC_FURY_2 = "Уровни 20–29 · Два оружия: меткость и урон левой руки",
        SEC_FURY_3 = "Уровни 30–40 · Жажда смерти → Шквал → Кровожадность",
        SEC_FURY_4 = "Уровни 41–60 · Reckless Swings и Оружие (Пронзающие раны)",

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
        TREE_RULES = "Новые ряды открываются каждые 5 очков в ветке. Особые таланты — на 11, 16, 21 и 31 очке.",

        TRAINER = "Тренер:",
        YOU_ARE_HERE = "Вы здесь",
        NEXT_TALENT = "Следующий талант",
        TOTAL = "Итого",
        RESPEC_NOTE = "|cffffd100Сброс талантов:|r у классового тренера в столице. С 40 уровня у тренера можно взять вторую специализацию — например, Защита для соло и Неистовство для групп.",
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
        TITLE = "Warrior Journal · WoW Forever (v" .. WG.VERSION .. ") — Romyl",
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
        SPEC_ARMS_ROLE = "PvP & group play",
        SPEC_ARMS_DESC = "Slow two-handers, burst via Mortal Strike and Overpower. In Forever the tree gained Weaponmaster (bonus by weapon type), Bloodthrill (Overpower on Rend targets) and the 16-point Spearing Strike.",
        SPEC_ARMS_TIP = "Mortal Strike cuts healing by 50% — the main reason to play it in PvP. For solo leveling in Forever most players pick Protection or Fury.",

        SPEC_FURY_NAME = "Fury",
        SPEC_FURY_ROLE = "Raid DPS & dual-wield leveling",
        SPEC_FURY_DESC = "Dual wield: Bloodthirst, Whirlwind (always hits with both weapons in Forever), Flurry (3 ranks). New talents: Reckless Swings (rage for health), Improved Whirlwind, Furious Precision (off-hand hit), Lingering Rage.",
        SPEC_FURY_TIP = "Early Fury suffers from misses and low rage. Take Unbridled Wrath and Furious Precision as early as possible.",

        SPEC_PROT_NAME = "Protection",
        SPEC_PROT_ROLE = "Tanking & the most popular Forever leveling spec",
        SPEC_PROT_DESC = "Shield + one-hander. Rage from blocks (Shield Specialization), Master of Defense, Vanguard (Charge in Defensive Stance), Focused Rage, Bastion (shield damage) and Shield Slam at 40.",
        SPEC_PROT_TIP = "In Forever Protection levels solo fast and safely, and dungeon groups always want a tank.",

        CORE_ABILITIES = "Core Abilities:",

        BUILD_LVL_PROT_TITLE = "Leveling: Protection (Prot 32)",
        BUILD_LVL_PROT_SUB = "The most popular Forever leveling spec. One point per level from 10 to 60; some talents are left unfinished and revisited later (PAUSE / RETURN tags).",
        BUILD_LVL_PROT_SRC = "Core 10–41: Icy Veins, Timesaver, Mobalytics, wowforever.gg (Nov 2026). 42–60 is flexible.",
        BUILD_LVL_FURY_TITLE = "Leveling: Fury (17/34)",
        BUILD_LVL_FURY_SUB = "Dual wield from level 20. At 60 you end up with the 17/34 raid build — no respec needed.",
        BUILD_LVL_FURY_SRC = "Core 10–40: Icy Veins, wow4evernews, Mobalytics (Nov 2026). 41–60 shaped into the 17/34 raid build.",
        BUILD_RAID_TITLE = "Raid DPS: Fury (17/34)",
        BUILD_RAID_SUB = "Maximum raid damage at level 60. Keep it in your second spec (available from 40).",
        BUILD_RAID_SRC = "Per ConquestCapped and Mobalytics. Icy Veins suggests a similar 18/33.",
        BUILD_TANK_TITLE = "Tank 60 (Fury 5 / Prot 46)",
        BUILD_TANK_SUB = "Raid and dungeon tank: every key Protection talent plus Cruelty.",
        BUILD_TANK_SRC = "0/5/46 per guides; fillers (Iron Will) are up to you.",
        BUILD_PVP_TITLE = "PvP: Arms (33/18)",
        BUILD_PVP_SUB = "Mortal Strike, Improved Hamstring and control. Mortal Strike cuts target healing by 50%.",
        BUILD_PVP_SRC = "Theorycraft from guides (31/20 and 33/18 both appear) — few have tested it at 60 yet.",

        SEC_PROT_1 = "Levels 10–19 · Protection: shield, Revenge, Thunder Clap",
        SEC_PROT_2 = "Levels 20–29 · Protection: Last Stand, Master of Defense, Vanguard (16 pts)",
        SEC_PROT_3 = "Levels 30–41 · Protection: Focused Rage, Bastion → Shield Slam",
        SEC_PROT_4 = "Levels 42–60 · Arms and Fury",
        SEC_FURY_1 = "Levels 10–19 · Fury: crit and rage",
        SEC_FURY_2 = "Levels 20–29 · Dual wield: off-hand hit and damage",
        SEC_FURY_3 = "Levels 30–40 · Death Wish → Flurry → Bloodthirst",
        SEC_FURY_4 = "Levels 41–60 · Reckless Swings and Arms (Impale)",

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
        TREE_RULES = "A new tier opens every 5 points in a tree. Milestone talents sit at 11, 16, 21 and 31 points.",

        TRAINER = "Trainer:",
        YOU_ARE_HERE = "You are here",
        NEXT_TALENT = "Next talent",
        TOTAL = "Total",
        RESPEC_NOTE = "|cffffd100Respec:|r at your class trainer in a capital city. From level 40 the trainer also offers Dual Specialization — e.g. Protection for solo and Fury for groups.",
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
