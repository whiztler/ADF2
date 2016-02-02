/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Debug tools
Author: whiztler
Script version: 1.47

File: ADF_debug.sqf
**********************************************************************************
INSTRUCTIONS::

Debug functions add various actions to the the player in editor preview.
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_debug.sqf");

// Add menu actions to mission maker for editor preview
if (local player) then {
	player addAction ["<t align='left' color='#C0C0C0'>––[ <t color='#FFFFFF'>ADF Dev Snippets<t color='#C0C0C0'> ]––––––",nil];
	player addAction ["<t align='left' color='#F7D358'>Show Position</t>",{execVM "ADF\library\D\ADF_snipPosition.sqf";}];
	player addAction ["<t align='left' color='#F7D358'>Civilian Mode ON/OFF</t>",{if (captive player) then {player setCaptive false; player allowDamage true; hintSilent "Civilian Mode OFF";} else {player setCaptive true; player allowDamage false; hintSilent "Civilian Mode ON";};}];		
};

if (isServer && !isDedicated) then {
	waitUntil {player == player && alive vehicle player};
	player addAction ["<t align='left' color='#F7D358'>Show Units / Veh. / Obj.</t>",{execVM "ADF\library\D\ADF_snipOjects.sqf";}];
	player addAction ["<t align='left' color='#F7D358'>Show Distance Object-Player</t>",{execVM "ADF\library\D\ADF_snipDistance.sqf";}];
	player addAction ["<t align='left' color='#F7D358'>Identify Classname</t>",{execVM "ADF\library\D\ADF_snipIdClassname.sqf";}];
	player addAction ["<t align='left' color='#F7D358'>Start OpFor Detection</t>",{execVM "ADF\library\D\ADF_snipDetect.sqf";}];
	player addAction ["<t align='left' color='#F7D358'>Stop OpFor Detection</t>",{ADF_terminate_detect = true; publicVariable "ADF_terminate_detect"}];
	player addAction ["<t align='left' color='#F7D358'>Set time +6 hours</t>",{skipTime 6;}];
	player addAction ["<t align='left' color='#F7D358'>Set time -6 hours</t>",{skipTime -6;}];
	player addAction ["<t align='left' color='#F7D358'>Spawn NATO Weapons Squad", {execVM "ADF\library\D\ADF_snipSpawnBluefor.sqf";}];
	player addAction ["<t align='left' color='#F7D358'>Spawn CSAT Weapons Squad", {execVM "ADF\library\D\ADF_snipSpawnOpfor.sqf";}];
	player addAction ["<t align='left' color='#F7D358'>Spawn Hummingbird", { _veh = createVehicle [ "B_Heli_Light_01_F", player modelToWorld [0, 10, 0], [], 0, "CAN_COLLIDE" ]; _veh setDir (direction player - 90); _veh setVectorUp surfaceNormal position _veh; _veh  setObjectTextureGlobal  [0, "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_furious_co.paa"];}];
	player addAction ["<t align='left' color='#F7D358'>Spawn Hunter", { _veh = createVehicle [ "B_MRAP_01_F", player modelToWorld [0, 10, 0], [], 0, "CAN_COLLIDE" ]; _veh setDir (direction player - 90); _veh setVectorUp surfaceNormal position _veh; _veh  setObjectTextureGlobal [0, "#(rgb, 8, 8, 3)color(0, 0, 0, 1)"]; /*_veh  setObjectTextureGlobal  [1, "#(rgb, 8, 8, 3)color(0.64, 0.64, 0.64, 1)"];*/}];
	player addAction ["<t align='left' color='#F7D358'>Spawn Speedboat", { _veh = createVehicle [ "C_Boat_Civil_01_rescue_F", player modelToWorld [0, 10, 0], [], 0, "CAN_COLLIDE" ]; _veh setDir (direction player - 90);}];
};

if (local player) then {
	player addAction ["<t align='left' color='#C0C0C0'>––––––––––––––––––––––––",nil];
};

ADF_fnc_debugMarkers = {
	// left empty for backward compatibility reasons
};

// Enable full Zeus functionality for non GM units
if (isServer || !hasInterface) exitWith {};
if (isNil "GM_1") then {GM_1 = objNull}; 
if (isNil "GM_2") then {GM_2 = objNull}; 
if !((player == GM_2) || (player == GM_1)) then {
	[] spawn {
		GMmod_1 addCuratorEditableObjects [vehicles, true];
		GMmod_1 addCuratorEditableObjects [(allMissionObjects "Man"), false];
		GMmod_1 addCuratorEditableObjects [(allMissionObjects "Air"), true];
		GMmod_1 addCuratorEditableObjects [(allMissionObjects "Ammo"), false];
		GMmod_1 allowCuratorLogicIgnoreAreas true;
		{GMmod_1 addCuratorEditableObjects [[_x], true];} forEach allUnits;
		GMmod_1 addCuratorEditableObjects [vehicles, true];
		sleep 30;
	};
};