/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_unitSetSkill
Author: Whiztler
Script version: 1.01

File: fn_unitSetSkill.sqf
**********************************************************************************
INSTRUCTIONS:
Applies skill to a single unit. Use ADF_fnc_groopSetSkill if you wish to apply a
skill set for an entire group.
Info: https://community.bistudio.com/wiki/AI_Sub-skills

REQUIRED PARAMETERS:
0. Object - the unit you wish to apply the skill set to.
1. String:
	"untrained"	- unskilled, slow to react 
	"recruit"	- semi skilled
	"novice"		- Skilled, trained. Vanilla+ setting
	"veteran"	- Very skilled, Well trained
	"expert"		- Special forces quality

OPTIONAL PARAMETERS:
n/a

EXAMPLE
[_myUnit, "veteran"] call ADF_fnc_groupSetSkill;

RETURNS:
Object
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_group.sqf");

params [["_u", objNull, [objNull]], ["_s", ["untrained", "recruit", "novice", "veteran", "expert"], [""]]];

private _k	= false;
private _s1	= 0.15;
private _s2	= 0.3;
private _s3	= 0.2;
private _s4	= 0.5;
private _s5	= 0.4;
private _s6	= 0.3;
private _s7	= 0.5;
private _s8	= 0.4;
private _s9	= 0.4;
private _s10	= 0.6;
private _s11	= 0.3; 

switch _s do {	
	case "untrained"	: {_s1 = 0.05; _s2 = 0.1; _s3 = 0.1; _s4 = 0.1; _s5 = 0.3; _s6 = 0.1; _s7 = 0.2; _s8 = 0.1; _s9 = 0.2; _s10 = 0.2; _s11 = 0; _k = true};
	case "recruit"	: {_s1 = 0.07; _s2 = 0.2; _s3 = 0.1; _s4 = 0.2; _s5 = 0.4; _s6 = 0.2; _s7 = 0.3; _s8 = 0.3; _s9 = 0.3; _s10 = 0.4; _s11 = 0.1};
	case "novice"	: {};
	case "veteran"	: {_s1 = 0.2; _s2 = 0.6; _s3 = 0.25; _s4 = 0.6; _s5 = 0.5; _s6 = 0.4; _s7 = 0.8; _s8 = 0.6; _s9 = 0.5; _s10 = 0.7; _s11 = 0.4};
	case "expert"	: {_s1 = 0.35; _s2 = 0.75; _s3 = 0.35; _s4 = 1; _s5 = 0.8; _s6 = 0.55; _s7 = 1; _s8 = 0.7; _s9 = 0.6; _s10 = 1; _s11 = 0.7; };
};

if (_k) then {_u disableAI "FSM";};
_u setSkill ["aimingAccuracy",_s1];
_u setSkill ["aimingShake",_s2];
_u setSkill ["aimingSpeed",_s3];
_u setSkill ["endurance",_s4];		
_u setSkill ["spotDistance",_s5];
_u setSkill ["spotTime",_s6];
_u setSkill ["courage",_s7];
_u setSkill ["reloadspeed",_s8];	
_u setSkill ["general",_s9];
if (_u == leader group _u) then {
	_u setSkill ["commanding",_s10];
} else {
	_u setSkill ["commanding",_s11];
};

ADF__DBGVAR2("ADF Debug: ADF_fnc_groupSetSkill - Skill (%1) set for group: %2", _s, _g);

_u
