/*
	Script to inform players of scenario victory!
*/
sleep 2;

[["You've done it... Sefrou-Ramal has been cleansed of the zombie magick!", "PLAIN"]] remoteExec ["titleText", 0];

sleep 5;

[["Thank you for testing the Sefrou-Ramal Alpha!\nPlease give UselessFodder your feedback to improve this scenario!\nYou can find him at discord.gg/UselessFodder or on socials", "PLAIN"]] remoteExec ["titleText", 0];

sleep 5;

//end the mission and return to select screen
"end1" call BIS_fnc_endMission;