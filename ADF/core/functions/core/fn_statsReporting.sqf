/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_statsReporting
Author: Whiztler
Script version: 1.01

File: fn_statsReporting.sqf
**********************************************************************************
Server/HC stats reporting. Executed on the server and all connected headless
clients. Stamps the following information in the RTP:

REQUIRED PARAMETERS:
0. Number: Default loop time in seconds
1. String: Full name of reporting entity (e.g. "Server" or "Headless Client")
2. String: Abbreviation of reporting entity (e.g. "Svr" or "HC")

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
[60, "Headless Client", "HC"] spawn ADF_fnc_statsReporting;

RETURNS:
Nothing
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_statsReporting");


if (hasInterface && isMultiplayer) exitWith {};

ADF__P3(_s,_n,_c);

waitUntil {
	// init
	private _f	= round (diag_fps);	
	private _h	= count (entities "HeadlessClient_F");
	private _u	= {alive _x} count allPlayers;
	private _a	= {local _x} count allUnits;
	
	if (_a < 0)  then {_a = 0};
	if (_f < 30) then {_s = 30};
	if (_f < 20) then {_s = 20};
	if (_f < 10) then {_s = 10};
	
	private _t = [(round time)] call BIS_fnc_secondsToString;
	diag_log 	format ["ADF RPT: %1 PERF - Total players: %2  --  Total local AI's: %3", _n, _u - _h, _a];
	private _m = format ["ADF RPT: %1 PERF - Elapsed time: %2  --  %3 FPS: %4  --  %3 Min FPS: %5", _n, _t, _c, _f, round (diag_fpsmin)];
	diag_log _m;
	if (ADF_Debug && (_n == "Server")) then {_m remoteExec ["systemChat", -2, false]};
	uiSleep _s;
	false
};

