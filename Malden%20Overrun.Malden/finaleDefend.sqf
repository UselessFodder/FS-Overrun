/*
	Checks if zombies completely control the decontamination machine area. If so, it halts the timer and begins warning them
	that they must retake the zone within 30 seconds or the machine will be overwhelmed and destroyed.
*/

//var to hold finale timer number
_finaleTimer = [0] call BIS_fnc_countdown;	

//time players must get back into objective
_defendTime = 60;

//var to hold number of loops after zombies take over
_loopCount = 0;

//bool to flip between modes
_zombieControl = false;

//start loop checking for only zombies in zone
while{FinalePhase == 3} do {
	//get number of units in area
	_totalUnits = allUnits inAreaArray "finaleDefend";
	_westUnits = {side _x == blufor} count _totalUnits;
	_eastUnits = {side _x == opfor} count _totalUnits;

	//check if area has zombies, but no players
	if(_westUnits == 0 && _eastUnits >= 1) then {
		//check if _zombieControl has already been flipped
		if (_zombieControl == false) then {
			//if so, start defend sequence and turn _zombieControl to true
			//get current finale timer to return if they retake
			_finaleTimer = [0] call BIS_fnc_countdown;	
			
			//set _zombieControl to true to prevent updating timer
			_zombieControl = true;
			
			//warn players
			[["finaleDefend",300,"We have to clear out those zombies or they'll overwhelm the machine!"],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];			
			
		};
		
		//keep finale timer the same
		[_finaleTimer] call BIS_fnc_countdown;	
		
		//warn of amount of time remaining to clear area
		if (_loopCount % 10 == 0 && _loopCount > 0) then { //Warn every 10 seconds
			_timeleft = _defendTime - _loopCount;
			
			[["finaleDefend",300,format ["We only have %1 seconds left to clear the zombies!", _timeleft]],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
		
		};
		
		//check if time has run out and, sadly, end the game with a bang if so
		if(_loopCount == _defendTime) then {
			[["finaleDefend",300,"THE MACHINE IS OVERLOADING"],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
			sleep 2;
			//explode area
			_bombloc = getMarkerPos "finaleDefend";
			"Bo_GBU12_LGB" createVehicle (_bombloc);
			sleep 0.2;
			"Bo_GBU12_LGB" createVehicle (_bombloc vectorAdd [10,10,0]);
			sleep 0.1;
			"Bo_GBU12_LGB" createVehicle (_bombloc vectorAdd [0,-5,0]);
			sleep 0.2;
			"Bo_GBU12_LGB" createVehicle (_bombloc vectorAdd [-10,0,0]);
			
			sleep 2;
			//end game
			["epicFail", false, 8] call BIS_fnc_endMission;
			sleep 8;
		};
		
	//increment for every loop zombies have control
	_loopCount = _loopCount + 1;
	
	} else {//if players retook the area
		if(_zombieControl == true) then {//changed bool back so timer can restart
			_zombieControl = false;
			//change loop count back so it can be used again
			_loopCount = 0;
			//notify players
			[["finaleDefend",300,"We've retaken the area. Keep holding!"],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
		};
	};

//try to match whole loop to 1 second
sleep 0.9;

};