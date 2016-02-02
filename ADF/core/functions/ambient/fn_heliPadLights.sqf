/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_heliPadLights
Author: Whiztler
Script version: 1.01

File: fn_heliPadLights.sqf
**********************************************************************************
Creates (runway) lights around a circular helipad.

INSTRUCTIONS:
Place a helipad (circle) on the map. in the init put:
[this] call ADF_fnc_heliPadLights;

By default it creates green lights. To change the light color:
[this, "blue"] call ADF_fnc_heliPadLights;
[this, "red"] call ADF_fnc_heliPadLights;
[this, "yellow"] call ADF_fnc_heliPadLights;
[this, "white"] call ADF_fnc_heliPadLights;

REQUIRED PARAMETERS:
0. Object (helipad)

OPTIONAL PARAMETERS:
1. String (light: "green", "blue", "red", "yellow", "white")

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_heliPadLights");

// init
params ["_o", ["_k", "green", [""]]];
ADF__PI;
private _p = getPosATL _o;
private _r = 5.75;
private _c = "";

switch _k do {
	case "green"		: {_c = "Land_Flush_Light_green_F"};
	case "blue"		: {_c = "Land_runway_edgelight_blue_f"};
	case "red"		: {_c = "Land_Flush_Light_red_F"};
	case "yellow"	: {_c = "Land_Flush_Light_yellow_F"};
	case "white"		: {_c = "Land_runway_edgelight"};
};

for "_i" from 1 to 360 step (360 / 8) do {
	private _px = (_p select 0) + (sin (_i) * _r);
	private _py = (_p select 1) + (cos (_i) * _r);
	private _pv = [_px, _py, _p select 2];
	private _v = createVehicle [_c, _pv, [], 0, "CAN_COLLIDE"];
	_v modelToWorld _pv;
};

true

