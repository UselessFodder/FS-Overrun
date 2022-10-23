/*
	Creates groups and fills them for zombies within the DECON zones
	Params = 0: location index of zone within ZoneArray, 1: number of zombies to be put into the group, 2: location to spawn group, 3: points value per zombie kill
*/

params ["_locationIndex", "_spawnCount","_currentSpawn", "_perKill"];

//set skill for group
_currentSkill = selectRandom [0.2,0.3,0.4,0.5,0.6,0.7];

//create group to put Z's in
_temp_Group = createGroup[EAST,true];

//for each Z, create a random Z from global ZList (init.sqf)
for [{private _i = 0}, {_i < _spawnCount}, {_i = _i + 1}] do {
	//create Z
	_newZ = _temp_Group createUnit[(selectRandom ZList), _currentSpawn, [], 5, "NONE"]; 
	//set random skill level
	_newZ setSkill _currentSkill;
	
		//add variables to _newZ so I can access them in EH
	_newZ setVariable["_killedValues",[_locationIndex, _perKill], false];

//create eventhandler to lower infection rate when killed				
_newZ addEventHandler ["Killed", 
	//check if zone is active and not in a mission or cleanse
	format ["if(ZoneArray select %1 select 3 && ZoneArray select %1 select 4 == false && ZoneArray select %1 select 5 == false) then {", _locationIndex] +
		//if not, get previous infectionrate value and then subtract perKill value passed into EH
		format ["private _previousValue = ZoneArray select %1 select 2;", _locationIndex] +
		format ["private _newValue = _previousValue - %1;", _perKill] +
		
		format ["ZoneArray select %1 set [2, _newValue];", _locationIndex] + 
		//format ["hintSilent 'Subtracting %1 to get ';", _perKill, ZoneArray select _locationIndex select 2] + //**TESTING DELETE
		
		//add currency to faction bank for each Z killed
		"[1] execVM 'addToBank.sqf';" +
		
		
	"};"

];
	
};

//give zombies orders
//[_temp_Group,_locationIndex] execVM "areaOrders.sqf";

_temp_Group setBehaviour "CARELESS";

//set random formation
_temp_Group setFormation selectRandom["WEDGE","DIAMOND","VEE","LINE"];

//give 3 seconds for AI scripts to start
//sleep 5;

// get random point inside zone
_currentWaypoint = [ZoneArray select _locationIndex select 0, false] call CBA_fnc_randPosArea;
_location = ZoneArray select _locationIndex select 0;

switch (selectRandom[0,1,2,3,3,4,4,4,4,4]) do {
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
		//private _allpositions = (nearestBuilding _currentWaypoint) buildingPos -1;	
		private _unitCounter = 0;
		private _building = nearestBuilding _currentWaypoint;
		{	
			//If more than 4 in group, delete extras to not massively overfill building
			_unitCounter = _unitCounter +1;						
			if (_unitCounter > 4) then {
				deleteVehicle _x;
				
			} else {
				//get nearest building
				private _building = nearestBuilding _currentWaypoint;
				
				//move unit into random spot within building
				_x setPosATL selectRandom (_building buildingPos -1);
				
				//TEST PLS DELETE***
				//diag_log format ["Putting Z into building at %1", _posToMove];
				diag_log format ["Putting Z into building at %1", getPos _x];
				
				//_x setPosATL _posToMove;
				
				
				//move all non-leaders into a separate group
				if (_x != leader _temp_Group) then {
					//set to new group to each spawn operates separately
					_id = time;
					_groupVarName = format ["EastGroup:%1", _id];
					private _groupVarName = createGroup[EAST,true]; 
					[_x] joinSilent _groupVarName;
					//give order to defend position to prevent zombies from running away
					[_groupVarName, getPos _x] call BIS_fnc_taskDefend;
					
				} else {
					[_temp_Group, getPos _x] call BIS_fnc_taskDefend;
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

//set behavior of group randomly
//_currentBehavior = selectRandom["CARELESS","SAFE","SAFE","SAFE","SAFE","AWARE","AWARE","AWARE","AWARE","AWARE"];		
//_temp_Group setBehaviour _currentBehavior;




sleep 5; 

//fix stuck zombies
doStop (leader _temp_Group);
sleep 1;
units _temp_Group doFollow leader _temp_Group;

_temp_Group;