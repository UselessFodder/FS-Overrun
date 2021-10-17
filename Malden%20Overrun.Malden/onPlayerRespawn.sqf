/*
	Remove any default equipment and set basic items on respawn
*/

//set default insignia
[_this select 0, "brt_gray"] call BIS_fnc_setUnitInsignia;

_deadBody = _this select 1;

//if body is in the base, then delete it
if (_deadBody distance getMarkerPos "FOB" < 50) then{
	deleteVehicle _deadBody;
};
