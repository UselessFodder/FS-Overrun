/*
	Defines the correct unit types for zombies.
	TODO: define player units, AI ally units, and vehicles for spawning
	TODO: allow individual unit defines
*/
	
//add zombies to spawn list based on params
ZList = [];

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

//** THIS IS WHERE YOU DEFINE YOUR CUSTOM ENEMY TYPES
if (_useCustom == 1) then {
	//*** At least one type of enemy must be defined within the array _zombieLists in order to push into the spawning ZList
	//  Currently, this must be pulled from a CfgGroups list as per the example below. Do as many _zConfigs as you wish
	//_zConfig1 = ( configfile >> "CfgGroups" >> "East" >> "***FACTIONNAME***" >> "***GROUPTYPE***" >> "***GROUPNAME***" );
	
	//*** After defining groups, you must pushback each _zConfig into _zombieLists
	//_zombieLists pushback _zConfig1;

	//*** If you have crafted custom params such as the "FastZombies" above, feel free to copy that syntax to add those enemy types in
};

};
//add all zombies from cfgGroup lists above into spawning list
{
	"
		ZList pushBack getText ( _x >> 'vehicle');
		
	" configClasses _x;
} forEach _zombieLists;

//make ZList available for other scripts
publicVariable "ZList";
	
//***Define player vehicles
/*
DeconTruckType = "";
GunTruckType = "";
HelicopterType = "";

*/