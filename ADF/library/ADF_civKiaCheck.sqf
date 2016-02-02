/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Civilian KIA Check
Author: Shuko (Adapted for A3 by Whiztler)
Script version: 1.3

File: ADF_civKiaCheck.sqf
********************************************************************************
INSTRUCTIONS::

This script checks for the number of civilians being killed
by BlueFor. When a civilian is KIA, the location is marked on the map with a
purple mil-dot.
********************************************************************************/


ADF_civKilled = 0;
if (isServer) then {
	ADF_fnc_civKia_EH = {
		private _p = getPos (_this select 0);
		private _s = side (_this select 1);
		ADF_civKiller = _this select 1;
		
		if (rating ADF_civKiller < 0) then {ADF_civKiller addRating 9999; publicVariable "ADF_civKiller";}; 
		
		if (_s == ADF_playerSide) then {
			ADF_civKilled = ADF_civKilled + 1;
			publicVariable "ADF_civKilled"; publicVariable "ADF_civKiller";
			private _m = createMarker [format ["m_ckia_%1", ADF_civKilled], _p];
			_m setMarkerShape "ICON"; _m setMarkerType "mil_dot"; _m setMarkerSize [0.7, 0.7]; _m setMarkerColor "ColorCIV"; 
		}
	};
	
	{
		if ((side _x == civilian) && (_x isKindOf "Man")) then {
		  _x addEventhandler ["killed", ADF_fnc_civKia_EH];
		};
	} foreach allUnits;
} else {
  if (hasInterface) then {"ADF_civKilled" addPublicVariableEventHandler {call ADF_fnc_civKia_msg}}; // JIP compatible EH
};