/*
	*** WORK IN PROGRESS **
	Script to find an infected zone at 100% infection rate, find the one of nearest that is DECONed, and send
	a group of zombies to reinfect it.
*/
diag_log "**Beginning Reinfection Script**";

//array holds all 100% zones
private _maxInfected = [];
//array holds all location names and positions
private _allPos = [];
//array holds nearest 3 zones
private _nearZones = [];
//holds selected origin of horde
private _originZone = nil;
//holds selected target of horde
private _targetZone = nil;

//get list of zones and find any that are at 100%
{
	//check if this zone is at 100%
	if(_x select 2 == 1) then{
		//add to infected array
		_maxInfected pushBack (_x select 0);		
		
		diag_log format ["%1 added to 100% list", _x select 0];
	};
	
	//build array of positions for use later
		//_currentZone = [_x select 0, getMarkerPos _x select 0]; ***DELETE
		//_allPos pushBack _currentZone;//***DELETE
	_allPos pushBack (getMarkerPos _x select 0);
	
		
} forEach ZoneArray;

diag_log format ["** Total number of 100% zones = %1 **", count _maxInfected];

//randomize array to ensure it's not always the same zones
_maxInfected = _maxInfected call BIS_fnc_arrayShuffle;

//incrementer to only check number of zones in array
private _currentArray = 0;

//selector to exit loop once selection complete
private _zoneSelected = false;

//find us a target zone
while {_zoneSelected == false && _currentArray <= count _maxInfected} do {
	_checkingZone = _maxInfected select _currentArray;
	
	diag_log format ["** Finding nearest zones to %1**", _checkingZone];

	//get three nearest zones to randomly selected 100%
	private _aNearZone = [_allPos, getMarkerPos _checkingZone] call BIS_fnc_nearestPosition;
	//add to array
	_nearZones pushBack _aNearZone;
	//remove that zone and check again
	private _uncheckedZones = _allPos - _aNearZone;

	private _aNearZone = [_uncheckedZones, getMarkerPos _checkingZone] call BIS_fnc_nearestPosition;
	//add to array
	_nearZones pushBack _aNearZone;
	//remove that zone and check again
	private _uncheckedZones = _uncheckedZones - _aNearZone;

	private _aNearZone = [_uncheckedZones, getMarkerPos _checkingZone] call BIS_fnc_nearestPosition;
	//add to array
	_nearZones pushBack _aNearZone;

	//find names of 3 nearest zones
	private _firstNearest = [allMapMarkers, _nearZones select 0] call BIS_fnc_nearestPosition;
	private _secondNearest = [allMapMarkers, _nearZones select 1] call BIS_fnc_nearestPosition;
	private _thirdNearest = [allMapMarkers, _nearZones select 2] call BIS_fnc_nearestPosition;
	
	diag_log format ["** Nearest zones are: %1, %2, %3**", _firstNearest, _secondNearest, _thirdNearest];
	
	//set nearZones to proper names
	_nearZones = [_firstNearest, _secondNearest, _thirdNearest];
	
	
	
	//starting with nearest, check if DECON. If so, this is reInfection target. If not, then check next, etc
	{
		diag_log format ["** Checking if %1 can be reinfected **", _x];
		
		//selector to exit loop when location is found
		private _zoneFound = false;
		//incrementor to ensure we do not get stuck in infinite loop
		private _incrementor = 0;
		
		while {_zoneFound == false && _incrementor <= count ZoneArray} do {
			//check name against current 
			if (ZoneArray select _incrementor select 0 == _x) then {
				_zoneFound = true;				
			} else {
				_incrementor = _incrementor + 1;
			};
		};
		
		//check if already DECONed. If so, set as target zone and set current _nearZone as origin zone
		if (ZoneArray select _incrementor select 1 == false) then {
			_zoneSelected = true;
			_targetZone = ZoneArray select _incrementor select 0;
			_originZone = _x;
			
			diag_log format ["** Reinfection zone found! Horde will go %1 -> %2**", _originZone, _targetZone];
			
		};
		
	} forEach _nearZones;
	

	//if none of these are able to be reinfected, move to next 100% zone
	_currentArray = _currentArray + 1;

};
//if no 100% zones have areas to reinfect near them, quit script



//else, spawn a group and a singular zombie to represent it (saves resources)

//send group toward target zone


//create a trigger to spawn the rest of the zombies with a randomized number between 20-40, delete trigger. attachTo the zombie

//initialize marker location

//create mission task to eliminate horde

//start while(group exists) loop

	//update marker location

	//check if marker is within 50m of the DECON zone. If so, reinfect it

	//wait 5 seconds

//once group doesn't exist, delete marker, update task, and end side mission