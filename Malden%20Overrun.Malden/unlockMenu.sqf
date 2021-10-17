/*
	Controls unlock options in the missionLaptop
*/

//remove all options from laptop menu
removeAllActions missionLaptop;

//add unlock options
//check what is not yet unlocked
if (UnlockTracker select 0 == false) then {
	missionLaptop addAction ["Unlock Helicopter - 300", { 
		remoteExec ["unlockHeli",2]; 
	}];
};
if (UnlockTracker select 1 == false) then {
	missionLaptop addAction ["Unlock Technical - 500", { 
		remoteExec ["unlockTech",2]; 
	}];
};	
if (UnlockTracker select 3 == false) then {
	missionLaptop addAction ["Unlock Suppressors - 800", { 
		remoteExec ["unlockSuppress",2]; 
	}];
};
if (UnlockTracker select 2 == false) then {
	missionLaptop addAction ["Unlock NVGs - 1200", { 
		remoteExec ["unlockNVG",2]; 
	}];
};
missionLaptop addAction ["Exit", { 
 ["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",0]; 
}];

unlockHeli = {
	//server actions
	if(isServer) then {	
		//get current bank
		_currentBank = FactionBank;	
		//check if 300 exists in FactionBank
		if (_currentBank >= 300) then {
			//remove 300 from bank
			[[-300],"addToBank.sqf"] remoteExec ["BIS_fnc_execVM",2];
			_currentBank = _currentBank - 300;
			//spawn heli
			["littleBirdUnlock.sqf"] remoteExec ["BIS_fnc_execVM",2];
			//set to unlocked for future use
			UnlockTracker set [0, TRUE];
			publicVariable "UnlockTracker";

			//inform users
			[format ["Helicopter has been unlocked. New bank total: %1", _currentBank]] remoteExec ["hint", 0];
			//exit menu
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",2]; 
			
		} else {
			//if there is not enough in bank, tell user
			[format ["You do not have enough to unlock. Current bank total: %1", _currentBank]] remoteExec ["hint", 0];
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",0]; 
			
		};
	};

};
unlockTech = {
	//server actions
	if(isServer) then {	
		//get current bank
		_currentBank = FactionBank;	
		//check if 500 exists in FactionBank
		if (_currentBank >= 500) then {
			//remove 500 from bank
			[[-500],"addToBank.sqf"] remoteExec ["BIS_fnc_execVM",2];
			_currentBank = _currentBank - 500;
			//spawn tech
			["techUnlock.sqf"] remoteExec ["BIS_fnc_execVM",2];
			//set to unlocked for future use
			UnlockTracker set [1, TRUE];
			publicVariable "UnlockTracker";
			//inform users
			[format ["Technical has been unlocked. New bank total: %1", _currentBank]] remoteExec ["hint", 0];
			//exit menu
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",2]; 
			
		} else {
			//if there is not enough in bank, tell user
			[format ["You do not have enough to unlock. Current bank total: %1", _currentBank]] remoteExec ["hint", 0];
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",2];
			
		};
	};

};
unlockSuppress = {
	//server actions
	if(isServer) then {	
		//get current bank
		_currentBank = FactionBank;	
		//check if 500 exists in FactionBank
		if (_currentBank >= 800) then {
			//remove 500 from bank
			[[-800],"addToBank.sqf"] remoteExec ["BIS_fnc_execVM",2];
			_currentBank = _currentBank - 800;
			//set to unlocked for future use
			UnlockTracker set [3, TRUE];
			publicVariable "UnlockTracker";
			//rerun initArsenal to update with new items
			["initArsenal.sqf"] remoteExec ["BIS_fnc_execVM",2];
			//inform users
			[format ["Suppressors have been unlocked. New bank total: %1", _currentBank]] remoteExec ["hint", 0];
			//exit menu
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",2]; 
			
		} else {
			//if there is not enough in bank, tell user
			[format ["You do not have enough to unlock. Current bank total: %1", _currentBank]] remoteExec ["hint", 0];
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",2];
			
		};
	};

};
unlockNVG = {
	//server actions
	if(isServer) then {	
		//get current bank
		_currentBank = FactionBank;	
		//check if 500 exists in FactionBank
		if (_currentBank >= 1200) then {
			//remove 500 from bank
			[[-1200],"addToBank.sqf"] remoteExec ["BIS_fnc_execVM",2];
			_currentBank = _currentBank - 1200;
			//set to unlocked for future use
			UnlockTracker set [2, TRUE];
			publicVariable "UnlockTracker";
			//rerun initArsenal to update with new items
			["initArsenal.sqf"] remoteExec ["BIS_fnc_execVM",2];
			//inform users
			[format ["NVGs have been unlocked. New bank total: %1", _currentBank]] remoteExec ["hint", 0];
			//exit menu
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",2]; 
			
		} else {
			//if there is not enough in bank, tell user
			[format ["You do not have enough to unlock. Current bank total: %1", _currentBank]] remoteExec ["hint", 0];
			["exitLaptopMenu.sqf"] remoteExec ["BIS_fnc_execVM",2];
			
		};
	};

};

