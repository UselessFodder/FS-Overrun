//sets respawn marker to mobileRespawn ever 10 seconds

while {true} do { //moves markers defines in editor to the position of vehicle every 10seconds
	
	//check if mobileRespawn is alive
	if (alive deconTruck) then {
		"respawn_west_mobile" setmarkerpos getpos deconTruck; 
	}else {
		//if truck is destroyed, delete the marker and wait until the truck respawns
		deleteMarker "respawn_west_mobile";
		
		waitUntil{alive deconTruck};
		//recreate marker
		createMarker ["respawn_west_mobile",deconTruck];
		"respawn_west_mobile" setMarkerType "mil_start";
		"respawn_west_mobile" setMarkerText "Mobile Respawn";
		"respawn_west_mobile" setMarkerAlpha 0.7;
		
		//"respawn_west_mobile" setmarkerpos getpos mobileRespawn; 
	};
	
	//wait 10 seconds
	sleep 10; 
};