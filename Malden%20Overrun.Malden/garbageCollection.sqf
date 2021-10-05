/*
	Clears all enemies > 800m away from players after some wait time
*/

//private _players = [];
private _garbage = [];
private _dist = 800;

_players = allPlayers;

while{true} do{
	{
		_unit = _x;
		if ((side _unit) == east) then {
			if ( ({(_unit distance _x) > _dist} count playableUnits) == ({isplayer _x} count playableUnits) ) then {
				//add them to the garbage collection stack to check again later
				_garbage pushBack _unit;
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
				diag_log "Running garbage collection";
			};
		};
	
	} forEach _garbage;

	Sleep 300;
};