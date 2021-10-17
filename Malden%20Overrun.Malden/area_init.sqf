/*
	Initializes area to full zombies and then calls area_spawn
*/
if(isServer) then {

	params["_locationIndex","_maxZ"];

	private _locationIndex = _this select 0;
	 
	 private _location = ZoneArray select _locationIndex select 0;
	 private _isInfected = ZoneArray select _locationIndex select 1;
	 private _infectionRate = ZoneArray select _locationIndex select 2;	 
	 
	 	//Log
		diag_log format ["Initializing area %1. Current infection is %2", _location, ZoneArray select _locationIndex select 2];
	 
	 //Build spawnpoint array to area within colored marker
	 private _spawnArray = allMapMarkers select {[_location, getMarkerPos _x] call BIS_fnc_inTrigger};

	 private _maxZ = _this select 1;
	 //get the nearest whole max Z count from maxZ * infection rate
	 private _currentMaxZ = round (_maxZ * _infectionRate);

	 _numZ = {_x inArea _location && side _x == east} count allunits;
	 _zCount = 0;
	 _perKill = (1/_maxZ)/2;

	while{ZoneArray select _locationIndex select 3 == true && _numZ < _currentMaxZ} do { 		

		//check if isInfected is still true
		_isInfected = ZoneArray select _locationIndex select 1;
		if(_isInfected) then {
			//get updated infection rate
			_infectionRate = ZoneArray select _locationIndex select 2;
			
			//update maxZ based on infectionRate
			_currentMaxZ = _maxZ * _infectionRate;

			//get Z count
			_numZ = {_x inArea _location && side _x == east} count allunits;
			
			//if below max Z
			if(_numZ < _currentMaxZ) then {
				//create group to put Z's in
				private _temp_Group = createGroup[EAST,true]; 				
			
			//select a position for new group and ensure it's more than 30m from the party
			private _locCheck = false;
			private _locCheckCounter = 0;
			private _minimumDistance = 30;
			private _currentSpawn = [0,0,0];
			
			while {!_locCheck} do {
				if (_locCheckCounter < 5) then {
					
					//select random spawnpoint
					_startSpawn = [ZoneArray select _locationIndex select 0, false] call CBA_fnc_randPosArea;
					_currentSpawn = _startSpawn findEmptyPosition [0,10];
					
					//default _locCheck to true and only change to false if a player is too close to the spawn
					_locCheck = true;
					
					//check if it is within minimum distance of a player
					{
						//_currentDistance = getMarkerPos _currentSpawn distance _x;
						_currentDistance = _currentSpawn distance _x;
						if (_currentDistance < _minimumDistance) then {
							//*** debug
							diag_log format ["Cannot use spawn as it is within %1 of a player, less than the minimum of %2", _currentDistance, _minimumDistance];
						
							//if the spawn is too close, change _locCheck to false so the check runs again
							_locCheck = false;
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
				
				//make sure groups no larger than 4 spawn
				if (_spawnCount > 4) then {
					_spawnCount = 4;
				};
				
				//for each Z, create a random Z from global ZList (init.sqf)
				for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
					//create Z
					_newZ = _temp_Group createUnit[(ZList select (random[0, 7, 15])), _currentSpawn, [], 5, "NONE"]; 
					//set random skill level
					_newZ setSkill _currentSkill;
					
						//add variables to _newZ so I can access them in EH
					_newZ setVariable["_killedValues",[_locationIndex, _perKill], false];
			
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
				
				//get random point from _waypointArray ***FIX TO USE 75% of the time later
				//_currentWaypoint = selectRandom _waypointArray;
				
				// get random point inside zone
				_currentWaypoint = [ZoneArray select _locationIndex select 0, false] call CBA_fnc_randPosArea;
				
				switch (selectRandom[4]) do {
					case 0: {[_temp_Group, _currentWaypoint, 20] call BIS_fnc_taskPatrol};
					case 1: {[_temp_Group, _currentWaypoint] call BIS_fnc_taskDefend};
					case 2: {[_temp_Group, _currentSpawn,5] call BIS_fnc_taskPatrol};
					case 3: {_orderPos = getPos (nearestBuilding _currentWaypoint); _temp_Group move _orderPos};
					case 4: {								
								_centerPos = ZoneArray select _locationIndex select 0;
								
								//find which axis is smaller and select that
								_centerPosX = getMarkerSize _centerPos select 0;
								_centerPosY = getMarkerSize _centerPos select 1;
								_orderRadius = _centerPosY;
								if (_centerPosX >= _centerPosY) then {
									_orderRadius = _centerPosX;
								};
								
								//randomize radius near center
								_orderRadius = random [1, _orderRadius *.25, _orderRadius * .75];
								
								//get a random position near zone center and order zombies to it
								_orderPos =  [getMarkerPos _centerPos, _orderRadius] call CBA_fnc_randPos;
								[_temp_Group, _orderPos, 10] call BIS_fnc_taskPatrol;
							};
						
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
			//ZoneArray select _locationIndex select 3 = false;
		}; //end if-else isInfected = true
		
		//hint format ["Number of current zombies: %1 of %2", _numZ, _currentMaxZ]; ***
		sleep 0.2;
			
	};//end while{true}

			//Log
			diag_log format ["Area %1 initialized. Current infection is %2", _location, ZoneArray select _locationIndex select 2];

	//call area_spawn to begin slower spawns
	null = [_locationIndex,_spawnArray,_maxZ] execVM "area_spawn.sqf";

};	

