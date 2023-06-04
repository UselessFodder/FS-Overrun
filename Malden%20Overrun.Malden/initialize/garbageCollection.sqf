/*
	Clears all enemies > 800m away from players after some wait time
*/

//private _players = [];
private _garbage = [];
private _dist = 800;

_players = allPlayers;

while{true} do{
	//reset array
	_garbage = [];

	{
		_unit = _x;
		if ((side _unit) == east) then {
			if ( ({(_unit distance _x) > _dist} count playableUnits) == ({isplayer _x} count playableUnits) ) then {
				//check if unit is part of a secondary mission
				_insideMission = false;				
				{
					//diag_log format ["Checking for %1 at %2",_x, getMarkerPos str _x];
					if(_unit distance getMarkerPos str _x < 100) then{
						_insideMission = true;
						//log
						diag_log format ["%1 is inside area %2 and won't be deleted by garbage collection",_unit,_x];
					};
				} forEach MissionMarkers;
				
				if(_insideMission == false) then {
					//add them to the garbage collection stack to check again later
					_garbage pushBack _unit;					
				};
			};
		};
	} forEach Allunits;

	//delay for 1 min to not delete enemies which were only temporarily away
	Sleep 60;
	
	//check again and delete
	{
	
		_unit = _x;
		if ((side _unit) == east) then {
			if ( ({(_unit distance _x) > _dist} count playableUnits) == ({isplayer _x} count playableUnits) ) then {
				deletevehicle _unit;
				diag_log format ["Garbage collection deleted %1",_unit];
			};
		};
	
	} forEach _garbage;

	Sleep 300;
};