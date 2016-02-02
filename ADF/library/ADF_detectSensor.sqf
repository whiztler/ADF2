/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Detection Sensor
Author: Whiztler
Script version: 1.3

File: ADF_DetectSensor.sqf
*********************************************************************************
INSTRUCTIONS::

Place a trigger:

Name: Give the trigger a unique name
Axis A,B: whatever size you want. The is the catchment area'
Activation: Blufor, once, detected by Opfor
MIN/MID/MAX: 5/7/10
Condition: this

On Activation:
0 = [thisTrigger, east, 500] execVM "ADF\library\ADF_DetectSensor.sqf";
********************************************************************************/

if (!isServer) exitWith {};
if (ADF_debug) then {["TRIGGER - DetectSensor Activated", false] call ADF_fnc_log};

params ["_t", "_s", "_r"];
private _l = (getPos _t) nearEntities ["Man", _r];

{
	if ((side _x == _s) && (_x in _l)) then {
		_x setBehaviour "COMBAT"; 
		_x setCombatMode "RED";
		_x setSkill 0.75;	
	};
} forEach allUnits;