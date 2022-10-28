/*
	If techTruck is destroyed, this is called to replace it after 15 seconds
*/
//log
diag_log "** techTruck has been destroyed. Respawning in 60.";

sleep 60;

/*
if(techTruck distance getMarkerPos "techSpawn" < 20) then {

	deleteVehicle techTruck;
	sleep 5;
	
};

*/

if(isServer) then {
	//create new techTruck
	techTruck = "B_ION_Offroad_armed_lxWS" createVehicle getMarkerPos "techSpawn"; 
	techTruck setDir 133;

	//add new eventHandler to new vic
	//techTruck addMPEventHandler ["MPKilled",{execVM "techDestroyed.sqf"}];
	[techTruck, ["Killed",{
		["techDestroyed.sqf"] remoteExec ["BIS_fnc_execVM",2]
	}]] remoteExec ["addEventHandler",0];

	
	//log
	diag_log "** techTruck has been respawned.";

};

