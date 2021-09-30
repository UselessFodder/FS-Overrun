/*
	Adds amount of currency passed into FactionBank
*/

params ["toAdd"];

_toAdd = _this select 0;

FactionBank = FactionBank + _toAdd;
publicVariable "FactionBank";