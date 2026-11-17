local WG = WarriorGuide_NS

WG.Data = {
    -- Вкладка 1: Карточки специализаций
    Specs = {
        {
            id = "arms",
            icon = "Interface\\Icons\\Ability_Warrior_SavageBlow",
            banner = "Interface\\TalentFrame\\WarriorArms-TopLeft",
            nameKey = "SPEC_ARMS_NAME",
            roleKey = "SPEC_ARMS_ROLE",
            descKey = "SPEC_ARMS_DESC",
            stats = {
                ruRU = "Приоритет: Медленный 2H урон > Сила > Ловкость > Выносливость",
                enUS = "Priority: Slow 2H Weapon DPS > Strength > Agility > Stamina"
            },
            keySpells = {
                { icon = "Interface\\Icons\\Ability_Warrior_SavageBlow", ru = "Смертельный удар", en = "Mortal Strike" },
                { icon = "Interface\\Icons\\Ability_Rogue_SliceDice", ru = "Размашистые удары", en = "Sweeping Strikes" },
                { icon = "Interface\\Icons\\Ability_MeleeDamage", ru = "Превосходство", en = "Overpower" },
            }
        },
        {
            id = "fury",
            icon = "Interface\\Icons\\Ability_Warrior_InnerRage",
            banner = "Interface\\TalentFrame\\WarriorFury-TopLeft",
            nameKey = "SPEC_FURY_NAME",
            roleKey = "SPEC_FURY_ROLE",
            descKey = "SPEC_FURY_DESC",
            stats = {
                ruRU = "Приоритет: 6–9% Меткости (Hit) > Крит > Сила Атаки (AP)",
                enUS = "Priority: 6–9% Hit Cap > Crit % > Attack Power"
            },
            keySpells = {
                { icon = "Interface\\Icons\\Spell_Nature_BloodLust", ru = "Кровожадность", en = "Bloodthirst" },
                { icon = "Interface\\Icons\\Ability_GhoulFrenzy", ru = "Шквал", en = "Flurry" },
                { icon = "Interface\\Icons\\Spell_Shadow_DeathPact", ru = "Инстинкт смерти", en = "Death Wish" },
            }
        },
        {
            id = "prot",
            icon = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
            banner = "Interface\\TalentFrame\\WarriorProtection-TopLeft",
            nameKey = "SPEC_PROT_NAME",
            roleKey = "SPEC_PROT_ROLE",
            descKey = "SPEC_PROT_DESC",
            stats = {
                ruRU = "Приоритет: Защита (440 кап) > Выносливость > Меткость > Блок",
                enUS = "Priority: Defense (440 Cap) > Stamina > Hit % > Block"
            },
            keySpells = {
                { icon = "Interface\\Icons\\INV_Shield_05", ru = "Мощный удар щитом", en = "Shield Slam" },
                { icon = "Interface\\Icons\\Ability_Warrior_Revenge", ru = "Реванш", en = "Revenge" },
                { icon = "Interface\\Icons\\Ability_Warrior_ShieldWall", ru = "Глухая оборона", en = "Shield Wall" },
            }
        }
    },

    -- Вкладка 2: Билды с визуальной сеткой талантов
    Builds = {
        {
            id = "leveling",
            icon = "Interface\\Icons\\INV_Axe_09",
            titleKey = "BUILD_LVL_TITLE",
            subKey = "BUILD_LVL_SUB",
            steps = {
                {
                    tierKey = "TIER_10_19",
                    talents = {
                        { lvl = "10–12", pts = "3/3", icon = "Interface\\Icons\\Ability_Rogue_Ambush", ru = "Улучшенный удар героя", en = "Improved Heroic Strike", noteRu = "Снижает стоимость ярости", noteEn = "Reduces rage cost" },
                        { lvl = "13–14", pts = "2/2", icon = "Interface\\Icons\\Ability_Warrior_Charge", ru = "Улучшенный рывок", en = "Improved Charge", noteRu = "+6 ярости на старте боя", noteEn = "+6 rage on pull" },
                        { lvl = "15–19", pts = "5/5", icon = "Interface\\Icons\\Spell_Nature_EnchantArmor", ru = "Тактическое превосходство", en = "Tactical Mastery", noteRu = "Сохраняет до 25 ярости при смене стоек", noteEn = "Retains up to 25 rage on stance swap" },
                    }
                },
                {
                    tierKey = "TIER_20_29",
                    talents = {
                        { lvl = "20", pts = "1/1", icon = "Interface\\Icons\\Spell_Holy_BlessingOfStamina", ru = "Управление злостью", en = "Anger Management", noteRu = "+1 ярость каждые 3 сек в бою", noteEn = "+1 rage every 3s in combat" },
                        { lvl = "21–22", pts = "2/2", icon = "Interface\\Icons\\INV_Sword_05", ru = "Улучшенное превосходство", en = "Improved Overpower", noteRu = "+50% крита для Превосходства", noteEn = "+50% Overpower crit chance" },
                        { lvl = "23–25", pts = "3/3", icon = "Interface\\Icons\\Ability_BackStab", ru = "Глубокие раны", en = "Deep Wounds", noteRu = "Кровотечение после критов", noteEn = "Bleed damage on crits" },
                        { lvl = "26–29", pts = "4/5", icon = "Interface\\Icons\\INV_Axe_09", ru = "Спец. на двуручном оружии", en = "Two-Handed Weapon Spec", noteRu = "+4% урона двуручкой", noteEn = "+4% 2H damage" },
                    }
                },
                {
                    tierKey = "TIER_30_40",
                    talents = {
                        { lvl = "30", pts = "1/1", icon = "Interface\\Icons\\Ability_Rogue_SliceDice", ru = "Размашистые удары", en = "Sweeping Strikes", noteRu = "Ключевой талант для боя с 2 мобами", noteEn = "Core 2-target cleave cooldown" },
                        { lvl = "31–35", pts = "5/5", icon = "Interface\\Icons\\INV_Axe_06", ru = "Спец. на топорах / мечах", en = "Axe / Sword Specialization", noteRu = "+5% крита (под Вихрь / Корпсемейкер)", noteEn = "+5% crit (Whirlwind Axe / Corpsemaker)" },
                        { lvl = "36–39", pts = "2/2", icon = "Interface\\Icons\\Ability_SearingArrow", ru = "Пронзающие раны + добивка", en = "Impale + 2H Spec (5/5)", noteRu = "+20% крит. урона способностей", noteEn = "+20% ability crit damage" },
                        { lvl = "40", pts = "1/1", icon = "Interface\\Icons\\Ability_Warrior_SavageBlow", ru = "Смертельный удар", en = "Mortal Strike", noteRu = "Главная атака до 60 уровня", noteEn = "Primary strike until level 60" },
                    }
                },
                {
                    tierKey = "TIER_41_60",
                    talents = {
                        { lvl = "41–45", pts = "5/5", icon = "Interface\\Icons\\Ability_Rogue_Eviscerate", ru = "Жестокость", en = "Cruelty", noteRu = "+5% шанса крита", noteEn = "+5% critical strike chance" },
                        { lvl = "46–50", pts = "5/5", icon = "Interface\\Icons\\Spell_Nature_Purge", ru = "Необузданный гнев", en = "Unbridled Wrath", noteRu = "Доп. ярость с автоатак", noteEn = "Extra rage on melee hits" },
                        { lvl = "51–55", pts = "5/5", icon = "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", ru = "Исступление", en = "Enrage", noteRu = "+25% урона после получения крита", noteEn = "+25% damage after being crit" },
                    }
                }
            }
        },
        {
            id = "raid",
            icon = "Interface\\Icons\\Spell_Nature_BloodLust",
            titleKey = "BUILD_RAID_TITLE",
            subKey = "BUILD_RAID_SUB",
            steps = {
                {
                    tierKey = "TIER_10_19",
                    talents = {
                        { lvl = "Arms", pts = "3/3", icon = "Interface\\Icons\\Ability_Rogue_Ambush", ru = "Улучшенный удар героя", en = "Improved Heroic Strike", noteRu = "Сброс лишней ярости под World Buffs", noteEn = "Rage dump with World Buffs" },
                        { lvl = "Arms", pts = "5/5", icon = "Interface\\Icons\\Spell_Nature_EnchantArmor", ru = "Тактическое превосходство", en = "Tactical Mastery", noteRu = "Переключение в стойку берсерка", noteEn = "Smooth Berserker Stance swaps" },
                        { lvl = "Arms", pts = "2/2", icon = "Interface\\Icons\\Ability_SearingArrow", ru = "Пронзающие раны", en = "Impale", noteRu = "Обязательный множитель крита", noteEn = "Mandatory crit damage multiplier" },
                    }
                },
                {
                    tierKey = "TIER_41_60",
                    talents = {
                        { lvl = "Fury", pts = "5/5", icon = "Interface\\Icons\\Ability_Rogue_Eviscerate", ru = "Жестокость", en = "Cruelty", noteRu = "+5% крита", noteEn = "+5% crit chance" },
                        { lvl = "Fury", pts = "5/5", icon = "Interface\\Icons\\Ability_DualWield", ru = "Спец. на бое двумя оружиями", en = "Dual Wield Specialization", noteRu = "+25% урона левой рукой", noteEn = "+25% off-hand damage" },
                        { lvl = "Fury", pts = "5/5", icon = "Interface\\Icons\\Ability_GhoulFrenzy", ru = "Шквал", en = "Flurry", noteRu = "+30% скорости атаки после крита", noteEn = "+30% attack speed after crits" },
                        { lvl = "Fury", pts = "1/1", icon = "Interface\\Icons\\Spell_Nature_BloodLust", ru = "Кровожадность", en = "Bloodthirst", noteRu = "Главный скилл, скейлится от AP", noteEn = "Main nuke scaling with Attack Power" },
                    }
                }
            }
        },
        {
            id = "pvp",
            icon = "Interface\\Icons\\Ability_Warrior_Charge",
            titleKey = "BUILD_PVP_TITLE",
            subKey = "BUILD_PVP_SUB",
            steps = {
                {
                    tierKey = "TIER_10_19",
                    talents = {
                        { lvl = "Arms", pts = "2/2", icon = "Interface\\Icons\\Ability_Warrior_Charge", ru = "Улучшенный рывок", en = "Improved Charge", noteRu = "Быстрый старт боя", noteEn = "Fast opener rage" },
                        { lvl = "Arms", pts = "5/5", icon = "Interface\\Icons\\Spell_Nature_EnchantArmor", ru = "Тактическое превосходство", en = "Tactical Mastery", noteRu = "Перехват и Подрезать сухожилия", noteEn = "Intercept & Hamstring swaps" },
                        { lvl = "Arms", pts = "3/3", icon = "Interface\\Icons\\Ability_ShockWave", ru = "Улучшенное подрезание", en = "Improved Hamstring", noteRu = "Шанс обездвижить цель на 5 сек", noteEn = "Chance to immobilize target for 5s" },
                    }
                },
                {
                    tierKey = "TIER_30_40",
                    talents = {
                        { lvl = "Arms", pts = "1/1", icon = "Interface\\Icons\\Ability_Warrior_SavageBlow", ru = "Смертельный удар", en = "Mortal Strike", noteRu = "-50% входящего исцеления по цели", noteEn = "-50% healing received debuff" },
                        { lvl = "Fury", pts = "5/5", icon = "Interface\\Icons\\Ability_BullRush", ru = "Пронзительный вой", en = "Piercing Howl", noteRu = "Массовое замедление вокруг воина", noteEn = "AoE snare around the warrior" },
                    }
                }
            }
        }
    },

    -- Вкладка 3: Роут прокачки по фракциям
    Routes = {
        Horde = {
            { lvl = "1–12", zoneRu = "Дуротар / Мулгор / Тирисфаль", zoneEn = "Durotar / Mulgore / Tirisfal", tipRu = "Сделайте классовый квест на 10 ур. для получения Оборонительной стойки.", tipEn = "Complete your level 10 class quest to unlock Defensive Stance." },
            { lvl = "12–22", zoneRu = "Степи (The Barrens)", zoneEn = "The Barrens", tipRu = "Идеальная зона без перебежек. Сходите в Огненную Пропасть (14+) и Пещеры Стенаний (18+).", tipEn = "Best quest hub density. Run Ragefire Chasm (14+) and Wailing Caverns (18+)." },
            { lvl = "22–30", zoneRu = "Когтистые горы / Предгорья Хилсбрада", zoneEn = "Stonetalon / Hillsbrad Foothills", tipRu = "На 29 уровне обязательно сходите в РФК за топором Трупный срубщик (Corpsemaker).", tipEn = "At level 29 run RFK for Corpsemaker two-handed axe." },
            { lvl = "30–40", zoneRu = "Тысяча Игл / Тернистая долина / Арати", zoneEn = "Thousand Needles / STV / Arathi", tipRu = "На 30 ур. сделайте классовый квест на Топор Вихря (Whirlwind Axe) — имба до 45+ ур.", tipEn = "At level 30 complete the Warrior quest for Whirlwind Axe — carries until 45+." },
            { lvl = "40–50", zoneRu = "Танарис / Фералас / Внутренние земли", zoneEn = "Tanaris / Feralas / Hinterlands", tipRu = "Зул'Фаррак (44–50) и Марадон (46–52) ради Кольца Блэкстоуна (+1% Hit).", tipEn = "Zul'Farrak (44–50) and Maraudon (46–52) for Blackstone Ring (+1% Hit)." },
            { lvl = "50–60", zoneRu = "Ун'Горо / Чумные земли / Зимние Ключи", zoneEn = "Un'Goro / Plaguelands / Winterspring", tipRu = "На 50 ур. возьмите классовый квест в Затонувшем Храме на Алмазную колбу (Diamond Flask).", tipEn = "At level 50 grab the Sunken Temple warrior quest for Diamond Flask trinket." },
        },
        Alliance = {
            { lvl = "1–12", zoneRu = "Элвиннский лес / Дун Морог / Тельдрассил", zoneEn = "Elwynn Forest / Dun Morogh / Teldrassil", tipRu = "На 10 уровне выполните классовый квест на Оборонительную стойку.", tipEn = "At level 10 complete the class quest for Defensive Stance." },
            { lvl = "12–22", zoneRu = "Западный Край / Лок Модан / Темные берега", zoneEn = "Westfall / Loch Modan / Darkshore", tipRu = "Пройдите Мертвые Копи (18–22) ради квестов и двуручного оружия.", tipEn = "Clear The Deadmines (18–22) for quest rewards and 2H weapons." },
            { lvl = "22–30", zoneRu = "Красногорье / Сумеречный лес", zoneEn = "Redridge Mountains / Duskwood", tipRu = "Отличные цепочки квестов и много зеленых/синих наград на силу.", tipEn = "Great quest chains with strong Strength gear rewards." },
            { lvl = "30–40", zoneRu = "Тернистая долина / Нагорье Арати / Южнобережье", zoneEn = "Stranglethorn Vale / Arathi / Southshore", tipRu = "На 30 ур. сделайте классовый квест на Топор Вихря (Whirlwind Axe).", tipEn = "At level 30 complete the Warrior quest for Whirlwind Axe." },
            { lvl = "40–50", zoneRu = "Танарис / Фералас / Выжженные земли", zoneEn = "Tanaris / Feralas / Blasted Lands", tipRu = "Зул'Фаррак и Марадон (Кольцо Блэкстоуна с Принцессы).", tipEn = "Zul'Farrak and Maraudon (Blackstone Ring from Princess Theradras)." },
            { lvl = "50–60", zoneRu = "Ун'Горо / Чумные земли / Зимние Ключи", zoneEn = "Un'Goro / Plaguelands / Winterspring", tipRu = "Классовый квест в Затонувшем Храме на тринкет Алмазная колба (Diamond Flask).", tipEn = "Sunken Temple class quest for Diamond Flask trinket." },
        }
    },

    -- Вкладка 4: Подземелья в стиле Dungeon Journal
    Dungeons = {
        {
            id = "rfc",
            lvl = "13–16",
            faction = "Horde",
            icon = "Interface\\Icons\\Spell_Fire_LavaSpawn",
            nameRu = "Огненная Пропасть (RFC)",
            nameEn = "Ragefire Chasm (RFC)",
            descRu = "Быстрый опыт и 4 квеста из Оргриммара и Подгорода.",
            descEn = "Fast XP and 4 quests from Orgrimmar and Undercity.",
            loot = {
                { icon = "Interface\\Icons\\INV_Belt_03", ru = "Квестовые пояса и штаны", en = "Quest belts & leggings" },
            }
        },
        {
            id = "dm",
            lvl = "17–24",
            faction = "Alliance",
            icon = "Interface\\Icons\\INV_Helmet_08",
            nameRu = "Мертвые Копи (Deadmines)",
            nameEn = "The Deadmines (VC)",
            descRu = "Ключевой данж Альянса с топовым лутом на 20 уровень.",
            descEn = "Core Alliance dungeon with best-in-slot level 20 gear.",
            loot = {
                { icon = "Interface\\Icons\\INV_Hammer_09", ru = "Кувалда Смайта (Smite's Mighty Hammer)", en = "Smite's Mighty Hammer" },
                { icon = "Interface\\Icons\\INV_Chest_Chain_04", ru = "Нагрудник Братства (Defias Chest)", en = "Blackened Defias Armor" },
            }
        },
        {
            id = "wc",
            lvl = "17–24",
            faction = "Both",
            icon = "Interface\\Icons\\Spell_Nature_Polymorph",
            nameRu = "Пещеры Стенаний (WC)",
            nameEn = "Wailing Caverns (WC)",
            descRu = "Квест на отличные штаны и синий щит с финального мурлока.",
            descEn = "Quest for great leggings and blue shield from final boss.",
            loot = {
                { icon = "Interface\\Icons\\INV_Pants_02", ru = "Поножи Клыка (Leggings of the Fang)", en = "Leggings of the Fang" },
                { icon = "Interface\\Icons\\INV_Chest_Plate04", ru = "Нагрудник Мутануса", en = "Slime Encrusted Pads" },
            }
        },
        {
            id = "rfk",
            lvl = "29–33",
            faction = "Both",
            icon = "Interface\\Icons\\INV_Axe_04",
            nameRu = "Лабиринты Иглошкурых (RFK)",
            nameEn = "Razorfen Kraul (RFK)",
            descRu = "Обязательный заход за лучшим двуручным топором до Вихря.",
            descEn = "Mandatory run for the best 2H axe before Whirlwind Axe.",
            loot = {
                { icon = "Interface\\Icons\\INV_Axe_04", ru = "Трупный срубщик (Corpsemaker)", en = "Corpsemaker (2H Axe)" },
            }
        },
        {
            id = "sm",
            lvl = "34–42",
            faction = "Both",
            icon = "Interface\\Icons\\INV_Axe_09",
            nameRu = "Монастырь Алого Ордена (SM)",
            nameEn = "Scarlet Monastery (Armory & Cath)",
            descRu = "Ключевой сет для воина на 37–40 уровнях.",
            descEn = "Iconic warrior plate/mail set for levels 37–40.",
            loot = {
                { icon = "Interface\\Icons\\INV_Axe_09", ru = "Опустошитель (Ravager)", en = "Ravager" },
                { icon = "Interface\\Icons\\INV_Shoulder_01", ru = "Наплечники Ирода (Herod's Shoulder)", en = "Herod's Shoulder" },
                { icon = "Interface\\Icons\\INV_Helmet_03", ru = "Шлем Ирода и Поножи Алого ордена", en = "Raging Berserker's Helm & Scarlet Leggings" },
            }
        },
        {
            id = "zf",
            lvl = "44–50",
            faction = "Both",
            icon = "Interface\\Icons\\INV_Sword_25",
            nameRu = "Зул'Фаррак (ZF)",
            nameEn = "Zul'Farrak (ZF)",
            descRu = "Много опыта, квест на тринкет и сборка эпического меча.",
            descEn = "Great XP grind, speed trinket quest, and epic 2H sword.",
            loot = {
                { icon = "Interface\\Icons\\INV_Misc_Food_54", ru = "Морковка на палочке (Carrot on a Stick)", en = "Carrot on a Stick" },
                { icon = "Interface\\Icons\\INV_Sword_25", ru = "Суль'траз Каратель (Sul'thraze)", en = "Sul'thraze the Lasher" },
            }
        },
        {
            id = "mara",
            lvl = "46–52",
            faction = "Both",
            icon = "Interface\\Icons\\INV_Jewelry_Ring_16",
            nameRu = "Марадон (Maraudon)",
            nameEn = "Maraudon (Princess Run)",
            descRu = "Обязателен ради квеста на пре-рейд кольцо с Принцессы.",
            descEn = "Mandatory for the pre-raid BiS ring quest from Princess.",
            loot = {
                { icon = "Interface\\Icons\\INV_Jewelry_Ring_16", ru = "Кольцо Блэкстоуна (+1% Hit, 20 AP)", en = "Blackstone Ring (+1% Hit, 20 AP)" },
            }
        },
        {
            id = "st",
            lvl = "50–55",
            faction = "Both",
            icon = "Interface\\Icons\\INV_Potion_27",
            nameRu = "Затонувший Храм (ST)",
            nameEn = "Sunken Temple (ST)",
            descRu = "Классовый квест воина на лучший тринкет в игре.",
            descEn = "Warrior class quest for the strongest burst trinket in Classic.",
            loot = {
                { icon = "Interface\\Icons\\INV_Potion_27", ru = "Алмазная колба (Diamond Flask)", en = "Diamond Flask (+75 Str trinket)" },
            }
        },
        {
            id = "brd",
            lvl = "52–60",
            faction = "Both",
            icon = "Interface\\Icons\\INV_Jewelry_Talisman_01",
            nameRu = "Глубины Черной Горы (BRD)",
            nameEn = "Blackrock Depths (BRD)",
            descRu = "Главный пре-рейд инст для фарма тринкета и нагрудника.",
            descEn = "Main pre-raid dungeon for trinket and chest farming.",
            loot = {
                { icon = "Interface\\Icons\\INV_Jewelry_Talisman_01", ru = "Рука правосудия (Hand of Justice)", en = "Hand of Justice" },
                { icon = "Interface\\Icons\\INV_Chest_Chain_03", ru = "Гладиаторский кольчужный нагрудник", en = "Savage Gladiator Chain" },
                { icon = "Interface\\Icons\\INV_Hammer_20", ru = "Железный враг (Ironfoe)", en = "Ironfoe" },
            }
        },
        {
            id = "ubrs",
            lvl = "55–60",
            faction = "Both",
            icon = "Interface\\Icons\\INV_Shoulder_23",
            nameRu = "Пик Черной Горы (LBRS / UBRS)",
            nameEn = "Blackrock Spire (LBRS / UBRS)",
            descRu = "Квестовый тринкет на +2% крита и парные мечи Дал'Ренда.",
            descEn = "Quest +2% crit trinket and Dal'Rend's twin swords.",
            loot = {
                { icon = "Interface\\Icons\\INV_Jewelry_Talisman_08", ru = "Глаз Зверя (+2% Crit) / Метка Тирании", en = "Blackhand's Breadth / Mark of Tyranny" },
                { icon = "Interface\\Icons\\INV_Shoulder_23", ru = "Наплечники Точности (+2% Hit)", en = "Truestrike Shoulders (+2% Hit)" },
                { icon = "Interface\\Icons\\INV_Sword_43", ru = "Парные мечи Дал'Ренда", en = "Dal'Rend's Sacred Charge & Tribal Guardian" },
            }
        }
    }
}
