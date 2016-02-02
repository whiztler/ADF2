/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Mobile Respawn
Author: Whiztler
Script version: 4.10

Game type: COOP
File: ADF_mhq.sqf
**********************************************************************************
This is a basic Mobile HQ script. The script offers various options to configure
in ADF_mission_settings.sqf:

- Enable the MHQ? (else just a normal vehicle) > TRUE / FALSE
- Respawn delay time > in minutes
- Number of respawns available > Any number greater than zero
- Vehicle classname of the MHQ > default is the BobCat

The player respawn position is moved to the MHQ location once the FOB has been
deployed. If the MHQ is destroyed the player respawn position is set to the last
safe position. If the MHQ is moving then the player respawn is NOT updated to the
(moving) MHQ position.

Instructions:
Place a vehicle on the map and name it MHQ. Configure MHQ options in
ADF_mission_settings.sqf
********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_mhq.sqf");
ADF__diagInit;

// Exits
if (ADF_isHC) exitWith {}; // HC exits script
if (side player == east) exitWith {ADF__DBGLOGERR("MHQ: The MHQ can only be used by BluFor")}; // Blufor only!

// Check if we should run the script at all
if (isNil "MHQ") then {  // Let's see if there is an MHQ vehicle
	if !(isNil "MHQ_1") exitWith {MHQ = MHQ_1};
	if ((isNil "MHQ_1") && !(isNil "MHQ_2")) exitWith {MHQ = MHQ_2};
	if (!hasInterface) exitWith {};
	waitUntil {sleep 1; ADF_missionInit}; // wait for the mission to initialize
	Sleep 2;
	hintSilent parseText "<t color='#FE2E2E'>ERROR!</t><br/><br/><t color='#A1A4AD'>The Mobile HQ (MHQ) is disabled.<br/>No vehicle was defined as MHQ</t><br/><br/><t color='#A1A4AD'>Make sure you place a vehicle in the editor and name it MHQ.</t><br/><br/>";	
};
if (isNil "MHQ") exitWith {};

waitUntil {ADF_missionInit}; // wait for the mission to initialize

// Init
ADF_MHQ_respawnTime		= round ((_this select 1) * 60);
ADF_MHQ_respawnCount		= _this select 2;
ADF_MHQ_vehicle			= _this select 3;
ADF_MHQ_BuildTime			= _this select 4;
ADF_MHQ_PackUpTime		= _this select 5;
ADF_MHQ_orgPos			= getPosATL MHQ;
ADF_MHQ_lastPos			= ADF_MHQ_orgPos;
ADF_MHQ_dir				= getDir MHQ;
ADF_MHQ_fuel				= 1;
ADF_MHQ_respawnLeft		= ADF_MHQ_respawnCount;
ADF_MHQ_respawned			= false;
ADF_MHQ_deployed			= false;
private _t				= "min";
private _rt				= 0;
private _tx				= [west] call BIS_fnc_respawnTickets;

if (ADF_MHQ_respawnTime < 60) then {ADF_MHQ_respawnTime = 60;};
if (ADF_mod_ACE3) then {MHQ setVariable ["ACE_Medical_isMedicalVehicle", true]}; // MHQ can act as medical vehicle // v1.39 a12

// Add the MHQ eventhandler and the FOB deploy action menu item
MHQ addEventHandler ["killed", {remoteExec ["ADF_fnc_MHQ_respawnInit", 0, true];}];
ADF_MHQ_FOB_deployAction = MHQ addAction ["<t align='left' color='#c0d6b2'>Deploy the F.O.B.</t>",{remoteExec ["ADF_fnc_fobDeploy", 0, true]},[],-95, false, true,"", ""];

