/*
	Spawns zombies for use in other scripts
*/

params["_currentSpawn"];

_currentSpawn = _this select 0;

//create group to put Z's in
private _temp_Group = createGroup[EAST,true]; 

//for each Z, create a random Z from global ZList (init.sqf)
//for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
	//create Z
	_newZ = _temp_Group createUnit[(ZList select (random[0, 7, 15])), getMarkerPos _currentSpawn, [], 3, "NONE"]; 
	//set random skill level
	_newZ setSkill _currentSkill;
//};	

	//set behavior of group	
	_temp_Group setBehaviour "AWARE";
	_temp_Group setCombatMode "RED";
	_temp_Waypoint = _temp_Group addWaypoint [deconTruck, -1];
	_temp_Waypoint setWaypointType "SAD";
	
	_newZ setPos [getPos _newZ select 0, getPos _newZ select 1, (getPos _newZ select 2) + 0.5]; //***
	
	//order to either destroy vehicle or attack area
/*	switch (selectRandom[0,1]) do {
		case 0: {[_temp_Group, getPos deconTruck] call BIS_fnc_taskAttack};
		case 1: {{_x doTarget deconTruck} forEach units _temp_Group};

	};//end switch	
*/
	// Set group to attack deconTruck area. ***
	//[_temp_Group, getMarkerPos "deconTruckMarker"] call BIS_fnc_taskAttack;
	
	//set to new group & waypoint to each spawn operates separately
	_id = time;
	_groupVarName = format ["EastGroup:%1", _id];
	_groupWayName = format ["EastWaypoint:%1", _id];
	missionNamespace setVariable [_groupVarName,_temp_Group];
	missionNamespace setVariable [_groupWayName,_temp_Waypoint];
	
	// Set group to attack deconTruck area. ***
	//[_groupVarName, getMarkerPos "deconTruckMarker"] call BIS_fnc_taskAttack;	
	
	_spawnDone = "true";
	_spawnDone