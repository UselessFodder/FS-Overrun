/*
	Cause time of day to never change
*/

_initdate = date;
while {true} do
{
	setdate _initdate;
	sleep 30;
}; 