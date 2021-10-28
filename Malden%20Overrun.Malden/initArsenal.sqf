/*
	Inits available items in arsenal
*/

if (isServer) then {
	//Backpacks for arsenal
	ArsenalBackpacks = [];

	//add all non-dismantled weapon backpacks to arsenal loader 
	{
		if (!((configName (_x)) isKindof ["Weapon_Bag_Base", configFile >> "CfgVehicles"])) then {
			ArsenalBackpacks pushBack (configName _x);
		} else {
			diag_log format ["%1 is a dismantled weapon and will not be added", configName (_x)];
		};
	} forEach ("((configName (_x)) isKindof ['Bag_Base', configFile >> 'CfgVehicles'])" configClasses (configFile >> "CfgVehicles"));
	publicVariable "ArsenalBackpacks";

	//All magazines in arsenal
	ArsenalMagazines = [];
	{
		ArsenalMagazines pushBack (configName _x);
	} forEach ("(getText (_x >> 'displayName') != '')" configClasses (configFile >> "cfgMagazines"));
	publicVariable "ArsenalMagazines";

	ArsenalItems = [];

	//add all base and modded items to the arsenal loader excluding optics (will check next)
	{
		ArsenalItems pushBack (configName _x);
		//diag_log format ["%1 added to ArsenalItems", (configName _x)];
	} 
	forEach ("((configName (_x)) isKindof ['ItemCore', configFile >> 'cfgWeapons']) && !(getText (configfile >> 'CfgWeapons' >> configName _x >> 'ItemInfo' >> 'mountAction') == 'MountOptic')" configClasses (configFile >> "cfgWeapons")); 

	//holder for all thermal and nvg scopes
	_nvgScopes = [];

	//add all non-NVG and non-thermal optics to arsenal loader
	{
		_dontAdd = false;
		_opticsModes = (configfile >> "CfgWeapons" >> configName (_x) >> "ItemInfo">>"OpticsModes") call BIS_fnc_getCfgSubClasses;

		if (count _opticsModes != 0) then {
			_currentOptic = configName (_x);
			_visionModes = [];
			{
				_currentOpMode = _x;
				_visionModes append getArray (configfile >> "CfgWeapons" >> _currentOptic >> "ItemInfo" >> "OpticsModes" >> _x >> "visionMode");

			} forEach _opticsModes;
			
			if ("NVG" in _visionModes) then {
				//diag_log format ["%1 has NVG in one of the optics modes: ", configName (_x)];
				_dontAdd = true;
			};
			if ("Ti" in _visionModes) then {
				//diag_log format ["%1 has Ti in one of the optics modes: ", configName (_x)];
				_dontAdd = true;
			};
			
		};
		
		if (!_dontAdd) then{
			ArsenalItems pushBack configName (_x);
		} else {
			_nvgScopes pushBack configName (_x);
			diag_log format ["%1 has been added to nvgScopes unlockable list", configName (_x)];	
		};
		
	}forEach ("(getText (_x >> 'displayName') != '') && (getText (configfile >> 'CfgWeapons' >> configName _x >> 'ItemInfo' >> 'mountAction') == 'MountOptic')" configClasses (configFile >> "cfgWeapons")); 


	//make sure to remove the Viper Helmets as they have integrated NVG and Thermal
	ArsenalItems = ArsenalItems - ["H_HelmetO_ViperSP_hex_F","H_HelmetO_ViperSP_ghex_F"];
	publicVariable "ArsenalItems";

	//define all NVG items
	_NVGItems = [
	//Viper Helmets
	"H_HelmetO_ViperSP_hex_F",
	"H_HelmetO_ViperSP_ghex_F",

	//ACE & CUP NV optics and binos
	"ACE_Vector",
	"CUP_Vector21Nite"

	];	

	//find and add all NVGs in base game and all mods
	{
		_NVGItems pushBack (configName _x);

	} 
	forEach ("((configName (_x)) isKindof ['NVGoggles', configFile >> 'cfgWeapons']) && (getText (_x >> 'displayName') != '')" configClasses (configFile >> "cfgWeapons")); 

	//add in previously ID'd nvg and thermal scopes
	_NVGItems append _nvgScopes;

	//define all suppressors
	_suppressors = ("getNumber (_x >> 'itemInfo' >> 'type') isEqualTo 101 && getNumber (_x>> 'scope') >1 && getNumber (_x >> 'ItemInfo' >> 'AmmoCoef' >> 'audibleFire') <1 " configClasses (configfile >> "CfgWeapons")) apply {configName _x};

	//Weapons for arsenal
	ArsenalWeapons = [];

	//add all base and modded pistols and rifles to the arsenal loader
	{
		_anyAttachments = ((configFile >>"cfgWeapons">>configName (_x)>>"LinkedItems") call BIS_fnc_getCfgSubClasses);
		
		
		//ensure item is a weapon first
		if (((configName _x) isKindof ["Rifle", configFile >> "cfgWeapons"]) || ((configName _x) isKindof ["Pistol", configFile >> "cfgWeapons"])) then {
			//check and ensure this weapon has no attachments 
			//to prevent accidentally adding a suppressor or nv scope
			if(count _anyAttachments == 0) then {
			
				ArsenalWeapons pushBack (configName _x);
			
			};
		};

	} forEach ("(getText (_x >> 'displayName') != '')" configClasses (configFile >> "cfgWeapons")); 

	publicVariable "ArsenalWeapons";

	//if NVGs have been unlocked, append all NVG items to the arsenal loader
	if(UnlockTracker select 2 == true) then {
		diag_log "NVGs are unlocked. Adding to Arsenal Items";
		ArsenalItems append _NVGItems;
	} else {
		//if not unlocked, ensure they are not in the items or weapons list
		ArsenalItems = ArsenalItems - _NVGItems;
		ArsenalWeapons = ArsenalWeapons - _NVGItems;
	};

	publicVariable "ArsenalItems";	
	publicVariable "ArsenalWeapons";	

	//if suppressors have been unlocked, append all suppressors to the arsenal loader
	if(UnlockTracker select 3 == true) then {
		diag_log "Suppressors are unlocked. Adding to Arsenal Items";
		ArsenalItems append _suppressors;	
	}else{
		//if supressors are not unlocked, ensure they are not in the item or weapons list	
		ArsenalItems = ArsenalItems - _suppressors;
		ArsenalWeapons = ArsenalWeapons - _suppressors;
	};

	publicVariable "ArsenalItems";
	publicVariable "ArsenalWeapons";

}; //end if(isServer)



