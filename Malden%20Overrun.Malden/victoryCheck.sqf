/*
	Checks if all currently unlocked zones are deconed and ends mission if they are
*/

//log run of this script
diag_log "Running Victory Check";

//get mission param on victory % needed
_victoryPercent = ["PercentToVictory", 100] call BIS_fnc_getParamValue;

//get full list and count of ZoneArray indexes currently created in Overrun
_currrentZones = [1,2,3,4,7,8,9,10,11,12,13,14,15,17,18,26,27,28,29,30];
_victoryZoneCount = (count _currrentZones) * _victoryPercent;

//value to hold total number of deconed zones
_totalDeconed = 0;

//forEach loop to check each member of _currrentZones
{
	//check if isInfected is false, meaning it's deconed
	if(!(ZoneArray select _x select 1)) then{
		//add a counter to the overal deconed areas
		_totalDeconed = _totalDeconed + 1;
	};//end if

} forEach _currrentZones;

//log total number of deconed zones
diag_log format ["%1 out of %2 zones deconed",_totalDeconed,_victoryZoneCount];

//If all zones are deconed, _totalDeconed will equal _victoryZoneCount and the players will win
if (_totalDeconed >= _victoryZoneCount) then {
	//*** SEPARATE INTO NEW SQF
	[["You've done it... Malden has been cleansed of the zombie menace!", "PLAIN"]] remoteExec ["titleText", 0];
	
	sleep 5;
	
	[["Thank you for testing the Malden Overrun Alpha!\nPlease give UselessFodder your feedback to improve this scenario!\nYou can find him at discord.gg/UselessFodder or on socials", "PLAIN"]] remoteExec ["titleText", 0];
	
	sleep 5;
	
	//end the mission and return to select screen
	"end1" call BIS_fnc_endMission;
};
