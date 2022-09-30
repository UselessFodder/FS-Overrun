/*
	Checks if all currently unlocked zones are deconed and begins final zone of they are
*/

//log run of this script
diag_log "Running Finale Check";

//get mission param on victory % needed
_victoryPercent = ["PercentToVictory", 100] call BIS_fnc_getParamValue;

//get full list and count of ZoneArray indexes currently created in Overrun
//_currrentZones = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];
//_victoryZoneCount = (count _currrentZones) * _victoryPercent;
_victoryZoneCount = (count ZoneArray) * _victoryPercent;

//value to hold total number of deconed zones
_totalDeconed = 0;

//forEach loop to check each member of _currrentZones
{
	//check if isInfected is false, meaning it's deconed
	if(!(_x select 1)) then{
		//add a counter to the overal deconed areas
		_totalDeconed = _totalDeconed + 1;
	};//end if

} forEach ZoneArray;

//log total number of deconed zones
diag_log format ["%1 out of %2 zones deconed",_totalDeconed,_victoryZoneCount];

//If all zones are deconed, _totalDeconed will equal _victoryZoneCount and the finale event will open up
if (_totalDeconed >= _victoryZoneCount) then {
	//Notify all players
	[["The Infection level is finally low enough. Let's finish this...", "PLAIN"]] remoteExec ["titleText", 0];
	
	sleep 3;
	
	//create a task notification
	["TaskAssigned", ["", format ["Decontaminate the Infection source at the old Military Base"]]] remoteExec ['BIS_fnc_showNotification',0,FALSE];
	
	//change area warning to draw the players in
	"finaleWarning" setMarkerText "DECONTAMINATE THE SOURCE";
	
	//set FinaleReady variable to ensure access to the final area
	FinaleReady = true;
	publicVariable "FinaleReady";

};
