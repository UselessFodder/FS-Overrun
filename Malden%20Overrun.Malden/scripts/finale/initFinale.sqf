/*
	Script to initialize the Finale area event
*/
//total defend time on final objective in seconds
_defendTimer = 480; //8 minutes

//number of zombies for phase 0
_zombieCount0 = 60;
//number of zombies for phase 1
_zombieCount1 = 70;
//number of zombies for phase 2
_zombieCount2 = 80;
//number of zombies for phase 3
_zombieCount3 = 100;

//lower numbers for smaller groups
if (count allPlayers <= 6) then {
	_zombieCount0 = _zombieCount0 *0.75;
	_zombieCount1 = _zombieCount1 *0.75;
	_zombieCount2 = _zombieCount2 *0.75;
	_zombieCount2 = _zombieCount3 *0.75;
};

//number of zombies for current phae
_zombieCountCurrent = _zombieCount0;

//spawn location
_location = "finaleArea";


//start at the correct phase
FinalePhase = 0;
publicVariable "FinalePhase";

//default sleep timer
_sleepTimer = 5;

//Keeps track of interrupts
_phaseInterrupt = 0;

//show first objective
"generatorStart" setMarkerAlpha 1;
	
//create a task notification
["TaskAssigned", ["", format ["Restart the base generator"]]] remoteExec ['BIS_fnc_showNotification',0,FALSE];

//notify
diag_log "Initialized Finale Event";
	
