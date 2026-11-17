local WG = WarriorGuide_NS

----------------------------------------------------------------------
-- Иконки талантов (Classic 1.12), чтобы не дублировать пути по всему файлу
----------------------------------------------------------------------
local I = {
    -- Оружие (Arms)
    IHS       = "Interface\\Icons\\Ability_Rogue_Ambush",          -- Improved Heroic Strike
    DEFLECT   = "Interface\\Icons\\Ability_Parry",                 -- Deflection
    ICHARGE   = "Interface\\Icons\\Ability_Warrior_Charge",        -- Improved Charge
    TM        = "Interface\\Icons\\Spell_Nature_EnchantArmor",     -- Tactical Mastery
    IOP       = "Interface\\Icons\\INV_Sword_05",                  -- Improved Overpower
    AM        = "Interface\\Icons\\Spell_Holy_BlessingOfStamina",  -- Anger Management
    DW        = "Interface\\Icons\\Ability_BackStab",              -- Deep Wounds
    TWOH      = "Interface\\Icons\\INV_Axe_09",                    -- Two-Handed Weapon Specialization
    IMPALE    = "Interface\\Icons\\Ability_SearingArrow",          -- Impale
    AXE       = "Interface\\Icons\\INV_Axe_06",                    -- Axe Specialization
    SWORD     = "Interface\\Icons\\INV_Sword_27",                  -- Sword Specialization
    SS        = "Interface\\Icons\\Ability_Rogue_SliceDice",       -- Sweeping Strikes
    IHAM      = "Interface\\Icons\\Ability_ShockWave",             -- Improved Hamstring
    MS        = "Interface\\Icons\\Ability_Warrior_SavageBlow",    -- Mortal Strike
    -- Неистовство (Fury)
    CRUELTY   = "Interface\\Icons\\Ability_Rogue_Eviscerate",      -- Cruelty
    UW        = "Interface\\Icons\\Spell_Nature_StoneClawTotem",   -- Unbridled Wrath
    PHOWL     = "Interface\\Icons\\Spell_Shadow_DeathScream",      -- Piercing Howl
    BCRAZE    = "Interface\\Icons\\Spell_Shadow_SummonImp",        -- Blood Craze
    IBS       = "Interface\\Icons\\Ability_Warrior_BattleShout",   -- Improved Battle Shout
    DWS       = "Interface\\Icons\\Ability_DualWield",             -- Dual Wield Specialization
    IEXEC     = "Interface\\Icons\\INV_Sword_48",                  -- Improved Execute
    ENRAGE    = "Interface\\Icons\\Spell_Shadow_UnholyFrenzy",     -- Enrage
    DEATHWISH = "Interface\\Icons\\Spell_Shadow_DeathPact",        -- Death Wish
    FLURRY    = "Interface\\Icons\\Ability_GhoulFrenzy",           -- Flurry
    BT        = "Interface\\Icons\\Spell_Nature_BloodLust",        -- Bloodthirst
}

-- Короткий конструктор шага прокачки: уровень, иконка, название, ранг, заметка, тег, тренер
local function L(lvl, icon, ru, en, rank, noteRu, noteEn, tag, trainerRu, trainerEn)
    return {
        lvl = lvl, icon = icon, ru = ru, en = en, rank = rank,
        noteRu = noteRu, noteEn = noteEn, tag = tag,
        trainerRu = trainerRu, trainerEn = trainerEn,
    }
end

-- Конструктор таланта для билдов 60 уровня (без привязки к уровню)
local function T(tier, icon, ru, en, rank, noteRu, noteEn, tag)
    return { tier = tier, icon = icon, ru = ru, en = en, rank = rank, noteRu = noteRu, noteEn = noteEn, tag = tag }
end

