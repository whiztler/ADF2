/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_randomPosInArea
Author: Whiztler
Script version: 1.01

File: fn_randomPosInArea.sqf
**********************************************************************************
return a position in a predefined area (e.g. marker, trigger) 
Works on circular triggers/markers only. With uneven shapes, units might spawn out
of area.

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0. Position - marker or trigger

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
_markerRandomPos = ["myMarker"] call ADF_fnc_randomPosInArea;	

RETURNS:
Array (position x,y,z)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_randomPosInArea");

// Init
ADF__P1(_t);

private _p 	= _t;
private _m	= if (typeName _t == "STRING") then {true} else {false};
private _s	= if (_m) then {getMarkerSize _t} else {triggerArea _t};

_s params ["_sx", "_sy"];
private _r	= if ((_sx + _sy) > 0) then {if (_sx == _sy) then {_sx / 2} else {(_sx + _sy) / 2}} else {0};
private _d	= random 360;
	
private _return = if (_r > 0) then {[_p, _r, _d] call ADF_fnc_randomPos} else {if (_m) then {getMarkerPos _t} else {getPosASL _t}};

if (ADF_debug) then {
	diag_log format ["ADF Debug: ADF_fnc_randomPos - Position: %1", _return];
	private _m = createMarker [format ["m_%1%2", round _return selecy 0, round _return select 1], _return];
	_m setMarkerSize [.7, .7];
	_m setMarkerShape "ICON";
	_m setMarkerType "hd_dot";
	_m setMarkerColor "ColorYellow";
};	

_return