//start while zombie spawning loop for phases 0 - 3
while {FinalePhase <= 3} do {
		//get Z count
		_numZ = {_x inArea _location && side _x == east} count allunits;
		
		//update spawn timer to allow initial burst of spawns
		if(_numZ < (_zombieCountCurrent *.75)) then {
			_sleepTimer = 0.5;
		} else {
			_sleepTimer = 5;
		};
		
		//if the area is under the current zombie count
		if (_numZ < _zombieCountCurrent) then {
			//create group to put Z's in
			private _temp_Group = createGroup[EAST,true]; 
			
			//select a position for new group and ensure it's more than 20m from the party
			private _locCheck = false;
			private _locCheckCounter = 0;
			private _minimumDistance = 30;
			private _currentSpawn = [_location, false, "Man"] call CBA_fnc_randPosArea;
			
			while {!_locCheck} do {
				if (_locCheckCounter < 5) then {
					
					//select random spawnpoint
					_startSpawn = [_location, false, "Man"] call CBA_fnc_randPosArea;
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
			_spawnCount = ((_zombieCountCurrent - _numZ) / (random [3,4,5]));
			
			//make sure groups no larger than 6 spawn
			if (_spawnCount > 6) then {
				_spawnCount = 6;
			};
			
			//for each Z, create a random Z from global ZList (init.sqf)
			for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
				//create Z
				_newZ = _temp_Group createUnit[selectRandom ZList, _currentSpawn, [], 5, "NONE"]; 

			};
			
			//set random formation
			_temp_Group setFormation selectRandom["WEDGE","DIAMOND","VEE","LINE"];
			
			// get random point inside zone
			//_currentWaypoint = [_location, false] call CBA_fnc_randPosArea;
			
			//order zombies based on phase
			[_temp_Group] execVM "unstickZombies.sqf";
			
	/*	
			switch(FinalePhase) do {
				//phase 0, zombies just patrol around
				case 0: {
				/*
					//get total marker size
					private _currentZone = MarkerSize _location;
					//get 10% of the average of the zone's total size
					private _patrolDistance = ((_currentZone select 0) + (_currentZone select 1)) * 0.15;
					
					//local patrol					
					[_temp_Group, _currentSpawn,_patrolDistance] call BIS_fnc_taskPatrol
				/
					//send zombies to center
					_centerPos = _location;
					
					//find which axis is smaller and select that
					_centerPosX = getMarkerSize _centerPos select 0;
					_centerPosY = getMarkerSize _centerPos select 1;
					_orderRadius = _centerPosY;
					if (_centerPosX <= _centerPosY) then {
						_orderRadius = _centerPosX;
					};
					
					//randomize radius near center of current zone size
					_orderRadius = random [1, _orderRadius *.25, _orderRadius * .65];
					
					//set a reasonable patrol distance
					private _patrolDistance = (_centerPosX + _centerPosY) * 0.15;
					
					//get a random position near zone center and order zombies to it
					_orderPos =  [getMarkerPos _centerPos, _orderRadius] call CBA_fnc_randPos;
					[_temp_Group, _orderPos, _patrolDistance] call BIS_fnc_taskPatrol;
				
				};
				//phase 1, zombies start patroling middle
				case 1: {
					_centerPos = _location;
					
					//find which axis is smaller and select that
					_centerPosX = getMarkerSize _centerPos select 0;
					_centerPosY = getMarkerSize _centerPos select 1;
					_orderRadius = _centerPosY;
					if (_centerPosX <= _centerPosY) then {
						_orderRadius = _centerPosX;
					};
					
					//randomize radius near center of current zone size
					_orderRadius = random [1, _orderRadius *.25, _orderRadius * .65];
					
					//set a reasonable patrol distance
					private _patrolDistance = (_centerPosX + _centerPosY) * 0.15;
					
					//get a random position near zone center and order zombies to it
					_orderPos =  [getMarkerPos _centerPos, _orderRadius] call CBA_fnc_randPos;
					[_temp_Group, _orderPos, _patrolDistance] call BIS_fnc_taskPatrol;
				};
				
				//phase 2, zombies find players
				case 2: {
					private _targetPlayer = selectRandom allPlayers;
					
					//ensure player is actually in zone
					while {_targetPlayer inArea _location == false} do {
						private _targetPlayer = selectRandom allPlayers;
					
					};
					
					//send group at player's last loc
					_temp_Group addWaypoint [_targetPlayer, -1];
				};
				//phase 3, all zombies to decon area
				case 3: {
					//add waypoint to center area
					_temp_Group addWaypoint [getMarkerPos "startDecon", -1];
				};
				
			
			};

			//fix "stuck leader" bug
			[_temp_Group] execVM "unstickZombies.sqf";
	*/
		
			//set to new group to each spawn operates separately
			_id = time;
			_groupVarName = format ["EastGroup:%1", _id];
			missionNamespace setVariable [_groupVarName,_temp_Group];	

	
		};
		
		//update total zombie numbers
		if(FinalePhase == 1) then {
			_zombieCountCurrent = _zombieCount1;
		} else {
			if(FinalePhase == 2) then {
				_zombieCountCurrent = _zombieCount2;
			} else {
				if(FinalePhase == 3) then {
					_zombieCountCurrent = _zombieCount3;					
					
					//if Phase just changed to 3, send all zombies to center zone
					if(_phaseInterrupt == 0) then {
						{	//check if side is east
							if (side _x == east) then {
								//delete previous waypoints
								while {(count (waypoints _x)) > 0} do
									{
										deleteWaypoint ((waypoints _x) select 0);
									};
								
								//add waypoint to center area
								_x addWaypoint [getMarkerPos "startDecon", -1];														
																
							};
						} forEach allGroups;
						
						//ensure this doesn't run again
						_phaseInterrupt = 1;
						
						//start timer script
						[_defendTimer,false] call BIS_fnc_countdown;								
						//[90,false] call BIS_fnc_countdown;	 //TESTING *** DELETE	
						
						//start timer informer
						["startDecon","%1 seconds until complete DECON"] execVM "timerNotification.sqf";
						
						//start the defend phase
						execVM "finaleDefend.sqf";												
												
					};
					
					//check if timer is done						 
					_timeLeft = [0] call BIS_fnc_countdown;		
					if (_timeLeft <= 0) then {
						//if timer is up, then kill all zombies and end scenario with victory!
						{
							if(side _x == east) then {
								_x setDamage 1;
							};
							
						} forEach allUnits;
						
						execVM "victory.sqf";
						
						FinalePhase = 4;
						publicVariable "FinalePhase";
						
					} else {
						//if timer isn't up yet, notify of current time left
						//[["startDecon",300,format ["%1 seconds until DECON", floor _timeLeft]],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
							
					};
					
				};
			};
		};
		
		
		
	//if trigger is inactive, leave sqf via a false FinalePhase #
	
	/*  Cannot do this yet as there is no way to reset the finale event
	if (FinaleActive == false) then {
		FinalePhase = 4;
		publicVariable "FinalePhase";
	};
	*/
	
	//delay next iteration	
	sleep _sleepTimer;
};