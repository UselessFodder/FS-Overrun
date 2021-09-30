/*
	Initializes area to full zombies and then calls area_spawn
*/
if(isServer) then {

	params["_locationIndex","_spawnArrayOLD","_waypointArrayOLD","_maxZ"];

	 private _locationIndex = _this select 0;
	 //private _location = Locations select _locationIndex;
	 //private _isInfected = IsInfected select _locationIndex;
	 //private _infectionRate = InfectionRate select _locationIndex;
	 
	 private _location = ZoneArray select _locationIndex select 0;
	 private _isInfected = ZoneArray select _locationIndex select 1;
	 private _infectionRate = ZoneArray select _locationIndex select 2;	 
	 
	 //Build spawnpoint array to area within colored marker
	 //private _spawnArray = _this select 1;
	 //private _spawnArray = allMapMarkers select {((getMarkerPos _x) distance (getMarkerPos _location)) <= 2000};
	 private _spawnArray = allMapMarkers select {[_location, getMarkerPos _x] call BIS_fnc_inTrigger};
	 private _waypointArray = _spawnArray;
	 	
	 _waypointArray = _this select 2;
	 _maxZ = _this select 3;
	 //get the nearest whole max Z count from maxZ * infection rate
	 private _currentMaxZ = round (_maxZ * _infectionRate);

	 _numZ = {_x inArea _location && side _x == east} count allunits;
	 _zCount = 0;
	 _perKill = (1/_maxZ)/2;

	//while{ActiveSpawn select _locationIndex == true && _numZ < _currentMaxZ} do{ 		
	while{ZoneArray select _locationIndex select 3 == true && _numZ < _currentMaxZ} do{ 		

		//check if isInfected is still true
		if(_isInfected) then {
			//get updated infection rate
			//_infectionRate = InfectionRate select _locationIndex;
			_infectionRate = ZoneArray select _locationIndex select 2;
			
			//update maxZ based on infectionRate
			_currentMaxZ = _maxZ * _infectionRate;

			//get Z count
			_numZ = {_x inArea _location && side _x == east} count allunits;
			
			//if below max Z
			if(_numZ < _currentMaxZ) then {
				//create group to put Z's in
				private _temp_Group = createGroup[EAST,true]; 
				
			//select a position for new group and ensure it's more than 20m from the party
			private _locCheck = false;
			private _locCheckCounter = 0;
			private _minimumDistance = 30;
			private _currentSpawn = selectRandom _spawnArray;
			
			while {!_locCheck} do {
				if (_locCheckCounter < 5) then {
					//select a spawnpoint
					_currentSpawn = selectRandom _spawnArray;	
					
					//check if it is within minimum distance of a player
					{
						_currentDistance = getMarkerPos _currentSpawn distance _x;
						if (_currentDistance > _minimumDistance) then {
							_locCheck = true;
						};							
					} forEach allPlayers;
					
					//increment counter
					_locCheckCounter = _locCheckCounter + 1;
				} else {
						//if no location can be found in 5 tries, lower the distance and try again
						if (_minimumDistance > 5) then {
							_minimumDistance = _minimumDistance - 2;
							_locCheckCounter = 0;							
						} else {
							//If distance is 5m, just use this as the best possible choice
							_locCheck = true;							
						};
				};
				
			};
				
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
					
						//add variables to _newZ so I can access them in EH
					_newZ setVariable["_killedValues",[_locationIndex, _perKill], false];
			/*
				//create eventhandler to lower infection rate when killed				
				_newZ addEventHandler ["Killed", {
					//check if zone is active and not in a mission or cleanse
					//if((ZoneArray select (_killedValues select 0) select 3) && (ZoneArray select (_killedValues select 0) select 4 == false) && (ZoneArray select (_killedValues select 0) select 5 == false)) then {
						//if not, get previous infectionrate value and then subtract perKill value passed into EH
						private _previousValue = ZoneArray select _locationIndex select 2;
						private _newValue = _previousValue - _perKill;
						
						ZoneArray select (_killedValues select 0) set [2, _newValue];
						hint format ["Subtracting %1 to get %2", _perKill, _newValue]; //**TESTING DELETE
						
						//add currency to faction bank for each Z killed
						[1] execVM "addToBank.sqf";
						
						
					//};
				
				}];
			*/
			
				//create eventhandler to lower infection rate when killed				
				_newZ addEventHandler ["Killed", 
					//check if zone is active and not in a mission or cleanse
					format ["if(ZoneArray select %1 select 3 && ZoneArray select %1 select 4 == false && ZoneArray select %1 select 5 == false) then {", _locationIndex] +
						//if not, get previous infectionrate value and then subtract perKill value passed into EH
						format ["private _previousValue = ZoneArray select %1 select 2;", _locationIndex] +
						format ["private _newValue = _previousValue - %1;", _perKill] +
						
						format ["ZoneArray select %1 set [2, _newValue];", _locationIndex] + 
						//format ["hint 'Subtracting %1 to get ';", _perKill, ZoneArray select _locationIndex select 2] + //**TESTING DELETE
						
						//add currency to faction bank for each Z killed
						"[1] execVM 'addToBank.sqf';" +
						
						
					"};"
				
				];
					
				};
				
				//set behavior of group randomly
				_currentBehavior = selectRandom["CARELESS","SAFE","SAFE","SAFE","SAFE","AWARE","AWARE","AWARE","AWARE","AWARE"];		
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
			//ActiveSpawn set [_locationIndex, false];
			ZoneArray select _locationIndex select 3 == false;
		}; //end if-else isInfected = true
		
		//hint format ["Number of current zombies: %1 of %2", _numZ, _currentMaxZ]; ***
		sleep 0.2;
			
	};//end while{true}

			//testing delete ***
			diag_log format ["Area %1 initialized. Current infection is %2", _location, ZoneArray select _locationIndex select 2];

	//call area_spawn to begin slower spawns
	null = [_locationIndex,_spawnArray,_waypointArray,_maxZ] execVM "area_spawn.sqf";

};	

