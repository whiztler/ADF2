/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Object Marker
Author: Whiztler
Script version: 1.11

Game type: N/A
File: ADF_fnc_objectMarker.sqf
**********************************************************************************
Creates gray boundingbox box markers for editorplaces or scripted objects. They
then appear as map objects.

CONFIG:

_array = ["ClassName", "ClassName", "ClassName"]; // Array of classnames of objects to mark on the map

[
	_array,		// Array
	"MyMarker",	// Position - object, marker, trigger, etc
	150			// Number - radius from center position
] call ADF_fnc_objectMarker;

The function changes the marker layer. If you have custom marker (e.g.) text
markers, you can re-apply them:

["myMarker"] call ADF_fnc_reMarker;
or in case of multiple markers:
{_x call ADF_fnc_reMarker} forEach ["marker1", "marker2", "marker3"];

Run on the server only!
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_objectMarker.sqf");

ADF_fnc_objectMarker = {
	// init
	ADF__diagInit;
	ADF__P3(_a,_p,_r);	
	
	if (typeName _p == "STRING") then {_p = getMarkerPos _p};	
	if (typeName _p == "OBJECT") then {_p = getPosATL _p};
	
	_q = nearestObjects [_p, _a, _r];
	
	{
		private _s = (boundingBoxReal _x) select 1;
		_s resize 2;
		private _m = createMarker [format ["mObj%1%2", floor(random 9999), floor(_x select 0)], 0];
		_m setMarkerShape "RECTANGLE";
		_m setMarkerSize _s;
		_m setMarkerBrush "SolidFull";
		_m setMarkerColor "ColorGrey";
		_m setMarkerDir (getDir _x);
	} forEach _q;
	
	ADF__diagTime("ADF_fnc_objectMarker");
};

ADF_fnc_reMarker = {
	ADF__P1(_a);
	
	// Store marker data
	private _mn = _a;
	private _mp = getMarkerPos _a;
	private _mt = getMarkerType _a;
	private _mc = getMarkerColor _a;
	private _my = markerShape _a;
	private _md = markerDir _a;
	private _ms = getMarkerSize _a;
	private _mx = markerText _a;	
	private _ma = markerAlpha _a;
	private _mb = markerBrush _a;
	
	// Delete the marker
	deleteMarker _a;
	
	// re-create the marker on top of the object markers
	private _m = createMarker [_mn, _mp];
	_m setMarkerType _mt;
	_m setMarkerColor _mc;
	_m setMarkerShape _my;
	_m setMarkerDir _md;
	_m setMarkerSize _ms;
	_m setMarkerText _mx;
	_m setMarkerAlpha _ma;
	_m setMarkerBrush _mb;
	
	ADF__DBGVAR1("ADF Debug: ADF_fnc_reMarker marker (%1) re-created", _mn);
};