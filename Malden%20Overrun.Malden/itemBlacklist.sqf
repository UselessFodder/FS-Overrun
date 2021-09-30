/*
	Checks if unit's loadout contains a restricted item. If so, removes all items and prompts the user to select a new loadout
*/

params ["_unit","_restrictedItemList"];

_unit = _this select 0;
_restrictedItemList = _this select 1;
_restrictedItemList = _restrictedItemList apply {toLower _x};

getUnitLoadout _unit params [
	"_gunInfo", "_launcherInfo", "_pistolInfo",
	"_uniformInfo", "_vestInfo", "_backpackInfo",
	"_helmet", "_glasses", "_binocluarInfo",
	"_items"
];

_gunInfo params ["_gun", "_gunMuzzle", "_gunPointer", "_gunOptic", "_gunMag", "_gunMag2", "_gunBipod"];
_launcherInfo params ["_launcher", "_launcherMuzzle", "_launcherPointer", "_launcherOptic", "_launcherMag", "_launcherMag2", "_launcherBipod"];
_pistolInfo params ["_pistol", "_pistolMuzzle", "_pistolPointer", "_pistolOptic", "_pistolMag", "_pistolMag2", "_pistolBipod"];
_binocluarInfo params ["_binocluar", "_binocluarMuzzle", "_binocluarPointer", "_binocluarOptic", "_binocluarMag", "_binocluarMag2", "_binocluarBipod"];

_uniformInfo params ["_uniform"];
_vestInfo params ["_vest"];
_backpackInfo params ["_backpack"];

if (toLower _gun in _restrictedItemList) then {
	_unit removeWeapon _gun;
};

if (toLower _gunMuzzle in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunMuzzle;
};

if (toLower _gunPointer in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunPointer;
};

if (toLower _gunOptic in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunOptic;
};

if (toLower _gunBipod in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunBipod;
};

if (toLower _launcher in _restrictedItemList) then {
	_unit removeWeapon _launcher;
};

if (toLower _launcherMuzzle in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherMuzzle;
};

if (toLower _launcherPointer in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherPointer;
};

if (toLower _launcherOptic in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherOptic;
};

if (toLower _launcherBipod in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherBipod;
};

if (toLower _pistol in _restrictedItemList) then {
	_unit removeWeapon _pistol;
};

if (toLower _pistolMuzzle in _restrictedItemList) then {
	_unit removeHandgunItem _pistolMuzzle;
};

if (toLower _pistolPointer in _restrictedItemList) then {
	_unit removeHandgunItem _pistolPointer;
};

if (toLower _pistolOptic in _restrictedItemList) then {
	_unit removeHandgunItem _pistolOptic;
};

if (toLower _pistolBipod in _restrictedItemList) then {
	_unit removeHandgunItem _pistolBipod;
};

if (toLower _uniform in _restrictedItemList) then {
	removeUniform _unit;
};

if (toLower _vest in _restrictedItemList) then {
	removeVest _unit;
};

if (toLower _backpack in _restrictedItemList) then {
	removeBackpack _unit;
};

if (toLower _helmet in _restrictedItemList) then {
	removeHeadgear _unit;
};

if (toLower _glasses in _restrictedItemList) then {
	removeGoggles _unit;
};

if (toLower _binocluar in _restrictedItemList) then {
	_unit removeWeapon _binocluar;
};

{
	if (toLower _x in _restrictedItemList) then {
		_unit unlinkItem _x;
	};
} forEach _items;

{
	_unit removeMagazine _x;
} forEach magazines _unit;

{
	_unit removeItem _x;
} forEach items _unit;

/*
_restrictedItemList = ["MX_F"];
_restrictedItemList = _restrictedItemList apply {toLower _x};

[missionNamespace, "ArsenalClosed", {
private _unit = player;

getUnitLoadout _unit params [
	"_gunInfo", "_launcherInfo", "_pistolInfo",
	"_uniformInfo", "_vestInfo", "_backpackInfo",
	"_helmet", "_glasses", "_binocluarInfo",
	"_items"
];

_gunInfo params ["_gun", "_gunMuzzle", "_gunPointer", "_gunOptic", "_gunMag", "_gunMag2", "_gunBipod"];
_launcherInfo params ["_launcher", "_launcherMuzzle", "_launcherPointer", "_launcherOptic", "_launcherMag", "_launcherMag2", "_launcherBipod"];
_pistolInfo params ["_pistol", "_pistolMuzzle", "_pistolPointer", "_pistolOptic", "_pistolMag", "_pistolMag2", "_pistolBipod"];
_binocluarInfo params ["_binocluar", "_binocluarMuzzle", "_binocluarPointer", "_binocluarOptic", "_binocluarMag", "_binocluarMag2", "_binocluarBipod"];

_uniformInfo params ["_uniform"];
_vestInfo params ["_vest"];
_backpackInfo params ["_backpack"];

if (toLower _gun in _restrictedItemList) then {
	_unit removeWeapon _gun;
};

if (toLower _gunMuzzle in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunMuzzle;
};

if (toLower _gunPointer in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunPointer;
};

if (toLower _gunOptic in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunOptic;
};

if (toLower _gunBipod in _restrictedItemList) then {
	_unit removePrimaryWeaponItem _gunBipod;
};

if (toLower _launcher in _restrictedItemList) then {
	_unit removeWeapon _launcher;
};

if (toLower _launcherMuzzle in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherMuzzle;
};

if (toLower _launcherPointer in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherPointer;
};

if (toLower _launcherOptic in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherOptic;
};

if (toLower _launcherBipod in _restrictedItemList) then {
	_unit removeSecondaryWeaponItem _launcherBipod;
};

if (toLower _pistol in _restrictedItemList) then {
	_unit removeWeapon _pistol;
};

if (toLower _pistolMuzzle in _restrictedItemList) then {
	_unit removeHandgunItem _pistolMuzzle;
};

if (toLower _pistolPointer in _restrictedItemList) then {
	_unit removeHandgunItem _pistolPointer;
};

if (toLower _pistolOptic in _restrictedItemList) then {
	_unit removeHandgunItem _pistolOptic;
};

if (toLower _pistolBipod in _restrictedItemList) then {
	_unit removeHandgunItem _pistolBipod;
};

if (toLower _uniform in _restrictedItemList) then {
	removeUniform _unit;
};

if (toLower _vest in _restrictedItemList) then {
	removeVest _unit;
};

if (toLower _backpack in _restrictedItemList) then {
	removeBackpack _unit;
};

if (toLower _helmet in _restrictedItemList) then {
	removeHeadgear _unit;
};

if (toLower _glasses in _restrictedItemList) then {
	removeGoggles _unit;
};

if (toLower _binocluar in _restrictedItemList) then {
	_unit removeWeapon _binocluar;
};

{
	if (toLower _x in _restrictedItemList) then {
		_unit unlinkItem _x;
	};
} forEach _items;

{
	_unit removeMagazine _x;
} forEach magazines _unit;

{
	_unit removeItem _x;
} forEach items _unit;
}] call BIS_fnc_addScriptedEventHandler;

*/