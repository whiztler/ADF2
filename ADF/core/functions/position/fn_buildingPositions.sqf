/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_buildingPositions
Author: Whiztler
Script version: 1.14

File: fn_buildingPositions.sqf
**********************************************************************************
The buildingPostions function creates and pupulates an array of buildings within
the given radius. The buildings are checked for being enterable and having
garrison positions.
The building positions (array) are stored in: ADF_garrPos via setVariable

INSTRUCTIONS:
Call from script on the server

REQUIRED PARAMETERS:
0: position -  (marker, object/unit, array [x,y,z])
1: number - radius in meters

OPTIONAL PARAMETERS:
n/a

EXAMPLE
_buildings = ["myMarker", 50] call ADF_fnc_buildingPositions;

RETURNS:
Array (Enterable buildings with building positions)
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_buildingPositions");

// init	
params [["_p", [0, 0, 0], [[]], [3]], ["_r", 10, [0]]];

// Create the building array
private _b = nearestObjects [_p, ["building"], _r];
if (count _b == 0) exitWith {[]};	

// Check if building can be entered. Then check if the building has garrison positions.
// If no position available, remove the building from the array

{
	if !(ADF__GVAR(_x,ADF_garrPosAvail,true)) then {
		_b = _b - [_x];
	} else {
	
		if ((count (ADF__GVAR(_x,ADF_garrPos,[]))) == 0) then {
			ADF__SVAR(_x,ADF_garrPos,[]);
			private _be = [_x] call BIS_fnc_isBuildingEnterable;
			private _bp = [_x] call BIS_fnc_buildingPositions;
			
			if (ADF_debug && ADF_debug_bPos) then {
				{
					_v = createVehicle ["Sign_Sphere100cm_F", [_x select 0, _x select 1, (_x select 2) + 1], [], 0, "NONE"];
					private _m = createMarker [format ["p_%1", _x], _x];
					_m setMarkerSize [.7, .7];
					_m setMarkerShape "ICON";
					_m setMarkerType "hd_dot";
					_m setMarkerColor "ColorYellow";
				} forEach _bp;
			};

			if (!_be || (count _bp == 0)) then {_b = _b - [_x]};
			ADF__SVAR(_x,ADF_garrPos,_bp);
			ADF__SVAR(_x,ADF_garrPosAvail,true);
		};
		
	};
	
} forEach _b;

// return the building array
_b
