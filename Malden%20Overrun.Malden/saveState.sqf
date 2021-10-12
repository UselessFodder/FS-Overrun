/*
	Saves the following global variables to profileNamespace:
	- IsInfected
	- InfectionRate
	- ActiveSpawn *** Why?
	Later, will save team and player resources
*/

//ensure this only saves on server
if(isServer) then {
	//start save log
	diag_log "Starting Save";	
	

	//get IsInfected variables from array
	private _isInfectedArray = [];	
	_zoneArraySize = count ZoneArray;
	for [{private _i = 0}, {_i < _zoneArraySize}, {_i = _i +1}] do{
		_currentBool = ZoneArray select _i select 1;
		_isInfectedArray pushBack _currentBool;
		diag_log format ["%1 read into %2 slot in IsInfected", _isInfectedArray select (count _isInfectedArray -1), (count _isInfectedArray) - 1];		
	};

	//save variables to namespace
	profileNamespace setVariable ["IsInfected", _isInfectedArray];
	
	//get InfectionRate variables from array
	private _infectionRateArray = [];	
	for [{private _i = 0}, {_i < _zoneArraySize}, {_i = _i +1}] do{
		_currentRate = ZoneArray select _i select 2;
		_infectionRateArray pushBack _currentRate;
		diag_log format ["%1 read into %2 slot in InfectionRate", _infectionRateArray select (count _infectionRateArray -1), (count _infectionRateArray) - 1];		
	};
	
	//save variable to namespace
	profileNamespace setVariable ["InfectionRate", _infectionRateArray];
	profileNamespace setVariable ["FactionBank", FactionBank];
	profileNamespace setVariable ["UnlockTracker", UnlockTracker];

	//save namespace
	saveProfileNamespace;
	
	//diag save complete
	diag_log "Save Complete";

};

//inform users
hint "Mission State Saved";