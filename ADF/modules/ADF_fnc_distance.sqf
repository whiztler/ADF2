/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Distance functions
Author: Whiztler
Script version: 1.11

File: ADF_fnc_distance.sqf
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_distance.sqf");


ADF_fnc_checkDistance = {
	/***************************************************************
	Name: ADF_fnc_checkDistance

	REQUIRED PARAMETERS:
	0. Position - marker / object / vehicle / group
	1. Position - marker / object / vehicle / group

	OPTIONAL PARAMETERS:
	n/a

	RETURNS:
	Integer (distance in meters)

	EXAMPLE::
	[player, "myMarler"] call ADF_fnc_checkDistance;
	[player, myObject] call ADF_fnc_checkDistance;
	***************************************************************/

	ADF__P2(_a,_b);
	
	ADF__CHKPOS(_a);
	ADF__CHKPOS(_b);
	private _r = round (_a distance2D _b);
	ADF__RPTVAR3("ADF RPT: ADF_fnc_checkDistance - Distance (%1 -- %2): %3 meters",_a, _b, _r);
	
	_r
};


ADF_fnc_checkClosest = {
	/***************************************************************
	Name: ADF_fnc_checkClosest

	REQUIRED PARAMETERS:
	0. Array - e.g. AllPlayers, allUnits, etc
	1. Position - Marker, unit, group, object, Array [X,Y.Z] (to
			    check against)

	OPTIONAL PARAMETERS:
	2. radius (number)

	RETURNS:
	Integer (distance number)

	EXAMPLE::
	[allPlayers, myObject] call ADF_fnc_checkClosest;
	***************************************************************/

	params ["_a", "_b", ["_r", 10^5, [0]]];	
	private _return = _r + 1;
	
	{
		_return = [_x, _b] call ADF_fnc_checkDistance;
		ADF__RPTVAR3("ADF RPT: ADF_fnc_checkClosest - distance %1 to %2 is %3 meters", _x, _b, _return);
		if (_return < _r) then {_r = _return};
	} forEach _a;
	
	_return	
};


ADF_fnc_countRadius = {
	/***************************************************************
	Name: ADF_fnc_countRadius

	REQUIRED PARAMETERS:
	0. Position - Marker, unit, group, object, Array [X,Y.Z].
	1. Side - east, wets, independent, etc.
	2. Number - radius.

	OPTIONAL PARAMETERS:
	3. type ("man", "car", "apc", "tank", "all" - default: "man")
	   either string for a single type or an array for multiple types

	RETURNS:
	Integer (number of units / vehicles / etc.)

	EXAMPLE::
	_enemyCount = ["myMarker", east, 250, "MAN"] call ADF_fnc_countRadius;
	***************************************************************/

	params [	"_p", ["_s", east, [west]], ["_r", 100, [0]], "_t"];
	
	ADF__CHKPOSA(_p);
	private _return = {side _x == _s} count (_p nearEntities [_t, _r]);
	
	_return	
};


ADF_fnc_calcTravelTime = {
	/***************************************************************
	Name: ADF_fnc_calcTravelTime

	REQUIRED PARAMETERS:
	0. Position - start position (marker, object, position array [X,Y,Z])
	1. Position - end position (marker, object, position array [X,Y,Z])
	2. Estmiated travel speed in Km/hr

	RETURNS:
	Array:
	0 - hours
	1 - minutes
	2 - seconds

	EXAMPLE:
	[myHelicopter, "destinationMarker", 275] call ADF_fnc_calcTravelTime;
	***************************************************************/

	params ["_p1", "_p2", ["_v", 50, [0]]];
	
	ADF__CHKPOSA(_p1);
	ADF__CHKPOSA(_p2);
	
	ADF__DBGVAR1("ADF Debug: ADF_fnc_calcTravelTime: Distance = %1 Meters", round (_p1 distance2D _p2));
	
	// Distance calculate in meters per seconds. Based on meters and Km/hr.
	private _s = (_p1 distance2D _p2) / (_v * 0.277777);
	ADF__DBGVAR1("ADF Debug: ADF_fnc_calcTravelTime: Seconds per meter: %1", _s);
	
	// Convert seonds into 24-hour time format.
	private _h	= floor (_s / 3600);
	_s	= _s mod 3600;
	private _m	= floor (_s / 60);
	_s	= _s mod 60;
	_s	= floor _s;

	ADF__DBGVAR3("ADF Debug: ADF_fnc_calcTravelTime: Hour(s): %1 -- Minute(s): %2 -- Seoond(s): %3", _h, _m, _s);

	[_h, _m, _s]
};
