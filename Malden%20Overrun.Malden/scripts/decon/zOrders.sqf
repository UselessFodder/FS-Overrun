/*
	Delays orders for single units to attack the decon truck. Fixes the glitch that prevents zombies from listening to orders
*/

params ["_temp_Group"];

//give 3 seconds for AI scripts to start
sleep 3;

_temp_Group setBehaviour "AWARE";
_temp_Group setCombatMode "RED";
_temp_Waypoint = _temp_Group addWaypoint [deconTruck, -1];
_temp_Waypoint setWaypointType "SAD";