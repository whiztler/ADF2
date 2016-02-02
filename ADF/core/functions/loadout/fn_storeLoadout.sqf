/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_storeLoadout
Author: Whiztler
Script version: 1.01

File: fn_storeLoadout.sqf
**********************************************************************************
Creates an Error message or Debug message. Error messages are always show on the
BIS bottom info screen. Both SP and MP.

REQUIRED PARAMETERS:
0. Object: (player) unit
1. String: - 	"save" save/store loadout
			"load" load/apply stored loadout

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
[player, "save"] call ADF_fnc_storeLoadout;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_storeLoadout");

ADF__P2(_u,_s);

if (_s == "SAVE") exitWith {
	// Containers
	ADF_StoreLoadout_uniform = uniform _u;
	ADF_StoreLoadout_vest = vest _u;
	ADF_StoreLoadout_backpack = backpack _u;
	ADF_StoreLoadout_headgear = headgear _u;	
	ADF_StoreLoadout_goggles = goggles _u;	
	// Weapons (also binos, gps etc)
	ADF_StoreLoadout_weapons = weapons _u;	
	ADF_StoreLoadout_magazines = magazines _u;
	// Weapon attachments etc
	ADF_StoreLoadout_primaryWeaponItems = primaryWeaponItems _u;
	ADF_StoreLoadout_secondaryWeaponItems = secondaryWeaponItems _u;	
	ADF_StoreLoadout_sideWeaponItems = handgunItems _u;
	// items
	ADF_StoreLoadout_items = items _u;
	ADF_StoreLoadout_assignedItems = assignedItems _u;
	
	true
};

if (_s == "LOAD") exitWith {
	[_u, true] call ADF_fnc_stripUnit;

	// Containers
	_u addUniform ADF_StoreLoadout_uniform;
	_u addVest ADF_StoreLoadout_vest;
	_u addBackpack ADF_StoreLoadout_backpack;
	_u addHeadgear ADF_StoreLoadout_headgear;
	_u addGoggles ADF_StoreLoadout_goggles;
	// Weapons/Magazines
	{_u addMagazine _x} forEach ADF_StoreLoadout_magazines;
	{_u addWeapon _x} forEach ADF_StoreLoadout_weapons;
	// Weapon attachments etc
	{_u addPrimaryWeaponItem _x} forEach ADF_StoreLoadout_primaryWeaponItems;
	{_u addSecondaryWeaponItem _x} forEach ADF_StoreLoadout_secondaryWeaponItems;
	{_u addHandgunItem _x} forEach ADF_StoreLoadout_sideWeaponItems;
	// Items
	{_u addItem _x} forEach ADF_StoreLoadout_items;
	{_u assignItem _x} forEach ADF_StoreLoadout_assignedItems;
	
	true
};



