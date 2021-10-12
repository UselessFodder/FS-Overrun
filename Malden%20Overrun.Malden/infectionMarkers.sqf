/*
	Updates infection rates and marker alpha channels every 20 seconds
*/
//if(isServer) then {
	while{true} do{

		//check if players are online
		if(count allPlayers > 0) then {

			//cycle through each location, add infection, and set alpha to half of infection rates
			for "_i" from 0 to 30 do { 
				//check if still infected
				//if(IsInfected select _i)then {
				if(ZoneArray select _i select 1) then {
					If(isServer) then {
						//add additional infection to all currently infected locations if they are < 100
						//if(InfectionRate select _i < 1) then {InfectionRate set [_i, ((InfectionRate select _i) + 0.001)];};
						if(ZoneArray select _i select 2 < 1) then {ZoneArray select _i set [2, ((ZoneArray select _i select 2) + 0.001)];};
						publicVariable "ZoneArray";
					};
					
					//update marker colors and alpha
					//Locations select _i setMarkerColor "ColorRed";
					ZoneArray select _i select 0 setMarkerColor "ColorRed";
					
					//set alpha to 80% for visibility, but never below 10%
					//_colorAlpha = (InfectionRate select _i) * 0.8;
					_colorAlpha = (ZoneArray select _i select 2) * 0.8;
					if (_colorAlpha < 0.1) then {
						_colorAlpha = 0.20;
					};
										
					//Locations select _i setMarkerAlpha _colorAlpha;
					ZoneArray select _i select 0 setMarkerAlpha _colorAlpha;

				} else {
					// If area is cleansed, mark it green
					//Locations select _i setMarkerColor "ColorGreen";
					ZoneArray select _i select 0 setMarkerColor "ColorGreen";
					//Locations select _i setMarkerAlpha 0.5;
					ZoneArray select _i select 0 setMarkerAlpha 0.5;
				};
			
			};

			//delay 20 seconds
			Sleep 20;
		};	
	};
//};