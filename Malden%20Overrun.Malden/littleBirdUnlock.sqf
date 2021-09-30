/*
	Spawns a helicopter if it is unlocked with a respawn command
*/
if (!isServer) exitWith {};

if(isServer) then {

	//create new littleBird
	littleBird = "B_Heli_Light_01_F" createVehicle getMarkerPos "heliSpawn"; 
	littleBird setDir 136;

	//add new eventHandler to new vic
	littleBird addEventHandler ["Killed",{execVM "littleBirdDestroyed.sqf"}];
	
	//global variable for if airborne decon needs to be rearmed
	LittleBirdArmed = true;
	publicVariable "LittleBirdArmed";
	
	
	//create marker
	createMarker ["littleBirdMarker",littleBird];
	"littleBirdMarker" setMarkerType "mil_triangle";
	"littleBirdMarker" setMarkerText "Little Bird";
	"littleBirdMarker" setMarkerAlpha 0.7;
	
	//update marker
	execVM "littleBirdMarker.sqf";

	//add decon action to heli
	[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","LittleBirdArmed == true",5,false,"",""]] remoteExec ["addAction",0];
	[littleBird,["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","LittleBirdArmed == false",5,false,"",""]] remoteExec ["addAction",0];
	//["littleBirdRemoveActions.sqf"] remoteExec ["BIS_fnc_execVM",0];
	sleep 0.5;
	//[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
	//[LittleBirdArmed] remoteExec ["littleBirdAddAction.sqf",0];

};