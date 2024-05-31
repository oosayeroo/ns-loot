Config = {}
Config.DebugCode = false
Config.NotifyScript = 'qb'
Config.CoreInventory = true
Config.CoreSkills = false
Config.Target = 'qb-target'

Config.NoLootZones = { --cannot loot in these zones (safezones etc)
	{Coords = vector3(-530.24, 5324.9, 81.06),Radius = 150.0},
}

-- PLEASE CONFIGURE EVERYTHING BELOW. DO NOT JUST PUT IT IN YOUR SERVER AND EXPECT IT TO WORK. YOU MUST CUSTOMISE IT TO FIT YOUR OWN SERVER
-- If something is marked as !OPTIONAL then you can use the fields within or remove that section completely if you dont want to use it
Config.Objects = {
-- General
	['dumpsters'] = {
		Models = { --any model in this list will be used for this type of loot. (DO NOT USE THE SAME MODEL IN MULTIPLE TABLES OR WILL CAUSE ERRORS)
			'prop_dumpster_01a',
			'prop_dumpster_02a',
			'prop_dumpster_02b',
			'prop_dumpster_3a',
			'prop_dumpster_4a',
			'prop_dumpster_4b',
			'prop_bin_05a',
			'prop_bin_06a',
			'prop_bin_07a',
			'prop_bin_07b',
			'prop_bin_07c',
			'prop_bin_07d',
			'prop_bin_08a',
			'prop_bin_08open',
			'prop_bin_09a',
			'prop_bin_10a',
			'prop_bin_10b',
			'prop_bin_11a',
			'prop_bin_12a',
			'prop_bin_13a',
			'prop_bin_14a',
			'prop_bin_14b',
			'prop_bin_beach_01d',
			'prop_bin_delpiero',
			'prop_bin_delpiero_b',
			'prop_recyclebin_01a',
			'prop_recyclebin_02_c',
			'prop_recyclebin_02_d',
			'prop_recyclebin_02a',
			'prop_recyclebin_02b',
			'prop_recyclebin_03_a',
			'prop_recyclebin_04_a',
			'prop_recyclebin_04_b',
			'prop_recyclebin_05_a',
			'zprop_bin_01a_old',
			'hei_heist_kit_bin_01',
			'ch_prop_casino_bin_01a',
			'vw_prop_vw_casino_bin_01a',
			'mp_b_kit_bin_01',
		},
		Label = "Search...", --target label
		Icon = 'fas fa-hand', --target icon
		Require = { -- !OPTIONAL
			Item = { --these are the items that are required
				'weapon_crowbar',
				'weapon_bat',
				'weapon_golfclub',
				'weapon_hammer',
				'weapon_hatchet',
				'weapon_machete',
				'weapon_nightstick',
				'weapon_wrench',
				'weapon_battleaxe',
				'weapon_stone_hatchet',
			},
			BreakChance = 2,
		},
		Emote = 'mechanic4', --!OPTIONAL
		MiniGame = 'ps-ui', --!OPTIONAL
		OnFail = { --many options to choose from or just change OnFail = false 		--!OPTIONAL (everything in this field is also --!OPTIONAL)
			ApplyDamage = 10, --takes x amount of health from player
			IgnoreArmour = true, --will take it from health only if this is true else will take it from armour first
			Effect = 'shock', -- check Config.OnFailEffects at bottom of this file
			Ragdoll = true, --will ragdoll you for a short time

			--you can even trigger external events on fail (these are examples)
			TriggerClientEvent = 'yourclienteventhere',
			TriggerServerEvent = 'yourservereventhere',
			EventArguments = { --these will be used in either the client or server triggers
				arg1 = 'arg1',
				arg2 = 'arg2',
			},
		},
		Cooldown = 2880, --cooldown for prop in seconds
		ActionLabel = "Scratting...", --progressbar label
		ActionTime = 5, --in seconds
		RewardChance = 75, --in % to find something
		RewardList = 'rubbish', --list from Config.Rewards
		RewardAmount = math.random(1,3), --how many different items to get
		SkillsAffected = { --uses core skills if Config.CoreSkills = true --!OPTIONAL
			[1] = { --skills must be in order from best to worse otherwise it wont work as intended
				Skill = 'Resourceful3', --skill name in your core skills database
				BonusAmount = 100, --in % more you receive if you have skill
			},
			[2] = {
				Skill = 'Resourceful2',
				BonusAmount = 50, 
			},
			[3] = {
				Skill = 'Resourceful1',
				BonusAmount = 25, 
			},
		},
	},

	['wrecks'] = {
		Models = {
			'prop_wreckedcart',
			'prop_snow_rub_trukwreck_2',
			'prop_wrecked_buzzard',
			'prop_rub_buswreck_01',
			'prop_rub_buswreck_03',
			'prop_rub_buswreck_06',
			'prop_rub_carwreck_10',
			'prop_rub_carwreck_11',
			'prop_rub_carwreck_12',
			'prop_rub_carwreck_13',
			'prop_rub_carwreck_14',
			'prop_rub_carwreck_15',
			'prop_rub_carwreck_16',
			'prop_rub_carwreck_17',
			'prop_rub_carwreck_2',
			'prop_rub_carwreck_3',
			'prop_rub_carwreck_5',
			'prop_rub_carwreck_7',
			'prop_rub_carwreck_8',
			'prop_rub_carwreck_9',
			'prop_rub_railwreck_1',
			'prop_rub_railwreck_2',
			'prop_rub_railwreck_3',
			'prop_rub_trukwreck_1',
			'prop_rub_trukwreck_2',
			'prop_rub_wreckage_3',
			'prop_rub_wreckage_4',
			'prop_rub_wreckage_5',
			'prop_rub_wreckage_6',
			'prop_rub_wreckage_7',
			'prop_rub_wreckage_8',
			'prop_rub_wreckage_9',
			'ch1_01_sea_wreck_3',
			'cs2_30_sea_ch2_30_wreck005',
			'cs2_30_sea_ch2_30_wreck7',
			'cs4_05_buswreck',
		},
		Label = "Scavenge...",
		Icon = 'fas fa-hand', 
		Require = { 
			Item = {
				'weapon_crowbar',
				'weapon_bat',
				'weapon_golfclub',
				'weapon_hammer',
				'weapon_hatchet',
				'weapon_machete',
				'weapon_nightstick',
				'weapon_wrench',
				'weapon_battleaxe',
				'weapon_stone_hatchet',
			},
			BreakChance = 2,
		},
		Emote = 'mechanic',
		MiniGame = 'ps-ui',
		Cooldown = 2880, 
		ActionLabel = "Looking For Parts...",
		ActionTime = 5, 
		RewardChance = 70,
		RewardList = 'wrecks', 
		RewardAmount = 1,
	},
	
	['femalemodelstest'] = {
		Models = {
			'a_f_m_beach_01',
			'a_f_m_bevhills_01',
    		'a_f_m_bevhills_02',
		},
		IsPed = true, 
		Label = "Loot Body...",
		Icon = 'fas fa-hand',
		Require = false,
		Emote = 'mechanic4',
		MiniGame = 'ps-ui',
		Cooldown = 5000,
		ActionLabel = "Looting Body...",
		ActionTime = 10,
		RewardChance = 100, 
		RewardList = 'pedtest', 
		RewardAmount = 1,
	},
}

