/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_stripUnit
Author: Whiztler
Script version: 1.01

File: fn_stripUnit.sqf
**********************************************************************************
Creates an Error message or Debug message. Error messages are always show on the
BIS bottom info screen. Both SP and MP.

REQUIRED PARAMETERS:
0. Object: AI unit, player
1. Bool - true: remove uniform
		false: do not remove uniform

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
[player, "true"] call ADF_fnc_stripUnit;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_stripUnit");

// init
params [["_o", objNull, [objNull]], ["_u", true, [false]]];

removeAllWeapons _o;
removeAllAssignedItems _o;
removeAllItems _o;
removeHeadgear _o;
removeGoggles _o;
removeVest _o;
removeBackpack _o;
if (_u) then  {removeUniform _o};

true	
