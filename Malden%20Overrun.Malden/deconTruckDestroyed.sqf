/*
	If deconTruck is destroyed, this is called to replace it after 60 seconds
*/
sleep 60;
//create new deconTruck
deconTruck = "B_Truck_01_medical_F" createVehicle getMarkerPos "deconTruckPoint"; 
deconTruck setDir 150;

if(isServer) then {
	//add new eventHandler to new vic
	deconTruck addEventHandler ["Killed",{execVM "deconTruckDestroyed.sqf"}];
	//add decon action to truck
	[deconTruck,["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];

};

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

//add arsenal
[deconTruck,ArsenalItems,true,true] remoteExecCall ["BIS_fnc_addVirtualItemCargo", 0];
[deconTruck,ArsenalBackpacks,true,true] remoteExecCall ["BIS_fnc_addVirtualBackpackCargo", 0];
[deconTruck,ArsenalWeapons,true,true] remoteExecCall ["BIS_fnc_addVirtualWeaponCargo", 0];
[deconTruck,ArsenalMagazines,true,true] remoteExecCall ["BIS_fnc_addVirtualMagazineCargo", 0];

//deconTruck addAction ["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

//[deconTruck,["Begin DECON", "initCleanse.sqf",[],1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",0];



//this addAction ["Begin DECON", {{} remoteExec ["initCleanse.sqf"]},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

//this addAction ["Begin DECON", {{null = execVM "initCleanse.sqf"} remoteExec ["call",0];},nil,1.5,FALSE,FALSE,"","CleanseActive == false",5,false,"",""];