// MHQ info message
if (hasInterface) then {
	private _rd = getNumber (missionConfigFile >> "respawnDelay");  
	if (_rd >= 60) then {
		_rt = _rd / 60;
	} else {
		_t = "sec";
		_rt = _rd;
	};

	if (ADF_Tickets) then {
		sleep 5;
		hint parseText format ["<img size= '6' shadow='false' image='%6'/><br/><br/><t color='#6C7169' size='1.5'>%7 Cmd MHQ</t><br/><br/><t color='#A1A4AD' align='left'>Mobile HQ (MHQ) is enabled. The MHQ vehicle can deploy a F.O.B. when stationary. Once the F.O.B. is deployed players will respawn at the MHQ.</t><br/><br/><t color='#A1A4AD' align='left'>MHQ respawns available:</t><t color='#FFFFFF' align='right' font='PuristaBold'>%1</t><br/><t color='#A1A4AD' align='left'>MHQ respawn time (min):</t><t color='#FFFFFF' align='right' font='PuristaBold'>%2</t><br/><br/><t color='#A1A4AD' align='left'>Player respawn delay (%3):</t><t color='#FFFFFF' align='right' font='PuristaBold'>%4</t><br/><t color='#1262c4' align='left'>BLUEFOR</t><t color='#A1A4AD' align='left'> tickets available: </t><t color='#FFFFFF' align='right' font='PuristaBold'>%5</t><br/><br/><br/>",ADF_MHQ_respawnLeft, (ADF_MHQ_respawnTime / 60), _t, _rt, _tx, ADF_clanLogo, ADF_clanName];
	} else {
		sleep 5;
		hint parseText format ["	<img size= '6' shadow='false' image='%5'/><br/><br/><t color='#6C7169' size='1.5'>%6 Cmd MHQ</t><br/><br/>	<t color='#A1A4AD' align='left'>Mobile HQ (MHQ) is enabled. The MHQ vehicle can deploy a F.O.B. when stationary. Once the F.O.B. is deployed players will respawn at the MHQ.</t><br/><br/>	<t color='#A1A4AD' align='left'>MHQ respawns available:</t>	<t color='#FFFFFF' align='right' font='PuristaBold'>%1</t><br/>	<t color='#A1A4AD' align='left'>MHQ respawn time (min):</t>	<t color='#FFFFFF' align='right' font='PuristaBold'>%2</t><br/><br/>	<t color='#A1A4AD' align='left'>Player respawn delay (%3):</t>	<t color='#FFFFFF' align='right' font='PuristaBold'>%4</t><br/><br/>",ADF_MHQ_respawnLeft, (ADF_MHQ_respawnTime / 60), _t, _rt, ADF_clanLogo, ADF_clanName];
	};
};

// load the functions
call compile preprocessFileLineNumbers "ADF\modules\ADF_fnc_MHQ.sqf";

// from here on end run on the server only
if (!isServer) exitWith {}; 

// Setup initial west respawn markers
if (!isNil "respawn_west") then {
	// respawn_west marker exist, move it to the MHQ spawn location
	"respawn_west" setMarkerPos ADF_MHQ_orgPos;
} else {
	// respawn_west marker does not exit. Create a (new) player respawn marker at the location of the MHQ 
	private _m = createMarker ["respawn_west",ADF_MHQ_orgPos];
	_m setMarkerShape "ICON"; 
	_m setMarkerType "Empty";
};

// Create the 'HQ flag' marker
private _m = createMarker ["mMHQ",ADF_MHQ_orgPos];
_m setMarkerShape "ICON"; 
_m setMarkerSize [.8,.8]; 
_m setMarkerType "b_hq";

// Execute the functions
[] call ADF_fnc_MHQ_lastPos; // Create the last safe MHQ position marker
[] call ADF_fnc_MHQ_PlayerRespawnPos; // Attach the respawn_west marker to the MHQ vehicle (updated every 10 seconds)
[] spawn ADF_fnc_MHQ_marker; // Attach the HQ Flag marker to the Bobcat HQ vehicle (updated every half second)

ADF__diagTime("ADF_mhq");
