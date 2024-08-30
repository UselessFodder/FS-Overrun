// init.sqf for Malden Overrun

//---------- Global variables------------------//

	/*
		Zone 2D Array Layout: [[0: Location Name, 1: IsInfected, 2: InfectionRate, 3: ActiveSpawn, 4: MissionActive, 5: CleanseActive, 6: ZoneSize[.5 W, .5H]]		
		
		Zone Key: 
		0: Abandoned_Camp, 1: Alpheus_Powerplant, 2: Camp_Chimera, 3: Camp_Griffin, 
		4: Camp_Hydra, 5: Camp_Pegasus, 6: Erseke, 7: Farmstead, 
		8: Icarus_Airbase, 9: Icarus_Dockyard, 10: Industrial_Complex, 11: Ithaki, 
		12: Kavala, 13: Kefalonia, 14: Lost_Village, 15: Lykaion_Outpost, 
		16: Murakami, 17: New_Delphi_East, 18: New_Delphi_West, 19: Patras, 
		20: Takeshi_Farm, 21: Volos
		
	*/

// ------------ Server only

if (isServer) then {

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
	_saveCheck = profileNamespace getVariable "ArcadiaIsInfected";
	
	IsInfected = [];
	if (!isNil "_saveCheck") then{	
		IsInfected = profileNamespace getVariable "ArcadiaIsInfected";
		//publicVariable "IsInfected";	
	};//end if
	
	_saveCheck = profileNamespace getVariable "ArcadiaInfectionRate";
	
	InfectionRate = [];
	if (!isNil "_saveCheck") then{
		InfectionRate = profileNamespace getVariable "ArcadiaInfectionRate";
		//publicVariable "InfectionRate";		
	};//end if	
	
	_saveCheck = profileNamespace getVariable "ArcadiaFactionBank";
	if (!isNil "_saveCheck") then{	
		FactionBank = profileNamespace getVariable "ArcadiaFactionBank";
		publicVariable "FactionBank";	
	};//end if
	
	_saveCheck = profileNamespace getVariable "ArcadiaUnlockTracker";
	if (!isNil "_saveCheck") then{	
		UnlockTracker = profileNamespace getVariable "ArcadiaUnlockTracker";
		publicVariable "UnlockTracker";	
	};//end if
	
	//build 2D master array
	private _isDone = [IsInfected, InfectionRate] execVM "initArray.sqf";
	
	waitUntil {scriptDone _isDone};
	
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
	
	
	//Define all spawnable units
	execVM "unitDefines.sqf";	
	
	//initialized unlocked vehicles
	if (UnlockTracker select 0 == true) then {
		execVM "littleBirdUnlock.sqf";
	};
	if (UnlockTracker select 1 == true) then {
		execVM "techUnlock.sqf";
	};

	//variable to activate cleanse mode
	CleanseActive = false;
	publicVariable "CleanseActive";

	// --------------- init scripts ------------ //

	//init mobileRespawnDestroyed on correct vehicle ***
	//mobileRespawn addEventHandler ["Killed",{execVM "mobileRespawnDestroyed.sqf"}];
	
	
	//deconTruck addEventHandler ["Killed",{execVM "deconTruckDestroyed.sqf"}];


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
	//execVM "finaleCheck.sqf";

};

// ----------- run on all clients

//init marker colors
execVM "infectionMarkers.sqf";

//hide finale event markers, if they exist
if("generatorStart" in allMapMarkers) then {
	"generatorStart" setMarkerAlpha 0;
};
if("serverStart" in allMapMarkers) then {
	"serverStart" setMarkerAlpha 0;
};
if("startDecon" in allMapMarkers) then {
	"startDecon" setMarkerAlpha 0;

	//diag_log format ["Current marker alphas: %1, %2, %3", markerAlpha "generatorStart", markerAlpha "serverStart", markerAlpha "startDecon"];
};

//Decon marker
execVM "deconMarker.sqf";

//initialize arsenal in box and decon truck
execVM "initArsenal.sqf";

//add decon action to deconTruck
deconTruck addAction ["Begin DECON", {[[],"initCleanse.sqf"] remoteExec ["BIS_fnc_execVM",2];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

//init deconTruckDestroyed on correct vehicle
deconTruck addEventHandler ["Killed",{
	{
		//deleteVehicle _x;
		[_x] remoteExec ["deleteVehicle",2]
	} forEach attachedObjects deconTruck;
	
	//execVM "deconTruckDestroyed.sqf"; 
	["deconTruckDestroyed.sqf"] remoteExec ["BIS_fnc_execVM",2]
}];


