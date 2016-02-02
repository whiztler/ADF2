/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Delete functions
Author: Whiztler
Script version: 1.10

File: ADF_fnc_delete.sqf
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_delete.sqf");


ADF_fnc_deleteCrewedVehicles = {
	/****************************************************************
	Name: ADF_fnc_deleteCrewedVehicles
	The function removes vehicles, its crew and the crew group.
	
	INSTRUCTIONS:
	call the function from your (spawn) script for crewed vehicles
	that need to be deleted. 

	REQUIRED PARAMETERS:
	0. Array of crewed vehicles

	OPTIONAL PARAMETERS:
	n/a

	RETURNS:
	Bool (success flag)

	EXAMPLE:
	[veh1, veh2, veh3] call ADF_fnc_deleteCrewedVehicles;
	****************************************************************/

	ADF__P1(_v);

	{
		private _g = group ((crew _x) select 0);
		ADF__DBGVAR2("ADF Debug: ADF_fnc_deleteCrewedVehicles - deleting vehicle: %1 and its crew (%2)", _v, _g);
		
		{deleteVehicle _x} forEach crew (vehicle _x) + [(vehicle _x)];
		deleteGroup _g;
	} forEach _v;
	
	true
};


ADF_fnc_deleteEntities = {
	/****************************************************************
	Name: ADF_fnc_deleteEntities
	This function removes pre-defined entities (objects, AI units,
	vehicles) within a pre-defined range (circular). The function
	does not delete static map objects.

	REQUIRED PARAMETERS:
	0. Position - (marker, object, position [x,y,z]).
	1. Number - radius in meters (number). The larger the range the
			  more expensive the function is. Try keep < 30.
	2. String - Types of entities (Array). E.g.
			  ["ALL"] // All objects/entities
			  ["MAN"] // Only AI's
			  ["MAN","CAR","APC","TANK","StaticWeapon"]
	   
	OPTIONAL PARAMETERS:
	3. Side - side of objects/units/vehicles to delete (west, east,
			civilian, independent).
			Use civilian in case of static objects.
			When using west, it does not delete empty vehicles
			that have been placed on the map using the editor.
			Even when it is a vehicle belonging to a specific side.
	4. Booly - Delete (true) or Destroy (false) the entity.
			 In case of destroy (false) setDamage is set to 1.

	RETURNS:
	Bool (true)

	EXAMPLE:
	["myMarker", 25, ["ALL"], west, false] call ADF_fnc_deleteEntities;
	[myObject, 50, ["MAN"], east, true] call ADF_fnc_deleteEntities;
	[position player, 10, ["CAR"], civilian, false] call ADF_fnc_deleteEntities;
	****************************************************************/

	// init
	params [	"_p", ["_r", 50, [0]], ["_t", ["MAN"], [[]]], ["_s", civilian, [east]], ["_d", true, [false]]];
	
	ADF__CHKPOS(_p);
	
	if (_s == civilian) then {	
		{
			if (_d) then {
				deleteVehicle _x
			} else {
				_x setDamage 1
			};
		} forEach (_p nearEntities [_t, _r]);
	} else {
		{
			if (side _x == _s) then {
				if (_d) then {
					deleteVehicle _x
				} else {
					_x setDamage 1
				};
			};	
		} forEach (_p nearEntities [_t, _r]);
	};
	
	true
};