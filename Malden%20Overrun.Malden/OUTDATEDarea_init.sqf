/*
	Initializes area to full zombies and then calls area_spawn
*/
if(isServer) then {

	params["_locationIndex","_spawnArray","_waypointArray","_maxZ"];

	 private _locationIndex = _this select 0;
	 private _location = Locations select _locationIndex;
	 private _isInfected = IsInfected select _locationIndex;
	 private _infectionRate = InfectionRate select _locationIndex;

	 
	 _spawnArray = _this select 1;
	 _waypointArray = _this select 2;
	 _maxZ = _this select 3;
	 //get the nearest whole max Z count from maxZ * infection rate
	 private _currentMaxZ = round (_maxZ * _infectionRate);

	 _numZ = {_x inArea _location && side _x == east} count allunits;
	 _zCount = 0;

	while{ActiveSpawn select _locationIndex == true && _numZ < _currentMaxZ} do{ 		
		//check if isInfected is still true
		if(_isInfected) then {
			//get updated infection rate
			_infectionRate = InfectionRate select _locationIndex;
			
			//update maxZ based on infectionRate
			_currentMaxZ = _maxZ * _infectionRate;

			//get Z count
			_numZ = {_x inArea _location && side _x == east} count allunits;
			
			//if below max Z
			if(_numZ < _currentMaxZ) then {
				//create group to put Z's in
				private _temp_Group = createGroup[EAST,true]; 
				
				//select a position for new group
				private _currentSpawn = selectRandom _spawnArray;
				
				//set skill for next group
				private _currentSkill = selectRandom [0.2,0.3,0.4,0.5,0.6,0.7];
				
				//prep to spawn a random amount of the remaining Z's needed
				_spawnCount = (_currentMaxZ - _numZ) / (random [3,4,5]);
				
				//make sure groups no larger than 10 spawn
				if (_spawnCount > 10) then {
					_spawnCount = 10;
				};
				
				//for each Z, create a random Z from global ZList (init.sqf)
				for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
					//create Z
					_newZ = _temp_Group createUnit[(ZList select (random[0, 7, 15])), getMarkerPos _currentSpawn, [], 5, "NONE"]; 
					//set random skill level
					_newZ setSkill _currentSkill;
				};
				
				//set behavior of group randomly
				_currentBehavior = selectRandom["CARELESS","SAFE","SAFE","SAFE","SAFE","SAFE","SAFE","SAFE","SAFE","SAFE","SAFE","SAFE","AWARE","AWARE","AWARE"];		
				_temp_Group setBehaviour _currentBehavior;
				
				//set random formation
				_temp_Group setFormation selectRandom["WEDGE","DIAMOND","VEE","LINE"];
				
				//get random point from _waypointArray
				_currentWaypoint = selectRandom _waypointArray;
				
				switch (selectRandom[0,1,2]) do {
					case 0: {[_temp_Group, getMarkerPos _currentWaypoint, 20] call BIS_fnc_taskPatrol};
					case 1: {[_temp_Group, getMarkerPos _currentWaypoint] call BIS_fnc_taskDefend};
					case 2: {[_temp_Group, getMarkerPos _currentSpawn,5] call BIS_fnc_taskPatrol}
				};//end switch	

				//set to new group to each spawn operates separately
				_id = time;
				_groupVarName = format ["EastGroup:%1", _id];
				missionNamespace setVariable [_groupVarName,_temp_Group];	
			
			//testing delete ***
			//hint format ["Number of current zombies: %1 of %2", _numZ, _currentMaxZ];
		
			}; 
		} else {
			//if isInfected has changed to false, exit spawner
			ActiveSpawn set [_locationIndex, false];
		}; //end if-else isInfected = true
		
		//hint format ["Number of current zombies: %1 of %2", _numZ, _currentMaxZ]; ***
		sleep 0.2;
			
	};//end while{true}

			//testing delete ***
			hint format ["Area initialized"];

	//call area_spawn to begin slower spawns
	null = [_locationIndex,_spawnArray,_waypointArray,_maxZ] execVM "area_spawn.sqf";

};	

