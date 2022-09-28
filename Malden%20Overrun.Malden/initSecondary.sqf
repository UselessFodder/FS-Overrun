/*
	Always-on Script to generate secondary/side missions at a defined interval
*/

//public variable for total number of side missions
NumberMissions = 0;
publicVariable "NumberMissions";

//public array for sidemission marker names
MissionMarkers = [];
publicVariable "MissionMarkers";

//array to hold all types of missions for selection
_missionTypes = [];

//add non-disabled mission types
if (["ReinfectionMission", 0] call BIS_fnc_getParamValue == 0) then {
	_missionTypes pushback 0;
};


//while loop to continuously spawn missions
while {true} do {
	//defined wait timer
	sleep 1500; //25 minutes
	
	//randomize up to 10 minutes additional time
	sleep random[600];
	
	//randomize mission
	_currentMission = selectRandom _missionTypes; //0 = horde reinfect, 1 = civ rescue, 2 = info retrieval
	
	//horde reinfect
	if (_currentMission == 0) then {
		[NumberMissions] execVM "spawnReinfection.sqf"		
	};


	NumberMissions = NumberMissions + 1;
	publicVariable "NumberMissions";
		
};