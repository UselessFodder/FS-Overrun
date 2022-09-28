// init.sqf for Malden Overrun

//---------- Global variables------------------//

	/*
		Zone 2D Array Layout: [[0: Location Name, 1: IsInfected, 2: InfectionRate, 3: ActiveSpawn, 4: MissionActive, 5: CleanseActive, 6: ZoneSize[.5 W, .5H]]		
		
		Zone Key: 
		0: Airport, 1: Aratte, 2: Arudy, 3: Blanches, 
		4: Bosquet, 5: Cancon, 6: Chapoi, 7: Corton, 
		8:Dorres, 9: Dourdan, 10: Faro, 11: Goisse, 
		12: Guran, 13: Houdan, 14: La_Pessagne, 15: La_Riviere, 
		16: La_Trinite, 17: Larche, 18: Lavalle, 19: Le_Port, 
		20: Le_Port_Harbor, 21: Loisse, 22: Lumber_Mill, 23: Military_Base, 
		24: Power_Plant, 25: Radio_Station, 26: Saint_Jean, 27: Saint_Louis, 
		28: Saint_Marie, 29: Saint_Martin, 30: Vigny
		
	*/

if (isServer) then {
	//list of location names
	Locations = ["Airport","Aratte","Arudy","Blanches","Bosquet","Cancon","Chapoi","Corton","Dorres","Dourdan","Faro","Goisse","Guran","Houdan","La_Pessagne","La_Riviere","La_Trinite","Larche","Lavalle","Le_Port","Le_Port_Harbor","Loisse","Lumber_Mill","Military_Base","Power_Plant","Radio_Station","Saint_Jean","Saint_Louis","Saint_Marie","Saint_Martin","Vigny"];
	
	//set default mission values to be overwritten by loaded ones later
	IsInfected = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];

	InfectionRate = [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];

	ActiveSpawn = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
	
	MissionActive = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];

	//currency for faction unlocks
	FactionBank = 0;
	publicVariable "FactionBank";
	
	//tracker to keep track of all unlocks
	//0 - Heli, 1 - Tech, 2 - NVGs, 3 - Supressors
	UnlockTracker = [false,false,false,false];
	publicVariable "UnlockTracker";
	
	//tracker for access to finale
	FinaleReady = false;
	publicVariable "FinaleReady";

	//check if profileNamespace contains changeable variables. If so, load variables
	_saveCheck = profileNamespace getVariable "IsInfected";
	
	if (!isNil "_saveCheck") then{	
		IsInfected = profileNamespace getVariable "IsInfected";
		//publicVariable "IsInfected";	
	};//end if
	
	_saveCheck = profileNamespace getVariable "InfectionRate";
	
	if (!isNil "_saveCheck") then{
		InfectionRate = profileNamespace getVariable "InfectionRate";
		//publicVariable "InfectionRate";		
	};//end if	
	
	_saveCheck = profileNamespace getVariable "FactionBank";
	if (!isNil "_saveCheck") then{	
		FactionBank = profileNamespace getVariable "FactionBank";
		publicVariable "FactionBank";	
	};//end if
	
	_saveCheck = profileNamespace getVariable "UnlockTracker";
	if (!isNil "_saveCheck") then{	
		UnlockTracker = profileNamespace getVariable "UnlockTracker";
		publicVariable "UnlockTracker";	
	};//end if
	
	//generate 2D master array from inputs
	ZoneArray = [];	
	for [{private _i = 0}, {_i < 31}, {_i = _i + 1}] do {
		private _arrayInput = [Locations select _i, IsInfected select _i, InfectionRate select _i, ActiveSpawn select _i, MissionActive select _i, false, MarkerSize (Locations select _i)];
		diag_log format ["Reading in %1 to ZoneArray slot %2", _arrayInput select 0, _i];
		ZoneArray set [_i, _arrayInput];
		diag_log format ["Location %1 is now read into ZoneArray %2", ZoneArray select _i select 0, _i];
	};
	
	publicVariable "ZoneArray";	
	diag_log format ["ZoneArray initialized with %1 entries", count ZoneArray];
	
	//check params and run resetState if selected
	if (["ResetStatus", 1] call BIS_fnc_getParamValue == 3)  then {
		[true] execVM "resetState.sqf";
	};
	
	//check params and unlock applicable slots
	if(["LittleBirdUnlocked", 0] call BIS_fnc_getParamValue == 1) then {
		diag_log "Little Bird Unlock Selected...";
		UnlockTracker set [0, true];
	};
	if(["TechnicalUnlocked", 0] call BIS_fnc_getParamValue == 1) then {
		diag_log "Technical Unlock Selected...";
		UnlockTracker set [1, true];
	};
	if(["NVGUnlocked", 0] call BIS_fnc_getParamValue == 1) then {
		diag_log "NVG Unlock Selected...";
		UnlockTracker set [2, true];
	};
	if(["SupressorUnlocked", 0] call BIS_fnc_getParamValue == 1) then {
		diag_log "Suppressor Unlock Selected...";
		UnlockTracker set [3, true];
	};
	publicVariable "UnlockTracker";
	
	
	//initialized unlocked vehicles
	if (UnlockTracker select 0 == true) then {
		execVM "littleBirdUnlock.sqf";
	};
	if (UnlockTracker select 1 == true) then {
		execVM "techUnlock.sqf";
	};
		
	//add zombies to spawn list based on params
	ZList = [];
	
	//list to hold all configs
	_zombieLists =[];
	
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
	
	//make ZList available for other scripts
	publicVariable "ZList";

	//variable to activate cleanse mode
	CleanseActive = false;
	publicVariable "CleanseActive";

	// --------------- init scripts ------------ //

	//init mobileRespawnDestroyed on correct vehicle ***
	//mobileRespawn addEventHandler ["Killed",{execVM "mobileRespawnDestroyed.sqf"}];
	
	//init deconTruckDestroted on correct vehicle
	deconTruck addEventHandler ["Killed",{execVM "deconTruckDestroyed.sqf"}];

	//Respawn marker
	execVM "respawnMarker.sqf";

	//init garbage collection
	execVM "garbageCollection.sqf";

	execVM "autosave.sqf";

	//prevent time from changing
	execVM "timeSet.sqf";
	
	//secondary missions
	execVM "initSecondary.sqf";
	
	//check if all areas are DECON and players are ready for Finale event
	execVM "finaleCheck.sqf";

};
//run on all clients

//init marker colors
execVM "infectionMarkers.sqf";

//Decon marker
execVM "deconMarker.sqf";

//initialize arsenal in box and decon truck
execVM "initArsenal.sqf";

//add decon action to deconTruck
deconTruck addAction ["Begin DECON", {[[],"initCleanse.sqf"] remoteExec ["BIS_fnc_execVM",2];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

