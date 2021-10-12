/*
	Allows little bird to lower infection rate via an addAction command
*/

//variables
private _nearLoc = "";
private _locIndex = -1;

//remove actions for all players
//{removeAllActions littleBird;} remoteExec ["call", 0];
//["littleBirdRemoveActions.sqf"] remoteExec ["BIS_fnc_execVM",0];

//server-side
if(isServer) then {

	//check if littleBird is near a point
	{

		if (100 >= (littleBird distance getMarkerPos _x)) then {		
			_nearLoc = _x;
			_locIndex = _forEachIndex;		
		};	
		
	} forEach Locations;

	//if null, this is not near location
	if(_nearLoc isEqualTo "") then {
		//titleText ["The helicopter must be within 100 meters of an infection center.", "PLAIN"];
		[["littleBirdMarker",200,"The helicopter must be within 100 meters of an infection center."],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
		//add action back to heli
		//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",2];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",0];
		//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",-2];
		//[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
		
	} else {
		// Check if area is still infected
		//if (isInfected select _locIndex == false) then {
		if (ZoneArray select _locIndex select 1 == false) then {
			//titleText [format ["%1 has already been decontaminated!", _nearLoc], "PLAIN"];		
			[["littleBirdMarker",300,(format ["%1 has already been decontaminated!", _nearLoc])],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
			//add action back to heli
			//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",-2];
			//[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
			
			
		} else {
			// else, check if infection rate is below 81%
			//if((InfectionRate select _locIndex) < 0.81) then {
			if((ZoneArray select _locIndex select 2) < 0.81) then {
				//titleText ["The infection is already below the airborne decontamination threashold!", "PLAIN"];			
				[["littleBirdMarker",300,"The infection is already below the airborne decontamination threashold!"],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];			
				
				//add action back to heli
				//[littleBird,["Airborne DECON", {["littleBirdDecon.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","true",5,false,"",""]] remoteExec ["addAction",-2];
				//[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
				
			} else {			
				[_locIndex,_nearLoc] remoteExec ["fnc_airDecon",0];
				
				fnc_airDecon = {
					params ["_locIndex","_nearLoc"];
					private _locIndex = _this select 0;
					private _nearLoc = _this select 1;

					[[_nearLoc,300,"Beginning airborne DECON process... Once started, hold steady for 20 seconds..."],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
					sleep 5;
					
					_deconShell_1 = "SmokeShell" createVehicle (position littleBird);
					_deconShell_1 attachto [littleBird, [0,0,-1]];
					_deconShell_2 = "SmokeShell" createVehicle (position littleBird);
					_deconShell_2 attachto [littleBird, [0.5,0,-1]];
					_deconShell_3 = "SmokeShell" createVehicle (position littleBird);
					_deconShell_3 attachto [littleBird, [-0.5,0,-1]];
					
					private _deconTimer = 20;
					private _airDeconFail = false;
					private _airDeconComplete = false;
					
					while{!_airDeconComplete  && !_airDeconFail} do {
						sleep 1;
						
						//inform every 5 seconds
						if(_deconTimer == 15 || _deconTimer == 10 || _deconTimer == 5) then {
							[[_nearLoc,300,(format ["%1 seconds left. Hold steady...", _deconTimer])],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
						};
						
						//lower timer
						_deconTimer = _deconTimer - 1;
						
						//check if heli has left area
						if((littleBird distance getMarkerPos _nearLoc) > 100) then {
							//update armed variable
							LittleBirdArmed = false;
							publicVariable "LittleBirdArmed";
							
							//inform area and set failure
							[[_nearLoc,300,"Helicopter is too far outside the contaminated area. Rearm decontaminate at base and try again..."],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
							_airDeconFail = true;

							
						} else {
							//check if timer is at 0 to complete decon
							if(_deconTimer == 0) then {							
								//update armed variable
								LittleBirdArmed = false;
								publicVariable "LittleBirdArmed";
								
								//set success
								_airDeconComplete = true;
							
								//set infection rate to 81%
								ZoneArray select _locIndex set [2, 0.81];
								//InfectionRate set [_locIndex, 0.81];
								
								
								//inform success
								[[_nearLoc,300,"Airborne decontamination successful. RTB to rearm decontaminate."],"messageNear.sqf"] remoteExec ["BIS_fnc_execVM",0];
							};
						};

					};

					
					//once attempt is complete, give rearm command & delete smoke
					//[littleBird,["Rearm Decontaminate", {["rearmLittleBird.sqf"] remoteExec ["BIS_fnc_execVM",0];},nil,1.5,FALSE,true,"","CleanseActive == false",5,false,"",""]] remoteExec ["addAction",-2];
					//[[LittleBirdArmed],"littleBirdAddAction.sqf"] remoteExec ["BIS_fnc_execVM",0];
					deleteVehicle _deconShell_1;
					deleteVehicle _deconShell_2;
					deleteVehicle _deconShell_3;

					
				};
			};
		
		};
	};
};