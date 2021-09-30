/*
	Saves the following global variables to profileNamespace:
	- IsInfected
	- InfectionRate
	- ActiveSpawn
	Later, will save team and player resources
*/

//ensure this only saves on server
if(isServer) then {
	//set variables to namespace
	profileNamespace setVariable ["IsInfected", IsInfected];
	profileNamespace setVariable ["InfectionRate", InfectionRate];
	profileNamespace setVariable ["ActiveSpawn", ActiveSpawn];
	profileNamespace setVariable ["FactionBank", FactionBank];
	profileNamespace setVariable ["UnlockTracker", UnlockTracker];

	//save namespace
	saveProfileNamespace;

};

//inform users
hint "Mission State Saved";
//["Mission State Saved"] remoteExec ["hint", 0];