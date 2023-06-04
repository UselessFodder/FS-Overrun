//sets techTruck marker to techTruck every 10 seconds

while {true} do { //moves markers defines in editor to the position of vehicle every 10seconds
	
	//check if techTruck is alive
	if (alive techTruck) then {
		"techMarker" setmarkerpos getpos techTruck; 
	}else {
		//if truck is destroyed, delete the marker and wait until the truck respawns
		deleteMarker "techMarker";
		
		waitUntil{alive techTruck};
		//recreate marker
		createMarker ["techMarker",techTruck];
		"techMarker" setMarkerType "mil_triangle";
		"techMarker" setMarkerText "Technical";
		"techMarker"setMarkerAlpha 0.7;
		
		//"techMarker" setmarkerpos getpos techTruck; 
	};
	
	//wait 10 seconds
	sleep 10; 
};