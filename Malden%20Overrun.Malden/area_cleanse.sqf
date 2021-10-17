/*
    File: area_cleanse.sqf
    Author: UselessFodder
    Date: 2020-10-18
    Last Update: 2020-10-18

    Description:
        Spawns zombies in during DECON mode

*/

/*
	if # of zombies in passed marker < passed total # of Z
		spawn random zombie type at random _SP#
*/

params["_locationIndex","_location"];

private _locationIndex = _this select 0;
private _location = ZoneArray select _locationIndex select 0;
//private _deconMan = null;

	//get playercount and set appropriate amount of zombies
	private _maxZ = 14;

	//if there is only 1 player, 7 Zs is too easy
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

	//get all markers within 100m, but more than 20m from deconTruck
	{
		_currentDistance = deconTruck distance getMarkerPos _x;
		if (_currentDistance > 20 && _currentDistance < 101) then {
			_spawnLocs pushBack _x;
		};	

	} forEach allMapMarkers;

	//get start amount of zombies
	_numZ = {_x inArea _location && side _x == east} count allunits;

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
		CleanseActive = false;	
		publicVariable "CleanseActive";		
				
		//kill timer & refresh hint
		[-1] call BIS_fnc_countdown;
		//inform the user
		[["deconTruckMarker",300,"DECON Vehicle destroyed. Area is not decontaminated..."],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
		//log
		diag_log "DECON truck destroyed. Cleaning";	
		//clear timer
		[["deconTruckMarker",300,"", _location],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0]
		//titleText ["DECON Vehicle destroyed. Area is not decontaminated...", "PLAIN"];
				
	} else { //if not, then check if timer is complete
	
		_timeLeft = [0] call BIS_fnc_countdown;
	//***[[format ["Time Left: %1", _timeLeft], "PLAIN"]] remoteExec ["titleText", 0];
		//if timer is complete, set area to not infected and clear cleanseActive
		if ( _timeLeft == 0) then {
		//if([true] call BIS_fnc_countdown != true) then {
		
		//***[["Cleanup initiated", "PLAIN"]] remoteExec ["titleText", 0];
			if(isServer) then {
				diag_log "DECON complete. Begining clean up";	
				//*** ["Time complete", "PLAIN"] remoteExec ["titleText", 0];				
				//set area to no longer infected
				ZoneArray select _locationIndex set [1, false];				
				
				
				//kill all zombies in area
				_killZ = {_x inArea _location && side _x == east} count allunits;
				
				//inform users
				[["deconTruckMarker",300,format ["Area %1 successfully decontaminated.", _location]],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
				
				{
					if(_x inArea _location && side _x == east) then {
						_x setDamage 1;
					};
				} forEach allunits;
				
				//unlock truck and delete deconMan
				deconTruck lock false;
				deconTruck lockDriver false;				
				{ deconTruck deleteVehicleCrew _x } forEach crew deconTruck;
				//deleteVehicle _deconMan;		//**
				
				//add 50 to bank
				[[50],"addToBank.sqf"] remoteExec ["BIS_fnc_execVM",2];
				
				//save state
				//sleep 15;
				execVM "saveState.sqf";
				
				//clear decon status
				CleanseActive = false;
				publicVariable "CleanseActive";
				
				//check if this is the final zone for victory
				execVM "victoryCheck.sqf";
				
			};
			

		
		}else { //if timer is not complete, update hint and spawn more zombies
			//update hint
			[["deconTruckMarker",300,format ["%1 seconds until DECON", floor _timeLeft], _location],"hintNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
			
			if(isServer) then {		
				//get Z count
				_numZ = {((_x distance deconTruck) < 75) && side _x == east} count allunits;
				
				//if below max ZList
				if(_numZ < _maxZ) then {
				
					//set skill for next group
					//private _currentSkill = selectRandom [0.2,0.3,0.4,0.5,0.6,0.7];
					private _currentSkill = 1;
					
					//prep to spawn a random amount of the remaining Z's needed
					_spawnCount = (_maxZ - _numZ) / (random [2,3,4]);
					
					for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {

						//select a position for new group
						private _currentSpawn = selectRandom _spawnLocs;	
					
						//execute script to create zombies				
						_zSpawn = [_currentSpawn] execVM "zSpawn.sqf";						
						
						//hold off until last unit is spawned
						waitUntil { scriptDone _zSpawn };
						
					};
			
				};
			};
			
		};//end else
	};//end else
	
	//delay 0.5 seconds
	sleep 1;
};