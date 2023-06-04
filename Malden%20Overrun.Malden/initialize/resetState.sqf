/*
	Resets the status of the following variables:
	- IsInfected
	- InfectionRate
	Later, will reset team and player resources
*/

private _actuallyReset = _this select 0;

//ensure someone actually wanted to run this
if (_actuallyReset == true) then {
	
	//start save log
	diag_log "Resetting Save";	
	

	//get IsInfected variables from array
	private _isInfectedArray = [];	
	_zoneArraySize = count ZoneArray;
	for [{private _i = 0}, {_i < _zoneArraySize}, {_i = _i +1}] do{
		_currentBool = true;
		ZoneArray select _i set [1, _currentBool];
		//diag_log format ["%1 read into %2 slot in ZoneArray", _isInfectedArray select (count _isInfectedArray -1), (count _isInfectedArray) - 1];		
	};

	//save variables to namespace
	profileNamespace setVariable ["IsInfected", _isInfectedArray];
	
	//get InfectionRate variables from array
	private _infectionRateArray = [];	
	for [{private _i = 0}, {_i < _zoneArraySize}, {_i = _i +1}] do{
		_currentRate = 0.50;
		ZoneArray select _i set [2, _currentRate];
		//diag_log format ["%1 read into %2 slot in InfectionRate", _infectionRateArray select (count _infectionRateArray -1), (count _infectionRateArray) - 1];		
	};	
	
	//set unlocks to none
	private _unlockArray = [];
	private _unlockArraySize = count UnlockTracker;
	for [{private _i = 0}, {_i < _zoneArraySize}, {_i = _i +1}] do{
		_currentBool = false;
		UnlockTracker set [_i, _currentBool];
		//diag_log format ["%1 read into %2 slot in InfectionRate", _infectionRateArray select (count _infectionRateArray -1), (count _infectionRateArray) - 1];		
	};	
	
	//set faction bank to zero
	FactionBank = 0;
	publicVariable "FactionBank";
	
	
	//diag save complete
	diag_log "Reset Complete";
};

//save reset
execVM "saveState.sqf";