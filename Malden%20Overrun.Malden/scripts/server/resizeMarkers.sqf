/*
	This script resizes all infection zone markers to the size of their current infection rate percentage.
	This change makes it easier for the players to find the final zombies in a zone since it's now "shrunk" and 
	concentrated the zombies spawns.

	Parameters - [0- Index of Current Zone to adjust in ZoneArray];
	Return - Array of new marker size: [.5 W, .5H]

*/

	params["_locationIndex"];
	private _locationIndex = _this select 0;
	
	private _location = ZoneArray select _locationIndex select 0;
	private _isInfected = ZoneArray select _locationIndex select 1;
	private _infectionRate = ZoneArray select _locationIndex select 2;
	private _maxMarkerSize = ZoneArray select _locationIndex select 6; //[.5 W, .5H]	
	
	//minimum threshold for the marker size
	private _minimumMarkerPercent = 0.35;
	
	//Check if the area is infected. If not, resize to full
	if (_isInfected == false) then {
		//TESTING PLS DELETE***
		//diag_log format ["%1 is DECON, setting to max of %2", _location, _maxMarkerSize];
		
		_location setMarkerSize _maxMarkerSize; 
		_maxMarkerSize
		
	} else { //if area is infected, get the current infection and change the zone size
		_maxMarkerW = _maxMarkerSize select 0;
		_maxMarkerH = _maxMarkerSize select 1;		
		
		//check if marker is below the minimum threshold. If so, then only adjust to that threshold
		if (_infectionRate < _minimumMarkerPercent) then {
			_infectionRate = _minimumMarkerPercent;
		};
		
		//TESTING PLS DELETE***
		//diag_log format ["%1 is infected, setting to new size of [%2,%3]", _location, _maxMarkerSize];
		
		
		//set width and height to infection rate
		_newMarkerW = _maxMarkerW * _infectionRate;
		_newMarkerH = _maxMarkerH * _infectionRate;
		
		//TESTING PLS DELETE***
		//diag_log format ["%1 is at %2, setting to new size of [%3,%4]", _location, _infectionRate, _newMarkerW, _newMarkerW];
		
		//check if marker will be smaller than 100m, then set to 100m if so
		if (_newMarkerH < 50) then {
			_newMarkerH = 50;
		};
		
		if (_newMarkerW < 50) then {
			_newMarkerW = 50;
		};
		//resize zone marker
		_location setMarkerSize [_newMarkerW,_newMarkerH]; 	
		
		[_newMarkerW,_newMarkerH]
	};
	
