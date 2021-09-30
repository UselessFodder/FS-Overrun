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

params["_locationIndex","_spawnArray","_waypointArray","_maxZ"];

 private _locationIndex = _this select 0;
 private _location = Locations select _locationIndex;
 private _isInfected = IsInfected select _locationIndex;
 private _infectionRate = InfectionRate select _locationIndex;
 
 _spawnArray = _this select 1;
 _waypointArray = _this select 2;
 _maxZ = _this select 3;

 _numZ = {_x inArea _location && side _x == east} count allunits;
 _zCount = 0;
 _perKill = 1/_maxZ;

objectiveComplete = true;
publicVariable "objectiveComplete";

_currentInfection = _infectionRate;
_previousInfection = _infectionRate;
_infectionHoldRate = InfectionRate select _locationIndex;


while{ActiveSpawn select _locationIndex == true} do{ 		
	//check if isInfected is still true
	if(_isInfected) then {
		//get updated infection rate and value to change to per kill
		_infectionRate = InfectionRate select _locationIndex;		
		
		//update maxZ based on infectionRate to nearest whole Z
		_currentMaxZ = round (_maxZ * _infectionRate);

		//get Z count
		_numZ = {_x inArea _location && side _x == east} count allunits;
		
		//if below max Z
		if(_numZ < _currentMaxZ) then {
			
			//either start mission or adjust infection rate
			
			//check if current infection rate is below threshold and last one wasn't
			_currentInfection  = _infectionRate - (_perKill * (_currentMaxZ - _numZ));	
			
			if(_currentInfection < 0.8 && _previousInfection > 0.8) then {
				InfectionRate set [_locationIndex, 0.8];
				_infectionHoldRate = 0.8;
				_currentInfection = 0.8;
				_previousInfection = 0.8;
				[_locationIndex,_spawnArray,_waypointArray] execVM "miniObjective.sqf";
				objectiveComplete = false;
				publicVariable "objectiveComplete";
				
			} else {
				if(_currentInfection < 0.6 && _previousInfection > 0.6) then {
					InfectionRate set [_locationIndex, 0.6];
					_infectionHoldRate = 0.6;
					_currentInfection = 0.6;
					_previousInfection = 0.6;
					[_locationIndex,_spawnArray,_waypointArray] execVM "miniObjective.sqf";	
					objectiveComplete = false;
					publicVariable "objectiveComplete";
					
				} else {
					if(_currentInfection < 0.4 && _previousInfection > 0.4) then {
						InfectionRate set [_locationIndex, 0.4];
						_infectionHoldRate = 0.4;
						_currentInfection = 0.4;
						_previousInfection = 0.4;
						[_locationIndex,_spawnArray,_waypointArray] execVM "miniObjective.sqf";
						objectiveComplete = false;
						publicVariable "objectiveComplete";
						
					}else {
						if(_currentInfection < 0.2 && _previousInfection > 0.2) then {
							InfectionRate set [_locationIndex, 0.2];
							_infectionHoldRate = 0.2;
							_currentInfection = 0.2;
							_previousInfection = 0.2;
							[_locationIndex,_spawnArray,_waypointArray] execVM "miniObjective.sqf";
							objectiveComplete = false;
							publicVariable "objectiveComplete";
							titleText ["20% reached","PLAIN"];
							
						} else {
							//objectiveComplete = true;
							//publicVariable "objectiveComplete";
						};
					};
				};
			};
				
				////if no mission isrunning, then update infectionRate
				if(objectiveComplete == true) then {				
					InfectionRate set [_locationIndex, _infectionRate - (_perKill * (_currentMaxZ - _numZ))];
					//set _previousInfection to test for mission start
					_previousInfection = _currentInfection;	
					//[[format ["New infection rate is %1, objectiveComplete = %2", InfectionRate select _locationIndex, objectiveComplete], "PLAIN"]] remoteExec ["titleText", 0]; //TESTING***

					
				} else {
					InfectionRate set [_locationIndex, _infectionHoldRate];
				}; 			
				
		
		
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
			
			switch (selectRandom[0,1,2,3]) do {
				case 0: {[_temp_Group, getMarkerPos _currentWaypoint, 20] call BIS_fnc_taskPatrol};
				case 1: {[_temp_Group, getMarkerPos _currentWaypoint] call BIS_fnc_taskDefend};
				case 2: {[_temp_Group, getMarkerPos _currentSpawn,5] call BIS_fnc_taskPatrol};
				case 3: {[_temp_Group, getMarkerPos _currentSpawn] call BIS_fnc_taskDefend}
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
		
		//clear hint
		//hint "";
		[""] remoteExec ["hint", 0];
		
	}; //end if-else isInfected = true

	//if decon is not in process
	if(!CleanseActive) then {
		//check if area is infected
		if(isInfected select _locationIndex) then {
			//display current infection rate
			_updatedInfection = InfectionRate select _locationIndex;
			[Format ["%1 infection rate: %2 %3", _location, round (_updatedInfection * 100), "%"]] remoteExec ["hint", 0];
			//hint Format ["%1 infection rate: %2 %3", _location, Floor (_infectionRate * 100), "%"];	
		} else {
			//display area DECONNED
			[Format ["%1 has been decontaminated.", _location]] remoteExec ["hint", 0];
			//hint Format ["%1 has been decontaminated.", _location];	
		};
	};
	
	//hint format ["Number of current zombies: %1 of %2", _numZ, _currentMaxZ]; ***
	sleep 5;
		
};//end while{true}
	

