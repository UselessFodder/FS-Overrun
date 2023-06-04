/*
	Executes a message to all players near a given marker
*/
params ["_loc","_distance","_message"];

private _loc = _this select 0;
private _distance = _this select 1;
private _message = _this  select 2;

//titleText [_message, "PLAIN"];
//[[_message, "PLAIN"]] remoteExec ["titleText", 0];
//check if current player is within passed distance
if((player distance (getMarkerPos _loc)) <= _distance) then {
	titleText [_message, "PLAIN"];
};
