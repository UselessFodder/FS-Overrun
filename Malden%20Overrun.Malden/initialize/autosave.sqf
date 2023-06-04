/*
	Executes a server save state every 20 minutes
*/

while {true} do {
	sleep 1200;
	execVM "saveState.sqf";
};