/*
	Adds correct command to littleBird based on passed value
*/

params["_littleBirdArmed"];

_littleBirdArmed = _this select 0;

//check if littleBird is still armed
if(_littleBirdArmed == true) then {
	//if so, add decon command
	//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",-2];
	littleBird addAction ["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""];
} else {
	//if not, add rearm command
	littleBird addAction ["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""];
};