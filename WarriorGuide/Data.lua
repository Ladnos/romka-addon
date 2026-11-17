local WG = WarriorGuide_NS

----------------------------------------------------------------------
-- Таланты воина WoW Forever (деревья переделаны относительно Classic 1.12:
-- новые таланты, рубеж на 16 очков, базовое Тактическое превосходство и т.д.).
-- Ряды и ранги собраны по гайдам на ноябрь 2026 (Icy Veins, Mobalytics,
-- The Forever Era, Timesaver, wowforever.gg, ConquestCapped). Если Blizzard
-- что-то поменяет хотфиксом — правьте здесь.
----------------------------------------------------------------------
local I = {
    -- Оружие (Arms)
    IHS       = "Interface\\Icons\\Ability_Rogue_Ambush",          -- Improved Heroic Strike (р1, 3)
    DEFLECT   = "Interface\\Icons\\Ability_Parry",                 -- Deflection (р1, 5)
    IREND     = "Interface\\Icons\\Ability_Gouge",                 -- Improved Rend (р1, 3)
    ICHARGE   = "Interface\\Icons\\Ability_Warrior_Charge",        -- Improved Charge (р2, 2)
    ITM       = "Interface\\Icons\\Spell_Nature_EnchantArmor",     -- Improved Tactical Mastery (р2, 3)
    IOP       = "Interface\\Icons\\INV_Sword_05",                  -- Improved Overpower (р2, 2)
    AM        = "Interface\\Icons\\Spell_Holy_BlessingOfStamina",  -- Anger Management (р3, 1)
    DW        = "Interface\\Icons\\Ability_BackStab",              -- Deep Wounds (р3, 3)
    SPEAR     = "Interface\\Icons\\INV_Weapon_Halbard_01",         -- Spearing Strike (р4, 1) — 16 очков
    TWOH      = "Interface\\Icons\\INV_Axe_09",                    -- Two-Handed Weapon Specialization (р4, 3)
    IMPALE    = "Interface\\Icons\\Ability_SearingArrow",          -- Impale (р4, 2)
    BTHRILL   = "Interface\\Icons\\Spell_Shadow_LifeDrain",        -- Bloodthrill (р5, 2)
    SS        = "Interface\\Icons\\Ability_Rogue_SliceDice",       -- Sweeping Strikes (р5, 1)
    WMASTER   = "Interface\\Icons\\INV_Axe_06",                    -- Weaponmaster (р5, 5)
    ISLAM     = "Interface\\Icons\\Ability_Warrior_DecisiveStrike",-- Improved Slam (р6, 2)
    IHAM      = "Interface\\Icons\\Ability_ShockWave",             -- Improved Hamstring (р6, 3)
    MS        = "Interface\\Icons\\Ability_Warrior_SavageBlow",    -- Mortal Strike (р7, 1)
    -- Неистовство (Fury)
    BOOMING   = "Interface\\Icons\\Spell_Nature_Purge",            -- Booming Voice (р1, 5)
    CRUELTY   = "Interface\\Icons\\Ability_Rogue_Eviscerate",      -- Cruelty (р1, 5)
    LRAGE     = "Interface\\Icons\\Spell_Nature_Reincarnation",    -- Lingering Rage (р2, 5)
    UW        = "Interface\\Icons\\Spell_Nature_StoneClawTotem",   -- Unbridled Wrath (р2, 5)
    FPREC     = "Interface\\Icons\\Ability_Marksmanship",          -- Furious Precision (р3, 3)
    PHOWL     = "Interface\\Icons\\Spell_Shadow_DeathScream",      -- Piercing Howl (р3, 1) — 11 очков
    BCRAZE    = "Interface\\Icons\\Spell_Shadow_SummonImp",        -- Blood Craze (р3, 3)
    DWS       = "Interface\\Icons\\Ability_DualWield",             -- Dual Wield Specialization (р4, 5)
    RSWINGS   = "Interface\\Icons\\Ability_CriticalStrike",        -- Reckless Swings (р4, 1) — 16 очков
    IEXEC     = "Interface\\Icons\\INV_Sword_48",                  -- Improved Execute (р4, 2)
    DEATHWISH = "Interface\\Icons\\Spell_Shadow_DeathPact",        -- Death Wish (р5, 1) — 21 очко
    IBRAGE    = "Interface\\Icons\\Spell_Nature_AncestralGuardian",-- Improved Berserker Rage (р5, 2)
    FLURRY    = "Interface\\Icons\\Ability_GhoulFrenzy",           -- Flurry (р6, 3)
    IWW       = "Interface\\Icons\\Ability_Whirlwind",             -- Improved Whirlwind (р6, 2)
    BT        = "Interface\\Icons\\Spell_Nature_BloodLust",        -- Bloodthirst (р7, 1), нужна Death Wish
    -- Защита (Protection)
    IBLOOD    = "Interface\\Icons\\Ability_Racial_BloodRage",      -- Improved Bloodrage (р1, 2)
    SHSPEC    = "Interface\\Icons\\INV_Shield_06",                 -- Shield Specialization (р1, 5)
    IRONWILL  = "Interface\\Icons\\Spell_Magic_MageArmor",         -- Iron Will (р1, 5)
    ANTICIP   = "Interface\\Icons\\Spell_Nature_MirrorImage",      -- Anticipation (р2, 5)
    IREV      = "Interface\\Icons\\Ability_Warrior_Revenge",       -- Improved Revenge (р2, 3)
    ITC       = "Interface\\Icons\\Ability_ThunderClap",           -- Improved Thunder Clap (р2, 3)
    LSTAND    = "Interface\\Icons\\Spell_Holy_AshesToAshes",       -- Last Stand (р3, 1) — 11 очков
    MOD       = "Interface\\Icons\\Ability_Defend",                -- Master of Defense (р3, 2)
    IDISARM   = "Interface\\Icons\\Ability_Warrior_Disarm",        -- Improved Disarm (р3, 3)
    DEFIANCE  = "Interface\\Icons\\Ability_Warrior_InnerRage",     -- Defiance (р3, 3)
    ISUNDER   = "Interface\\Icons\\Ability_Warrior_Sunder",        -- Improved Sunder Armor (р4, 3)
    VANGUARD  = "Interface\\Icons\\Ability_Warrior_Charge",        -- Vanguard (р4, 1) — 16 очков
    ISBASH    = "Interface\\Icons\\Ability_Warrior_ShieldBash",    -- Improved Shield Bash (р4, 2)
    CBLOW     = "Interface\\Icons\\Ability_ThunderBolt",           -- Concussion Blow (р5, 1) — 21 очко
    FRAGE     = "Interface\\Icons\\Ability_Warrior_BattleShout",   -- Focused Rage (р5, 3)
    BASTION   = "Interface\\Icons\\Ability_Warrior_DefensiveStance",-- Bastion (р6, 5)
    SSLAM     = "Interface\\Icons\\INV_Shield_05",                 -- Shield Slam (р7, 1)
}

-- Шаг прокачки: уровень, иконка, название, ранг, заметка, тег, тренер
local function L(lvl, icon, ru, en, rank, noteRu, noteEn, tag, trainerRu, trainerEn)
    return {
        lvl = lvl, icon = icon, ru = ru, en = en, rank = rank,
        noteRu = noteRu, noteEn = noteEn, tag = tag,
        trainerRu = trainerRu, trainerEn = trainerEn,
    }
end

-- Талант итогового билда 60 уровня (без привязки к уровню)
local function T(tier, icon, ru, en, rank, noteRu, noteEn, tag)
    return { tier = tier, icon = icon, ru = ru, en = en, rank = rank, noteRu = noteRu, noteEn = noteEn, tag = tag }
end

-- Названия. Для новых талантов Forever в скобках оставлен английский оригинал,
-- чтобы их было легко найти в окне талантов клиента.
local N = {
    IHS = { "Улучшенный удар героя", "Improved Heroic Strike" },
    DEFLECT = { "Отражение", "Deflection" },
    IREND = { "Улучшенное кровопускание", "Improved Rend" },
    ICHARGE = { "Улучшенный рывок", "Improved Charge" },
    ITM = { "Улучш. тактическое превосходство", "Improved Tactical Mastery" },
    IOP = { "Улучшенное превосходство", "Improved Overpower" },
    AM = { "Управление злостью", "Anger Management" },
    DW = { "Глубокие раны", "Deep Wounds" },
    TWOH = { "Спец. на двуручном оружии", "Two-Handed Weapon Specialization" },
    IMPALE = { "Пронзающие раны", "Impale" },
    BTHRILL = { "Bloodthrill (новый)", "Bloodthrill" },
    SS = { "Размашистые удары", "Sweeping Strikes" },
    WMASTER = { "Weaponmaster (новый)", "Weaponmaster" },
    IHAM = { "Улучшенное подрезание", "Improved Hamstring" },
    MS = { "Смертельный удар", "Mortal Strike" },
    BOOMING = { "Громогласный голос", "Booming Voice" },
    CRUELTY = { "Жестокость", "Cruelty" },
    LRAGE = { "Lingering Rage (новый)", "Lingering Rage" },
    UW = { "Необузданный гнев", "Unbridled Wrath" },
    FPREC = { "Furious Precision (новый)", "Furious Precision" },
    PHOWL = { "Пронзительный вой", "Piercing Howl" },
    BCRAZE = { "Кровавое бешенство", "Blood Craze" },
    DWS = { "Спец. на бое двумя оружиями", "Dual Wield Specialization" },
    RSWINGS = { "Reckless Swings (новый)", "Reckless Swings" },
    IEXEC = { "Улучшенная казнь", "Improved Execute" },
    DEATHWISH = { "Жажда смерти", "Death Wish" },
    IBRAGE = { "Улучшенная ярость берсерка", "Improved Berserker Rage" },
    FLURRY = { "Шквал", "Flurry" },
    IWW = { "Improved Whirlwind (новый)", "Improved Whirlwind" },
    BT = { "Кровожадность", "Bloodthirst" },
    IBLOOD = { "Улучшенная кровавая ярость", "Improved Bloodrage" },
    SHSPEC = { "Специализация на щите", "Shield Specialization" },
    IRONWILL = { "Железная воля", "Iron Will" },
    ANTICIP = { "Предчувствие", "Anticipation" },
    IREV = { "Улучшенный реванш", "Improved Revenge" },
    ITC = { "Улучшенный удар грома", "Improved Thunder Clap" },
    LSTAND = { "Ни шагу назад", "Last Stand" },
    MOD = { "Master of Defense (новый)", "Master of Defense" },
    IDISARM = { "Улучшенное разоружение", "Improved Disarm" },
    DEFIANCE = { "Вызов", "Defiance" },
    ISUNDER = { "Улучшенный раскол брони", "Improved Sunder Armor" },
    VANGUARD = { "Vanguard (новый)", "Vanguard" },
    ISBASH = { "Улучшенный удар щитом", "Improved Shield Bash" },
    CBLOW = { "Оглушающий удар", "Concussion Blow" },
    FRAGE = { "Focused Rage (новый)", "Focused Rage" },
    BASTION = { "Bastion (новый)", "Bastion" },
    SSLAM = { "Мощный удар щитом", "Shield Slam" },
}

