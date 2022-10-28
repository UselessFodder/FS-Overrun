/*
	Hacky fix for zombie groups 'sticking' and not carrying out orders
	Params: 0 - group to unstick
*/

params["_temp_Group"];
//spawn location
_location = "finaleArea";

sleep 5;

//give orders based on phase
switch(FinalePhase) do {
	//phase 0, zombies just patrol around
	case 0: {
		//send zombies to center
		_centerPos = _location;
		
		//find which axis is smaller and select that
		_centerPosX = getMarkerSize _centerPos select 0;
		_centerPosY = getMarkerSize _centerPos select 1;
		_orderRadius = _centerPosY;
		if (_centerPosX <= _centerPosY) then {
			_orderRadius = _centerPosX;
		};
		
		//randomize radius near center of current zone size
		_orderRadius = random [1, _orderRadius *.25, _orderRadius * .65];
		
		//set a reasonable patrol distance
		private _patrolDistance = (_centerPosX + _centerPosY) * 0.15;
		
		//get a random position near zone center and order zombies to it
		_orderPos =  [getMarkerPos _centerPos, _orderRadius] call CBA_fnc_randPos;
		[_temp_Group, _orderPos, _patrolDistance] call BIS_fnc_taskPatrol;

	};
	//phase 1, zombies start patroling middle
	case 1: {
		_centerPos = _location;
		
		//find which axis is smaller and select that
		_centerPosX = getMarkerSize _centerPos select 0;
		_centerPosY = getMarkerSize _centerPos select 1;
		_orderRadius = _centerPosY;
		if (_centerPosX <= _centerPosY) then {
			_orderRadius = _centerPosX;
		};
		
		//randomize radius near center of current zone size
		_orderRadius = random [1, _orderRadius *.25, _orderRadius * .65];
		
		//set a reasonable patrol distance
		private _patrolDistance = (_centerPosX + _centerPosY) * 0.15;
		
		//get a random position near zone center and order zombies to it
		_orderPos =  [getMarkerPos _centerPos, _orderRadius] call CBA_fnc_randPos;
		[_temp_Group, _orderPos, _patrolDistance] call BIS_fnc_taskPatrol;
	};

	//phase 2, zombies find players
	case 2: {
		private _targetPlayer = selectRandom allPlayers;
		
		//ensure player is actually in zone
		while {_targetPlayer inArea _location == false} do {
			private _targetPlayer = selectRandom allPlayers;
		
		};
		
		//send group at player's last loc
		_temp_Group addWaypoint [_targetPlayer, -1];
	};
	//phase 3, all zombies to decon area
	case 3: {
		//add waypoint to center area
		_temp_Group addWaypoint [getMarkerPos "phase3Marker", -1];
	};
};
				
			
			

//code for save			
//reset leader to fix "no orders" bug
//_temp_Group selectLeader (selectRandom units _temp_Group);
//_temp_Group selectLeader (leader _temp_Group);

/*
_wpPos = getWPPos [_temp_Group, 0];
//deleteWaypoint [_temp_Group, (count waypoints _temp_Group -1)];
deleteWaypoint [_temp_Group, 0];
sleep 0.5;
_wp = _temp_Group addWaypoint [_wpPos, 0, 0];
//deleteVehicle leader _temp_Group;

*/

//diag_log "Fixed group";