//if JIP, wait until all variables can be executed
if (didJIP) then {
	sleep 2;
};

	waitUntil{ !isNil {missionNamespace getVariable "ArsenalItems";} };
	waitUntil{ !isNil {missionNamespace getVariable "ArsenalBackpacks";} };
	waitUntil{ !isNil {missionNamespace getVariable "ArsenalWeapons";} };
	waitUntil{ !isNil {missionNamespace getVariable "ArsenalMagazines";} };
	waitUntil{ !isNull arsenalBox};
	waitUntil{ !isNull deconTruck};

//add all items to arsenalBox
[arsenalBox,ArsenalItems,true,true] call BIS_fnc_addVirtualItemCargo;
[arsenalBox,ArsenalBackpacks,true,true] call BIS_fnc_addVirtualBackpackCargo;
[arsenalBox,ArsenalWeapons,true,true] call BIS_fnc_addVirtualWeaponCargo;
[arsenalBox,ArsenalMagazines,true,true] call BIS_fnc_addVirtualMagazineCargo;

sleep 1;

//add all items to deconTruck
[deconTruck,ArsenalItems,true,true] call BIS_fnc_addVirtualItemCargo;
[deconTruck,ArsenalBackpacks,true,true] call BIS_fnc_addVirtualBackpackCargo;
[deconTruck,ArsenalWeapons,true,true] call BIS_fnc_addVirtualWeaponCargo;
[deconTruck,ArsenalMagazines,true,true] call BIS_fnc_addVirtualMagazineCargo;