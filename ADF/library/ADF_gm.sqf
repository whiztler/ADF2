/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Game Master/Instructor/Zeus configuration
Author: Whiztler
Script version: 1.60

File: ADF_gm.sqf
**********************************************************************************
This script applies various additional functionality to GM/Zeus/instructors

Instructions:

Make sure your zeus units (max 2) are named: GM_1 and/or GM_2
Place a 'ZEUS Game Master' module for each unit:
- Name: GMmod_x (where x is 1 or 2)
- Owner: GM_x (where x is the unit number, 1 or 2)
- Default addons: All addons (incl unofficial ones)
- Forced interface: disabled
********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_gm.sqf");

// Init
if ((isNil "GM_1") && (isNil "GM_2")) exitWith {// No Zeus playable slots detected
	private _m = "ZEUS - No GM units active. Terminating ADF_GM";
	ADF__DBGLOG(_m);
	ADF__RPTLOG(_m);
}; 

showCuratorCompass true;

// GM roles
private _ADF_GM_gear = {
	params ["_u"];
	removeBackpackGlobal _u;
	removeUniform _u;
	removeHeadgear _u;
	_u forceAddUniform "U_BG_Guerrilla_6_1";
	_u addHeadgear "H_Booniehat_khk_hs";
	if (ADF_mod_TFAR) then {_u addBackpack "tf_rt1523g";} else {_u addBackpack "B_TacticalPack_blk";};
	_u addVest "V_Rangemaster_belt";
	_u unassignItem "NVGoggles";
	_u addWeapon "ItemGPS";
	_u addWeapon "NVGoggles";
	_u addWeapon "Laserdesignator";
	_u addMagazine "Laserbatteries";
	_u unassignItem "NVGoggles";
	_u linkItem "ItemGPS";
	if (ADF_mod_ACE3) then {
		_u setVariable ["ace_medical_allowDamage", false];	
		_u addItem "ACE_fieldDressing";
		_u addItem "ACE_fieldDressing";
		_u addItem "ACE_morphine";
		_u addItem "ACE_EarPlugs";
		_u addItem "ace_mapTools";
		_u addItem "ACE_CableTie";
		_u addItem "ACE_IR_Strobe_Item";		
	} else {
		_u addItem "FirstAidKit";
		_u addItem "FirstAidKit";			
	};
	if (ADF_mod_ACRE) then {_u addWeapon "ACRE_PRC343"};
	if (ADF_mod_TFAR) then {_u addWeapon "tf_anprc152"};	
	if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_u addWeapon "ItemRadio"};
	if (ADF_mod_CTAB) then {(backpackContainer _u) addItemCargoGlobal ["ItemcTab", 1]};
	if (ADF_Clan_uniformInsignia) then {[_u,"CLANPATCH"] call BIS_fnc_setUnitInsignia};
};

if !(isNil "GM_1") then {
	if !(player == GM_1) exitWith {};
	GM_1 addAction ["<t align='left' color='#FBF4DF'>GM - Teleport</t>",{openMap true;hintSilent format ["%1, click on a location on the map to teleport...", name vehicle player];onMapSingleClick "vehicle player setPos _pos; onMapSingleClick ' '; true; openMap false; hint format ['%1, you are now at: %2', name vehicle player, getPosATL player];";},[],-85, true, true,"", ""];	
	[GM_1] call _ADF_GM_gear;
	ADF_GM_init = true;
	ADF__DBGVAR("ADF Debug: ZEUS: GM-1 active");
};

if !(isNil "GM_2") then {
	if !(player == GM_2) exitWith {};
	GM_2 addAction ["<t align='left' color='#FBF4DF'>GM - Teleport</t>",{openMap true;hintSilent format ["%1, click on a location on the map to teleport...", name vehicle player];onMapSingleClick "vehicle player setPos _pos; onMapSingleClick ' '; true; openMap false; hint format ['%1, you are now at: %2', name vehicle player, getPosATL player];";},[],-85, true, true,"", ""];	
	[GM_2] call _ADF_GM_gear;
	ADF_GM_init = true;
	ADF__DBGVAR("ADF Debug: ZEUS: GM-2 active");
};

if (!isServer) exitWith {};

if ((isNil "GMmod_1") && (isNil "GMmod_2")) exitWith {
	ADF__DBGVAR("ADF Debug: ZEUS - No Zeus Modules exist (GMmod_1/2). Terminating");
};

if 	((!(isNil "GMmod_1") &&  !(isNil "GMmod_2")) && (!(isNil "GM_1") && !(isNil "GM_2"))) then {
	ADF_curArray = [GMmod_1,GMmod_2];
	GM_1 assignCurator GMmod_1;
	GM_2 assignCurator GMmod_2;
	ADF__DBGVAR("ADF Debug: ZEUS - Assigning GM_1 to GMmod_1 -- GM_2 to GMmod_2");
};

if 	(!(isNil "GMmod_1") && (!(isNil "GM_1") && (isNil "GM_2"))) then {
	ADF_curArray = [GMmod_1];
	GM_1 assignCurator GMmod_1;
	ADF__DBGVAR("ADF Debug: ZEUS - Assigning GM_1 to GMmod_1 - No GM_2 detected.");
};

if	(!(isNil "GMmod_2") && ((isNil "GM_1") && !(isNil "GM_2"))) then {
	ADF_curArray = [GMmod_2];
	GM_2 assignCurator GMmod_2;
	ADF__DBGVAR("ADF Debug: ZEUS - Assigning GM_2 to GMmod_2 - No GM_1 detected.");
};

// Wrong GM or wrong Logic. Can't connect GM_1 to GMmod_2 and vica versa
if (((isNil "GMmod_1") && !(isNil "GMmod_2")) && (!(isNil "GM_1") && (isNil "GM_2"))) exitWith {
	ADF__DBGLOGERR("ZEUS - Cannot assign GM_1 to GMmod_2. Terminating");
};
if ((!(isNil "GMmod_1") && (isNil "GMmod_2")) && ((isNil "GM_1") && !(isNil "GM_2"))) exitWith {
	ADF__DBGLOGERR("ZEUS - Cannot assign GM_2 to GMmod_1. Terminating");
};

if (ADF_mod_Ares) exitWith { // Use ARES instead of ADF Zeus functions > V1.39 B7
	private _m = "ZEUS - Ares addon detected. Using Ares instead of ADF Zeus functions";
	ADF__DBGLOG(_m);
	ADF__RPTLOG(_m);
}; 

// ADV_zeus by Belbo. Edited by Whiz

{ //adds objects placed in editor:
	_x addCuratorEditableObjects [vehicles, true];
	_x addCuratorEditableObjects [(allMissionObjects "Man"), false];
	_x addCuratorEditableObjects [(allMissionObjects "Air"), true];
	_x addCuratorEditableObjects [(allMissionObjects "Ammo"), false];
	_x allowCuratorLogicIgnoreAreas true;
} forEach ADF_curArray;

//makes all units continuously available to Zeus (for respawning players and AI that's being spawned by a script.)
ADF__DBGVAR("ADF Debug: ZEUS - ADV Zeus function Initialized");
while {true} do {
	{
		if !(isNil "GMmod_1") then {GMmod_1 addCuratorEditableObjects [[_x], true]};
		if !(isNil "GMmod_2") then {GMmod_2 addCuratorEditableObjects [[_x], true]};
	} forEach allUnits + vehicles;

	sleep 10;
	//if (ADF_debug) then {["ZEUS - Objects transferred to Curator(s) ", false] call ADF_fnc_log};
};

