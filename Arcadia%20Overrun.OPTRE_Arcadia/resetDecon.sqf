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
		
	  //attach patch to truck 
	  _tex = "UserTexture1m_F" createvehicle getpos deconTruck; 
	  _tex setobjectTexture [0,"BRT_Gray.paa"]; 
	  _tex Attachto [deconTruck, [-1.4,-2.3,0.4]];
	  _tex setdir 90;
	  _tex setObjectScale 1.5; 
	 
	  //attach patch to truck 
	  _tex = "UserTexture1m_F" createvehicle getpos deconTruck; 
	  _tex setobjectTexture [0,"BRT_Gray.paa"]; 
	  _tex Attachto [deconTruck, [1.1,-2.3,0.4]];
	  _tex setdir 270;
	  _tex setObjectScale 1.7; 
 

		
		//create arsenal for all players
		[deconTruck,ArsenalItems,true,true] remoteExecCall ["BIS_fnc_addVirtualItemCargo", 0];
		[deconTruck,ArsenalBackpacks,true,true] remoteExecCall ["BIS_fnc_addVirtualBackpackCargo", 0];
		[deconTruck,ArsenalWeapons,true,true] remoteExecCall ["BIS_fnc_addVirtualWeaponCargo", 0];
		[deconTruck,ArsenalMagazines,true,true] remoteExecCall ["BIS_fnc_addVirtualMagazineCargo", 0];
			
	};
};