-- Сокращения: S("IHS", lvl, "1/3", ...) и TT(tier, "IHS", "3/3", ...)
local function S(key, lvl, rank, noteRu, noteEn, tag, trainerRu, trainerEn)
    return L(lvl, I[key], N[key][1], N[key][2], rank, noteRu, noteEn, tag, trainerRu, trainerEn)
end
local function TT(tier, key, rank, noteRu, noteEn, tag)
    return T(tier, I[key], N[key][1], N[key][2], rank, noteRu, noteEn, tag)
end

-- Чему учит тренер (WoW Forever): общие строки для обоих билдов прокачки
local TR = {
    [10] = { "Кровавая ярость, Раскол брони, Провокация; квест на Оборонительную стойку", "Bloodrage, Sunder Armor, Taunt; Defensive Stance quest" },
    [12] = { "Превосходство, Удар щитом", "Overpower, Shield Bash" },
    [14] = { "Тактическое превосходство (теперь базовое!), Деморализующий крик, Реванш", "Tactical Mastery (now baseline!), Demoralizing Shout, Revenge" },
    [16] = { "Дразнящий удар, Блок щитом", "Mocking Blow, Shield Block" },
    [18] = { "Разоружение", "Disarm" },
    [20] = { "Рассекающий удар, Возмездие, Мощный удар, Victory Rush (новое)", "Cleave, Retaliation, Slam, Victory Rush (new)" },
    [22] = { "Устрашающий крик", "Intimidating Shout" },
    [24] = { "Казнь", "Execute" },
    [26] = { "Вызывающий крик", "Challenging Shout" },
    [28] = { "Глухая оборона", "Shield Wall" },
    [30] = { "Стойка берсерка (квест), Перехват", "Berserker Stance (quest), Intercept" },
    [32] = { "Ярость берсерка", "Berserker Rage" },
    [36] = { "Вихрь (бьёт обоими оружиями без таланта)", "Whirlwind (hits with both weapons, no talent needed)" },
    [38] = { "Зуботычина", "Pummel" },
    [40] = { "Латные доспехи, вторая специализация (Dual Spec)", "Plate Mail, Dual Specialization" },
    [50] = { "Безрассудство", "Recklessness" },
}

-- Шаг прокачки с автоматической строкой тренера для этого уровня
local function P(key, lvl, rank, noteRu, noteEn, tag)
    local tr = TR[lvl]
    return S(key, lvl, rank, noteRu, noteEn, tag, tr and tr[1], tr and tr[2])
end

