/*
	Runs timer to update every 0.5 seconds
	Params: 0 - Location to send the hintNear to
*/

params["_location","_message"];

_timeLeft = [0] call BIS_fnc_countdown;		

while {_timeLeft > 0} do {
	_timeLeft = [0] call BIS_fnc_countdown;	
	[[_location,300, format [_message, floor _timeLeft]],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
	sleep 0.5;
}