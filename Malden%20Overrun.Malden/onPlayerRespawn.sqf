/*
	Remove any default equipment and set basic items on respawn
*/

//set default insignia
[player, "brt_gray"] call BIS_fnc_setUnitInsignia;

removeAllItems player;
player addItem "Binocular";
player assignItem "Binocular";
player addItem "ItemCompass";
player assignItem "ItemCompass";
player additem "ItemMap";
player assignItem "ItemMap";
player addItem "ItemWatch";
player assignItem "ItemWatch";
player addItem "FirstAidKit";
player addItem "tf_anprc152";
player assignItem "tf_anprc152";
