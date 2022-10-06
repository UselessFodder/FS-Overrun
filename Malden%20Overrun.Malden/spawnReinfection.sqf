/*
	*** WORK IN PROGRESS **
	Script to find an infected zone at 100% infection rate, find the one of nearest that is DECONed, and send
	a group of zombies to reinfect it.
*/
//param = number of current missions
params ["_currentMission"];

diag_log format ["**Beginning Reinfection Script. Current mission number: %1**", _currentMission];

//array holds all 100% zones
private _maxInfected = [];
//array holds all location names and positions
private _allPos = [];
//array holds nearest 3 zones
private _nearZones = [];
//holds selected origin of horde
 _originZone = nil;
//holds selected target of horde
 _targetZone = "";
 //variable to hold mission end result for notification
 _missionEndResult = 0;

//get list of zones and find any that are at 100%
{
	diag_log format ["Checking %1. Current Infection: %2", _x select 0, _x select 2];
	//check if this zone is at 100%
	if(_x select 2 >= 1) then{
		//add to infected array
		_maxInfected pushBack (_x select 0);		
		
		diag_log format ["%1 added to 100% list", _x select 0];
	};
	
	//build array of positions for use later
		//_currentZone = [_x select 0, getMarkerPos _x select 0]; ***DELETE
		//_allPos pushBack _currentZone;//***DELETE
	//_allPos pushBack (getMarkerPos _x select 0);
	_allPos pushBack (_x select 0);
	
		
} forEach ZoneArray;

diag_log format ["** Total number of 100% zones = %1 **", count _maxInfected];

//if no target zones have been found
if (count _maxInfected == 0) exitWith{

	diag_log "** No 100% infection zones. Exiting reinfection script. **";
};

//randomize array to ensure it's not always the same zones
_maxInfected = _maxInfected call BIS_fnc_arrayShuffle;

//incrementer to only check number of zones in array
private _currentArray = 0;

//selector to exit loop once selection complete
private _zoneSelected = false;

//find us a target zone in 3 tries
while {_zoneSelected == false && _currentArray <= 2} do {
	_checkingZone = _maxInfected select _currentArray;
	_nearZones = [];
	
	diag_log format ["** Finding nearest zones to %1**", _checkingZone];
	
	_zoneToDelete = [_checkingZone];
	_uncheckedZones = _allPos - _zoneToDelete;
	//get three nearest zones to randomly selected 100%
	_aNearZone = [_uncheckedZones, _checkingZone] call BIS_fnc_nearestPosition;
	sleep 0.1;
	//add to array
	_nearZones pushBack _aNearZone;
	//remove that zone and check again
	_zoneToDelete = [_aNearZone];
	_uncheckedZones = _uncheckedZones - _zoneToDelete;



	_aNearZone = [_uncheckedZones, getMarkerPos _checkingZone] call BIS_fnc_nearestPosition;
	sleep 0.1;
	//add to array
	_nearZones pushBack _aNearZone;
	//remove that zone and check again
	_zoneToDelete = [_aNearZone];
	_uncheckedZones = _uncheckedZones - _zoneToDelete;



	_aNearZone = [_uncheckedZones, getMarkerPos _checkingZone] call BIS_fnc_nearestPosition;
	sleep 0.1;
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
		
		if (_zoneFound == false) then {
			diag_log format ["** Checking if %1 can be reinfected **", _x];
		};
		
		//check if already DECONed. If so, set as target zone and set current _nearZone as origin zone
		if (ZoneArray select _incrementor select 1 == false) then {
			_zoneSelected = true;
			_targetZone = ZoneArray select _incrementor select 0;
			_originZone = _checkingZone;
			
			diag_log format ["** Reinfection zone found! Horde will go %1 -> %2**", _originZone, _targetZone];
			
		};
		
	} forEach _nearZones;
	

	//if none of these are able to be reinfected, move to next 100% zone
	_currentArray = _currentArray + 1;

};
//if no target zones have been found
if (_targetZone == "") exitWith {

	diag_log "** No Target Found to reinfect in 3 tries. Exiting **";
};


//else, spawn a group and a singular zombie to represent it (saves resources)
//create group to put Z's in
private _temp_Group = createGroup[EAST,true]; 

//create Z
_newZ = _temp_Group createUnit[(selectRandom ZList), getMarkerPos _originZone, [], 3, "NONE"]; 
_temp_Group setFormation "LINE";

//send group toward target zone
_temp_Group addWaypoint [getMarkerPos _targetZone, -1];



