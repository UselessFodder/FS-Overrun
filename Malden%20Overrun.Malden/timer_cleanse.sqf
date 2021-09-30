/*
	Starts timer for all players during decon process
*/

params["_locationIndex","_location"];

private _locationIndex = _this select 0;
private _location = Locations select _locationIndex;

//begin the countdown
[150,false] call BIS_fnc_countdown;
//[150,true] remoteExec ["BIS_fnc_countdown", 0];

//if the DECON process is still underway
while{CleanseActive} do {
	//check if deconTruck is still alive. If not, delete driver, set cleanseactive to false, and kill countdown timer
	if (isNull deconTruck == true || deconTruck getHitPointDamage "HitEngine" == 1 || deconTruck getHitPointDamage "HitHull" == 1 || deconTruck getHitPointDamage "HitFuel" == 1) then {
		
		//kill timer & refresh hint
		//[-1] call BIS_fnc_countdown;
		hint "";
		
		//[-1] remoteExec ["BIS_fnc_countdown", 0];
		//[""] remoteExec ["hint", 0];
		
		//inform the user
		titleText ["DECON Vehicle destroyed. Area is not decontaminated...", "PLAIN"];
		CleanseActive = false;		
		
	}else { // if truck is not destroyed, check if timer is complete
	
		_timeLeft = [0] call BIS_fnc_countdown;
		
		//if timer is complete, set area to not infected and clear cleanseActive
		if ( _timeLeft <= 0) then {
			
			//inform the User
			titleText[format ["Area %1 successfully decontaminated.", _location], "PLAIN"];
			CleanseActive = false;			
		
		} else{//if timer is not complete, update hint
			hint format ["%1 until DECON", floor _timeLeft];
		
		};//end else
	
	
	};//end else

	//delay 0.5 seconds
	sleep 0.5;
};//end while