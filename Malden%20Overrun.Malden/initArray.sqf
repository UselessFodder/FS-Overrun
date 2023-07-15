/*
	Description: This script searches the entire map for all markers of the type "rectangle" and builds a ZoneArray of them in 
		alphabetical order. The script also generates the approprate parameters within the ZoneArray based on the name and size 
		of the rectangle marker. Lastly, this script calls the next stage in building the scenario that adds in the area triggers.
		
	Use: This script is called by init.sqf 
	
	Called by: init.sqf
	Calls: initTriggers.sqf
	Called on: Server only
	Parameters: 0: _isInfected (Array of infection states for all zones)
				1: _infectionRate (Array of saved infection rates)
	Return: Bool true when script is complete
*/

//params. If none are passed, default to nil as per the init.sqf save check
params [
	["_isInfected",[]],
	["_infectionRate",[]]
];

//notify diag
diag_Log "*** Starting generation of new ZoneArray";

//array to hold all found zones
private _newZones = [];

_newZones = allMapMarkers select {markerShape _x == "RECTANGLE"};

//DEBUG*** DELETE
diag_Log format ["Array of all markers found: %1", _newZones];

//Reorder array into alphabetical order
_newZones sort true;

//add checks for save data to either pull in the saved values or generate them
private _savedInfected = false;
if(count _isInfected > 0) then {
	diag_Log "*** Infection State save detected. Loading into ZoneArray";
	_savedInfected = true;
};
private _savedRate = false;
if(count _infectionRate > 0) then {
	diag_Log "*** Infection Rate save detected. Loading into ZoneArray";
	_savedRate = true;
};

//build 2d master array
ZoneArray = [];
{
	//array to hold this location's values
	private _arrayInput = [];
	
	//add location name
	_arrayInput pushBack _x;
	
	//if data is already saved, read it in now
	if(_savedInfected) then {
		_arrayInput pushBack (_isInfected select _forEachIndex);
	} else {
	//add IsInfected state (default true)
		_arrayInput pushBack true;
	};
	
	//if data is already saved, read it in now
	if(_savedRate) then {
		_arrayInput pushBack (_infectionRate select _forEachIndex);
	} else {
		//add InfectionRate randomized between 30% - 80%
		private _infectionRate = parseNumber ((0.3 + random 0.5) toFixed 2);
		_arrayInput pushBack _infectionRate;
	};
	
	//add ActiveSpawn, MissionActive, and CleanseActive (always false)
	_arrayInput pushBack false;
	_arrayInput pushBack false;
	_arrayInput pushBack false;
	
	//add marker's size as a 2 element array
	_arrayInput pushBack markerSize _x;

	//DEBUG*** DELETE
	diag_Log format ["Adding to ZoneArray: %1", _arrayInput];

	//finally, add entry into ZoneArray
	ZoneArray pushBack _arrayInput;
} forEach _newZones;

//DEBUG*** DELETE
diag_Log format ["ZoneArray entries added: %1", count ZoneArray];

//broadcast ZoneArray
PublicVariable "ZoneArray";

//with ZoneArray generated, call initTriggers.sqf to create the appropriate area triggers
private _jobsDone = execVM "initTriggers.sqf";

waitUntil {scriptDone _jobsDone};

//return true when scripts are complete
_jobsDone;