//create a trigger to spawn the rest of the zombies with a randomized number between 20-40, attachTo the zombie, delete trigger when complete
private _tempTrigger = createTrigger ["EmptyDetector", getPos _newZ];
_tempTrigger attachTo [_newZ];
_tempTrigger setTriggerArea [200,200,200,false];
_tempTrigger setTriggerActivation ["WEST","PRESENT",false];
_tempTrigger setTriggerStatements ["this",
"
_newZ = attachedTo thisTrigger;
_temp_Group = group _newZ;

_numSpawn = floor(random 30) + 10;
diag_log format ['** Starting horde spawn, total Z: %1**', _numSpawn];
 for '_i' from 0 to 40 do {
	if(_i < _numSpawn) then {
		_spawnLoc = (getPos leader _temp_Group) vectorAdd [random [-30,0,30], random [-30,0,30],0];
		_spawnZ = _temp_Group createUnit[(selectRandom ZList), _spawnLoc, [], 3, 'NONE'];
	};
};

deletevehicle thisTrigger;	
",""];


//initialize marker location
_markerName = format["reinfectionMarker%1",_currentMission];

_reinfectionMarker = createMarker [_markerName, position _newZ];
_reinfectionMarker setMarkerColor "ColorRed";
_reinfectionMarker setMarkerType "hd_warning";
_reinfectionMarker setMarkerPos position leader _temp_Group;

//update marker location
MO_fnc_markerUpdate = 
{
	params ["_group", "_markerName"];
	private _leader = leader _group;
	while {alive _leader} do {
		_markerName setMarkerPos position _leader;
		
		sleep 10;
		_leader = leader _group;
	};
	
	diag_log format ["Horde destroyed. Deleting %1", _markerName];
	deleteMarker _markerName;
	
	//find marker in MissionMarkers and delete it for garbage collection tracking	
	_i = 0;
	{
		if(_x == _markerName) then {
			MissionMarkers deleteAt _i;
		};
		_i = _i + 1;
	} forEach MissionMarkers;	
	publicVariable "MissionMarkers";
	
	
	//log
	diag_log format ["Removed Reinfection marker %1 from mission marker list: %2",_markerName, MissionMarkers];

};

[_temp_Group, _markerName] spawn MO_fnc_markerUpdate;

//update all mission markerShadow
MissionMarkers pushback formatText ["%1",_markerName];
publicVariable "MissionMarkers";

//log
diag_log format ["Added Reinfection marker %1 to mission marker list: %2",_markerName, MissionMarkers];

//Notify players of horde
["TaskAssigned", ["", format ["A horde is moving from %1 to %2 to reinfect the zone!", _originZone, _targetZone]]] remoteExec ['BIS_fnc_showNotification',0,FALSE];

//start while(group exists) loop
while {alive leader _temp_Group} do {
	//check if target zone is still DECON (to ensure another group didn't infect it already)
	{
		if (_x select 0 == _targetZone) then {
			//check infection status
			if(_x select 1 == true) then {
				//if deconed, destroy group and notify players
				{
					deleteVehicle _x;
				} forEach units _temp_Group;
			
				diag_log format ["** %1 has been reinfected by another group. Deleting horde", _targetZone];
				
				_missionEndResult = 2;
			};
		};

	} forEach ZoneArray;	
	
	//check if marker is within 10m of the DECON zone. If so, reinfect it
	if ((leader _temp_Group distance getMarkerPos _targetZone) <= 10) then {
		diag_log format ["** Horde is within 5m of %1. Reinfecting", _targetZone];
		
		
		//cycle through all ZoneArray to find right one
		{
			if (_x select 0 == _targetZone) then {
				//set target to infected and 5% infection rate
				_x set [1, true];
				_x set [2, 0.05];				
				
				diag_log format ["** %1 is set isInfected: %2, Infection Rate: %3", _x select 0, _x select 1, _x select 2];
				
				//change marker to proper color
				_targetZone setMarkerColor "ColorRed";		
				_targetZone setMarkerAlpha 0.2;
				
				//set notification status
				_missionEndResult = 1;
				
				//save the new status
				execVM "saveState.sqf";
			};

		} forEach ZoneArray;
		publicVariable "ZoneArray";
		
		//delete horde
		{
			_x setDamage 1;
		} forEach units _temp_Group;		
	};	
	
	//wait 5 seconds
	sleep 5;
};

diag_log format ["** Ending reinfection horde mission. Mission End Result: %1", _missionEndResult];

//check what result was
switch (_missionEndResult) do
{
	case 0: {["TaskSucceeded", ["", format ["Horde has been destroyed! %1 no longer under threat", _targetZone]]] remoteExec ['BIS_fnc_showNotification',0,FALSE];}; 	//players eliminated horde
	case 1: {["TaskFailed", ["", format ["Horde has reinfected %1!", _targetZone]]] remoteExec ['BIS_fnc_showNotification',0,FALSE];}; 									//horde reinfected zone
	case 2: {["TaskFailed", ["", format ["%1 has already been reinfected! Horde is dispersed", _targetZone]]] remoteExec ['BIS_fnc_showNotification',0,FALSE];}; 		//zone already reinfected
};
