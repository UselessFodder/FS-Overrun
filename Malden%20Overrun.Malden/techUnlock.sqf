/*
	Spawns a technical if it is unlocked
*/

if (!isServer) exitWith {};

if(isServer) then {
	//create new technical
	techTruck = "B_LSV_01_armed_F" createVehicle getMarkerPos "techSpawn"; 
	techTruck setDir 133;

	//add new eventHandler to new vic
	techTruck addEventHandler ["Killed",{execVM "techDestroyed.sqf"}];
	//add decon action to heli
	//[deconTruck,["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];

		//create marker
	createMarker ["techMarker",techTruck];
	"techMarker" setMarkerType "mil_triangle";
	"techMarker" setMarkerText "Technical";
	"techMarker" setMarkerAlpha 0.7;
	
	//update marker
	execVM "techMarker.sqf";

};