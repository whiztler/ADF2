/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Object functions
Author: Whiztler
Script version: 1.01

File: ADF_fnc_object.sqf
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_object.sqf");


ADF_fnc_objectSimulation = {
	/****************************************************************
	Name: ADF_fnc_objectDisable
	Disables AI units/objects

	REQUIRED PARAMETERS:
	0. Object
	1; Bool:
		- false for disable simulation
		- true for enable simulation

	OPTIONAL PARAMETERS:
	n/a

	RETURNS:
	Bool (success flag)

	EXAMPLE:
	[enemy_unit, false] call ADF_fnc_objectSimulation;
	****************************************************************/

	params [["_u", objNull, [objNull]], ["_s", false, [true]]];

	if (_s) then {
		_u enableSimulation false; 
		
		_u disableAI "FSM";
		_u disableAI "SUPPRESSION"; 
		_u disableAI "TARGET";
		_u disableAI "AUTOTARGET";
		_u disableAI "MOVE"; 
	
		ADF__DBGVAR1("ADF Debug: ADF_fnc_objectSimulation - Simulation aspects desiabled for: %1", _u);
	} else {
		_u enableAI "FSM";
		_u enableAI "SUPPRESSION"; 
		_u enableAI "TARGET";
		_u enableAI "AUTOTARGET";
		_u enableAI "MOVE"; 
		
		_u enableSimulation true;
		
		ADF__DBGVAR1("ADF Debug: ADF_fnc_objectSimulation - Simulation aspects enabled for: %1", _u);
	};
	
	true
};


ADF_fnc_objectHeliPilot = {
	/****************************************************************
	Name: ADF_fnc_objectHeliPilot
	This function makes heli pilots perform actions even when under
	fire or when they have spotted enemies.

	REQUIRED PARAMETERS:
	0. Object

	OPTIONAL PARAMETERS:
	n/a

	RETURNS:
	Bool (success flag)

	EXAMPLE:
	[myPilot] call ADF_fnc_objectHeliPilot;
	****************************************************************/
	
	params [["_u", objNull, [objNull]]];

	_u setBehaviour "COMBAT";
	_u setCombatMode "BLUE";
	
	_u disableAI "SUPPRESSION"; 
	_u disableAI "CHECKVISIBLE";
	_u disableAI "AUTOTARGET";
	_u disableAI "AUTOCOMBAT";

	_u enableAttack false;
	
	ADF__DBGVAR1("ADF Debug: ADF_fnc_objectHeliPilot - Helicopter pilot AI aspects disabled for: %1", _u);
	
	true
};


