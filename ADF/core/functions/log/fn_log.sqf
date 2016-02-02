/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_log
Author: Whiztler
Script version: 1.01

File: fn_log.sqf
**********************************************************************************
Creates an Error message or Debug message. Error messages are always show on the
BIS bottom info screen. Both SP and MP.

REQUIRED PARAMETERS:
0. String: message
1. Bool - true: error messgae
		false: debug message

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
if (ADF_debug) then {["YourErrorMessageHere", true] call ADF_fnc_log}; // Only in debug mode
["YourErrorMessageHere", false] call ADF_fnc_log; // Always show (also MP)

RETURNS:
Object (floodlight object)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_log");
	
// init
ADF__P2(_m,_e);

// Error message?
if (_e) then { 
	private _h = "ADF Error: ";
	private _w = _h + _m;
	[_w] call BIS_fnc_error;
	diag_log _w;
	
// Debug log message?	
} else { 
	private _h = "ADF Debug: ";
	private _w = _h + _m;
	_w remoteExec ["systemChat", -2, false];
	diag_log _w;		
};	