WG.Data = {
    ------------------------------------------------------------------
    -- Вкладка 1: Карточки специализаций
    ------------------------------------------------------------------
    Specs = {
        {
            id = "arms",
            icon = "Interface\\Icons\\Ability_Warrior_SavageBlow",
            banner = "Interface\\TalentFrame\\WarriorArms-TopLeft",
            nameKey = "SPEC_ARMS_NAME",
            roleKey = "SPEC_ARMS_ROLE",
            descKey = "SPEC_ARMS_DESC",
            tipKey = "SPEC_ARMS_TIP",
            stats = {
                ruRU = "Приоритет: Медленный 2H урон > Сила > Крит > Выносливость",
                enUS = "Priority: Slow 2H Weapon DPS > Strength > Crit > Stamina"
            },
            keySpells = {
                { icon = "Interface\\Icons\\Ability_Warrior_SavageBlow", ru = "Смертельный удар", en = "Mortal Strike", talent = true },
                { icon = "Interface\\Icons\\INV_Axe_06", ru = "Weaponmaster", en = "Weaponmaster", talent = true },
                { icon = "Interface\\Icons\\Ability_MeleeDamage", ru = "Превосходство", en = "Overpower", lvl = 12 },
                { icon = "Interface\\Icons\\INV_Sword_48", ru = "Казнь", en = "Execute", lvl = 24 },
            }
        },
        {
            id = "fury",
            icon = "Interface\\Icons\\Ability_Warrior_InnerRage",
            banner = "Interface\\TalentFrame\\WarriorFury-TopLeft",
            nameKey = "SPEC_FURY_NAME",
            roleKey = "SPEC_FURY_ROLE",
            descKey = "SPEC_FURY_DESC",
            tipKey = "SPEC_FURY_TIP",
            stats = {
                ruRU = "Приоритет: Меткость (Hit) > Крит > Сила Атаки (AP) > Сила",
                enUS = "Priority: Hit > Crit % > Attack Power > Strength"
            },
            keySpells = {
                { icon = "Interface\\Icons\\Spell_Nature_BloodLust", ru = "Кровожадность", en = "Bloodthirst", talent = true },
                { icon = "Interface\\Icons\\Ability_Whirlwind", ru = "Вихрь", en = "Whirlwind", lvl = 36 },
                { icon = "Interface\\Icons\\Ability_CriticalStrike", ru = "Reckless Swings", en = "Reckless Swings", talent = true },
                { icon = "Interface\\Icons\\Spell_Shadow_DeathPact", ru = "Жажда смерти", en = "Death Wish", talent = true },
            }
        },
        {
            id = "prot",
            icon = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
            banner = "Interface\\TalentFrame\\WarriorProtection-TopLeft",
            nameKey = "SPEC_PROT_NAME",
            roleKey = "SPEC_PROT_ROLE",
            descKey = "SPEC_PROT_DESC",
            tipKey = "SPEC_PROT_TIP",
            stats = {
                ruRU = "Приоритет: Выносливость > Защита > Блок > Меткость",
                enUS = "Priority: Stamina > Defense > Block > Hit"
            },
            keySpells = {
                { icon = "Interface\\Icons\\INV_Shield_05", ru = "Мощный удар щитом", en = "Shield Slam", talent = true },
                { icon = "Interface\\Icons\\Ability_Warrior_Revenge", ru = "Реванш", en = "Revenge", lvl = 14 },
                { icon = "Interface\\Icons\\Ability_Warrior_Charge", ru = "Vanguard: Рывок в Оборонит. стойке", en = "Vanguard: Charge in Defensive", talent = true },
                { icon = "Interface\\Icons\\Spell_Nature_Rejuvenation", ru = "Victory Rush", en = "Victory Rush", lvl = 20 },
            }
        }
    },

    ------------------------------------------------------------------
    -- Вкладка 2: Билды
    --   mode = "levels" — по одному очку на уровень (с паузами и возвратами)
    --   mode = "trees"  — итоговая раскладка 60 уровня по веткам и рядам
    ------------------------------------------------------------------
    Builds = {
        {
            id = "level_prot",
            mode = "levels",
            icon = "Interface\\Icons\\INV_Shield_06",
            titleKey = "BUILD_LVL_PROT_TITLE",
            subKey = "BUILD_LVL_PROT_SUB",
            srcKey = "BUILD_LVL_PROT_SRC",
            totals = { arms = 11, fury = 8, prot = 32 },
            sections = {
                {
                    titleKey = "SEC_PROT_1",
                    steps = {
                        P("SHSPEC", 10, "1/5", "Шанс блока + ярость при блоке. Сразу берите щит и одноручное оружие.", "Block chance + rage on block. Equip a shield and one-hander right away.", "key"),
                        P("SHSPEC", 11, "2/5", "Больше блока и ярости.", "More block and rage."),
                        P("SHSPEC", 12, "3/5", "Больше блока и ярости.", "More block and rage."),
                        P("SHSPEC", 13, "4/5", "Больше блока и ярости.", "More block and rage."),
                        P("SHSPEC", 14, "5/5", "Закрыт: ярость почти с каждого блока — основа соло-прокачки щитом.", "Maxed: rage from nearly every block — the core of shield leveling."),
                        P("IREV", 15, "1/3", "Реванш сильнее (до +60% урона на 3/3).", "Stronger Revenge (up to +60% damage at 3/3)."),
                        P("IREV", 16, "2/3", "Реванш сильнее.", "Stronger Revenge."),
                        P("IREV", 17, "3/3", "Закрыт: Реванш — главная кнопка урона до 40.", "Maxed: Revenge is your main damage button until 40.", "key"),
                        P("ITC", 18, "1/3", "Удар грома для паков из 2–3 мобов.", "Thunder Clap for 2–3 mob pulls."),
                        P("ITC", 19, "2/3", "Пауза: 10 очков открывают 3-й ряд. Последний ранг вернём на 23.", "Paused: 10 points unlock tier 3. Last rank comes back at 23.", "pause"),
                    }
                },
                {
                    titleKey = "SEC_PROT_2",
                    steps = {
                        P("LSTAND", 20, "1/1", "Талант на 11 очков: временно поднимает здоровье — кнопка спасения.", "11-point talent: temporary max health boost — your panic button.", "key"),
                        P("MOD", 21, "1/2", "Ярость при уклонении/парировании со щитом.", "Rage when you dodge/parry with a shield."),
                        P("MOD", 22, "2/2", "Закрыт: ярость идёт даже когда вы сами не попадаете.", "Maxed: rage keeps flowing even when you miss."),
                        P("ITC", 23, "3/3", "Возвращаемся к Удару грома, отложенному на 19.", "Back to Thunder Clap, paused at 19.", "return"),
                        P("DEFIANCE", 24, "1/3", "Больше угрозы. Нужно одно очко, чтобы набрать 15 в ветке.", "More threat. One point to reach 15 in the tree.", "filler"),
                        P("VANGUARD", 25, "1/1", "Талант на 16 очков: Рывок в Оборонительной стойке — пул без смены стойки.", "16-point talent: Charge in Defensive Stance — pull without swapping.", "key"),
                        P("IBLOOD", 26, "1/2", "Кровавая ярость даёт больше ярости.", "Bloodrage gives more rage."),
                        P("IBLOOD", 27, "2/2", "Закрыт: быстрый старт боя без Рывка.", "Maxed: fast fight start without Charge."),
                        P("ANTICIP", 28, "1/5", "Одно очко: открываем 5-й ряд к 30 уровню.", "One point: unlocks tier 5 by level 30.", "filler"),
                        P("DEFIANCE", 29, "2/3", "Ещё угрозы — пригодится в подземельях.", "More threat — useful in dungeons.", "pause"),
                    }
                },
                {
                    titleKey = "SEC_PROT_3",
                    steps = {
                        P("FRAGE", 30, "1/3", "Атакующие способности дешевле на 1 ярость.", "Offensive abilities cost 1 less rage."),
                        P("FRAGE", 31, "2/3", "−2 ярости.", "−2 rage."),
                        P("FRAGE", 32, "3/3", "Закрыт: −3 ярости на Реванш, Удар грома, Раскол брони.", "Maxed: −3 rage on Revenge, Thunder Clap, Sunder.", "key"),
                        P("CBLOW", 33, "1/1", "Талант на 21 очко: оглушение — сбивает касты и экономит здоровье.", "21-point talent: stun — interrupts casts and saves health."),
                        P("DEFIANCE", 34, "3/3", "Возврат: закрываем Вызов.", "Return: finish Defiance.", "return"),
                        P("ANTICIP", 35, "2/5", "Защита (Defense) — меньше крит. ударов по вам.", "Defense skill — fewer crits on you.", "filler"),
                        P("BASTION", 36, "1/5", "Больше урона со щитом в руке.", "More damage while wielding a shield."),
                        P("BASTION", 37, "2/5", "Больше урона со щитом.", "More damage with a shield."),
                        P("BASTION", 38, "3/5", "Больше урона со щитом.", "More damage with a shield."),
                        P("BASTION", 39, "4/5", "Пауза: 30 очков в ветке → на 40 берём Мощный удар щитом. 5-й ранг — на 41.", "Paused: 30 points → Shield Slam at 40. Rank 5 comes at 41.", "pause"),
                        P("SSLAM", 40, "1/1", "Талант на 31 очко: второй сильный удар — прокачка заметно ускоряется.", "31-point talent: a second hard hitter — leveling speeds up a lot.", "key"),
                        P("BASTION", 41, "5/5", "Возврат: Bastion закрыт. Ветка Защиты готова (32 очка).", "Return: Bastion maxed. Protection done (32 points).", "return"),
                    }
                },
                {
                    titleKey = "SEC_PROT_4",
                    steps = {
                        P("IHS", 42, "1/3", "Переходим в Оружие: дешевый Удар героя для сброса ярости.", "Moving to Arms: cheaper Heroic Strike as a rage dump."),
                        P("IHS", 43, "2/3", "−2 ярости к Удару героя.", "−2 rage on Heroic Strike."),
                        P("IHS", 44, "3/3", "Закрыт.", "Maxed."),
                        P("DEFLECT", 45, "1/5", "Парирование. Нужно для 2-го ряда Оружия.", "Parry. Needed for Arms tier 2.", "filler"),
                        P("DEFLECT", 46, "2/5", "5 очков в Оружии → открыт 2-й ряд.", "5 Arms points → tier 2 open.", "filler"),
                        P("ICHARGE", 47, "1/2", "Больше ярости от Рывка (вместе с Vanguard — прямо в Оборонительной стойке).", "More rage from Charge (works in Defensive Stance with Vanguard)."),
                        P("ICHARGE", 48, "2/2", "Закрыт.", "Maxed."),
                        P("ITM", 49, "1/3", "Больше ярости сохраняется при смене стойки.", "Keep more rage on stance swap."),
                        P("ITM", 50, "2/3", "Ещё больше ярости при смене стойки.", "Even more rage on stance swap.", nil),
                        P("ITM", 51, "3/3", "Закрыт: смена стойки под Перехват/Зуботычину почти бесплатна.", "Maxed: swapping for Intercept/Pummel is nearly free."),
                        P("AM", 52, "1/1", "Талант на 11 очков в Оружии: +1 ярость каждые 3 сек в бою.", "Arms 11-point talent: +1 rage every 3 sec in combat.", "key"),
                        P("CRUELTY", 53, "1/5", "Переходим в Неистовство: +1% крита.", "Moving to Fury: +1% crit."),
                        P("CRUELTY", 54, "2/5", "+2% крита.", "+2% crit."),
                        P("CRUELTY", 55, "3/5", "+3% крита.", "+3% crit."),
                        P("CRUELTY", 56, "4/5", "+4% крита.", "+4% crit."),
                        P("CRUELTY", 57, "5/5", "+5% крита: больше ярости и урона Реванша/Удара щитом.", "+5% crit: more rage and Revenge/Shield Slam damage.", "key"),
                        P("LRAGE", 58, "1/5", "Ярость медленнее сгорает после боя — следующий пул начинается с ярости.", "Rage decays slower after combat — start the next pull with rage."),
                        P("LRAGE", 59, "2/5", "+4 сек до сгорания ярости.", "+4 sec before rage decays."),
                        P("LRAGE", 60, "3/5", "Билд готов: Arms 11 / Fury 8 / Prot 32. На 60 — сброс под рейд или танк-билд.", "Build complete: Arms 11 / Fury 8 / Prot 32. At 60 respec for raid or tanking.", "key"),
                    }
                },
            },
        },
        {
            id = "level_fury",
            mode = "levels",
            icon = "Interface\\Icons\\Ability_DualWield",
            titleKey = "BUILD_LVL_FURY_TITLE",
            subKey = "BUILD_LVL_FURY_SUB",
            srcKey = "BUILD_LVL_FURY_SRC",
            totals = { arms = 17, fury = 34, prot = 0 },
            sections = {
                {
                    titleKey = "SEC_FURY_1",
                    steps = {
                        P("CRUELTY", 10, "1/5", "+1% крита. Двуручник или два оружия — оба варианта работают.", "+1% crit. Two-hander or dual wield — both work.", "key"),
                        P("CRUELTY", 11, "2/5", "+2% крита.", "+2% crit."),
                        P("CRUELTY", 12, "3/5", "+3% крита.", "+3% crit."),
                        P("CRUELTY", 13, "4/5", "+4% крита.", "+4% crit."),
                        P("CRUELTY", 14, "5/5", "+5% крита. Закрыт.", "+5% crit. Maxed."),
                        P("UW", 15, "1/5", "Ярость с автоатак: главная проблема раннего Fury — нехватка ярости и промахи.", "Rage from auto attacks: early Fury's main problem is low rage and misses."),
                        P("UW", 16, "2/5", "Больше ярости с автоатак.", "More rage from auto attacks."),
                        P("UW", 17, "3/5", "Больше ярости с автоатак.", "More rage from auto attacks."),
                        P("UW", 18, "4/5", "Больше ярости с автоатак.", "More rage from auto attacks."),
                        P("UW", 19, "5/5", "Закрыт. 10 очков → открыт 3-й ряд.", "Maxed. 10 points → tier 3 open.", "key"),
                    }
                },
                {
                    titleKey = "SEC_FURY_2",
                    steps = {
                        P("PHOWL", 20, "1/1", "Талант на 11 очков: массовое замедление — спасает при лишнем аггро. На 20 учите бой двумя оружиями.", "11-point talent: AoE snare — saves you on adds. Train Dual Wield at 20."),
                        P("FPREC", 21, "1/3", "Меткость левой руки — меньше промахов при бое двумя оружиями.", "Off-hand hit — fewer misses while dual wielding."),
                        P("FPREC", 22, "2/3", "Ещё меткость левой руки.", "More off-hand hit."),
                        P("FPREC", 23, "3/3", "Закрыт: до +10% меткости левой руки.", "Maxed: up to +10% off-hand hit.", "key"),
                        P("LRAGE", 24, "1/5", "Одно очко ради 15 в ветке (открывает 4-й ряд). Остальные ранги — на 59–60.", "One point to reach 15 (unlocks tier 4). More ranks at 59–60.", "pause"),
                        P("DWS", 25, "1/5", "+5% урона левой рукой.", "+5% off-hand damage."),
                        P("DWS", 26, "2/5", "+10% урона левой рукой.", "+10% off-hand damage."),
                        P("DWS", 27, "3/5", "+15% урона левой рукой.", "+15% off-hand damage."),
                        P("DWS", 28, "4/5", "+20% урона левой рукой.", "+20% off-hand damage."),
                        P("DWS", 29, "5/5", "+25% урона левой рукой. Закрыт.", "+25% off-hand damage. Maxed.", "key"),
                    }
                },
                {
                    titleKey = "SEC_FURY_3",
                    steps = {
                        P("DEATHWISH", 30, "1/1", "Талант на 21 очко: +урон на 30 сек. Нужен для Кровожадности.", "21-point talent: bonus damage for 30 sec. Required for Bloodthirst.", "key"),
                        P("IBRAGE", 31, "1/2", "Ярость от Ярости берсерка.", "Rage from Berserker Rage."),
                        P("IBRAGE", 32, "2/2", "Закрыт.", "Maxed."),
                        P("IEXEC", 33, "1/2", "Казнь дешевле.", "Cheaper Execute."),
                        P("IEXEC", 34, "2/2", "Закрыт: 25 очков → открыт 6-й ряд.", "Maxed: 25 points → tier 6 open."),
                        P("FLURRY", 35, "1/3", "+10% скорости атаки после крита.", "+10% attack speed after a crit."),
                        P("FLURRY", 36, "2/3", "+20% скорости атаки после крита.", "+20% attack speed after a crit."),
                        P("FLURRY", 37, "3/3", "+30% скорости атаки после крита. В Forever у Шквала 3 ранга.", "+30% attack speed after a crit. Flurry has 3 ranks in Forever.", "key"),
                        P("IWW", 38, "1/2", "Вихрь: −1 сек перезарядки, +15% урона по ближайшей цели.", "Whirlwind: −1 sec cooldown, +15% damage to the closest enemy."),
                        P("IWW", 39, "2/2", "Вихрь: −2 сек, +30% урона по ближайшей цели.", "Whirlwind: −2 sec, +30% damage to the closest enemy."),
                        P("BT", 40, "1/1", "Талант на 31 очко. Ротация: Кровожадность > Вихрь > Удар героя.", "31-point talent. Rotation: Bloodthirst > Whirlwind > Heroic Strike.", "key"),
                    }
                },
                {
                    titleKey = "SEC_FURY_4",
                    steps = {
                        P("RSWINGS", 41, "1/1", "Талант на 16 очков: 25% базового здоровья → след. 4 удара дают +5 ярости. КД 15 сек.", "16-point talent: 25% base health → next 4 swings give +5 rage. 15 sec CD.", "key"),
                        P("IHS", 42, "1/3", "Переходим в Оружие: дешевый Удар героя.", "Moving to Arms: cheaper Heroic Strike."),
                        P("IHS", 43, "2/3", "−2 ярости к Удару героя.", "−2 rage on Heroic Strike."),
                        P("IHS", 44, "3/3", "Закрыт.", "Maxed."),
                        P("DEFLECT", 45, "1/5", "Только для открытия 2-го ряда Оружия.", "Only to unlock Arms tier 2.", "filler"),
                        P("DEFLECT", 46, "2/5", "5 очков в Оружии.", "5 Arms points.", "filler"),
                        P("ITM", 47, "1/3", "Больше ярости при смене стойки.", "Keep more rage on stance swap."),
                        P("ITM", 48, "2/3", "Ещё больше ярости при смене стойки.", "Even more rage on stance swap."),
                        P("ITM", 49, "3/3", "Закрыт.", "Maxed."),
                        P("IOP", 50, "1/2", "Шанс крита Превосходства.", "Overpower crit chance."),
                        P("IOP", 51, "2/2", "Закрыт: 10 очков в Оружии.", "Maxed: 10 Arms points."),
                        P("AM", 52, "1/1", "+1 ярость каждые 3 сек в бою.", "+1 rage every 3 sec in combat."),
                        P("DW", 53, "1/3", "Криты вешают кровотечение.", "Crits apply a bleed."),
                        P("DW", 54, "2/3", "Кровотечение сильнее.", "Stronger bleed."),
                        P("DW", 55, "3/3", "Закрыт.", "Maxed."),
                        P("ICHARGE", 56, "1/2", "Одно очко: 15 в Оружии → открыты Пронзающие раны.", "One point: 15 Arms points → unlocks Impale.", "filler"),
                        P("IMPALE", 57, "1/2", "+урон критов Кровожадности и Вихря.", "+crit damage for Bloodthirst and Whirlwind."),
                        P("IMPALE", 58, "2/2", "Закрыт: Arms 17 — как в рейдовом билде.", "Maxed: Arms 17 — same as the raid build.", "key"),
                        P("LRAGE", 59, "2/5", "Возврат к Lingering Rage, отложенному на 24.", "Back to Lingering Rage, paused at 24.", "return"),
                        P("LRAGE", 60, "3/5", "Билд готов: Arms 17 / Fury 34 — это и есть рейдовый билд, сброс не нужен.", "Done: Arms 17 / Fury 34 — already the raid build, no respec needed.", "return"),
                    }
                },
            },
        },
        {
            id = "raid",
            mode = "trees",
            icon = "Interface\\Icons\\Spell_Nature_BloodLust",
            titleKey = "BUILD_RAID_TITLE",
            subKey = "BUILD_RAID_SUB",
            srcKey = "BUILD_RAID_SRC",
            totals = { arms = 17, fury = 34, prot = 0 },
            trees = {
                {
                    treeKey = "TREE_ARMS", points = 17,
                    talents = {
                        TT(1, "IHS", "3/3", "Дешевый Удар героя — сброс лишней ярости.", "Cheaper Heroic Strike — rage dump."),
                        TT(1, "DEFLECT", "2/5", "Только для открытия рядов.", "Only to unlock tiers.", "filler"),
                        TT(2, "ITM", "3/3", "Смена стоек без потери ярости.", "Stance dance without losing rage.", "key"),
                        TT(2, "IOP", "2/2", "Шанс крита Превосходства.", "Overpower crit chance."),
                        TT(2, "ICHARGE", "1/2", "Очко для открытия 4-го ряда.", "Point to unlock tier 4.", "filler"),
                        TT(3, "AM", "1/1", "Пассивная ярость.", "Passive rage."),
                        TT(3, "DW", "3/3", "Кровотечение с критов.", "Bleed on crits."),
                        TT(4, "IMPALE", "2/2", "Урон критов способностей — главная причина брать Оружие.", "Ability crit damage — the main reason to go into Arms.", "key"),
                    }
                },
                {
                    treeKey = "TREE_FURY", points = 34,
                    talents = {
                        TT(1, "CRUELTY", "5/5", "+5% крита.", "+5% crit.", "key"),
                        TT(2, "UW", "5/5", "Ярость с автоатак.", "Rage from auto attacks."),
                        TT(2, "LRAGE", "3/5", "Ярость дольше держится между пулами.", "Rage lingers between pulls."),
                        TT(3, "PHOWL", "1/1", "Талант на 11 очков.", "11-point talent."),
                        TT(3, "FPREC", "3/3", "Меткость левой руки — ключевой стат для рейда.", "Off-hand hit — key for raiding.", "key"),
                        TT(4, "DWS", "5/5", "+25% урона левой рукой.", "+25% off-hand damage.", "key"),
                        TT(4, "RSWINGS", "1/1", "Талант на 16 очков: ярость за здоровье.", "16-point talent: rage for health.", "key"),
                        TT(4, "IEXEC", "2/2", "Дешевая Казнь в фазе добивания.", "Cheap Execute in the execute phase."),
                        TT(5, "DEATHWISH", "1/1", "Нужна для Кровожадности.", "Required for Bloodthirst."),
                        TT(5, "IBRAGE", "2/2", "Ярость от Ярости берсерка.", "Rage from Berserker Rage."),
                        TT(6, "FLURRY", "3/3", "+30% скорости атаки после крита.", "+30% attack speed after a crit.", "key"),
                        TT(6, "IWW", "2/2", "Вихрь каждые 8 сек, +30% урона по ближайшей цели.", "Whirlwind every 8 sec, +30% to the closest enemy.", "key"),
                        TT(7, "BT", "1/1", "Главный удар.", "Main nuke.", "key"),
                    }
                },
            },
        },
        {
            id = "tank",
            mode = "trees",
            icon = "Interface\\Icons\\INV_Shield_05",
            titleKey = "BUILD_TANK_TITLE",
            subKey = "BUILD_TANK_SUB",
            srcKey = "BUILD_TANK_SRC",
            totals = { arms = 0, fury = 5, prot = 46 },
            trees = {
                {
                    treeKey = "TREE_PROT", points = 46,
                    talents = {
                        TT(1, "IBLOOD", "2/2", "Ярость на старте боя.", "Rage at the start of a fight."),
                        TT(1, "SHSPEC", "5/5", "Блок + ярость при блоке.", "Block + rage on block.", "key"),
                        TT(1, "IRONWILL", "3/5", "Заполнитель: остаток очков.", "Filler for leftover points.", "filler"),
                        TT(2, "ANTICIP", "5/5", "Защита (Defense) — к капу против крит. ударов боссов.", "Defense skill — toward the boss crit cap.", "key"),
                        TT(2, "IREV", "3/3", "Урон и угроза Реванша.", "Revenge damage and threat."),
                        TT(2, "ITC", "3/3", "Угроза по пакам.", "AoE threat."),
                        TT(3, "LSTAND", "1/1", "Кнопка спасения.", "Panic button."),
                        TT(3, "MOD", "2/2", "Ярость при уклонении и парировании.", "Rage on dodge and parry."),
                        TT(3, "IDISARM", "3/3", "Дольше Разоружение — меньше урона от боссов с оружием.", "Longer Disarm — less damage from armed bosses."),
                        TT(3, "DEFIANCE", "3/3", "Больше угрозы.", "More threat.", "key"),
                        TT(4, "ISUNDER", "3/3", "Дешевый Раскол брони — основа угрозы.", "Cheaper Sunder Armor — threat backbone."),
                        TT(4, "VANGUARD", "1/1", "Рывок в Оборонительной стойке.", "Charge in Defensive Stance.", "key"),
                        TT(4, "ISBASH", "2/2", "Удар щитом надежнее сбивает касты.", "Shield Bash interrupts more reliably."),
                        TT(5, "CBLOW", "1/1", "Оглушение.", "Stun."),
                        TT(5, "FRAGE", "3/3", "Атакующие способности дешевле.", "Cheaper offensive abilities.", "key"),
                        TT(6, "BASTION", "5/5", "Урон со щитом.", "Damage with a shield."),
                        TT(7, "SSLAM", "1/1", "Главный удар танка.", "Main tank strike.", "key"),
                    }
                },
                {
                    treeKey = "TREE_FURY", points = 5,
                    talents = {
                        TT(1, "CRUELTY", "5/5", "+5% крита: больше ярости и угрозы.", "+5% crit: more rage and threat.", "key"),
                    }
                },
            },
        },
        {
            id = "pvp",
            mode = "trees",
            icon = "Interface\\Icons\\Ability_Warrior_SavageBlow",
            titleKey = "BUILD_PVP_TITLE",
            subKey = "BUILD_PVP_SUB",
            srcKey = "BUILD_PVP_SRC",
            totals = { arms = 33, fury = 18, prot = 0 },
            trees = {
                {
                    treeKey = "TREE_ARMS", points = 33,
                    talents = {
                        TT(1, "DEFLECT", "2/5", "Парирование против других бойцов.", "Parry against melee.", "filler"),
                        TT(1, "IREND", "3/3", "Сильное Кровопускание — работает вместе с Bloodthrill.", "Strong Rend — works with Bloodthrill."),
                        TT(2, "ICHARGE", "2/2", "Ярость на старте: сразу Подрезать + Смертельный удар.", "Opener rage: Hamstring + Mortal Strike right away."),
                        TT(2, "ITM", "3/3", "Рывок → Перехват → Зуботычина без потери ярости.", "Charge → Intercept → Pummel without losing rage.", "key"),
                        TT(2, "IOP", "2/2", "Наказывает за уклонения.", "Punishes dodges."),
                        TT(3, "AM", "1/1", "Ярость, даже если по вам не бьют.", "Rage even when nobody hits you."),
                        TT(3, "DW", "3/3", "Кровотечение с критов.", "Bleed on crits."),
                        TT(4, "TWOH", "3/3", "Урон двуручником.", "Two-hander damage."),
                        TT(4, "IMPALE", "2/2", "Взрывной урон критами.", "Burst crit damage.", "key"),
                        TT(5, "SS", "1/1", "Урон по двум целям у флага.", "Two-target damage on flags."),
                        TT(5, "WMASTER", "5/5", "Бонус зависит от типа оружия (топоры/древковое — крит).", "Bonus depends on weapon type (axes/polearms — crit).", "key"),
                        TT(5, "BTHRILL", "2/2", "Шанс открыть Превосходство по цели с Кровопусканием.", "Chance to enable Overpower on Rend targets."),
                        TT(6, "IHAM", "3/3", "Шанс обездвижить цель Подрезанием.", "Chance to root with Hamstring.", "key"),
                        TT(7, "MS", "1/1", "−50% исцеления по цели.", "−50% healing on the target.", "key"),
                    }
                },
                {
                    treeKey = "TREE_FURY", points = 18,
                    talents = {
                        TT(1, "CRUELTY", "5/5", "+5% крита.", "+5% crit.", "key"),
                        TT(2, "UW", "5/5", "Ярость с автоатак.", "Rage from auto attacks."),
                        TT(3, "PHOWL", "1/1", "Массовое замедление.", "AoE snare.", "key"),
                        TT(3, "FPREC", "3/3", "Меткость, если играете с двумя оружиями.", "Hit (if you swap to dual wield)."),
                        TT(3, "BCRAZE", "1/3", "Очко для открытия 4-го ряда.", "Point to unlock tier 4.", "filler"),
                        TT(4, "IEXEC", "2/2", "Дешевая Казнь для добивания.", "Cheap Execute for finishing."),
                        TT(4, "RSWINGS", "1/1", "Мгновенная ярость в начале боя.", "Burst rage at the start of a fight."),
                    }
                },
            },
        },
    },

    ------------------------------------------------------------------
    -- Вкладка 3: Роут прокачки по фракциям
    ------------------------------------------------------------------
    Routes = {
        Horde = {
            {
                lvl = "1–12", minLvl = 1, maxLvl = 12,
                zoneRu = "Дуротар / Мулгор / Тирисфальские леса", zoneEn = "Durotar / Mulgore / Tirisfal Glades",
                tipsRu = {
                    "На 10 ур. возьмите у тренера классовый квест на Оборонительную стойку — она нужна для танкования и Удара щитом.",
                    "В Forever для соло-прокачки чаще всего берут Защиту: щит + одноручное оружие (см. вкладку «Билды»). Для Неистовства — два оружия с 20 уровня.",
                    "Профессии: Горное дело + Кузнечное дело (или Инженерия — бомбы и сетки).",
                },
                tipsEn = {
                    "At level 10 take the Defensive Stance class quest from your trainer — you need it for tanking and Shield Bash.",
                    "In Forever, Protection is the most popular solo leveling spec: shield + one-hander (see the Builds tab). For Fury — dual wield from level 20.",
                    "Professions: Mining + Blacksmithing (or Engineering — bombs and nets).",
                },
                trainerRu = "Рывок, Кровопускание (4), Удар грома (6), Подрезать сухожилия (8), Кровавая ярость, Раскол брони (10), Превосходство (12)",
                trainerEn = "Charge, Rend (4), Thunder Clap (6), Hamstring (8), Bloodrage, Sunder Armor (10), Overpower (12)",
            },
            {
                lvl = "12–22", minLvl = 12, maxLvl = 22,
                zoneRu = "Степи (Перекрёсток) / Серебряный бор", zoneEn = "The Barrens (Crossroads) / Silverpine Forest",
                tipsRu = {
                    "Степи — самая плотная по квестам зона Орды. Берите все задания Перекрёстка и Кабестана.",
                    "Сохраняйте квесты на подземелья: Огненная Пропасть (13+) и Пещеры Стенаний (17+).",
                    "На 20 ур.: Victory Rush (после убийства — мгновенный удар с лечением на 10% здоровья) и Рассекающий удар.",
                },
                tipsEn = {
                    "The Barrens is the densest Horde quest zone. Grab every quest in Crossroads and Ratchet.",
                    "Keep dungeon quests: Ragefire Chasm (13+) and Wailing Caverns (17+).",
                    "At 20: Victory Rush (after a kill — an instant strike that heals 10% health) and Cleave.",
                },
                trainerRu = "Тактическое превосходство (14, теперь базовое), Деморализующий крик, Реванш (14), Дразнящий удар (16), Разоружение (18), Рассекающий удар, Возмездие, Мощный удар, Victory Rush (20), Устрашающий крик (22)",
                trainerEn = "Tactical Mastery (14, now baseline), Demoralizing Shout, Revenge (14), Mocking Blow (16), Disarm (18), Cleave, Retaliation, Slam, Victory Rush (20), Intimidating Shout (22)",
                dungeonsRu = "Огненная Пропасть, Пещеры Стенаний", dungeonsEn = "Ragefire Chasm, Wailing Caverns",
            },
            {
                lvl = "22–30", minLvl = 22, maxLvl = 30,
                zoneRu = "Когтистые горы / Ясеневый лес / Предгорья Хилсбрада / Тысяча Игл", zoneEn = "Stonetalon / Ashenvale / Hillsbrad Foothills / Thousand Needles",
                tipsRu = {
                    "С 24 ур. используйте Казнь на добивании — экономит время на каждом мобе.",
                    "На 29+ сходите в Лабиринты Иглошкурых (RFK) за Трупным срубщиком.",
                    "Начинайте копить на 30 уровень: Стойка берсерка и новые ранги стоят денег.",
                },
                tipsEn = {
                    "From 24 use Execute to finish mobs — saves time on every pull.",
                    "At 29+ run Razorfen Kraul for Corpsemaker.",
                    "Save gold for 30: Berserker Stance and new ranks are expensive.",
                },
                trainerRu = "Казнь (24), Вызывающий крик (26), Глухая оборона (28), Стойка берсерка (квест) и Перехват (30)",
                trainerEn = "Execute (24), Challenging Shout (26), Shield Wall (28), Berserker Stance (quest) & Intercept (30)",
                dungeonsRu = "Лабиринты Иглошкурых, Монастырь (Кладбище)", dungeonsEn = "Razorfen Kraul, SM Graveyard",
            },
            {
                lvl = "30–40", minLvl = 30, maxLvl = 40,
                zoneRu = "Тысяча Игл / Пустоши / Нагорье Арати / Тернистая долина / Пылевые топи", zoneEn = "Thousand Needles / Desolace / Arathi / Stranglethorn Vale / Dustwallow Marsh",
                tipsRu = {
                    "На 30 ур. возьмите у тренера квест на Стойку берсерка — затем цепочку на оружие Вихря (Топор Вихря держится до 45+).",
                    "Монастырь Алого Ордена: Оружейная ради Опустошителя и сета Ирода.",
                    "На 40 ур. учите Латные доспехи и вторую специализацию: например, Защита для соло + Неистовство для групп.",
                },
                tipsEn = {
                    "At 30 take the Berserker Stance quest, then the Whirlwind weapon chain (Whirlwind Axe lasts until 45+).",
                    "Scarlet Monastery: Armory for Ravager and Herod's gear.",
                    "At 40 learn Plate Mail and Dual Specialization: e.g. Protection for solo + Fury for groups.",
                },
                trainerRu = "Ярость берсерка (32), Вихрь — бьёт обоими оружиями (36), Зуботычина (38), Латные доспехи и вторая специализация (40)",
                trainerEn = "Berserker Rage (32), Whirlwind — hits with both weapons (36), Pummel (38), Plate Mail & Dual Specialization (40)",
                dungeonsRu = "Монастырь Алого Ордена (Оружейная, Собор)", dungeonsEn = "Scarlet Monastery (Armory, Cathedral)",
            },
            {
                lvl = "40–50", minLvl = 40, maxLvl = 50,
                zoneRu = "Танарис / Фералас / Внутренние земли / Бесплодные земли / Азшара", zoneEn = "Tanaris / Feralas / Hinterlands / Badlands / Azshara",
                tipsRu = {
                    "Зул'Фаррак (44–50): квест Газ'риллы даёт Морковку на палочке (+3% к скорости маунта).",
                    "Марадон (46–52): квест на Принцессу → Кольцо Блэкстоуна (+1% Hit, 20 AP).",
                    "Сейчас как раз время Сул'траза: соберите обе половинки в ZF.",
                },
                tipsEn = {
                    "Zul'Farrak (44–50): the Gahz'rilla quest gives Carrot on a Stick (+3% mount speed).",
                    "Maraudon (46–52): Princess quest → Blackstone Ring (+1% Hit, 20 AP).",
                    "Prime time for Sul'thraze: collect both halves in ZF.",
                },
                trainerRu = "Новые ранги способностей; Безрассудство (50)",
                trainerEn = "New ability ranks; Recklessness (50)",
                dungeonsRu = "Ульдаман, Зул'Фаррак, Марадон", dungeonsEn = "Uldaman, Zul'Farrak, Maraudon",
            },
            {
                lvl = "50–60", minLvl = 50, maxLvl = 60,
                zoneRu = "Ун'Горо / Оскверненный лес / Пылающие степи / Чумные земли / Зимние Ключи / Силитус", zoneEn = "Un'Goro / Felwood / Burning Steppes / Plaguelands / Winterspring / Silithus",
                tipsRu = {
                    "На 50 ур. Павший герой Орды (Болото Печали) даёт классовую цепочку воина в Затонувшем Храме → Алмазная колба.",
                    "Глубины Черной Горы — лучший опыт и вещи на 52–60.",
                    "На 60: пре-рейд сет (BRD, UBRS, Страт). Рейдовый билд держите во второй специализации (доступна с 40).",
                },
                tipsEn = {
                    "At 50 the Fallen Hero of the Horde (Swamp of Sorrows) starts the warrior Sunken Temple chain → Diamond Flask.",
                    "Blackrock Depths — best XP and gear for 52–60.",
                    "At 60: pre-raid gear (BRD, UBRS, Strat). Keep the raid build in your second spec (available from 40).",
                },
                trainerRu = "Последние ранги: Смертельный удар, Казнь, Вихрь",
                trainerEn = "Final ranks: Mortal Strike, Execute, Whirlwind",
                dungeonsRu = "Затонувший Храм, Глубины Черной Горы, Пик Черной Горы, Стратхольм", dungeonsEn = "Sunken Temple, Blackrock Depths, Blackrock Spire, Stratholme",
            },
        },
        Alliance = {
            {
                lvl = "1–12", minLvl = 1, maxLvl = 12,
                zoneRu = "Элвиннский лес / Дун Морог / Тельдрассил", zoneEn = "Elwynn Forest / Dun Morogh / Teldrassil",
                tipsRu = {
                    "На 10 ур. выполните классовый квест на Оборонительную стойку.",
                    "В Forever для соло-прокачки чаще всего берут Защиту: щит + одноручное оружие (см. вкладку «Билды»). Для Неистовства — два оружия с 20 уровня.",
                    "Профессии: Горное дело + Кузнечное дело (или Инженерия — бомбы и сетки).",
                },
                tipsEn = {
                    "At level 10 complete the class quest for Defensive Stance.",
                    "In Forever, Protection is the most popular solo leveling spec: shield + one-hander (see the Builds tab). For Fury — dual wield from level 20.",
                    "Professions: Mining + Blacksmithing (or Engineering — bombs and nets).",
                },
                trainerRu = "Рывок, Кровопускание (4), Удар грома (6), Подрезать сухожилия (8), Кровавая ярость, Раскол брони (10), Превосходство (12)",
                trainerEn = "Charge, Rend (4), Thunder Clap (6), Hamstring (8), Bloodrage, Sunder Armor (10), Overpower (12)",
            },
            {
                lvl = "12–22", minLvl = 12, maxLvl = 22,
                zoneRu = "Западный Край / Лок Модан / Темные берега", zoneEn = "Westfall / Loch Modan / Darkshore",
                tipsRu = {
                    "Цепочка Братства Справедливости в Западном Крае ведёт в Мертвые Копи — награда Поножи Западного Края.",
                    "Мертвые Копи (17–26): Кувалда Смайта — отличный двуручник на 20 уровень.",
                    "На 20 ур.: Victory Rush (после убийства — мгновенный удар с лечением на 10% здоровья) и Рассекающий удар.",
                },
                tipsEn = {
                    "The Defias Brotherhood chain in Westfall leads to the Deadmines — rewards Chausses of Westfall.",
                    "Deadmines (17–26): Smite's Mighty Hammer is a great two-hander at 20.",
                    "At 20: Victory Rush (after a kill — an instant strike that heals 10% health) and Cleave.",
                },
                trainerRu = "Тактическое превосходство (14, теперь базовое), Деморализующий крик, Реванш (14), Дразнящий удар (16), Разоружение (18), Рассекающий удар, Возмездие, Мощный удар, Victory Rush (20), Устрашающий крик (22)",
                trainerEn = "Tactical Mastery (14, now baseline), Demoralizing Shout, Revenge (14), Mocking Blow (16), Disarm (18), Cleave, Retaliation, Slam, Victory Rush (20), Intimidating Shout (22)",
                dungeonsRu = "Мертвые Копи, Пещеры Стенаний", dungeonsEn = "The Deadmines, Wailing Caverns",
            },
            {
                lvl = "22–30", minLvl = 22, maxLvl = 30,
                zoneRu = "Красногорье / Сумеречный лес / Болотина / Ясеневый лес", zoneEn = "Redridge Mountains / Duskwood / Wetlands / Ashenvale",
                tipsRu = {
                    "Отличные цепочки квестов и много зеленых/синих наград на силу.",
                    "С 24 ур. используйте Казнь на добивании.",
                    "На 29+ можно сходить в Лабиринты Иглошкурых (Степи) за Трупным срубщиком.",
                },
                tipsEn = {
                    "Great quest chains with plenty of Strength gear rewards.",
                    "From 24 use Execute to finish mobs.",
                    "At 29+ you can run Razorfen Kraul (Barrens) for Corpsemaker.",
                },
                trainerRu = "Казнь (24), Вызывающий крик (26), Глухая оборона (28), Стойка берсерка (квест) и Перехват (30)",
                trainerEn = "Execute (24), Challenging Shout (26), Shield Wall (28), Berserker Stance (quest) & Intercept (30)",
                dungeonsRu = "Лабиринты Иглошкурых", dungeonsEn = "Razorfen Kraul",
            },
            {
                lvl = "30–40", minLvl = 30, maxLvl = 40,
                zoneRu = "Тернистая долина / Нагорье Арати / Южнобережье / Пустоши / Пылевые топи", zoneEn = "Stranglethorn Vale / Arathi / Southshore / Desolace / Dustwallow Marsh",
                tipsRu = {
                    "На 30 ур. возьмите у тренера квест на Стойку берсерка, затем цепочку на оружие Вихря.",
                    "Монастырь Алого Ордена: Оружейная ради Опустошителя и сета Ирода.",
                    "На 40 ур. учите Латные доспехи и вторую специализацию: например, Защита для соло + Неистовство для групп.",
                },
                tipsEn = {
                    "At 30 take the Berserker Stance quest, then the Whirlwind weapon chain.",
                    "Scarlet Monastery: Armory for Ravager and Herod's gear.",
                    "At 40 learn Plate Mail and Dual Specialization: e.g. Protection for solo + Fury for groups.",
                },
                trainerRu = "Ярость берсерка (32), Вихрь — бьёт обоими оружиями (36), Зуботычина (38), Латные доспехи и вторая специализация (40)",
                trainerEn = "Berserker Rage (32), Whirlwind — hits with both weapons (36), Pummel (38), Plate Mail & Dual Specialization (40)",
                dungeonsRu = "Монастырь Алого Ордена", dungeonsEn = "Scarlet Monastery",
            },
            {
                lvl = "40–50", minLvl = 40, maxLvl = 50,
                zoneRu = "Танарис / Фералас / Внутренние земли / Бесплодные земли / Выжженные земли", zoneEn = "Tanaris / Feralas / Hinterlands / Badlands / Blasted Lands",
                tipsRu = {
                    "Зул'Фаррак (44–50): Морковка на палочке и Сул'траз Каратель.",
                    "Марадон (46–52): квест на Принцессу Терадрас → Кольцо Блэкстоуна.",
                    "Копите золото на верховое животное к 40 уровню.",
                },
                tipsEn = {
                    "Zul'Farrak (44–50): Carrot on a Stick and Sul'thraze the Lasher.",
                    "Maraudon (46–52): Princess Theradras quest → Blackstone Ring.",
                    "Save gold for your level 40 mount.",
                },
                trainerRu = "Новые ранги способностей; Безрассудство (50)",
                trainerEn = "New ability ranks; Recklessness (50)",
                dungeonsRu = "Ульдаман, Зул'Фаррак, Марадон", dungeonsEn = "Uldaman, Zul'Farrak, Maraudon",
            },
            {
                lvl = "50–60", minLvl = 50, maxLvl = 60,
                zoneRu = "Ун'Горо / Оскверненный лес / Пылающие степи / Чумные земли / Зимние Ключи / Силитус", zoneEn = "Un'Goro / Felwood / Burning Steppes / Plaguelands / Winterspring / Silithus",
                tipsRu = {
                    "Классовая цепочка в Затонувшем Храме (Павший герой Орды, Болото Печали) → тринкет Алмазная колба.",
                    "Глубины Черной Горы — лучший опыт и вещи на 52–60.",
                    "На 60: пре-рейд сет (BRD, UBRS, Страт). Рейдовый билд держите во второй специализации (доступна с 40).",
                },
                tipsEn = {
                    "Sunken Temple class chain (Fallen Hero of the Horde, Swamp of Sorrows) → Diamond Flask trinket.",
                    "Blackrock Depths — best XP and gear for 52–60.",
                    "At 60: pre-raid gear (BRD, UBRS, Strat). Keep the raid build in your second spec (available from 40).",
                },
                trainerRu = "Последние ранги: Смертельный удар, Казнь, Вихрь",
                trainerEn = "Final ranks: Mortal Strike, Execute, Whirlwind",
                dungeonsRu = "Затонувший Храм, Глубины Черной Горы, Пик Черной Горы, Стратхольм", dungeonsEn = "Sunken Temple, Blackrock Depths, Blackrock Spire, Stratholme",
            },
        }
    },

    ------------------------------------------------------------------
    -- Вкладка 4: Подземелья в стиле Dungeon Journal
    --   loot.id — ID предмета: по наведению показывается настоящая подсказка из игры
    --   loot.q  — качество (2 зелёный, 3 синий, 4 эпик), если клиент ещё не знает предмет
    ------------------------------------------------------------------
    Dungeons = {
        {
            id = "rfc", lvl = "13–18", minLvl = 13, maxLvl = 18, faction = "Horde",
            icon = "Interface\\Icons\\Spell_Fire_LavaSpawn",
            nameRu = "Огненная Пропасть (RFC)", nameEn = "Ragefire Chasm (RFC)",
            zoneRu = "Оргриммар, Расселина Теней", zoneEn = "Orgrimmar, Cleft of Shadow",
            descRu = "Короткое подземелье прямо под Оргриммаром. Быстрый опыт и пачка квестов из Оргриммара и Громового Утёса.",
            descEn = "A short dungeon right under Orgrimmar. Fast XP and a bundle of quests from Orgrimmar and Thunder Bluff.",
            tipRu = "Хороший первый опыт танкования: щит, Оборонительная стойка и Раскол брони по главной цели.",
            tipEn = "A good first tanking run: shield, Defensive Stance and Sunder Armor on the main target.",
            quests = {
                { ru = "Hidden Enemies (Тралл) — убить Базалана и Джергоша", en = "Hidden Enemies (Thrall) — kill Bazzalan and Jergosh" },
                { ru = "Slaying the Beast — убить Тарагамана Ненасытного", en = "Slaying the Beast — kill Taragaman the Hungerer" },
                { ru = "Searching for the Lost Satchel — сумка Маура Зловещего Тотема", en = "Searching for the Lost Satchel — Maur Grimtotem's satchel" },
            },
            loot = {
                { icon = "Interface\\Icons\\INV_Belt_03", q = 2, ru = "Квестовые награды", en = "Quest rewards",
                  slotRu = "Пояса, поножи, оружие ~15 ур.", slotEn = "Belts, leggings, weapons ~lvl 15",
                  srcRu = "Квесты подземелья", srcEn = "Dungeon quests",
                  noteRu = "Закрывают слоты до Степей.", noteEn = "Cover your slots until the Barrens." },
            }
        },
        {
            id = "dm", lvl = "17–26", minLvl = 17, maxLvl = 26, faction = "Alliance",
            icon = "Interface\\Icons\\INV_Helmet_08",
            nameRu = "Мертвые Копи (Deadmines)", nameEn = "The Deadmines (VC)",
            zoneRu = "Западный Край, Луноречье", zoneEn = "Westfall, Moonbrook",
            descRu = "Главное подземелье Альянса на 20 уровень: много опыта, золото и сильные синие вещи.",
            descEn = "The core Alliance dungeon at level 20: lots of XP, gold and strong blue items.",
            tipRu = "Мистер Смайт по ходу боя меняет оружие и оглушает группу — держите его на себе и не стойте у сундуков.",
            tipEn = "Mr. Smite swaps weapons and stuns the group — keep him on you and stay away from the chests.",
            quests = {
                { ru = "The Defias Brotherhood (Гриан Стаутмантл) → Поножи Западного Края", en = "The Defias Brotherhood (Gryan Stoutmantle) → Chausses of Westfall" },
                { ru = "Red Silk Bandanas (Разведчик Риэлл) — красные банданы с треша", en = "Red Silk Bandanas (Scout Riell) — bandanas from trash" },
            },
            loot = {
                { id = 7230, icon = "Interface\\Icons\\INV_Hammer_09", q = 3, ru = "Кувалда Смайта", en = "Smite's Mighty Hammer",
                  slotRu = "Двуручная булава", slotEn = "Two-Hand Mace",
                  srcRu = "Мистер Смайт", srcEn = "Mr. Smite",
                  noteRu = "Лучший двуручник на 20 ур. до Монастыря.", noteEn = "Best two-hander at 20 until Scarlet Monastery." },
                { id = 5191, icon = "Interface\\Icons\\INV_Sword_23", q = 3, ru = "Жестокая зазубрина", en = "Cruel Barb",
                  slotRu = "Одноручный меч", slotEn = "One-Hand Sword",
                  srcRu = "Эдвин ван Клиф", srcEn = "Edwin VanCleef",
                  noteRu = "Для танкования со щитом.", noteEn = "For tanking with a shield." },
                { icon = "Interface\\Icons\\INV_Pants_03", q = 3, ru = "Поножи Западного Края", en = "Chausses of Westfall",
                  slotRu = "Ноги — кольчуга", slotEn = "Legs — Mail",
                  srcRu = "Квест The Defias Brotherhood", srcEn = "Quest: The Defias Brotherhood",
                  noteRu = "Носятся до 30+ уровня.", noteEn = "Worn until 30+." },
            }
        },
        {
            id = "wc", lvl = "17–24", minLvl = 17, maxLvl = 24, faction = "Both",
            icon = "Interface\\Icons\\Spell_Nature_Polymorph",
            nameRu = "Пещеры Стенаний (WC)", nameEn = "Wailing Caverns (WC)",
            zoneRu = "Степи, оазис к юго-западу от Перекрёстка", zoneEn = "The Barrens, oasis southwest of the Crossroads",
            descRu = "Запутанные пещеры с четырьмя Лордами Клыка и финальным Мутанусом Пожирателем.",
            descEn = "A maze of caves with four Lords of the Fang and Mutanus the Devourer at the end.",
            tipRu = "Друиды Клыка усыпляют: держите Ярость берсерка/Кровавую ярость наготове и прерывайте Ударом щитом.",
            tipEn = "Druids of the Fang cast Sleep: interrupt with Shield Bash and keep rage up with Bloodrage.",
            quests = {
                { ru = "Leaders of the Fang (Нара Дикая Грива) — камни четырёх лордов", en = "Leaders of the Fang (Nara Wildmane) — gems of the four lords" },
                { ru = "Deviate Hides (Налпак) — шкуры загадочных зверей", en = "Deviate Hides (Nalpak) — deviate hides" },
                { ru = "Serpentbloom — цветы внутри подземелья", en = "Serpentbloom — flowers inside the dungeon" },
                { ru = "Smart Drinks (Кабестан) — Wailing Essence", en = "Smart Drinks (Ratchet) — Wailing Essence" },
            },
            loot = {
                { icon = "Interface\\Icons\\INV_Chest_Chain_04", q = 3, ru = "Кольчуга мутанта", en = "Mutant Scale Breastplate",
                  slotRu = "Грудь — кольчуга", slotEn = "Chest — Mail",
                  srcRu = "Мутанус Пожиратель", srcEn = "Mutanus the Devourer",
                  noteRu = "Отличная грудь для воина 20+.", noteEn = "Great chest for a warrior at 20+." },
                { id = 10410, icon = "Interface\\Icons\\INV_Pants_02", q = 3, ru = "Поножи Клыка", en = "Leggings of the Fang",
                  slotRu = "Ноги — кожа", slotEn = "Legs — Leather",
                  srcRu = "Лорды Клыка", srcEn = "Lords of the Fang",
                  noteRu = "Кожа, но статы на силу/ловкость отличные для уровня.", noteEn = "Leather, but great Str/Agi for the level." },
            }
        },
        {
            id = "rfk", lvl = "29–33", minLvl = 29, maxLvl = 33, faction = "Both",
            icon = "Interface\\Icons\\INV_Axe_04",
            nameRu = "Лабиринты Иглошкурых (RFK)", nameEn = "Razorfen Kraul (RFK)",
            zoneRu = "Южные Степи", zoneEn = "Southern Barrens",
            descRu = "Обязательный заход за лучшим двуручным топором до оружия Вихря.",
            descEn = "A must-run for the best two-handed axe before the Whirlwind weapon.",
            tipRu = "Много кабанов и мелких паков: Размашистые удары с 30 ур. + Рассекающий удар чистят треш очень быстро.",
            tipEn = "Lots of boars and small packs: Sweeping Strikes (30) + Cleave clears trash fast.",
            quests = {
                { ru = "Willix the Importer — сопроводить Уиллкса к выходу", en = "Willix the Importer — escort Willix out" },
                { ru = "Blueleaf Tubers (Кабестан) — клубни с помощью суслика", en = "Blueleaf Tubers (Ratchet) — dig tubers with a snufflenose" },
                { ru = "The Crone of the Kraul — убить Чаргу Острый Бок", en = "The Crone of the Kraul — kill Charlga Razorflank" },
            },
            loot = {
                { id = 6687, icon = "Interface\\Icons\\INV_Axe_04", q = 3, ru = "Трупный срубщик", en = "Corpsemaker",
                  slotRu = "Двуручный топор", slotEn = "Two-Hand Axe",
                  srcRu = "Босс Лабиринтов Иглошкурых", srcEn = "Razorfen Kraul boss",
                  noteRu = "Носится до 40 и выше. С ним берите Спец. на топорах.", noteEn = "Lasts until 40+. Pair it with Axe Specialization." },
            }
        },
        {
            id = "sm", lvl = "30–42", minLvl = 30, maxLvl = 42, faction = "Both",
            icon = "Interface\\Icons\\INV_Axe_09",
            nameRu = "Монастырь Алого Ордена (SM)", nameEn = "Scarlet Monastery (SM)",
            zoneRu = "Тирисфальские леса (4 крыла: Кладбище, Библиотека, Оружейная, Собор)", zoneEn = "Tirisfal Glades (4 wings: Graveyard, Library, Armory, Cathedral)",
            descRu = "Четыре крыла на 30–42 уровни. Оружейная — главное крыло для воина: Ирод и его лут.",
            descEn = "Four wings for levels 30–42. The Armory is the key warrior wing: Herod and his loot.",
            tipRu = "Ирод кружится Вихрем — отходите от него, пока он крутится. Ключ от Оружейной и Собора падает в Библиотеке.",
            tipEn = "Herod uses Whirlwind — step away while he spins. The Armory/Cathedral key drops in the Library.",
            quests = {
                { ru = "In the Name of the Light — убить Вайтмейн, Могрейна, Ирода и Доана", en = "In the Name of the Light — kill Whitemane, Mograine, Herod and Doan" },
                { ru = "Into The Scarlet Monastery (Орда) — финальные боссы", en = "Into The Scarlet Monastery (Horde) — final bosses" },
            },
            loot = {
                { id = 7717, icon = "Interface\\Icons\\INV_Axe_09", q = 3, ru = "Опустошитель", en = "Ravager",
                  slotRu = "Двуручный топор", slotEn = "Two-Hand Axe",
                  srcRu = "Ирод (Оружейная)", srcEn = "Herod (Armory)",
                  noteRu = "При ударе может запустить вихрь на 9 сек — огромный урон по пакам.", noteEn = "Chance on hit to whirlwind for 9 sec — huge AoE damage." },
                { id = 7718, icon = "Interface\\Icons\\INV_Shoulder_01", q = 3, ru = "Наплечники Ирода", en = "Herod's Shoulder",
                  slotRu = "Плечи — кольчуга", slotEn = "Shoulder — Mail",
                  srcRu = "Ирод (Оружейная)", srcEn = "Herod (Armory)",
                  noteRu = "Сила + Ловкость + Выносливость.", noteEn = "Strength + Agility + Stamina." },
                { id = 7719, icon = "Interface\\Icons\\INV_Helmet_03", q = 3, ru = "Шлем неистового берсерка", en = "Raging Berserker's Helm",
                  slotRu = "Голова — кольчуга", slotEn = "Head — Mail",
                  srcRu = "Ирод (Оружейная)", srcEn = "Herod (Armory)",
                  noteRu = "Сила и шанс крита.", noteEn = "Strength and crit chance." },
                { id = 7723, icon = "Interface\\Icons\\INV_Hammer_04", q = 3, ru = "Мощь Могрейна", en = "Mograine's Might",
                  slotRu = "Двуручная булава", slotEn = "Two-Hand Mace",
                  srcRu = "Командир Могрейн (Собор)", srcEn = "Scarlet Commander Mograine (Cathedral)",
                  noteRu = "Альтернатива Опустошителю для булавы.", noteEn = "Mace alternative to Ravager." },
                { id = 10330, icon = "Interface\\Icons\\INV_Pants_04", q = 2, ru = "Алые поножи", en = "Scarlet Leggings",
                  slotRu = "Ноги — кольчуга", slotEn = "Legs — Mail",
                  srcRu = "Треш Монастыря", srcEn = "Monastery trash",
                  noteRu = "Часть Алого комплекта.", noteEn = "Part of the Scarlet set." },
            }
        },
        {
            id = "zf", lvl = "44–50", minLvl = 44, maxLvl = 50, faction = "Both",
            icon = "Interface\\Icons\\INV_Sword_25",
            nameRu = "Зул'Фаррак (ZF)", nameEn = "Zul'Farrak (ZF)",
            zoneRu = "Танарис, к северу от Прибамбасска", zoneEn = "Tanaris, north of Gadgetzan",
            descRu = "Много опыта, квест на Морковку на палочке и сборный меч Сул'траз.",
            descEn = "Great XP, the Carrot on a Stick quest and the assembled sword Sul'thraze.",
            tipRu = "Событие на лестнице: встаньте наверху, держите Вихрь/Рассекающий и Удар грома — волны троллей идут плотно.",
            tipEn = "Stairs event: hold the top, use Whirlwind/Cleave and Thunder Clap — troll waves come in tight.",
            quests = {
                { ru = "Gahz'rilla (Уиззл, Мерцающая равнина) → Морковка на палочке", en = "Gahz'rilla (Wizzle Brassbolts, Shimmering Flats) → Carrot on a Stick" },
                { ru = "Divino-matic Rod (Прибамбасск)", en = "Divino-matic Rod (Gadgetzan)" },
                { ru = "Troll Temper (Трентон Лайтхаммер)", en = "Troll Temper (Trenton Lighthammer)" },
            },
            loot = {
                { id = 9372, icon = "Interface\\Icons\\INV_Sword_25", q = 3, ru = "Сул'траз Каратель", en = "Sul'thraze the Lasher",
                  slotRu = "Двуручный меч", slotEn = "Two-Hand Sword",
                  srcRu = "Собирается из двух половинок, падающих в ZF", srcEn = "Combined from two halves that drop in ZF",
                  noteRu = "Мощный эффект при ударе. Носится до 55+.", noteEn = "Strong chance-on-hit effect. Lasts until 55+." },
                { id = 11122, icon = "Interface\\Icons\\INV_Misc_Food_54", q = 2, ru = "Морковка на палочке", en = "Carrot on a Stick",
                  slotRu = "Аксессуар", slotEn = "Trinket",
                  srcRu = "Квест Gahz'rilla", srcEn = "Quest: Gahz'rilla",
                  noteRu = "+3% к скорости верхового животного. Надевайте в пути.", noteEn = "+3% mount speed. Wear it while traveling." },
            }
        },
        {
            id = "mara", lvl = "46–52", minLvl = 46, maxLvl = 52, faction = "Both",
            icon = "Interface\\Icons\\INV_Jewelry_Ring_16",
            nameRu = "Марадон (Maraudon)", nameEn = "Maraudon (Princess Run)",
            zoneRu = "Пустоши (Desolace), Долина Копий", zoneEn = "Desolace, Valley of Spears",
            descRu = "Обязателен ради квеста на пре-рейд кольцо с Принцессы Терадрас.",
            descEn = "Mandatory for the pre-raid ring quest from Princess Theradras.",
            tipRu = "Для прохода к Принцессе нужен Скипетр Селебраса (квест Legends of Maraudon) — с ним путь в 2 раза короче.",
            tipEn = "Get the Scepter of Celebras (Legends of Maraudon) — it halves the path to the Princess.",
            quests = {
                { ru = "Corruption of Earth and Seed (Селендра) — убить Принцессу Терадрас", en = "Corruption of Earth and Seed (Selendra) — kill Princess Theradras" },
                { ru = "Legends of Maraudon → Скипетр Селебраса (портал к Принцессе)", en = "Legends of Maraudon → Scepter of Celebras (portal to Princess)" },
            },
            loot = {
                { id = 17713, icon = "Interface\\Icons\\INV_Jewelry_Ring_16", q = 3, ru = "Кольцо Блэкстоуна", en = "Blackstone Ring",
                  slotRu = "Кольцо", slotEn = "Finger",
                  srcRu = "Квест Corruption of Earth and Seed", srcEn = "Quest: Corruption of Earth and Seed",
                  noteRu = "+1% Hit и 20 AP — носится до рейдов.", noteEn = "+1% Hit and 20 AP — worn into raids." },
            }
        },
        {
            id = "st", lvl = "50–55", minLvl = 50, maxLvl = 55, faction = "Both",
            icon = "Interface\\Icons\\INV_Potion_27",
            nameRu = "Затонувший Храм (ST)", nameEn = "Sunken Temple (ST)",
            zoneRu = "Болото Печали", zoneEn = "Swamp of Sorrows",
            descRu = "Классовый квест воина на один из лучших тринкетов прокачки.",
            descEn = "Warrior class quest for one of the best leveling trinkets.",
            tipRu = "Перья для квеста падают с троллей на балконах вокруг центрального зала — обойдите все 6 балконов.",
            tipEn = "Quest feathers drop from the trolls on the balconies around the central hall — clear all 6.",
            quests = {
                { ru = "Voodoo Feathers (Павший герой Орды) → Алмазная колба", en = "Voodoo Feathers (Fallen Hero of the Horde) → Diamond Flask" },
                { ru = "The Temple of Atal'Hakkar — фрагменты идолов", en = "The Temple of Atal'Hakkar — idol fragments" },
            },
            loot = {
                { id = 20130, icon = "Interface\\Icons\\INV_Potion_27", q = 3, ru = "Алмазная колба", en = "Diamond Flask",
                  slotRu = "Аксессуар (использование)", slotEn = "Trinket (use)",
                  srcRu = "Квест воина Voodoo Feathers", srcEn = "Warrior quest: Voodoo Feathers",
                  noteRu = "+75 к силе на 60 сек и лечение. Жмите на опасных пулах.", noteEn = "+75 Strength for 60 sec plus healing. Pop on dangerous pulls." },
            }
        },
        {
            id = "brd", lvl = "52–60", minLvl = 52, maxLvl = 60, faction = "Both",
            icon = "Interface\\Icons\\INV_Jewelry_Talisman_01",
            nameRu = "Глубины Черной Горы (BRD)", nameEn = "Blackrock Depths (BRD)",
            zoneRu = "Черная гора (между Тлеющим ущельем и Пылающими степями)", zoneEn = "Blackrock Mountain (Searing Gorge / Burning Steppes)",
            descRu = "Главный пре-рейд инст для фарма тринкета, нагрудника и оружия.",
            descEn = "The main pre-raid dungeon for trinket, chest and weapon farming.",
            tipRu = "Ключ Тени (Shadowforge Key) открывает короткие пути. Арена (Кольцо Закона) — случайный босс при каждом заходе.",
            tipEn = "The Shadowforge Key opens shortcuts. The Ring of Law arena spawns a random boss each run.",
            quests = {
                { ru = "Attunement to the Core (Лотос Рифтвейкер) — допуск в Огненные Недра", en = "Attunement to the Core (Lothos Riftwaker) — Molten Core attunement" },
                { ru = "Dark Iron Legacy → Ключ Тени", en = "Dark Iron Legacy → Shadowforge Key" },
                { ru = "Ribbly Screwspigot — убить Риббли в таверне", en = "Ribbly Screwspigot — kill Ribbly in the tavern" },
            },
            loot = {
                { id = 11815, icon = "Interface\\Icons\\INV_Jewelry_Talisman_01", q = 3, ru = "Рука правосудия", en = "Hand of Justice",
                  slotRu = "Аксессуар", slotEn = "Trinket",
                  srcRu = "Редкий дроп с треша и боссов BRD", srcEn = "Rare drop from BRD trash and bosses",
                  noteRu = "20 AP и 2% шанс на доп. атаку. Носится до Naxxramas.", noteEn = "20 AP and 2% chance for an extra attack. Lasts into Naxxramas." },
                { id = 11726, icon = "Interface\\Icons\\INV_Chest_Chain_03", q = 4, ru = "Кольчуга дикого гладиатора", en = "Savage Gladiator Chain",
                  slotRu = "Грудь — кольчуга", slotEn = "Chest — Mail",
                  srcRu = "Арена (Кольцо Закона)", srcEn = "Ring of Law (Arena)",
                  noteRu = "Лучший пре-рейд нагрудник: сила, ловкость и +2% крита.", noteEn = "Best pre-raid chest: Strength, Agility and +2% crit." },
                { id = 11684, icon = "Interface\\Icons\\INV_Hammer_20", q = 4, ru = "Железный враг", en = "Ironfoe",
                  slotRu = "Одноручная булава", slotEn = "One-Hand Mace",
                  srcRu = "Император Дагран Тауриссан", srcEn = "Emperor Dagran Thaurissan",
                  noteRu = "Шанс на 2 доп. атаки — отлично для Fury.", noteEn = "Chance for 2 extra attacks — great for Fury." },
            }
        },
        {
            id = "ubrs", lvl = "55–60", minLvl = 55, maxLvl = 60, faction = "Both",
            icon = "Interface\\Icons\\INV_Shoulder_23",
            nameRu = "Пик Черной Горы (LBRS / UBRS)", nameEn = "Blackrock Spire (LBRS / UBRS)",
            zoneRu = "Черная гора", zoneEn = "Blackrock Mountain",
            descRu = "Нижняя часть — 5 игроков, верхняя — до 10. Пре-рейд плечи, тринкет на крит и парные мечи.",
            descEn = "Lower Spire is 5-man, Upper Spire up to 10. Pre-raid shoulders, crit trinket and twin swords.",
            tipRu = "Для UBRS нужна Печать Вознесения (квест Seal of Ascension) хотя бы у одного в рейде.",
            tipEn = "UBRS requires the Seal of Ascension (quest Seal of Ascension) on at least one raid member.",
            quests = {
                { ru = "Seal of Ascension (Ваэлан) → ключ в UBRS", en = "Seal of Ascension (Vaelan) → UBRS key" },
                { ru = "Допуск к Ониксии: Warlord's Command (Орда) / Marshal Windsor (Альянс)", en = "Onyxia attunement: Warlord's Command (Horde) / Marshal Windsor (Alliance)" },
            },
            loot = {
                { id = 13965, icon = "Interface\\Icons\\INV_Jewelry_Talisman_08", q = 3, ru = "Длань Чернорука", en = "Blackhand's Breadth",
                  slotRu = "Аксессуар", slotEn = "Trinket",
                  srcRu = "UBRS", srcEn = "UBRS",
                  noteRu = "+2% крита пассивно — пре-рейд BiS.", noteEn = "+2% crit passive — pre-raid BiS." },
                { id = 12927, icon = "Interface\\Icons\\INV_Shoulder_23", q = 3, ru = "Наплечники верного удара", en = "Truestrike Shoulders",
                  slotRu = "Плечи — кожа", slotEn = "Shoulder — Leather",
                  srcRu = "UBRS", srcEn = "UBRS",
                  noteRu = "+2% Hit и сила атаки — помогает добрать кап меткости.", noteEn = "+2% Hit and AP — helps reach the hit cap." },
                { id = 12940, icon = "Interface\\Icons\\INV_Sword_43", q = 3, ru = "Священный заряд Дал'Ренда", en = "Dal'Rend's Sacred Charge",
                  slotRu = "Одноручный меч (правая рука)", slotEn = "Main Hand Sword",
                  srcRu = "Вождь Ренд Чернорук (UBRS)", srcEn = "Warchief Rend Blackhand (UBRS)",
                  noteRu = "Комплект с Племенным стражем: +50 AP за 2 предмета.", noteEn = "Set with Tribal Guardian: +50 AP for 2 pieces." },
                { id = 12939, icon = "Interface\\Icons\\INV_Sword_36", q = 3, ru = "Племенной страж Дал'Ренда", en = "Dal'Rend's Tribal Guardian",
                  slotRu = "Одноручный меч (левая рука)", slotEn = "Off Hand Sword",
                  srcRu = "Вождь Ренд Чернорук (UBRS)", srcEn = "Warchief Rend Blackhand (UBRS)",
                  noteRu = "Вторая половина комплекта Дал'Ренда.", noteEn = "Second half of the Dal'Rend set." },
            }
        },
        {
            id = "strat", lvl = "58–60", minLvl = 58, maxLvl = 60, faction = "Both",
            icon = "Interface\\Icons\\Spell_Shadow_RaiseDead",
            nameRu = "Стратхольм (Strat)", nameEn = "Stratholme (Strat)",
            zoneRu = "Восточные Чумные земли", zoneEn = "Eastern Plaguelands",
            descRu = "Две части: «живая» (Алый бастион) и «мёртвая» (Барон Ривендер). Шлем и плащ для пре-рейда.",
            descEn = "Two sides: Live (Scarlet bastion) and Undead (Baron Rivendare). Pre-raid helm and cloak.",
            tipRu = "«Забег на Барона» — 45 минут на таймере (квест Dead Man's Plea). С Барона падает редкий конь смерти.",
            tipEn = "\"Baron Run\" — a 45-minute timer (quest Dead Man's Plea). The Baron can drop a rare deathcharger.",
            quests = {
                { ru = "Dead Man's Plea — спасти Исиду за 45 минут", en = "Dead Man's Plea — save Ysida within 45 minutes" },
                { ru = "Houses of the Holy — святые сосуды в живой части", en = "Houses of the Holy — holy water on the live side" },
            },
            loot = {
                { id = 13404, icon = "Interface\\Icons\\INV_Helmet_09", q = 3, ru = "Маска непрощённого", en = "Mask of the Unforgiven",
                  slotRu = "Голова — кожа", slotEn = "Head — Leather",
                  srcRu = "Тимми Жестокий (живая часть)", srcEn = "Timmy the Cruel (Live side)",
                  noteRu = "Меткость и крит — пре-рейд шлем до Сердца Льва.", noteEn = "Hit and crit — pre-raid helm until Lionheart." },
                { id = 13340, icon = "Interface\\Icons\\INV_Misc_Cape_18", q = 3, ru = "Плащ Чёрного Барона", en = "Cape of the Black Baron",
                  slotRu = "Спина", slotEn = "Back",
                  srcRu = "Барон Ривендер", srcEn = "Baron Rivendare",
                  noteRu = "Ловкость и сила атаки — пре-рейд плащ.", noteEn = "Agility and attack power — pre-raid cloak." },
                { id = 13335, icon = "Interface\\Icons\\Ability_Mount_Undeadhorse", q = 4, ru = "Поводья коня смерти", en = "Deathcharger's Reins",
                  slotRu = "Верховое животное", slotEn = "Mount",
                  srcRu = "Барон Ривендер (очень редко)", srcEn = "Baron Rivendare (very rare)",
                  noteRu = "Эпический конь — повод фармить Барона.", noteEn = "Epic mount — a reason to farm the Baron." },
            }
        },
    }
}
