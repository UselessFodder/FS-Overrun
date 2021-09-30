/*
    File: lav_Spawn.sqf
    Author: UselessFodder
    Date: 2020-10-18
    Last Update: 2020-10-18

    Description:
        Spawns zombies in 

    Parameter(s):
        _text   - Text to write into log                        [STRING, defaults to ""]
        _tag    - Tag to display between KPLIB prefix and text  [STRING, defaults to "INFO"]

    Returns:
        Function reached the end [BOOL]
*/

/*
	if # of zombies in Lavalle marker < 25
		spawn random zombie type at random lav_SP#
*/
["Lavalle"] spawn{
	 _numZ = {_x inArea "Lavalle" && side _x == east} count allunits;
	 _lav_Group = createGroup east; 
	 _zCount = 0;
	 _maxZ = 15;
 

	while{true} do{ 
		_numZ = {_x inArea "Lavalle" && side _x == east} count allunits;
		
		if(_numZ < _maxZ) then {
		
			_spawnCount = (_maxZ - _numZ) / ((random 3) + 1);
			
			for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
				_newZ = _lav_Group createUnit["RyanZombieB_RangeMaster_FOpfor", getMarkerPos "Lavalle", ["lav_SP_1","lav_SP_2","lav_SP_3","lav_SP_4"], 10, "NONE"]; 
			};
		};
		
		hint format ["Number of current zombies: %1", _numZ]; 
		sleep 5;
	};
};


/*
			_newZ = _lav_Group createUnit["RyanZombieB_RangeMaster_FOpfor", getMarkerPos "Lavalle", ["lav_SP_1","lav_SP_2","lav_SP_3","lav_SP_4"], 10, "NONE"]; 
			_zCount = _zCount + 1;
			hint format ["Number of current zombies: %1", _numZ]; 
			_numZ = {_x inArea "Lavalle"} count allunits;
			_numZ = _numZ + 1;
*/