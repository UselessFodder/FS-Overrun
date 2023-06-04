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
	 

	
	 private _maxZ = _this select 1;
	 //get the nearest whole max Z count from maxZ * infection rate
	 private _currentMaxZ = round (_maxZ * _infectionRate);
	 
	 //update zone size
	 [_locationIndex] execVM "resizeMarkers.sqf";

	//Build spawnpoint array to area within colored marker
	//private _spawnArray = allMapMarkers select {[_location, getMarkerPos _x] call BIS_fnc_inTrigger};
	private _spawnArray = [];
	while {(count _spawnArray) < (_maxZ/2)} do {
		//select random spawnpoint not inside an object
		private _locStartSpawn = [ZoneArray select _locationIndex select 0, false] call CBA_fnc_randPosArea;
		private _saveSpawn = _locStartSpawn findEmptyPosition [0,10];
		
		//push into _spawnArray
		_spawnArray pushBack _saveSpawn;
		
	};

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
				
				//prep to spawn a random amount of the remaining Z's needed
				_spawnCount = (_currentMaxZ - _numZ) / (random [3,4,5]);
				
				//make sure groups no larger than 4 spawn
				if (_spawnCount > 4) then {
					_spawnCount = 4;
				};
				
				//spawn group, fill with zombies, and give them randomized orders
				[_locationIndex, _spawnCount,_currentSpawn, _perKill] execVM "areaZCreate.sqf";
				
				//[_temp_Group,_locationIndex] execVM "areaOrders.sqf";
			
		
			}; 
		} else {
			//if isInfected has changed to false, exit spawner
			//ZoneArray select _locationIndex select 3 = false;
		}; //end if-else isInfected = true
		

		sleep 0.2;
			
	};//end while{true}

			//Log
			diag_log format ["Area %1 initialized. Current infection is %2", _location, ZoneArray select _locationIndex select 2];

	//call area_spawn to begin slower spawns
	null = [_locationIndex,_spawnArray,_maxZ] execVM "area_spawn.sqf";

};	

