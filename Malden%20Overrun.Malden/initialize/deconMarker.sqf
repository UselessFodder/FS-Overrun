//sets decon truck marker to deconTruck every 10 seconds

while {true} do { //moves markers defines in editor to the position of vehicle every 20 seconds
	
	//check if mobileRespawn is alive
	if (alive deconTruck) then {
		"deconTruckMarker" setmarkerpos getpos deconTruck; 
	}else{
		"deconTruckMarker" setMarkerAlpha 0;
		
		waitUntil{alive deconTruck};
			"deconTruckMarker" setMarkerAlpha 0.7;
			"deconTruckMarker" setmarkerpos getpos deconTruck; 
		
	};
	
	//wait 10 seconds
	sleep 10; 
};