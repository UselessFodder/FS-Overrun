// init.sqf for Malden Overrun

/* ***TODO:
		x Set up spawn point arrays
		x Create zombie type array to create variety
		x Set up separate groups of 5-10 based on maxZ
		x patrol and defense routes for groups
		x Arsenal
		x FOB construction
		x Mobile respawn
		x Garbage Collection
		x Turn off conditions
		x Infection rate
		x Set markers for all towns
		x Initialize points	
		X Decrease infection rate	
		X Cleasing vehicle & DECON
		X Saving
		X Mini-Objectives
		- Set triggers for all towns
		X Victory conditions
		
*/

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
	//publicVariable "Locations";
	
	//set default mission values to be overwritten by loaded ones later
	IsInfected = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];
	//publicVariable "IsInfected";

	InfectionRate = [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];
	//publicVariable "InfectionRate";

	ActiveSpawn = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
	//publicVariable "ActiveSpawn";
	
	MissionActive = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
	//publicVariable "ActiveSpawn";

	//currency for faction unlocks
	FactionBank = 0;
	publicVariable "FactionBank";
	
	//tracker to keep track of all unlocks
	//0 - Heli, 1 - Tech, 2 - NVGs, 3 - Supressors
	UnlockTracker = [false,false,false,false];
	publicVariable "UnlockTracker";

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

	//zombie selection for spawning
	ZList = ["RyanZombieB_RangeMaster_FOpfor", "RyanZombieC_man_polo_6_FOpfor", "RyanZombie15Opfor","RyanZombieC_man_w_worker_FmediumOpfor", "RyanZombieC_man_1Opfor", "RyanZombie25mediumOpfor", "RyanZombie18mediumOpfor", "RyanZombieC_man_pilot_FslowOpfor", "RyanZombie17slowOpfor", "RyanZombieCrawler20Opfor", "RyanZombieCrawler22Opfor", "RyanZombieSpider6Opfor", "RyanZombie23walkerOpfor", "RyanZombieB_Soldier_lite_FOpfor"];
	//"RyanZombieboss27Opfor", "RyanZombieboss19Opfor" *** SAVE FOR LATER
	
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

};

//init marker colors
execVM "infectionMarkers.sqf";

//Decon marker
execVM "deconMarker.sqf";

//prevent time from changing
execVM "timeSet.sqf";

//initialize arsenal in box and decon truck
execVM "initArsenal.sqf";

//add decon action to deconTruck
deconTruck addAction ["Begin DECON", {[[],"initCleanse.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];
