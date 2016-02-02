/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_stripVehicle
Author: Whiztler
Script version: 1.01

File: fn_stripVehicle.sqf
**********************************************************************************
Clears the cargo contents of a vehicle.

REQUIRED PARAMETERS:
0. Object: vehicle, aircraft, etc.

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
[myCar] call  ADF_fnc_stripVehicle;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_stripVehicle");

//init
ADF__P1(_v);

clearWeaponCargoGlobal _v;
clearBackpackCargoGlobal _v;	
clearMagazineCargoGlobal _v;
clearItemCargoGlobal _v;

true
