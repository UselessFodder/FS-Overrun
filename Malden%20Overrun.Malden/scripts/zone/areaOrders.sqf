/*
	Delays orders for units in area_init and area_spawn. Fixes the glitch that prevents zombies from listening to orders
	Params: 0 - Group to give orders to, 1 - Index of zone within ZoneArray
*/

params ["_temp_Group","_locationIndex"];

//give 3 seconds for AI scripts to start
sleep 4;


// get random point inside zone
_currentWaypoint = [ZoneArray select _locationIndex select 0, false] call CBA_fnc_randPosArea;
_location = ZoneArray select _locationIndex select 0;

switch (selectRandom[0,1,2,3,4,4,4,4]) do {
	//case 0: {[_temp_Group, _currentWaypoint, 20] call BIS_fnc_taskPatrol}; ***
	//long patrol around a different waypoint than spawn
	case 0: {
		private _currentZone = MarkerSize _location;
		//get 20% of the average of the zone's total size
		private _patrolDistance = ((_currentZone select 0) + (_currentZone select 1)) * 0.2;
		
		//long patrol
		[_temp_Group, _currentWaypoint, _patrolDistance] call BIS_fnc_taskPatrol					
	};
	//defend current spawn point
	case 1: {[_temp_Group, _currentWaypoint] call BIS_fnc_taskDefend};
	
	//patrol locally around spawn point
	case 2: {
		private _currentZone = MarkerSize _location;
		//get 5% of the average of the zone's total size
		private _patrolDistance = ((_currentZone select 0) + (_currentZone select 1)) * 0.05;
		
		//local patrol					
		[_temp_Group, getpos leader _temp_Group,_patrolDistance] call BIS_fnc_taskPatrol
		
	};
	//put group in building in zone and separate groups to prevent moving into formation
	case 3: {				
		private _allpositions = (nearestBuilding _currentWaypoint) buildingPos -1;	
		private _unitCounter = 0;
		{
			_unitCounter = _unitCounter +1;						
			if (_unitCounter > 3) then {
				deleteVehicle _x;
				
			} else {
			
				//get position inside building
				private _posToMove = (nearestBuilding _currentWaypoint) buildingPos selectRandom[(count _allpositions)-1];
				
				//add a little distance so units don't spawn on top of each other
				_posToMove = _posToMove vectorAdd [random[0.1,1.1,2]-1,random[0.1,1.1,2]-1,0];
				
				//TEST PLS DELETE***
				diag_log format ["Putting Z into building at %1", _posToMove];
				
				_x setPosATL _posToMove;
				
				//move all non-leaders into a separate group
				if (_x != leader _temp_Group) then {
					//set to new group to each spawn operates separately
					_id = time;
					_groupVarName = format ["EastGroup:%1", _id];
					private _groupVarName = createGroup[EAST,true]; 
					[_x] joinSilent _groupVarName;
				};
			};
		} forEach units _temp_Group;
	
	};
	
	//patrol around center of zone
	case 4: {								
		_centerPos = ZoneArray select _locationIndex select 0;
		
		//find which axis is smaller and select that
		_centerPosX = getMarkerSize _centerPos select 0;
		_centerPosY = getMarkerSize _centerPos select 1;
		_orderRadius = _centerPosY;
		if (_centerPosX >= _centerPosY) then {
			_orderRadius = _centerPosX;
		};
		
		//randomize radius near center of current zone size
		//_orderRadiusMin = _infectionRate * 0.25;
		//_orderRadiusMax = _infectionRate * 0.75;
		_orderRadius = random [1, _orderRadius *.45, _orderRadius * .75];
		//_orderRadius = random [1, _orderRadius *_orderRadiusMin, _orderRadius * _orderRadiusMax];
		
		//set a reasonable patrol distance
		private _patrolDistance = (_centerPosX + _centerPosY) * 0.1;
		
		//get a random position near zone center and order zombies to it
		_orderPos =  [getMarkerPos _centerPos, _orderRadius] call CBA_fnc_randPos;
		[_temp_Group, _orderPos, _patrolDistance] call BIS_fnc_taskPatrol;
	};

};//end switch	