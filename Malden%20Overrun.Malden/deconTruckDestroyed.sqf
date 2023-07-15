/*
	If deconTruck is destroyed, this is called to replace it after 60 seconds
*/

//log
diag_log "** Decon Truck has been destroyed. Respawning in 60 seconds";

sleep 60;

if(isServer) then {
	//create new deconTruck
	deconTruck = DeconTruckType createVehicle getMarkerPos "deconTruckPoint"; 
	deconTruck setDir 150;


	/*

	
	deconTruck addEventHandler ["Killed",{
		{
			deleteVehicle _x;
		} forEach attachedObjects deconTruck;
		
		execVM "deconTruckDestroyed.sqf"; 
	}];
	
	*/
	//add decon action to truck
	[deconTruck,["Begin DECON", {[[],"initCleanse.sqf"] remoteExec ["BIS_fnc_execVM",2];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];
	
	//add new eventHandler to new vic
	[deconTruck, ["Killed",{
		{
			//deleteVehicle _x;
			[_x] remoteExec ["deleteVehicle",2]
		} forEach attachedObjects deconTruck;
		["deconTruckDestroyed.sqf"] remoteExec ["BIS_fnc_execVM",2]
	}]] remoteExec ["addEventHandler",0];
	/*
	deconTruck addMPEventHandler ["MPKilled", {
		{
			deleteVehicle _x;
		} forEach attachedObjects deconTruck;
		
		execVM "deconTruckDestroyed.sqf"; 
	}];
	*/

  //attach patch to truck 
  _tex = "UserTexture1m_F" createvehicle getpos deconTruck; 
  //_tex setobjectTexture [0,"BRT_Gray.paa"]; 
  [_tex, [0,"BRT_Gray.paa"]] remoteExec ["setObjectTexture",0];
  _tex Attachto [deconTruck, [-1.4,-2.3,0.4]];
  _tex setdir 90;
  _tex setObjectScale 1.5; 
 
  //attach patch to truck 
  _tex = "UserTexture1m_F" createvehicle getpos deconTruck; 
  //_tex setobjectTexture [0,"BRT_Gray.paa"]; 
  [_tex, [0,"BRT_Gray.paa"]] remoteExec ["setObjectTexture",0];
  _tex Attachto [deconTruck, [1.1,-2.3,0.4]];
  _tex setdir 270;
  _tex setObjectScale 1.7; 

	//add arsenal
	[deconTruck,ArsenalItems,true,true] remoteExecCall ["BIS_fnc_addVirtualItemCargo", 0];
	[deconTruck,ArsenalBackpacks,true,true] remoteExecCall ["BIS_fnc_addVirtualBackpackCargo", 0];
	[deconTruck,ArsenalWeapons,true,true] remoteExecCall ["BIS_fnc_addVirtualWeaponCargo", 0];
	[deconTruck,ArsenalMagazines,true,true] remoteExecCall ["BIS_fnc_addVirtualMagazineCargo", 0];

	//log
	diag_log format ["** Decon Truck has been respawned with %1 attached items",count attachedObjects deconTruck];

//deconTruck addAction ["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

//[deconTruck,["Begin DECON", "initCleanse.sqf",[],1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];



//this addAction ["Begin DECON", {{} remoteExec ["initCleanse.sqf"]},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

//this addAction ["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

};