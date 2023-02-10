/*
	Returns all normal functions to mission laptop
*/

	//remove all actions from laptop
	removeAllActions missionLaptop;

	//add basic actions back in
	
	missionLaptop addAction ["Save Mission State", { 
		{null = execVM "saveState.sqf"} remoteExec ["call",0]; 
	}];

	missionLaptop addAction ["Reset DECON Truck", { 
		{null = execVM "resetDecon.sqf"} remoteExec ["call",2]; 
	}];

	missionLaptop addAction ["Reset Transport Truck", { 
		{null = execVM "resetRespawn.sqf"} remoteExec ["call",0]; 
	}];

	missionLaptop addAction ["Unlock Menu", { 
		{null = execVM "unlockMenu.sqf"} remoteExec ["call",0]; 
	}];
	
