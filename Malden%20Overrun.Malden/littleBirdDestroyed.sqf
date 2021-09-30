/*
	If littleBird is destroyed, this is called to replace it after 15 seconds
*/
sleep 60;
if(littleBird distance getMarkerPos "heliSpawn" < 20) then {

	deleteVehicle littleBird;
	sleep 5;
	
};

if(isServer) then {
	//create new littleBird
	littleBird = "B_Heli_Light_01_F" createVehicle getMarkerPos "heliSpawn"; 
	littleBird setDir 136;

	//add new eventHandler to new vic
	littleBird addEventHandler ["Killed",{execVM "littleBirdDestroyed.sqf"}];
	
	//global variable for if airborne decon needs to be rearmed
	LittleBirdArmed = true;
	publicVariable "LittleBirdArmed";
	//remove all actions, then add decon action to heli
		//SAVE [littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",-2];
	//["littleBirdRemoveActions.sqf"] remoteExec ["BIS_fnc_execVM",0];	
	//[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
	[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","LittleBirdArmed == true",5,false,"",""]] remoteExec ["addAction",0];
	[littleBird,["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","LittleBirdArmed == false",5,false,"",""]] remoteExec ["addAction",0];
	
};

