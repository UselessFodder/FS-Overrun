//sets littleBird marker to littleBird every 10 seconds

while {true} do { //moves markers defines in editor to the position of vehicle every 10seconds
	
	//check if littleBird is alive
	if (alive littleBird) then {
		"littleBirdMarker" setmarkerpos getpos littleBird; 
	}else {
		//if truck is destroyed, delete the marker and wait until the truck respawns
		deleteMarker "littleBirdMarker";
		
		waitUntil{alive littleBird};
		//recreate marker
		createMarker ["littleBirdMarker",littleBird];
		"littleBirdMarker" setMarkerType "mil_triangle";
		"littleBirdMarker" setMarkerText "Little Bird";
		"littleBirdMarker"setMarkerAlpha 0.7;
		
		//"littleBirdMarker" setmarkerpos getpos littleBird; 
	};
	
	//wait 10 seconds
	sleep 10; 
};