local IHS_RU, IHS_EN = "Улучшенный удар героя", "Improved Heroic Strike"
local DEF_RU, DEF_EN = "Отражение", "Deflection"
local ICH_RU, ICH_EN = "Улучшенный рывок", "Improved Charge"
local TM_RU, TM_EN = "Тактическое превосходство", "Tactical Mastery"
local DW_RU, DW_EN = "Глубокие раны", "Deep Wounds"
local IOP_RU, IOP_EN = "Улучшенное превосходство", "Improved Overpower"
local TWOH_RU, TWOH_EN = "Спец. на двуручном оружии", "Two-Handed Weapon Spec."
local AXE_RU, AXE_EN = "Спец. на топорах", "Axe Specialization"
local IMP_RU, IMP_EN = "Пронзающие раны", "Impale"
local CR_RU, CR_EN = "Жестокость", "Cruelty"
local UW_RU, UW_EN = "Необузданный гнев", "Unbridled Wrath"
local IBS_RU, IBS_EN = "Улучшенный боевой крик", "Improved Battle Shout"
local EN_RU, EN_EN = "Исступление", "Enrage"

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
                ruRU = "Приоритет: Медленный 2H урон > Сила > Ловкость > Выносливость",
                enUS = "Priority: Slow 2H Weapon DPS > Strength > Agility > Stamina"
            },
            keySpells = {
                { icon = "Interface\\Icons\\Ability_Warrior_SavageBlow", ru = "Смертельный удар", en = "Mortal Strike", lvl = 40, talent = true },
                { icon = "Interface\\Icons\\Ability_Rogue_SliceDice", ru = "Размашистые удары", en = "Sweeping Strikes", lvl = 30, talent = true },
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
                ruRU = "Приоритет: 6–9% Меткости (Hit) > Крит > Сила Атаки (AP)",
                enUS = "Priority: 6–9% Hit Cap > Crit % > Attack Power"
            },
            keySpells = {
                { icon = "Interface\\Icons\\Spell_Nature_BloodLust", ru = "Кровожадность", en = "Bloodthirst", lvl = 40, talent = true },
                { icon = "Interface\\Icons\\Ability_GhoulFrenzy", ru = "Шквал", en = "Flurry", talent = true },
                { icon = "Interface\\Icons\\Spell_Shadow_DeathPact", ru = "Жажда смерти", en = "Death Wish", talent = true },
                { icon = "Interface\\Icons\\Ability_Whirlwind", ru = "Вихрь", en = "Whirlwind", lvl = 36 },
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
                ruRU = "Приоритет: Защита (440 кап) > Выносливость > Меткость > Блок",
                enUS = "Priority: Defense (440 Cap) > Stamina > Hit % > Block"
            },
            keySpells = {
                { icon = "Interface\\Icons\\INV_Shield_05", ru = "Мощный удар щитом", en = "Shield Slam", talent = true },
                { icon = "Interface\\Icons\\Ability_Warrior_Revenge", ru = "Реванш", en = "Revenge", lvl = 14 },
                { icon = "Interface\\Icons\\Ability_Warrior_Sunder", ru = "Раскол брони", en = "Sunder Armor", lvl = 10 },
                { icon = "Interface\\Icons\\Ability_Warrior_ShieldWall", ru = "Глухая оборона", en = "Shield Wall", lvl = 28 },
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
            id = "leveling",
            mode = "levels",
            icon = "Interface\\Icons\\INV_Axe_09",
            titleKey = "BUILD_LVL_TITLE",
            subKey = "BUILD_LVL_SUB",
            totals = { arms = 31, fury = 20, prot = 0 },
            sections = {
                {
                    titleKey = "LVL_SECTION_1",
                    steps = {
                        L(10, I.IHS, IHS_RU, IHS_EN, "1/3",
                            "Удар героя дешевле на 1 ярость — главный «сброс» ярости до 40 уровня.",
                            "Heroic Strike costs 1 less rage — your main rage dump until 40.", "key",
                            "Кровавая ярость, Раскол брони, Провокация; квест на Оборонительную стойку",
                            "Bloodrage, Sunder Armor, Taunt; Defensive Stance quest"),
                        L(11, I.IHS, IHS_RU, IHS_EN, "2/3", "−2 ярости к Удару героя.", "−2 rage on Heroic Strike."),
                        L(12, I.IHS, IHS_RU, IHS_EN, "3/3", "Талант закрыт: Удар героя стоит 12 ярости.", "Maxed: Heroic Strike now costs 12 rage.", nil,
                            "Превосходство, Удар щитом", "Overpower, Shield Bash"),
                        L(13, I.DEFLECT, DEF_RU, DEF_EN, "1/5",
                            "Нужно только чтобы набрать 5 очков в 1-м ряду и открыть 2-й ряд.",
                            "Only here to reach 5 points in tier 1 and unlock tier 2.", "filler"),
                        L(14, I.DEFLECT, DEF_RU, DEF_EN, "2/5",
                            "Остаётся 2/5 до конца билда — дальше сюда не возвращаемся.",
                            "Stays at 2/5 for the rest of the build.", "filler",
                            "Деморализующий крик, Реванш", "Demoralizing Shout, Revenge"),
                        L(15, I.ICHARGE, ICH_RU, ICH_EN, "1/2", "+3 ярости от Рывка: можно сразу бить Рассекающим/Ударом героя.", "+3 rage from Charge for an instant opener."),
                        L(16, I.ICHARGE, ICH_RU, ICH_EN, "2/2", "+6 ярости от Рывка. Талант закрыт.", "+6 rage from Charge. Maxed.", nil,
                            "Дразнящий удар, Блок щитом", "Mocking Blow, Shield Block"),
                        L(17, I.TM, TM_RU, TM_EN, "1/5", "Сохраняет 5 ярости при смене стойки.", "Keep 5 rage when switching stances."),
                        L(18, I.TM, TM_RU, TM_EN, "2/5", "Сохраняет 10 ярости: Превосходство после уклонения уже почти бесплатное.", "Keep 10 rage — Overpower after a dodge is now nearly free.", nil,
                            "Разоружение", "Disarm"),
                        L(19, I.TM, TM_RU, TM_EN, "3/5",
                            "Ставим на паузу: 10 очков в ветке открывают 3-й ряд. Ранги 4–5 вернём на 38–39.",
                            "Paused: 10 points unlock tier 3. Ranks 4–5 come back at 38–39.", "pause"),
                    }
                },
                {
                    titleKey = "LVL_SECTION_2",
                    steps = {
                        L(20, I.AM, "Управление злостью", "Anger Management", "1/1",
                            "+1 ярость каждые 3 сек в бою. Меньше простоев между мобами.",
                            "+1 rage every 3 sec in combat. Less downtime between pulls.", "key",
                            "Рассекающий удар, Возмездие", "Cleave, Retaliation"),
                        L(21, I.DW, DW_RU, DW_EN, "1/3", "Критические удары вешают кровотечение.", "Crits apply a bleed."),
                        L(22, I.DW, DW_RU, DW_EN, "2/3", "Кровотечение сильнее.", "Stronger bleed.", nil,
                            "Устрашающий крик", "Intimidating Shout"),
                        L(23, I.DW, DW_RU, DW_EN, "3/3", "Закрыт. Нужен для Пронзающих ран (36–37).", "Maxed. Required for Impale (36–37).", "key"),
                        L(24, I.IOP, IOP_RU, IOP_EN, "1/2", "+25% шанса крита Превосходства.", "+25% Overpower crit chance.", nil,
                            "Казнь", "Execute"),
                        L(25, I.IOP, IOP_RU, IOP_EN, "2/2", "+50% крита Превосходства — почти гарантированный крит.", "+50% Overpower crit — near-guaranteed crit."),
                        L(26, I.TWOH, TWOH_RU, TWOH_EN, "1/5", "+1% урона двуручным оружием.", "+1% two-handed weapon damage.", nil,
                            "Вызывающий крик", "Challenging Shout"),
                        L(27, I.TWOH, TWOH_RU, TWOH_EN, "2/5", "+2% урона двуручником.", "+2% two-handed damage."),
                        L(28, I.TWOH, TWOH_RU, TWOH_EN, "3/5", "+3% урона двуручником.", "+3% two-handed damage.", nil,
                            "Глухая оборона", "Shield Wall"),
                        L(29, I.TWOH, TWOH_RU, TWOH_EN, "4/5",
                            "Оставляем 4/5: 20 очков в ветке → на 30 открываются Размашистые удары.",
                            "Left at 4/5: 20 points in the tree unlock Sweeping Strikes at 30.", "pause"),
                    }
                },
                {
                    titleKey = "LVL_SECTION_3",
                    steps = {
                        L(30, I.SS, "Размашистые удары", "Sweeping Strikes", "1/1",
                            "Следующие 5 атак бьют вторую цель. Тяните мобов по двое.",
                            "Next 5 attacks hit a second target. Pull mobs in pairs.", "key",
                            "Стойка берсерка (квест), Перехват, Мощный удар", "Berserker Stance (quest), Intercept, Slam"),
                        L(31, I.AXE, AXE_RU, AXE_EN, "1/5",
                            "Под топор (Трупный срубщик, Топор Вихря). С мечом — Спец. на мечах, с булавой — на булавах.",
                            "For axes (Corpsemaker, Whirlwind Axe). Using a sword/mace? Take that spec instead."),
                        L(32, I.AXE, AXE_RU, AXE_EN, "2/5", "+2% крита топором.", "+2% crit with axes.", nil,
                            "Ярость берсерка", "Berserker Rage"),
                        L(33, I.AXE, AXE_RU, AXE_EN, "3/5", "+3% крита топором.", "+3% crit with axes."),
                        L(34, I.AXE, AXE_RU, AXE_EN, "4/5", "+4% крита топором.", "+4% crit with axes."),
                        L(35, I.AXE, AXE_RU, AXE_EN, "5/5", "+5% крита. Больше критов → больше ярости и Глубоких ран.", "+5% crit. More crits → more rage and Deep Wounds.", "key"),
                        L(36, I.IMPALE, IMP_RU, IMP_EN, "1/2", "+10% к урону критов способностей.", "+10% ability crit damage.", nil,
                            "Вихрь (Стойка берсерка)", "Whirlwind (Berserker Stance)"),
                        L(37, I.IMPALE, IMP_RU, IMP_EN, "2/2", "+20% к урону критов: Смертельный удар и Вихрь бьют заметно больнее.", "+20% crit damage: Mortal Strike and Whirlwind hit much harder.", "key"),
                        L(38, I.TM, TM_RU, TM_EN, "4/5",
                            "Возвращаемся к пропущенному на 19 ур. таланту: 20 ярости при смене стойки.",
                            "Back to the talent paused at 19: keep 20 rage on stance swap.", "return",
                            "Зуботычина", "Pummel"),
                        L(39, I.TM, TM_RU, TM_EN, "5/5",
                            "Возврат закрыт: 25 ярости. Свободные Вихрь/Превосходство/Перехват в одном бою. 30 очков → Смертельный удар.",
                            "Return complete: keep 25 rage. 30 points spent → Mortal Strike next.", "return"),
                        L(40, I.MS, "Смертельный удар", "Mortal Strike", "1/1",
                            "Главная атака до конца прокачки. Ротация: Смертельный удар > Вихрь > Удар героя.",
                            "Main attack for the rest of leveling. Rotation: Mortal Strike > Whirlwind > Heroic Strike.", "key",
                            "Латные доспехи!", "Plate Mail!"),
                    }
                },
                {
                    titleKey = "LVL_SECTION_4",
                    steps = {
                        L(41, I.CRUELTY, CR_RU, CR_EN, "1/5", "+1% крита. Переходим во вторую ветку.", "+1% crit. Moving to the second tree."),
                        L(42, I.CRUELTY, CR_RU, CR_EN, "2/5", "+2% крита.", "+2% crit."),
                        L(43, I.CRUELTY, CR_RU, CR_EN, "3/5", "+3% крита.", "+3% crit."),
                        L(44, I.CRUELTY, CR_RU, CR_EN, "4/5", "+4% крита.", "+4% crit."),
                        L(45, I.CRUELTY, CR_RU, CR_EN, "5/5", "+5% крита — лучший талант в Неистовстве для любого билда.", "+5% crit — best Fury talent for any build.", "key"),
                        L(46, I.UW, UW_RU, UW_EN, "1/5", "Шанс получить 1 ярость при ударе.", "Chance to gain 1 rage on melee hit."),
                        L(47, I.UW, UW_RU, UW_EN, "2/5", "Больше ярости с автоатак.", "More rage from auto attacks."),
                        L(48, I.UW, UW_RU, UW_EN, "3/5", "Больше ярости с автоатак.", "More rage from auto attacks."),
                        L(49, I.UW, UW_RU, UW_EN, "4/5", "Больше ярости с автоатак.", "More rage from auto attacks."),
                        L(50, I.UW, UW_RU, UW_EN, "5/5", "Закрыт. 10 очков в Неистовстве → открыт 3-й ряд.", "Maxed. 10 Fury points unlock tier 3.", nil,
                            "Безрассудство", "Recklessness"),
                        L(51, I.IBS, IBS_RU, IBS_EN, "1/5", "+5% к силе атаки от Боевого крика (и для группы).", "+5% Battle Shout attack power (whole party)."),
                        L(52, I.IBS, IBS_RU, IBS_EN, "2/5", "+10% к Боевому крику.", "+10% Battle Shout."),
                        L(53, I.IBS, IBS_RU, IBS_EN, "3/5", "+15% к Боевому крику.", "+15% Battle Shout."),
                        L(54, I.IBS, IBS_RU, IBS_EN, "4/5", "+20% к Боевому крику.", "+20% Battle Shout."),
                        L(55, I.IBS, IBS_RU, IBS_EN, "5/5", "Закрыт. 15 очков → открыт 4-й ряд (Исступление).", "Maxed. 15 points unlock tier 4 (Enrage)."),
                        L(56, I.ENRAGE, EN_RU, EN_EN, "1/5", "После получения крита: +5% урона на 12 сек.", "After being crit: +5% damage for 12 sec."),
                        L(57, I.ENRAGE, EN_RU, EN_EN, "2/5", "+10% урона после получения крита.", "+10% damage after being crit."),
                        L(58, I.ENRAGE, EN_RU, EN_EN, "3/5", "+15% урона после получения крита.", "+15% damage after being crit."),
                        L(59, I.ENRAGE, EN_RU, EN_EN, "4/5", "+20% урона после получения крита.", "+20% damage after being crit."),
                        L(60, I.ENRAGE, EN_RU, EN_EN, "5/5",
                            "+25% урона. Билд готов: Arms 31 / Fury 20. Дальше — сброс под рейд или PvP.",
                            "+25% damage. Build complete: Arms 31 / Fury 20. Next — respec for raid or PvP.", "key"),
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
            totals = { arms = 17, fury = 34, prot = 0 },
            trees = {
                {
                    treeKey = "TREE_ARMS", points = 17,
                    talents = {
                        T(1, I.IHS, IHS_RU, IHS_EN, "3/3", "Дешевый Удар героя — сброс лишней ярости под баффами.", "Cheaper Heroic Strike — rage dump under world buffs.", "key"),
                        T(1, I.DEFLECT, DEF_RU, DEF_EN, "3/5", "Только для открытия рядов.", "Only to unlock the next tiers.", "filler"),
                        T(2, I.TM, TM_RU, TM_EN, "5/5", "Смена стоек без потери ярости (Стойка берсерка ↔ Боевая).", "Stance dance without losing rage (Berserker ↔ Battle).", "key"),
                        T(3, I.AM, "Управление злостью", "Anger Management", "1/1", "Пассивная ярость на долгих боях.", "Passive rage on long fights."),
                        T(3, I.DW, DW_RU, DW_EN, "3/3", "Кровотечение с критов + доступ к Пронзающим ранам.", "Bleed on crits + unlocks Impale."),
                        T(4, I.IMPALE, IMP_RU, IMP_EN, "2/2", "+20% урона критов способностей — обязательно.", "+20% ability crit damage — mandatory.", "key"),
                    }
                },
                {
                    treeKey = "TREE_FURY", points = 34,
                    talents = {
                        T(1, I.CRUELTY, CR_RU, CR_EN, "5/5", "+5% крита.", "+5% crit.", "key"),
                        T(2, I.UW, UW_RU, UW_EN, "5/5", "Ярость с автоатак (особенно с быстрой левой рукой).", "Rage from auto attacks (great with a fast off-hand)."),
                        T(3, I.IBS, IBS_RU, IBS_EN, "5/5", "+25% к Боевому крику для всей группы.", "+25% Battle Shout for the whole party."),
                        T(4, I.DWS, "Спец. на бое двумя оружиями", "Dual Wield Specialization", "5/5", "+25% урона левой рукой.", "+25% off-hand damage.", "key"),
                        T(4, I.IEXEC, "Улучшенная казнь", "Improved Execute", "2/2", "Казнь дешевле на 5 ярости — фаза добивания босса.", "Execute costs 5 less rage — boss execute phase."),
                        T(4, I.ENRAGE, EN_RU, EN_EN, "5/5", "Нужно для Шквала.", "Required for Flurry."),
                        T(5, I.DEATHWISH, "Жажда смерти", "Death Wish", "1/1", "+20% урона на 30 сек. Жмите вместе с тринкетами.", "+20% damage for 30 sec. Pop with trinkets.", "key"),
                        T(6, I.FLURRY, "Шквал", "Flurry", "5/5", "+30% скорости атаки на 3 удара после крита.", "+30% attack speed for 3 swings after a crit.", "key"),
                        T(7, I.BT, "Кровожадность", "Bloodthirst", "1/1", "Главный удар: урон = 45% силы атаки. Приоритет: КЖ > Вихрь > Удар героя.", "Main nuke: damage = 45% AP. Priority: BT > WW > HS.", "key"),
                    }
                },
            },
        },
        {
            id = "pvp",
            mode = "trees",
            icon = "Interface\\Icons\\Ability_Warrior_Charge",
            titleKey = "BUILD_PVP_TITLE",
            subKey = "BUILD_PVP_SUB",
            totals = { arms = 31, fury = 20, prot = 0 },
            trees = {
                {
                    treeKey = "TREE_ARMS", points = 31,
                    talents = {
                        T(1, I.IHS, IHS_RU, IHS_EN, "3/3", "Дешевый Удар героя.", "Cheaper Heroic Strike."),
                        T(1, I.DEFLECT, DEF_RU, DEF_EN, "3/5", "Открытие рядов + немного парирования.", "Unlocks tiers + a bit of parry.", "filler"),
                        T(2, I.ICHARGE, ICH_RU, ICH_EN, "2/2", "Быстрый старт: ярость сразу на Подрезание/Смертельный удар.", "Fast opener: rage for Hamstring/Mortal Strike."),
                        T(2, I.TM, TM_RU, TM_EN, "5/5", "Рывок → Перехват → Зуботычина без потери ярости.", "Charge → Intercept → Pummel without losing rage.", "key"),
                        T(3, I.AM, "Управление злостью", "Anger Management", "1/1", "Ярость, даже если по вам не бьют.", "Rage even when nobody hits you."),
                        T(3, I.DW, DW_RU, DW_EN, "3/3", "Кровотечение + доступ к Пронзающим ранам.", "Bleed + unlocks Impale."),
                        T(3, I.IOP, IOP_RU, IOP_EN, "2/2", "Наказывает разбойников и котов за уклонения.", "Punishes rogues and cats for dodging."),
                        T(4, I.IMPALE, IMP_RU, IMP_EN, "2/2", "Взрывной урон критами.", "Burst crit damage.", "key"),
                        T(5, I.SS, "Размашистые удары", "Sweeping Strikes", "1/1", "Урон по двум целям у флага.", "Two-target damage on flags."),
                        T(5, I.SWORD, "Спец. на мечах / булавах", "Sword / Mace Specialization", "5/5", "Под ваше оружие: мечи — доп. атаки, булавы — оглушение.", "Match your weapon: swords — extra attacks, maces — stun."),
                        T(6, I.IHAM, "Улучшенное подрезание", "Improved Hamstring", "3/3", "15% шанс обездвижить цель на 5 сек.", "15% chance to root the target for 5 sec.", "key"),
                        T(7, I.MS, "Смертельный удар", "Mortal Strike", "1/1", "−50% исцеления по цели на 10 сек.", "−50% healing on target for 10 sec.", "key"),
                    }
                },
                {
                    treeKey = "TREE_FURY", points = 20,
                    talents = {
                        T(1, I.CRUELTY, CR_RU, CR_EN, "5/5", "+5% крита.", "+5% crit.", "key"),
                        T(2, I.UW, UW_RU, UW_EN, "5/5", "Ярость с автоатак.", "Rage from auto attacks."),
                        T(3, I.PHOWL, "Пронзительный вой", "Piercing Howl", "1/1", "Массовое замедление на 50% вокруг воина.", "AoE 50% snare around you.", "key"),
                        T(3, I.BCRAZE, "Кровавое бешенство", "Blood Craze", "3/3", "Регенерация здоровья после получения крита.", "Health regen after being crit."),
                        T(3, I.IBS, IBS_RU, IBS_EN, "1/5", "Одно очко, чтобы открыть 4-й ряд.", "One point to unlock tier 4.", "filler"),
                        T(4, I.IEXEC, "Улучшенная казнь", "Improved Execute", "2/2", "Дешевая Казнь для добивания.", "Cheap Execute for finishing.", "key"),
                        T(4, I.ENRAGE, EN_RU, EN_EN, "3/5", "Урон после получения крита.", "Damage after being crit."),
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
                    "Ищите у торговцев любой двуручник: с 1 до 60 он важнее любых статов.",
                    "Профессии: Горное дело + Кузнечное дело (или Инженерия — бомбы и сетки).",
                },
                tipsEn = {
                    "At level 10 take the Defensive Stance class quest from your trainer — you need it for tanking and Shield Bash.",
                    "Buy any two-hander from vendors: from 1 to 60 weapon damage beats any stat.",
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
                    "На 20 ур. появляется Рассекающий удар — сильный сброс ярости на 2+ мобов.",
                },
                tipsEn = {
                    "The Barrens is the densest Horde quest zone. Grab every quest in Crossroads and Ratchet.",
                    "Keep dungeon quests: Ragefire Chasm (13+) and Wailing Caverns (17+).",
                    "Cleave arrives at 20 — a strong rage dump on 2+ mobs.",
                },
                trainerRu = "Деморализующий крик, Реванш (14), Дразнящий удар (16), Разоружение (18), Рассекающий удар, Возмездие (20), Устрашающий крик (22)",
                trainerEn = "Demoralizing Shout, Revenge (14), Mocking Blow (16), Disarm (18), Cleave, Retaliation (20), Intimidating Shout (22)",
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
                trainerRu = "Казнь (24), Вызывающий крик (26), Глухая оборона (28), Перехват и Мощный удар (30)",
                trainerEn = "Execute (24), Challenging Shout (26), Shield Wall (28), Intercept & Slam (30)",
                dungeonsRu = "Лабиринты Иглошкурых, Монастырь (Кладбище)", dungeonsEn = "Razorfen Kraul, SM Graveyard",
            },
            {
                lvl = "30–40", minLvl = 30, maxLvl = 40,
                zoneRu = "Тысяча Игл / Пустоши / Нагорье Арати / Тернистая долина / Пылевые топи", zoneEn = "Thousand Needles / Desolace / Arathi / Stranglethorn Vale / Dustwallow Marsh",
                tipsRu = {
                    "На 30 ур. возьмите у тренера квест на Стойку берсерка — затем цепочку на оружие Вихря (Топор Вихря держится до 45+).",
                    "Монастырь Алого Ордена: Оружейная ради Опустошителя и сета Ирода.",
                    "На 40 ур. учите Латные доспехи у тренера и сразу меняйте кольчугу на латы.",
                },
                tipsEn = {
                    "At 30 take the Berserker Stance quest, then the Whirlwind weapon chain (Whirlwind Axe lasts until 45+).",
                    "Scarlet Monastery: Armory for Ravager and Herod's gear.",
                    "At 40 learn Plate Mail at your trainer and swap mail for plate.",
                },
                trainerRu = "Ярость берсерка (32), Вихрь (36), Зуботычина (38), Латные доспехи (40)",
                trainerEn = "Berserker Rage (32), Whirlwind (36), Pummel (38), Plate Mail (40)",
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
                    "На 60: пре-рейд сет (BRD, UBRS, Страт) и сброс талантов на Рейд ДПС.",
                },
                tipsEn = {
                    "At 50 the Fallen Hero of the Horde (Swamp of Sorrows) starts the warrior Sunken Temple chain → Diamond Flask.",
                    "Blackrock Depths — best XP and gear for 52–60.",
                    "At 60: pre-raid gear (BRD, UBRS, Strat) and respec to Raid DPS.",
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
                    "Ищите у торговцев любой двуручник: с 1 до 60 он важнее любых статов.",
                    "Профессии: Горное дело + Кузнечное дело (или Инженерия — бомбы и сетки).",
                },
                tipsEn = {
                    "At level 10 complete the class quest for Defensive Stance.",
                    "Buy any two-hander from vendors: from 1 to 60 weapon damage beats any stat.",
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
                    "На 20 ур. появляется Рассекающий удар — сильный сброс ярости на 2+ мобов.",
                },
                tipsEn = {
                    "The Defias Brotherhood chain in Westfall leads to the Deadmines — rewards Chausses of Westfall.",
                    "Deadmines (17–26): Smite's Mighty Hammer is a great two-hander at 20.",
                    "Cleave arrives at 20 — a strong rage dump on 2+ mobs.",
                },
                trainerRu = "Деморализующий крик, Реванш (14), Дразнящий удар (16), Разоружение (18), Рассекающий удар, Возмездие (20), Устрашающий крик (22)",
                trainerEn = "Demoralizing Shout, Revenge (14), Mocking Blow (16), Disarm (18), Cleave, Retaliation (20), Intimidating Shout (22)",
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
                trainerRu = "Казнь (24), Вызывающий крик (26), Глухая оборона (28), Перехват и Мощный удар (30)",
                trainerEn = "Execute (24), Challenging Shout (26), Shield Wall (28), Intercept & Slam (30)",
                dungeonsRu = "Лабиринты Иглошкурых", dungeonsEn = "Razorfen Kraul",
            },
            {
                lvl = "30–40", minLvl = 30, maxLvl = 40,
                zoneRu = "Тернистая долина / Нагорье Арати / Южнобережье / Пустоши / Пылевые топи", zoneEn = "Stranglethorn Vale / Arathi / Southshore / Desolace / Dustwallow Marsh",
                tipsRu = {
                    "На 30 ур. возьмите у тренера квест на Стойку берсерка, затем цепочку на оружие Вихря.",
                    "Монастырь Алого Ордена: Оружейная ради Опустошителя и сета Ирода.",
                    "На 40 ур. учите Латные доспехи и меняйте кольчугу на латы.",
                },
                tipsEn = {
                    "At 30 take the Berserker Stance quest, then the Whirlwind weapon chain.",
                    "Scarlet Monastery: Armory for Ravager and Herod's gear.",
                    "At 40 learn Plate Mail and swap mail for plate.",
                },
                trainerRu = "Ярость берсерка (32), Вихрь (36), Зуботычина (38), Латные доспехи (40)",
                trainerEn = "Berserker Rage (32), Whirlwind (36), Pummel (38), Plate Mail (40)",
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
                    "На 60: пре-рейд сет (BRD, UBRS, Страт) и сброс талантов на Рейд ДПС.",
                },
                tipsEn = {
                    "Sunken Temple class chain (Fallen Hero of the Horde, Swamp of Sorrows) → Diamond Flask trinket.",
                    "Blackrock Depths — best XP and gear for 52–60.",
                    "At 60: pre-raid gear (BRD, UBRS, Strat) and respec to Raid DPS.",
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
