/*
	Deletes previous DECON Truck and creates new one at base
*/

//Check if DECON Truck is alive to prevent using
// 	this to speed up a regular respawn
if(isNull deconTruck == false) then {
	if(isServer) then {	
		//delete previous deconTruck
		deleteVehicle deconTruck;
		
		//Wait 15 seconds for any outstanding effects to completedFSM
		sleep 15;
		
		//create new deconTruck
		deconTruck = "B_Truck_01_medical_F" createVehicle getMarkerPos "deconTruckPoint"; 
		deconTruck setDir 150;

		//add new eventHandler to new vic
		deconTruck addEventHandler ["Killed",{execVM "deconTruckDestroyed.sqf"}];
		//add decon action to truck
		[deconTruck,["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];
		//deconTruck addAction ["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];
	};
};