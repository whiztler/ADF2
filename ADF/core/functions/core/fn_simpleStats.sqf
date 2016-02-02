/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Function: ADF_fnc_simpleStats
Author: Whiztler
Script version: 1.01

File: fn_simpleStats.sqf
**********************************************************************************
This function displays server/headless client statistics and information. In the 
ADF sample mission the function is activated using a radio traigger [0-0-0]. But
you can call the function from anywhere, anytime. As long as it is executed by all
connected clients.

REQUIRED PARAMETERS:
n/a

OPTIONAL PARAMETERS:
n/a

EXAMPLE:
[] call ADF_fnc_simpleStats;

RETURNS:
Bool
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_simpleStats");

// Init
ADF_sStats_textServer 	= "";
ADF_sStats_textHeadless1	= "";
ADF_sStats_textHeadless2	= "";
ADF_sStats_textHeadless3	= "";
private _s				= 0.5;
private _c				= 0;

while {(_c != 20)} do {
	_c = _c + 1;
	
	private _gen = {
		ADF__P3(_c,_n,_m);
		private "_ADF_FPS";
		
		if (isMultiplayer) then {_ADF_FPS = round (diag_fps)} else {_ADF_FPS = "N/A";};
		
		_m = format ["
			<t color='#FFFFFF' align='left' font='PuristaMedium' size='.9'>%1:</t><br/>
			
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>FPS:</t>
			<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%2</t><br/>
			
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units west:</t>
			<t color='#799cff' align='right' font='PuristaBold' size='.9'>%3</t><br/>
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units east:</t>
			<t color='#ff8989' align='right' font='PuristaBold' size='.9'>%4</t><br/>
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units independent:</t>
			<t color='#d8ff5f' align='right' font='PuristaBold' size='.9'>%5</t><br/>
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units Civilian:</t>
			<t color='#eebffd' align='right' font='PuristaBold' size='.9'>%6</t><br/><br/>",
			_n,														// 1
			_ADF_FPS, 												// 2			
			{(local _x) && (side _x == west)} count allUnits, 			// 3
			{(local _x) && (side _x == east)} count allUnits, 			// 4
			{(local _x) && (side _x == independent)} count allUnits, 	// 5
			{(local _x) && (side _x == civilian)} count allUnits 		// 6
		];

		if (_c == 0) exitWith {ADF_sStats_textServer	= _m; publicVariable "ADF_sStats_textServer"};
		if (_c == 1) exitWith {ADF_sStats_textHeadless1 = _m; publicVariable "ADF_sStats_textHeadless1"};
		if (_c == 2) exitWith {ADF_sStats_textHeadless2 = _m; publicVariable "ADF_sStats_textHeadless2"};
		if (_c == 3) exitWith {ADF_sStats_textHeadless3 = _m; publicVariable "ADF_sStats_textHeadless3"};
		
	};	

	if (isDedicated || isServer) then {[0,"Server",ADF_sStats_textServer] call _gen};
	if (ADF_isHC1) then {[1,"Headless Client 1",ADF_sStats_textHeadless1] call _gen};
	if (ADF_isHC2) then {[2,"Headless Client 2",ADF_sStats_textHeadless2] call _gen};
	if (ADF_isHC3) then {[3,"Headless Client 3",ADF_sStats_textHeadless2] call _gen};
		
	private _ADF_textIntro = format ["
		<t color='#FFFFFF' size='1.3' font='PuristaMedium'>SERVER STATS</t><br/><br/>		
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Game time:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%1</t><br/>
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Total Units:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%2</t><br/>
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Total Players:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%3</t><br/>	
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Total Groups:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%4</t><br/><br/>",
		[(round time)] call BIS_fnc_secondsToString, 	//1
		count allUnits,								//2
		{alive _x} count (allPlayers - ADF_cntHC),		//3
		count allGroups								//4		
	];
		
	if (hasInterface) then {hintSilent parseText (_ADF_textIntro + ADF_sStats_textServer + ADF_sStats_textHeadless1 + ADF_sStats_textHeadless2 + ADF_sStats_textHeadless3)};
	
	UiSleep _s;
};

hintSilent "";

{_x = nil} forEach [ADF_sStats_textServer, ADF_sStats_textHeadless1, ADF_sStats_textHeadless2, ADF_sStats_textHeadless3];

true

