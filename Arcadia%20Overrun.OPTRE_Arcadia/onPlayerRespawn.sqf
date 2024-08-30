/*
	Remove any default equipment and set arsenal items on respawn
*/

private _loadout = player getVariable ["savedLoadout", []];

// Check if there is a saved loadout
if (!(_loadout isEqualTo [])) then {
	// Restore the unit's loadout when they respawn
	player setUnitLoadout _loadout;
};

//set default insignia
[_this select 0, "brt_gray"] call BIS_fnc_setUnitInsignia;

_deadBody = _this select 1;

//if body is in the base, then delete it
if (_deadBody distance getMarkerPos "FOB" < 50) then{
	deleteVehicle _deadBody;
};
