/*
	Adds Airborne Decon command back to helicopter
*/

//remove all custom commands from heli
//littleBird remoteExec ["removeAllActions", 0];
{removeAllActions littleBird;} remoteExec ["call", 0]; 

//check if heli is near helipad
if ((littleBird distance getMarkerPos "heliSpawn") < 10) then {
	//Inform user of wait time
	[["heliSpawn",20,"Rearming airborne decontaminate now..."],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];	
	//wait 10 seconds
	sleep 10;
	//inform complete
	[["heliSpawn",20,"Decontaminate rearmed!"],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
	//global variable for armed status
	LittleBirdArmed = true;
	publicVariable "LittleBirdArmed";
	
	//give action back
	//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",2]; removeAllActions littleBird;},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",0];	
	//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",-2];
	[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];

} else {
	//if not near, inform user and add rearm command back to heli
	[["littleBirdMarker",200,"Helicopter is too far from helipad at base. Get within 10m and try again..."],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];	
	//add rearm command
	//[littleBird,["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",2]; removeAllActions littleBird;},nil,1.5,FALSE,true,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];
	//[littleBird,["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",-2];
	[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
};