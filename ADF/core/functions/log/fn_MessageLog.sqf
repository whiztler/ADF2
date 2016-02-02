/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_messageLog
Author: Whiztler
Script version: 1.01

File: fn_messageLog.sqf
**********************************************************************************
This function is exclusively used by ADF_fnc_messageParser.
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_messageLog");

if (!hasInterface) exitWith {};

// init
ADF__P2(_n,_m);

// Create the Message PParser logbook entry (if enabled)
private _t = [dayTime] call BIS_fnc_timeToString;
private _l = format ["Log: %1", _t];
private _b = format ["<br/><br/><font color='#9da698' size='14'>From: %1<br/>Time: %2</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>%3</font><br/><br/>", _n, _t, _m];
player createDiaryRecord [ADF_messageParserLogName, [_l, _b]];

true

