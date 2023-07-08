/*
	Defines the correct unit types for zombies.
	TODO: define player units, AI ally units, and vehicles for spawning
	TODO: allow individual unit defines
*/
	
//add zombies to spawn list based on params
ZList = [];
DemonList = [];

//list to hold all configs
_zombieLists =[];

//*** CHANGE TO 1 IF YOU WANT TO USE CUSTOM ENEMY TYPES DEFINED BELOW
private _useCustom = 0;

//if default, use Ryanzombies default defined
if (_useCustom == 0) then {
	//Medium Civ Zombies
	_zConfig1 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "Ryanzombiesgroupmediumopfor" >> "Ryanzombiesgroupmedium1opfor" );
	//Medium Soldier Zombies
	_zConfig2 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "Ryanzombiesgroupmediumopfor" >> "Ryanzombiesgroupmedium5opfor");
	//Slow Civ Zombies
	_zConfig3 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "Ryanzombiesgroupslowopfor" >> "Ryanzombiesgroupslow1opfor" );
	//Slow Solder Zombies
	_zConfig4 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "Ryanzombiesgroupslowopfor" >> "Ryanzombiesgroupslow5opfor" );
	
	//add to configlist to push into ZList below
	_zombieLists pushback _zConfig1;
	_zombieLists pushback _zConfig2;
	_zombieLists pushback _zConfig3;
	_zombieLists pushback _zConfig4;
	
	//check if params allow these types of zombies
	_classUnlocked = ["FastZombies", 0] call BIS_fnc_getParamValue;
	if (_classUnlocked == 0) then {
		_zConfig5 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "Ryanzombiesgroupfastopfor" >> "Ryanzombiesgroupfast2opfor" );
		_zombieLists pushback _zConfig5;
		_zConfig6 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "Ryanzombiesgroupfastopfor" >> "Ryanzombiesgroupfast5opfor" );
		_zombieLists pushback _zConfig6;
	};
	_classUnlocked = ["CrawlZombies", 0] call BIS_fnc_getParamValue;
	if (_classUnlocked == 0) then {
		_zConfig7 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "RyanzombiesgroupCrawleropfor" >> "RyanzombiesgroupCrawler2opfor" );
		_zombieLists pushback _zConfig7;
	};
	_classUnlocked = ["SpiderZombies", 0] call BIS_fnc_getParamValue;
	if (_classUnlocked == 0) then {
		_zConfig8 = ( configfile >> "CfgGroups" >> "East" >> "Ryanzombiesfactionopfor" >> "Ryanzombiesgroupspideropfor" >> "Ryanzombiesgroupspider2opfor" );
		_zombieLists pushback _zConfig8;
	};
	
	//add all zombies from cfgGroup lists above into spawning list
	{
		"
			ZList pushBack getText ( _x >> 'vehicle');
			
		" configClasses _x;
	} forEach _zombieLists;
	
	//*** Boss-type monsters for the mini-objective
	DemonList = ["RyanZombieboss27Opfor", "RyanZombieboss19Opfor"];

	
	//check if these mods are enabled
	//WebKnights Zombies and Creatures
	_wkUnlocked = isClass(configFile >> "cfgPatches" >> "WBK_ZombieCreatures");
	if(_wkUnlocked) then {
		//note in debug
		diag_log "WebKnights is Enabled. Loading WK Zombies and Creatures";
		//add in zombies from WebKnights at appropriate amounts to balance out with Z&D
		_wkList = ["Zombie_O_Crawler_Civ","Zombie_O_Crawler_Civ","Zombie_O_Crawler_Civ","Zombie_O_Crawler_Civ","Zombie_O_Crawler_Civ","Zombie_O_Crawler_Civ",
			"Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ",
			"Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ","Zombie_O_Shambler_Civ",
			"Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ",
			"Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ","Zombie_O_RA_Civ",
			"Zombie_O_RC_Civ","Zombie_O_RC_Civ","Zombie_O_RC_Civ","Zombie_O_RC_Civ","Zombie_O_RC_Civ","Zombie_O_RC_Civ",
			"Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ",
			"Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ","Zombie_O_Walker_Civ",
			"WBK_SpecialZombie_Corrupted_3","WBK_SpecialZombie_Corrupted_3","WBK_SpecialZombie_Corrupted_3","WBK_SpecialZombie_Corrupted_3",
			"Zombie_Special_OPFOR_Leaper_1","Zombie_Special_OPFOR_Leaper_1","Zombie_Special_OPFOR_Leaper_2","Zombie_Special_OPFOR_Leaper_2",
			"Zombie_Special_OPFOR_Boomer","Zombie_Special_OPFOR_Boomer","Zombie_Special_OPFOR_Boomer","Zombie_Special_OPFOR_Screamer","Zombie_Special_OPFOR_Screamer"
			];
		
		{
			ZList pushBack _x;
		} forEach _wkList;
	};
	
	//Devourerking's Necroplague Mutants
	_devUnlocked = isClass(configfile >> "CfgPatches" >> "dev_mutant_common");
	if(_devUnlocked) then {
		//note in debug
		diag_log "Devourking's is Enabled. Loading Devourerking's Necroplague Mutants";
		//add in monsters from Devourking's at appropriate amounts to balance out with Z&D
		_devList = ["dev_parasite_o","dev_parasite_o","dev_parasite_o","dev_parasite_o","dev_parasite_o","dev_parasite_o","dev_parasite_o","dev_parasite_o",
		"dev_asymhuman_stage2_o","dev_asymhuman_stage2_o","dev_asymhuman_stage2_o","dev_asymhuman_stage2_o","dev_asymhuman_stage2_o","dev_asymhuman_stage2_o",
		"dev_form939_o","dev_form939_o","dev_form939_o","dev_form939_o","dev_form939_o","dev_form939_o"
		];
		
		{
			ZList pushBack _x;
		} forEach _devList;
		
		//add in special boss types
		_devBoss = ["dev_asymhuman_o","dev_toxmut_o"];
		
		{
			DemonList pushBack _x;
		} forEach _devBoss;
	};
	
	
	//*** Friendly DECONTruck
	DeconTruckType = "B_Truck_01_medical_F";
	
	//*** Friendly Helicopter
	LittleBirdType = "B_Heli_Light_01_F";
	
	//*** Friendly armed truck
	TechTruckType = "B_LSV_01_armed_F";
	
	//*** Objects for research mini-objective
	ResearchObjects = ["Land_PlasticCase_01_large_black_CBRN_F","Land_PlasticCase_01_large_CBRN_F","Land_PlasticCase_01_large_olive_CBRN_F","Land_PlasticCase_01_medium_CBRN_F",
		"Land_PlasticCase_01_medium_black_CBRN_F","Land_PlasticCase_01_medium_olive_CBRN_F","Land_PlasticCase_01_small_CBRN_F","Land_PlasticCase_01_small_olive_CBRN_F",
			"Land_PlasticCase_01_small_black_CBRN_F","CBRNCase_01_F","Box_C_UAV_06_medical_F","Box_C_IDAP_UAV_06_medical_F","Land_MultiScreenComputer_01_closed_black_F",
				"Land_MultiScreenComputer_01_closed_olive_F","Land_MultiScreenComputer_01_closed_sand_F","Laptop_EP1","Land_Laptop_device_F","Land_Laptop_unfolded_F"];
		
};

