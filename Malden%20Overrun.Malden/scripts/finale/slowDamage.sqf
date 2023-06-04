/*
	Script to slowly damage players over time while inside the zone
	Params: 0 - Unit that trigger is called on, 1 - Zone to check if unit is inside
*/

params["_affectedUnit","_currentZone"];

diag_log format ["** %1 has entered restricted zone %2. Starting slowDamage", _affectedUnit, _currentZone];

while {_affectedUnit inArea _currentZone} do {
	//wait between damages
	sleep 5;
	
	//cause ace damage to chest as infection takes over
	[_affectedUnit, 0.4, "body", "unknown"] call ace_medical_fnc_addDamageToUnit;


};

diag_log format ["** %1 is no longer being affected by slowDamage", _affectedUnit];