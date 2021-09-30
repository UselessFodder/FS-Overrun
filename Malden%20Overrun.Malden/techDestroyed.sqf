/*
	If techTruck is destroyed, this is called to replace it after 15 seconds
*/
sleep 60;
if(techTruck distance getMarkerPos "techSpawn" < 20) then {

	deleteVehicle techTruck;
	sleep 5;
	
};

if(isServer) then {
	//create new techTruck
	techTruck = "B_LSV_01_armed_F" createVehicle getMarkerPos "techSpawn"; 
	techTruck setDir 133;

	//add new eventHandler to new vic
	techTruck addEventHandler ["Killed",{execVM "techDestroyed.sqf"}];
	//add decon action to heli
	//[deconTruck,["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];

};