//** THIS IS WHERE YOU DEFINE YOUR CUSTOM ENEMY TYPES
if (_useCustom == 1) then {
	//*** At least one type of enemy must be defined within the array _zombieLists or _tempList below in order to push into the spawning ZList
	//  These are for every classnae in group and are pulled from CfgGroups list as per the example below. Do as many _zConfigs as you wish
	//_zConfig1 = ( configfile >> "CfgGroups" >> "East" >> "***FACTIONNAME***" >> "***GROUPTYPE***" >> "***GROUPNAME***" );
	
	//*** After defining groups, you must pushback each _zConfig into _zombieLists
	//_zombieLists pushback _zConfig1;

	//*** If you have crafted custom params such as the "FastZombies" above, feel free to copy that syntax to add those enemy types in
	
	//*** Define any INDIVIDUAL classnames in this array here. This is useful for mods that don't use groups!
	private _templist = [];
	
	//*** Boss-type monsters for the mini-objective. Must have AT LEAST one unit type
	DemonList = [];
	
	//*** Friendly DECONTruck
	DeconTruckType = "B_Truck_01_medical_F";
	
	//*** Friendly Helicopter
	LittleBirdType = "B_Heli_Light_01_F";
	
	//*** Friendly armed truck
	TechTruckType = "B_LSV_01_armed_F";
	
	//*** Objects for research mini-objective
	ResearchObjects = ["Land_PlasticCase_01_large_black_CBRN_F","Land_PlasticCase_01_large_CBRN_F","Land_PlasticCase_01_large_olive_CBRN_F","Land_PlasticCase_01_medium_CBRN_F",
		"Land_PlasticCase_01_medium_black_CBRN_F","Land_PlasticCase_01_medium_olive_CBRN_F","Land_PlasticCase_01_small_CBRN_F","Land_PlasticCase_01_small_olive_CBRN_F",
			"Land_PlasticCase_01_small_black_CBRN_F","CBRNCase_01_F","Box_C_UAV_06_medical_F","Box_C_IDAP_UAV_06_medical_F","Land_MultiScreenComputer_01_closed_black_F",
				"Land_MultiScreenComputer_01_closed_olive_F","Land_MultiScreenComputer_01_closed_sand_F","Laptop_EP1","Land_Laptop_device_F","Land_Laptop_unfolded_F"];
	
	
	//check if any cfgGroups are used and, if so, add them to ZList
	if(count _zombieLists > 0) then {
		//add all zombies from cfgGroup lists above into spawning list
		{
			"
				ZList pushBack getText ( _x >> 'vehicle');
				
			" configClasses _x;
		} forEach _zombieLists;
	};	
	
	//check if templist is used and, if so, add them to ZList
	if(count _tempList > 0) then {
		{
			ZList pushBack _x;
		} forEach _tempList;
	};
	
	
};


//make unit selections available for other scripts
publicVariable "ZList";
publicVariable "DemonList";
publicVariable "DeconTruckType";
publicVariable "LittleBirdType";
publicVariable "TechTruckType";
publicVariable "ResearchObjects";
	
//***Define player vehicles
/*
DeconTruckType = "";
GunTruckType = "";
HelicopterType = "";

*/