/*********************************************************************************
ADF - ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Local Player init
Author: Whiztler
Script version: 1.50

File: initPlayerLocal.sqf
**********************************************************************************
DO NOT edit this file. To set-up and configure your mission, edit the files in
the  'mission\1-config\'  folder.
*********************************************************************************/

diag_log "ADF RPT: Init - executing initPlayerLocal.sqf"; // Reporting. Do NOT edit/remove

if (isNull player) then {waitUntil {!(isNull player)}; waitUntil {player == player}};

// Mission settings
#include "mission\1-config\ADF_mission_settings.sqf"

// Briefing
if (hasInterface) then {private "_n"; _n = format ["mission\2-briefing\", _ADF_briefingName]; execVM _n};

// Pre-init
#include "ADF\library\ADF_init_pre.sqf"
#include "ADF\library\ADF_functions.sqf"

// HC init
if (_ADF_HC_init && !hasInterface) then {private "_h"; _h = [_ADF_HCLB_enable] execVM "ADF\library\ADF_init_HC.sqf"; waitUntil {scriptDone _h}}; 

// Mission intro
if (!ADF_debug && !ADF_missionInit && hasInterface) then {
	private "_m";
	if (_ADF_MissionIntroImage == "") then {_ADF_MissionIntroImage = ADF_clanLogo};
	_m = getText (missionConfigFile >> "onLoadMission");  	
	[_ADF_mission_init_time, _ADF_MissionIntroImage, _m] spawn {
		params ["_t", "_i", "_d"];
		private "_l";
		_l = ["tLayer"] call BIS_fnc_rscLayer; 
		_l cutText ["", "BLACK IN", (_t + 10)];
		waitUntil {time > (_t - 10)};
		["<img size= '9' shadow='false' image='" + _i + "'/><br/><br/><t size='.7' color='#FFFFFF'>" + _d + "</t>", 0, 0, 3, 12] spawn BIS_fnc_dynamicText;
	};
};

// Init Players
if (!ADF_isHC) then {
	call compile preprocessFileLineNumbers "ADF\modules\ADF_fnc_presets.sqf";
	ADF_getLoadOut = [_ADF_customLoadout_MOD, _ADF_uniform_inf, _ADF_uniform_sor, _ADF_add_NVGoggles, _ADF_add_GPS, _ADF_INF_assault_weapon, _ADF_INF_LMG_weapon, _ADF_INF_hand_weapon, _ADF_INF_scopes, _ADF_SOR_assault_weapon, _ADF_SOR_hand_weapon, _ADF_CAV_assault_weapon, _ADF_TFAR_PersonalRadio, _ADF_TFAR_SWRadio, _ADF_TFAR_LRRadio, _ADF_noLoadout, _ADF_TFAR_LRRadioSOR, _ADF_ACE3_microDAGR_all, _ADF_ACE3_microDAGR_leaders, _ADF_cTAB_microDAGR_all, _ADF_cTAB_microDAGR_leaders] execVM "ADF\library\ADF_clientLoadout.sqf";
	if (_ADF_mhq_enable) then {[_ADF_mhq_enable, _ADF_mhq_respawn_time, _ADF_mhq_respawn_nr, _ADF_mhq_respawn_class, _ADF_mhq_deploy_time, _ADF_mhq_packup_time, _ADF_wTixNr] execVM "ADF\library\ADF_MHQ.sqf"};
	execVM "ADF\library\ADF_GM.sqf"
	if (_ADF_altitude) then {execVM "ADF\library\ADF_ABF.sqf"};
	if (_ADF_crewCheck_Pilots || _ADF_crewCheck_Armoured) then {[_ADF_crewCheck_Pilots, _ADF_crewCheck_Armoured] execVM "ADF\library\ADF_crewCheck.sqf";};
	if (_ADF_civKia_enable) then {execVM "ADF\library\ADF_civKiaCheck.sqf"};
	if (ADF_mod_ACE3 && ADF_sameGearRespawn) then {ACE_Respawn_SavePreDeathGear = true};
	if (ADF_debug) then {execVM "ADF\library\ADF_debug.sqf";};
	[_ADF_preset, _ADF_ACRE_fullDuplex, _ADF_ACRE_interference, _ADF_ACRE_AIcanHear, _ADF_TFAR_microDAGR] execVM "ADF\library\ADF_clientPreset.sqf";
	
	// Client EH's
	ADF_fnc_clientKilled = player addEventHandler ["killed", {_this execVM "ADF\library\ADF_onPlayerKilled.sqf"}];
};

// Init Players + HC
if (_ADF_ambient_uCiv) then {[_ADF_ambient_uCiv_nr, _ADF_ambient_uCiv_dist, _ADF_ambient_uCiv_wpnr, _ADF_civKia_enable] execVM "ADF\library\e\MADal\MAD_civilians.sqf"};
if (_ADF_ambient_vCiv) then {[_ADF_ambient_vCiv_nr, _ADF_ambient_vCiv_dist, _ADF_ambient_vCiv_del, _ADF_civKia_enable] execVM "ADF\library\e\MADal\MAD_traffic.sqf"};

// Post-init
if (!ADF_isHC) then {
	[_ADF_mission_init_time, ADF_tpl_version, ADF_mission_version, _ADF_devBuild, _ADF_devBuildNr] execVM "ADF\library\ADF_init_post.sqf";
};

// Custom mission init
execVM "Scripts\init.sqf";


