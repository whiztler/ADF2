/********************************************************************************
ADF - ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Mission init
Author: Whiztler
Script version: 1.20

File: initServer.sqf
********************************************************************************
DO NOT edit this file. To set-up and configure your mission, edit the files in
the  'mission\1-config\'  folder.
************************************************************************************************/

diag_log "ADF RPT: Init - executing initServer.sqf"; // Reporting. Do NOT edit/remove

// Pre-init
#include "ADF\library\ADF_init_pre.sqf"
#include "ADF\library\ADF_functions.sqf"

// Mission settings
#include "mission\1-config\ADF_mission_settings.sqf"

// Session reporting dedicated server 
if (isDedicated) then {
	#include "ADF\library\ADF_init_rpt.sqf"
};

// Exec mission settings
if (_ADF_HC_init) then {private "_h"; _h = [_ADF_HCLB_enable] execVM "ADF\library\ADF_init_HC.sqf"; waitUntil {scriptDone _h}}; 
if (ADF_Tickets) then {[west, _ADF_wTixNr] call BIS_fnc_respawnTickets; [east, _ADF_eTixNr] call BIS_fnc_respawnTickets};
if (_ADF_CleanUp) then {[_ADF_CleanUp_viewDist, _ADF_CleanUp_manTimer, _ADF_CleanUp_vehTimer, _ADF_CleanUp_abaTimer] execVM "ADF\library\e\repCleanup\repCleanup.sqf"};
if (_ADF_Caching && !ADF_HC_connected) then {[_ADF_Caching_UnitDistance, -1, ADF_debug, _ADF_Caching_vehicleDistance_land, _ADF_Caching_vehicleDistance_air, _ADF_Caching_vehicleDistance_sea, _ADF_Caching_debugInfo] execVM "ADF\library\e\zbe_cache\main.sqf"};
if (_ADF_suppliesInit) then {execVM "ADF\library\ADF_init_supplies.sqf"};
if (_ADF_mhq_enable) then {[_ADF_mhq_enable,_ADF_mhq_respawn_time,_ADF_mhq_respawn_nr,_ADF_mhq_respawn_class,_ADF_mhq_deploy_time,_ADF_mhq_packup_time,_ADF_wTixNr] execVM "ADF\library\ADF_MHQ.sqf"};
if (_ADF_misBal) then {[_ADF_misBal_low,_ADF_misBal_high] execVM "ADF\library\ADF_missionBalancer.sqf"};
if (_ADF_crewCheck_Pilots || _ADF_crewCheck_Armoured) then {[_ADF_crewCheck_Pilots,_ADF_crewCheck_Armoured] execVM "ADF\library\ADF_crewCheck.sqf";};
if (_ADF_civKia_enable) then {execVM "ADF\library\ADF_civKiaCheck.sqf"};
if (_ADF_ambient_uCiv) then {[_ADF_ambient_uCiv_nr, _ADF_ambient_uCiv_dist, _ADF_ambient_uCiv_wpnr,_ADF_civKia_enable] execVM "ADF\library\e\MADal\MAD_civilians.sqf"};
if (_ADF_ambient_vCiv) then {[_ADF_ambient_vCiv_nr, _ADF_ambient_vCiv_dist, _ADF_ambient_vCiv_del,_ADF_civKia_enable] execVM "ADF\library\e\MADal\MAD_traffic.sqf"};
if (!_ADF_Thermal) then {{_x disableTIEquipment true} forEach vehicles};
execVM "ADF\library\ADF_GM.sqf";

// Post-init
private ["_vb", "_ms", "_m"];
_ms 	= "ADF - ARMA Mission Development Framework v";
If ((_ADF_devBuild == "Alpha") || (_ADF_devBuild == "Beta")) then {
	_vb =  format [" (Build: %1 %2)", _ADF_devBuild, _ADF_devBuildNr];
	_ms = _ms + _vt + _vb;	
} else {
	_ms = _ms + _vt;
};

_m = createMarker ["mADF_version",[5,-200, 0]];
_m setMarkerSize [0, 0];
_m setMarkerShape "ICON";
_m setMarkerType "mil_box";
_m setMarkerColor "ColorGrey";
_m setMarkerDir 0;
_m setMarkerText _ms;

if ({side _x == east} count allUnits == 0) then {createCenter east};
if ({side _x == west} count allUnits == 0) then {createCenter west};
if ({side _x == resistance} count allUnits == 0) then {createCenter resistance};
if ({side _x == independent} count allUnits == 0) then {createCenter independent};
if ({side _x == civilian} count allUnits == 0) then {createCenter civilian};

// Custom mission init
execVM "Scripts\init.sqf";