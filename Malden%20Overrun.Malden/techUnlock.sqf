/*
	Spawns a technical if it is unlocked
*/

if (!isServer) exitWith {};

if(isServer) then {
	//create new technical
	techTruck = "B_LSV_01_armed_F" createVehicle getMarkerPos "techSpawn"; 
	techTruck setDir 133;

	//add new eventHandler to new vic
	//techTruck addMPEventHandler ["MPKilled",{execVM "techDestroyed.sqf"}];
	[techTruck, ["Killed",{
		["techDestroyed.sqf"] remoteExec ["BIS_fnc_execVM",2]
	}]] remoteExec ["addEventHandler",0];

		//create marker
	createMarker ["techMarker",techTruck];
	"techMarker" setMarkerType "mil_triangle";
	"techMarker" setMarkerText "Technical";
	"techMarker" setMarkerAlpha 0.7;
	
	//update marker
	execVM "techMarker.sqf";

	diag_log "** techTruck has been unlocked.";
};