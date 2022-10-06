/*
	Script to inform players of scenario victory!
*/
sleep 2;

[["You've done it... Malden has been cleansed of the zombie menace!", "PLAIN"]] remoteExec ["titleText", 0];

sleep 5;

[["Thank you for testing the Malden Overrun Alpha!\nPlease give UselessFodder your feedback to improve this scenario!\nYou can find him at discord.gg/UselessFodder or on socials", "PLAIN"]] remoteExec ["titleText", 0];

sleep 5;

//end the mission and return to select screen
"end1" call BIS_fnc_endMission;