/*
	If mobileRespawn is destroyed, this is called to replace it after 30 seconds
*/
sleep 30;
if (isServer) then {
	//create new mobileRespawn
	mobileRespawn = "c_Truck_02_covered_F" createVehicle getMarkerPos "mobileRespawnPoint"; 
	mobileRespawn setDir 130;

	//add new eventHandler to new vic
	mobileRespawn addEventHandler ["Killed",{execVM "mobileRespawnDestroyed.sqf"}];
};