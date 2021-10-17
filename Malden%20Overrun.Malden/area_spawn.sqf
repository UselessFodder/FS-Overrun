/*
    File: area_Spawn.sqf
    Author: UselessFodder
    Date: 2020-10-18
    Last Update: 2020-10-18

    Description:
        Spawns zombies in 

*/

/*
	if # of zombies in passed marker < passed total # of Z
		spawn random zombie type at random _SP#
*/

//params["_locationIndex","_spawnArray","_maxZ"];

 private _locationIndex = _this select 0;
 private _spawnArray = _this select 1;
 private _maxZ = _this select 2;
 
 	 private _location = ZoneArray select _locationIndex select 0;
	 private _isInfected = ZoneArray select _locationIndex select 1;
	 private _infectionRate = ZoneArray select _locationIndex select 2;

 _numZ = {_x inArea _location && side _x == east} count allunits;
 _zCount = 0;
 _perKill = (1/_maxZ)/2;


_currentInfection = _infectionRate;
_previousInfection = _infectionRate;
//_infectionHoldRate = InfectionRate select _locationIndex;
_infectionHoldRate = ZoneArray select _locationIndex select 2;


//while{ActiveSpawn select _locationIndex == true} do{ 		
//while zone is active
while{ZoneArray select _locationIndex select 3 == true} do{ 		
	//check if isInfected is still true
	_isInfected = ZoneArray select _locationIndex select 1;
	if(_isInfected) then {
		//get updated infection rate and value to change to per kill
		//_infectionRate = InfectionRate select _locationIndex;		
		_infectionRate = ZoneArray select _locationIndex select 2;
		
		//update maxZ based on infectionRate to nearest whole Z
		_currentMaxZ = round (_maxZ * _infectionRate);

		//get Z count
		_numZ = {_x inArea _location && side _x == east} count allunits;
		
		//if below max Z
		if(_numZ < _currentMaxZ) then {
			
			//either start mission or adjust infection rate
			//_currentInfection  = _infectionRate - (_perKill * (_currentMaxZ - _numZ));	
			_currentInfection = _infectionRate;
			
			//check if current infection rate is below threshold and last one wasn't				
			if(_currentInfection < 0.8 && _previousInfection > 0.8) then {
				//InfectionRate set [_locationIndex, 0.8];
				ZoneArray select _locationIndex set [2, 0.8];
				_infectionHoldRate = 0.8;
				_currentInfection = 0.8;
				_previousInfection = 0.8;
				[_locationIndex,_spawnArray] execVM "miniObjective.sqf";
				
				
			} else {
				if(_currentInfection < 0.6 && _previousInfection > 0.6) then {
					//InfectionRate set [_locationIndex, 0.6];
					ZoneArray select _locationIndex set [2, 0.6];
					_infectionHoldRate = 0.6;
					_currentInfection = 0.6;
					_previousInfection = 0.6;
					[_locationIndex,_spawnArray] execVM "miniObjective.sqf";	
					
				} else {
					if(_currentInfection < 0.4 && _previousInfection > 0.4) then {
						//InfectionRate set [_locationIndex, 0.4];
						ZoneArray select _locationIndex set [2, 0.4];
						_infectionHoldRate = 0.4;
						_currentInfection = 0.4;
						_previousInfection = 0.4;
						[_locationIndex,_spawnArray] execVM "miniObjective.sqf";
						
					}else {
						if(_currentInfection < 0.2 && _previousInfection > 0.2) then {
							//InfectionRate set [_locationIndex, 0.2];
							ZoneArray select _locationIndex set [2, 0.2];
							_infectionHoldRate = 0.2;
							_currentInfection = 0.2;
							_previousInfection = 0.2;
							[_locationIndex,_spawnArray] execVM "miniObjective.sqf";							
							
						} else {
							//objectiveComplete = true;
							//publicVariable "objectiveComplete";
						};
					};
				};
			};
				
				////if no mission is running, then update infectionRate			
				if (ZoneArray select _locationIndex select 4 == false) then {
					//InfectionRate set [_locationIndex, _infectionRate - (_perKill * (_currentMaxZ - _numZ))];					
					ZoneArray select _locationIndex set [2,_infectionRate];
					
					//set _previousInfection to test for mission start
					_previousInfection = _currentInfection;					
					
				} else {
					//InfectionRate set [_locationIndex, _infectionHoldRate];
					ZoneArray select _locationIndex set [2, _infectionHoldRate];
				}; 			
				
		
		
			//create group to put Z's in
			private _temp_Group = createGroup[EAST,true]; 
			
			//select a position for new group and ensure it's more than 20m from the party
			private _locCheck = false;
			private _locCheckCounter = 0;
			private _minimumDistance = 30;
			private _currentSpawn = [ZoneArray select _locationIndex select 0, false] call CBA_fnc_randPosArea;
			
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
			
			//make sure groups no larger than 6 spawn
			if (_spawnCount > 6) then {
				_spawnCount = 6;
			};
			
			//for each Z, create a random Z from global ZList (init.sqf)
			for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
				//create Z
				_newZ = _temp_Group createUnit[selectRandom ZList, _currentSpawn, [], 5, "NONE"]; 
				//set random skill level
				_newZ setSkill _currentSkill;
			
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
			_currentBehavior = selectRandom["CARELESS","SAFE","SAFE","AWARE","AWARE","AWARE"];		
			_temp_Group setBehaviour _currentBehavior;
			
			//set random formation
			_temp_Group setFormation selectRandom["WEDGE","DIAMOND","VEE","LINE"];
			
			//get random point from _waypointArray
			//_currentWaypoint = selectRandom _waypointArray;
			
			// get random point inside zone
			_currentWaypoint = [ZoneArray select _locationIndex select 0, false] call CBA_fnc_randPosArea;
			
			switch (selectRandom[0,1,2,3,4,4,4,4]) do {
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
		
		//clear hint
		[[_location,500,""],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
		
	}; //end if-else isInfected = true

	//if decon is not in process
	if(!CleanseActive) then {
		//check if area is infected
		if(ZoneArray select _locationIndex select 1) then {
			//display current infection rate
			//_updatedInfection = InfectionRate select _locationIndex;
			_updatedInfection = ZoneArray select _locationIndex select 2;
			[[_location,400,Format ["%1 infection rate: %2 %3", _location, round (_updatedInfection * 100), "%"]],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
		} else {
			//display area DECONNED
			[[_location,300,Format ["%1 has been decontaminated.", _location]],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
			//hint Format ["%1 has been decontaminated.", _location];	
		};
	};
	
	
	sleep 2;
		
};//end while{true}

//end any ongoing missions to allow them to become active again
ZoneArray select _locationIndex set [4, false];

//testing delete ***
diag_log format ["Area %1 deactivated. Current infection is %2", _location, ZoneArray select _locationIndex select 2];
	
//clear area hint
[[_location,500,""],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0];