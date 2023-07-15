/*
	Description: This script creates a trigger at each point in ZoneArray that will run the area_Init function
		when a player enters it.
	
	Use: This script is called by initArray.sqf when a previous ZoneArray is not stored in the profileNamespace i.e. the first time
		the scenario is run
	
	Called by: initArray.sqf
	Calls: area_init.sqf (when triggered)
	Called on: Server only
	Returns: Bool true when script is complete
*/

//constant to calculate correct maxZ number from zone size
private _zFactor = 3.5;

//Build trigger for every zone
{
	//get trigger name
	//private _name = format ["%1Trigger", _x select 0];
	
	//get average of length and width axes
	private _averageSize = ((_x select 6 select 0) + (_x select 6 select 1))/2;
	
	//determine maxZ amount
	private _maxZ = (_averageSize * 2)/ _zFactor;
	
	//ensure things don't go to high or low
	if (_maxZ < 30) then {
		_maxZ = 30;
	} else {
		if (_maxZ > 100) then {
			_maxZ = 100;
		};
	};
	
	//build basic trigger that is server only
	_currentTrigger = createTrigger ["EmptyDetector", getMarkerPos (ZoneArray select _forEachIndex select 0), false];
	
	//make trigger slightly larger than max zone size
	_currentTrigger setTriggerArea [(_x select 6 select 0) * 1.5, (_x select 6 select 1) * 1.5, 0, false];
	
	//make trigger activation only players
	_currentTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];

	//set trigger statements to initiate/deactivate area_init.sqf using format to add in variables
	_currentTrigger setTriggerStatements [
		"this",
		format ["
			if (ZoneArray select %1 select 3 == false) then { 
				call{ZoneArray select %1 set [3,true]; 
				 
				[[%1,%2],'area_init.sqf'] remoteExec ['BIS_fnc_execVM',[0,2] select isMultiplayer];} 
			}", _forEachIndex, _maxZ
		],
		format [
			"call{ZoneArray select %1 set [3,false];}", _forEachIndex
		]
	];

	//make note in diag
	diag_log format ["Created trigger for %1 with maxZ of %2", _x select 0, _maxZ];
} forEach ZoneArray;

private _jobsDone = true;
_jobsDone;