/*
	Adds amount of currency passed into FactionBank
*/

params ["_toAdd"];

_toAdd = _this select 0;

FactionBank = FactionBank + _toAdd;
publicVariable "FactionBank";