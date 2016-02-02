/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Mission Balancer
Author: Whiztler
Script version: 2.01

File: ADF_missionBalancer.sqf
*********************************************************************************
The mission balancer is automatically loaded on mission start. It requires
maxPlayers in 'mission\1-config\ADF_mission_information.sqf' to be defined. The
maxPlayers should match the number of playable slots (incl HC) exactly!

The mission maker can use the following variables to apply mission balancing in
scripts (assume maxPlayers is set to 30):

Spawn pprobability set by the mission balancer:

More than 70% (20 players) of slots filled with players: ADF_MB = 100%
Less than 40% (12 players) of slots filled with players: ADF_MB = 75%
Between 40% - 65% of slots filled with players		: ADF_MB = 50%

In scripts use:

if (random 1 < ADF_MB) then {
	// spawn code goes here
};

The mission balance is re-calculated each time a new player joins (JIP).
********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_missionBalancer.sqf");

// Init
waitUntil {time > 0};
private _m 	= playableSlotsNumber ADF_playerSide;	
private _u 	= {alive _x && side _x == ADF_playerSide} count (allPlayers - ADF_cntHC);

if (_m == 0) exitWith {
	private _k = parseText "<t color='#FFFFFF' size='1.5'>ERROR</t><br/><br/><t color='#A1A4AD'>The Mission Balancer could not initialize.<br/><br/>You need to define ADF_playerSide in 'mission\1-config\ADF_mission_settings.sqf'</t>";
	_k remoteExec ["hint", -2, false]; 
	ADF__LOGERR("The Mission Balancer could not initialize. You need to define ADF_playerSide in 'mission\1-config\ADF_mission_settings.sqf'");
	ADF_fnc_missionBalance = {ADF__RPTVAR1("ADF RPT: Mission Balancer: MB not initiated. Exiting.")};
};	

ADF_fnc_missionBalance = {	
	params ["_mbH", "_c", ["_j", false [true]]];
	// _mBH: playableSlotsNumber ADF_playerSide;	
	// _c: {alive _x} count (allPlayers - ADF_cntHC);
	
	private _mbM	= round (_mbH * .70); // 70%
	private _mbL	= round (_mbH / 2.5); // 40% 
	
	ADF_MB = if (_c > _mbM) then {1} else {if (_c < _mbM) then {0.5} else {0.70}};
	
	if (_j) then {ADF__RPTVAR1("ADF RPT: Mission Balancer: JIP player connected. Re-balancing")};
	if (!_j) then {ADF__RPTVAR1(ADF__RPTVAR1("ADF RPT: Mission Balancer: maxPlayers (slots) : %1", _mbH)};
	ADF__RPTVAR1("ADF RPT: Mission Balancer: Connected players  : %1", _c);	
	ADF__RPTVAR1("ADF RPT: Mission Balancer: ADF_MB = %1", ADF_MBH);	
};

[_m, _u, false] call ADF_fnc_missionBalance;