Config.Rewards = { --these are just example items used in here. please change to suit your server
	['pedtest'] = {
		{item = 'sprunk',amount = 1},
	},
	['rubbish'] = {
		{item = 'lockpick',amount = math.random(1,3)},
		{item = 'snikkel_candy',amount = math.random(1,3)},
		{item = 'water_bottle',amount = math.random(1,1)},
		{item = 'empty_bottle',amount = math.random(1,2)},
		{item = 'metalscrap',amount = math.random(1,1)},
		{item = 'tinnedfishopen',amount = math.random(1,1)},
		{item = 'tinnedmeatopen',amount = math.random(1,1)},
		{item = 'coffee',amount = math.random(1,1)},
	},
	['wrecks'] = {
		{item = 'vehicleparts',amount = math.random(5,10)},
		{item = 'metalscrap',amount = math.random(1,2)},
		{item = 'sparkplugs',amount = 1},
		{item = 'axleparts',amount = math.random(1,2)},
		{item = 'carbattery',amount = 1},
	},
}

-- list of all particle effects found here - https://vespura.com/fivem/particle-list/
Config.OnFailEffects = { --these are setup correcly. please consult gta documentation to make new ones (playing incorrect effects can break your character or cause crashes)
	['shock'] = {
		ParticleDictionary = 'core',
        ParticleAsset = 'ent_dst_elec_fire_sp',
        LoopAmount = 25,
        Duration = 1, --in seconds
	},
	['fire'] = { --damages player quite a bit from the fire
		ParticleDictionary = 'core',
        ParticleAsset = 'ent_ray_meth_fires',
        LoopAmount = 25,
        Duration = 1,
	},
	['explode'] = {
		ParticleDictionary = 'core',
        ParticleAsset = 'exp_grd_grenade_lod',
        LoopAmount = 1,
        Duration = 1,
	},
}