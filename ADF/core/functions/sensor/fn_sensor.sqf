/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_sensor
Author: Whiztler
Script version: 1.01

File: fn_sensor.sqf
**********************************************************************************
This is an alternative for triggers for conditions that do NOT need to be checked
every frame or every 0.5 seconds.

INSTRUCTIONS:
The function checks distance players to an object/marker/vehicle.  You'll need to
define the array of units/players/vehicles it needs to check against.
Call from script on the server

REQUIRED PARAMETERS:
0: Array - Array to check against. E.g. allPlayers
1: Object or String - object/vehicle/marker to check distance to players. Name the object in the editor or script.
2. Number - Sensor radius in meters
3. Number - Check interval in seconds.
4. Bool - Persisten:
		- true: is persistent
		- false: not persistent (run once)
5. String - "myCode1" Code to run (spawned) when the condition is true. E.g. myCode = {hint "The sensor is active";};
6. String - "myCode2" Code to run (spawned) when the condition is false (deactivation). E.g. myCode2 = {hint "The sensor is deactivated";};
			
OPTIONAL PARAMETERS:
n/a

EXAMPLE:
_checkArray = allPlayers;
[_cArr, myObject, 500, 5, true, "myCode1", "myCode2"] call ADF_fnc_sensor;
myCode1 = {systemChat "The sensor is active";};
myCode2 = {systemChat "The sensor is deactivated";};
// Mycode represents the code that is executed when players/vehicles get within the sensor radius.

RETURNS:
Nothing

*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_sensor");

// Init
ADF__P7(_a,_b,_r,_s,_p,_cIN,_cOUT);
private _codeOutExec	= false;
private _codeIn 		= call compile format ["%1", _cIN];
private _codeOut		= if (_cOUT != "") then {_codeOutExec = true; call compile format ["%1", _cOUT]};

// Check distance loop
waitUntil {
	private _c = [_a, _b, _r] call ADF_fnc_checkClosest;
	private _e = false;	
	
	if (_c < _r) then {		
		[] spawn _codeIn;			
		if !(_p) then {
			_e = true;
			_s = 0;
		} else {
			waitUntil {
				sleep _s;
				_c = [_a, _b, _r] call ADF_fnc_checkClosest;
				_c > _r
			};
			if (_codeOutExec) then {[] spawn _codeOut};
		};			
	};		
	
	sleep _s;
	_e
};

ADF__DBGVAR1("ADF Debug:  ADF_fnc_sensor: sensor %1 deactivated", _b);
