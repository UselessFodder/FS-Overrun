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
		- Victory conditions
		
*/

//---------- Global variables------------------//

if (isServer) then {
	//key-style map of location names
	Locations = ["Airport","Aratte","Arudy","Blanches","Bosquet","Cancon","Chapoi","Corton","Dorres","Dourdan","Faro","Goisse","Guran","Houdan","La_Pessagne","La_Riviere","La_Trinite","Larche","Lavalle","Le_Port","Le_Port_Harbor","Loisse","Lumber_Mill","Military_Base","Power_Plant","Radio_Station","Saint_Jean","Saint_Louis","Saint_Marie","Saint_Martin","Vigny"];
	publicVariable "Locations";
	
	//set default mission values to be overwritten by loaded ones later
	IsInfected = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];
	publicVariable "IsInfected";

	InfectionRate = [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];
	publicVariable "InfectionRate";

	ActiveSpawn = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
	publicVariable "ActiveSpawn";

	//currency for faction unlocks
	FactionBank = 0;
	publicVariable "FactionBank";
	
	//tracker to keep track of all unlocks
	//0 - Heli, 1 - Tech
	UnlockTracker = [false,false];
	publicVariable "UnlockTracker";

	//check if profileNamespace contains changeable variables. If so, load variables
	_saveCheck = profileNamespace getVariable "IsInfected";
	
	if (!isNil "_saveCheck") then{	
		IsInfected = profileNamespace getVariable "IsInfected";
		publicVariable "IsInfected";	
	};//end if
	
	_saveCheck = profileNamespace getVariable "InfectionRate";
	
	if (!isNil "_saveCheck") then{
		InfectionRate = profileNamespace getVariable "InfectionRate";
		publicVariable "InfectionRate";		
	};//end if
	
	_saveCheck = profileNamespace getVariable "ActiveSpawn";
	
	if (!isNil "_saveCheck") then{
		ActiveSpawn = profileNamespace getVariable "ActiveSpawn";
		publicVariable "ActiveSpawn";			
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

	//init mobileRespawnDestroyed on correct vehicle
	mobileRespawn addEventHandler ["Killed",{execVM "mobileRespawnDestroyed.sqf"}];
	
	//init deconTruckDestroted on correct vehicle
	deconTruck addEventHandler ["Killed",{execVM "deconTruckDestroyed.sqf"}];

	//Respawn markers
	execVM "respawnMarker.sqf";

	//init garbage collection
	execVM "garbageCollection.sqf";

	execVM "autosave.sqf";

};

//for players spawning in, set helicopter actions locally
if(!isServer) then {
	/*
	if(UnlockTracker select 0 == true) then {
		if(isNil "LittleBirdArmed" || LittleBirdArmed == true) then {
			removeAllActions littleBird;
			littleBird addAction ["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",2]; {removeAllActions littleBird;} remoteExec ["call", 0];},nil,1.5,FALSE,true,"","true",5,false,"",""];
			//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",2]; {removeAllActions littleBird;} remoteExec ["bis_fnc_call", 0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",0];
		} else {
			removeAllActions littleBird;
			littleBird addAction ["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",2]; {removeAllActions littleBird;} remoteExec ["call", 0];},nil,1.5,FALSE,true,"","true",5,false,"",""];
			//[littleBird,["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",2]; {removeAllActions littleBird;} remoteExec ["bis_fnc_call", 0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",0];
		};
		
		
	}; */
	//[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
	//[LittleBirdArmed] execVM "LittleBirdAddAction.sqf";
};

//init marker colors
execVM "infectionMarkers.sqf";

//Decon marker
execVM "deconMarker.sqf";

//prevent time from changing
execVM "timeSet.sqf";

//initialize arsenal in box and respawn truck
execVM "initArsenal.sqf";
