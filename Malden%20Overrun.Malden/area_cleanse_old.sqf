/*
    File: area_cleanse.sqf
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

params["_locationIndex","_location"];

private _locationIndex = _this select 0;
private _location = Locations select _locationIndex;
private _deconMan = null;

	//get playercount and set appropriate amount of zombies
	private _maxZ = 14;

	//if there is only 1 player, 10 Zs is too easy
	if (count allPlayers > 2) then {
		_maxZ = (count allPlayers) * 7;
	};

	//ensure the zombie count doesn't get too excessive
	if (_maxZ > 70) then {
		_maxZ = 70;
	};

	//array to hold all spawnable locations
	private _spawnLocs = [];

	//array to hold current number of Zs
	private _numZ = nil;

	//get all markers within 75m, but more than 15m from deconTruck
	{
		_currentDistance = deconTruck distance getMarkerPos _x;
		if (_currentDistance > 15 && _currentDistance < 76) then {
			_spawnLocs pushBack _x;
		};	

	} forEach allMapMarkers;

	//get start amount of zombies
	_numZ = {_x inArea _location && side _x == east} count allunits;

//if(isServer) then {

	//spawn invisible man in deconTruck to cause Zs to attack
	// FIX THIS SPAGHETTI CODE ***
If(isNull _deconMan) then {
	_decon = createGroup [west, deleteWhenEmpty];
	_decon addVehicle deconTruck; 
	deconTruck lock true;
	deconTruck lockDriver true;
	_deconMan = _decon createUnit ["B_Survivor_F", getPos deconTruck,[],5, "NONE"];
	[_deconMan] orderGetIn true;
	_deconMan setBehaviour "CARELESS";
	_deconMan assignAsCargo deconTruck;
	_deconMan moveInCargo [deconTruck,0];
	deconTruck allowCrewInImmobile true;
	//if deconMan gets out, delete him
	_deconMan addEventHandler ["GetOutMan", {params ["_unit", "_role", "_vehicle", "_turret"]; deleteVehicle _unit;}];
};

//begin the countdown
[150,false] call BIS_fnc_countdown;

//every 0.5 seconds, check if the deconTruck is still alive. If so, check if there are fewer than maxZ and spawn the difference between them at random _spawnLocs
while{CleanseActive} do {
	//check if deconTruck is still alive. If not, delete driver, set cleanseactive to false, and kill countdown timer
	if (isNull deconTruck == true || deconTruck getHitPointDamage "HitEngine" == 1 || deconTruck getHitPointDamage "HitHull" == 1 || deconTruck getHitPointDamage "HitFuel" == 1) then {
		/*if(isServer) then {
			remove driver
			deleteVehicle _deconMan;
		};	*/
		
		//set cleanseActive to false
		CleanseActive == false;	
		publicVariable "CleanseActive";		
				
		//kill timer & refresh hint
		[-1] call BIS_fnc_countdown;
		//inform the user
		//titleText ["DECON Vehicle destroyed. Area is not decontaminated...", "PLAIN"];
				
	} else { //if not, then check if timer is complete
	
		_timeLeft = [0] call BIS_fnc_countdown;
	//***[[format ["Time Left: %1", _timeLeft], "PLAIN"]] remoteExec ["titleText", 0];
		//if timer is complete, set area to not infected and clear cleanseActive
		if ( _timeLeft == 0) then {
		//if([true] call BIS_fnc_countdown != true) then {
		
		//***[["Cleanup initiated", "PLAIN"]] remoteExec ["titleText", 0];
			if(isServer) then {
				//*** ["Time complete", "PLAIN"] remoteExec ["titleText", 0];				
				//set area to no longer infected
				isInfected set [_locationIndex, false];
				publicVariable "IsInfected";
				
				//kill all zombies in area
				_killZ = {_x inArea _location && side _x == east} count allunits;
				
				{
					if(_x inArea _location && side _x == east) then {
						_x setDamage 1;
					};
				} forEach allunits;
				
				//unlock truck and delete deconMan
				deconTruck lock false;
				deconTruck lockDriver false;
				deleteVehicle _deconMan;		
				
				//save state
				//sleep 15;
				execVM "saveState.sqf";
			};
			
			//clear decon status
			CleanseActive = false;
			publicVariable "CleanseActive";
		
		}else { //if timer is not complete, update hint and spawn more zombies
			//update hint
			//hint format ["%1 until DECON", floor _timeLeft];
			//[format ["%1 until DECON", _timeLeft]] remoteExec ["hint", 0];
			//[format ["Time left: %1", _timeLeft], "PLAIN"] remoteExec ["titleText", 0];
			
			if(isServer) then {		
				//get Z count
				//_numZ = {_x inArea _location && side _x == east} count allunits;
				_numZ = {((_x distance deconTruck) < 75) && side _x == east} count allunits;
				
				//if below max ZList
				if(_numZ < _maxZ) then {
				
					//set skill for next group
					//private _currentSkill = selectRandom [0.2,0.3,0.4,0.5,0.6,0.7];
					private _currentSkill = 1;
					
					//prep to spawn a random amount of the remaining Z's needed
					_spawnCount = (_maxZ - _numZ) / (random [2,3,4]);
					
					for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
					
						//create group to put Z's in
						private _temp_Group = createGroup[EAST,true]; 
						
						//select a position for new group
						private _currentSpawn = selectRandom _spawnLocs;
						

						
						//for each Z, create a random Z from global ZList (init.sqf)
						//for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
							//create Z
							_newZ = _temp_Group createUnit[(ZList select (random[0, 7, 15])), getMarkerPos _currentSpawn, [], 3, "NONE"]; 
							//set random skill level
							_newZ setSkill _currentSkill;
						//};	
						
							//set behavior of group	
							_temp_Group setBehaviour "COMBAT";					
							
							//order to either destroy vehicle or attack area
						/*	switch (selectRandom[0,1]) do {
								case 0: {[_temp_Group, getPos deconTruck] call BIS_fnc_taskAttack};
								case 1: {{_x doTarget deconTruck} forEach units _temp_Group};

							};//end switch	
						*/
							// Set group to attack deconTruck area. ***
							//[_temp_Group, getMarkerPos "deconTruckMarker"] call BIS_fnc_taskAttack;
							
							//set to new group to each spawn operates separately
							_id = time;
							_groupVarName = format ["EastGroup:%1", _id];
							missionNamespace setVariable [_groupVarName,_temp_Group];	
							
							// Set group to attack deconTruck area. ***
							[_groupVarName, getMarkerPos "deconTruckMarker"] call BIS_fnc_taskAttack;


					};
			
				};
			};
			
		};//end else
	};//end else
	
	//delay 0.5 seconds
	sleep 1;
};
//};
/*  ***
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

while{ActiveSpawn select _locationIndex == true} do{ 		
	//check if isInfected is still true
	if(_isInfected) then {
		//get updated infection rate and value to change to per kill
		_infectionRate = InfectionRate select _locationIndex;
		
		//update maxZ based on infectionRate
		_currentMaxZ = _maxZ * _infectionRate;

		//get Z count
		_numZ = {_x inArea _location && side _x == east} count allunits;
		
		//if below max Z
		if(_numZ < _currentMaxZ) then {
			//adjust infection rate based on number of missing Zs
			if(_numZ < (_currentMaxZ * 0.9)) then {InfectionRate set [_locationIndex, _infectionRate - (_perKill * (_currentMaxZ - _numZ))];};
		
			//create group to put Z's in
			private _temp_Group = createGroup[EAST,true]; 
			
			//select a position for new group
			private _currentSpawn = selectRandom _spawnArray;
			
			//set skill for next group
			private _currentSkill = selectRandom [0.2,0.3,0.4,0.5,0.6,0.7];
			
			//prep to spawn a random amount of the remaining Z's needed
			_spawnCount = (_currentMaxZ - _numZ) / (random [3,4,5]);
			
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
		ActiveSpawn select _locationIndex set false;
	}; //end if-else isInfected = true

	//display current infection rate
	hint Format ["%1 infection rate: %2 %3", _location, Floor (_infectionRate * 100), "%"];
	
	//hint format ["Number of current zombies: %1 of %2", _numZ, _currentMaxZ]; ***
	sleep 5;
		
};//end while{true}
	
*/
