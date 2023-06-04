/*
	Clears the saveState values within the profileNamespace
*/
if(isServer) then {
	//set nil to namespace variables
	profileNamespace setVariable ["IsInfected", nil];
	profileNamespace setVariable ["InfectionRate", nil];
	profileNamespace setVariable ["ActiveSpawn", nil];
	profileNamespace setVariable ["FactionBank", nil];
	profileNamespace setVariable ["UnlockTracker", nil];
	//save namespace
	saveProfileNamespace;

};