/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: CAS create functions
Author: Whiztler
Script version: 1.13

File: ADF_fnc_createCAS.sqf
**********************************************************************************
These functions are called by ADF\library\ADF_CAS.sqf.
To configure CAS support open and edit ADF\library\ADF_CAS.sqf
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_fnc_createCAS.sqf");

ADF_fnc_CAS_supportRq = {
	// Init
	params ["_u", "_i"];
	
	// Removed the action
	_u removeAction _i;
	
	// Map click process.
	if (player == ADF_CAS_requester) then {openMap true; hintSilent format ["\n%1, click on a location\n on the map where you want\nClose Air Support.\n\n", name _u]};
	ADF_CAS_requester onMapSingleClick {
		ADF_CAS_pos = _pos;
		publicVariableServer "ADF_CAS_pos";
		onMapSingleClick ""; true;
		openMap false; hint "";
		[] spawn ADF_fnc_CAS_Activated;
		remoteExec ["ADF_fnc_CAS_server", 2, false];
	};
};

ADF_fnc_CAS_Activated = {
	// Init
	private _p	= str (format ["%1 . %2", round (ADF_CAS_pos select 0), round (ADF_CAS_pos select 1)]);
	private _v	= createVehicle ["Land_HelipadEmpty_F", ADF_CAS_pos, [], 0, "NONE"];
	private _av	= getPosASL _v;
	private _m	= round (_av select 2);
	deleteVehicle _v;
	
	private _at	= [ADF_CAS_spawn, ADF_CAS_pos, 275] call ADF_fnc_calcTravelTime; 
	private _d	= str (floor ((ADF_CAS_delay / 60) + (_at select 1)));

	// NLT
	private _th	= date select 3;
	private _tm	= date select 4;
	if ((_tm + 10) >= 60) then {
		_th	= _th + 1;
		_tm	= (_tm + 10) - 60; 
	} else {_tm = _tm + 10};
	
	private _t = format ["%1:%2", _th, _tm];
	
	ADF_CAS_marker = true; publicVariableServer "ADF_CAS_marker";

	if (!hasInterface) exitWith {};
	// 9=liner CAS proc
	hintSilent parseText format ["<img size= '5' shadow='false' image='%4'/><br/><br/><t color='#6C7169' align='left'>%1 this is %3. Request %2. How copy?</t><br/><br/>", ADF_CAS_callSign, ADF_CAS_station, ADF_CAS_groupName, ADF_clanLogo];
	if (ADF_CAS_log) then {
		ADF__LOGBK;
		player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: " +ADF_CAS_groupName+ "</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>"+ ADF_CAS_callSign +" this is "+ ADF_CAS_groupName +". Request "+ ADF_CAS_station +". How copy?</font><br/><br/>"]];
	};
	sleep 6;

	hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_CAS_image+ "'/><br/><br/><t color='#6C7169' align='left'>%1: %3 this is %2. Ready to copy. Over.</t><br/><br/>", ADF_CAS_pilotName, ADF_CAS_callSign, ADF_CAS_groupName];
	if (ADF_CAS_log) then {
		ADF__LOGBK;
		player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: "+ ADF_CAS_callSign +"</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/>	<font color='#6C7169'>"+ ADF_CAS_pilotName +": " +ADF_CAS_groupName+ " this is "+ ADF_CAS_callSign +". Ready to copy. Over.</font><br/><br/>"]];
	};
	sleep 9;
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_clanLogo+ "'/><br/><br/><t color='#6C7169' align='left'>%1 with %2:</t><br/><br/><t color='#6C7169' align='left'>PRIORIY: #1</t><br/><t color='#6C7169' align='left'>TARGET: %3, %4</t><br/><t color='#6C7169' align='left'>LOCATION: %5, %6 MSL</t><br/><t color='#6C7169' align='left'>TARGET TIME: NLT %7</t><br/><t color='#6C7169' align='left'>RESULT: %8</t><br/><t color='#6C7169' align='left'>CONTROL: %10 command</t><br/><t color='#6C7169' align='left'>REMARKS: Vectors %9, Friendlies close. How copy?</t><br/><br/>", ADF_CAS_callSign, ADF_CAS_station, ADF_CAS_targetName, ADF_CAS_targetDesc, _p, _m, _t, ADF_CAS_result, ADF_CAS_apprVector, ADF_CAS_groupName];
	if (ADF_CAS_log) then {
		ADF__LOGBK;
		player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: " +ADF_CAS_groupName+ "</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/>		<font color='#6C7169'>"+ ADF_CAS_callSign +" with "+ ADF_CAS_station +":<br/><br/>PRIORIY: #1<br/><br/>TARGET: " +ADF_CAS_targetName+ ", " +ADF_CAS_targetDesc+ "<br/><br/>LOCATION: "+ _p +", "+ str _m +" MSL<br/><br/>TARGET TIME: NLT "+ _t +"<br/><br/>RESULT: " +ADF_CAS_result+ "<br/><br/>CONTROL: " +ADF_CAS_groupName+ " command<br/><br/>REMARKS: Vectors "+ ADF_CAS_apprVector +", Friendlies close. How copy?</font><br/><br/>"]];
	};
	sleep 30;
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_CAS_image+ "'/><br/><br/><t color='#6C7169' align='left'>%1: Read back. PRIORIY: #1, TARGET: %2, %3, LOCATION: %4, %5 MSL, NLT %6, RESULT: %7, CONTROL: %9, REMARKS: Vectors %8, Friendlies close. Over.</t><br/><br/>", ADF_CAS_pilotName, ADF_CAS_targetName, ADF_CAS_targetDesc, _p, _m, _t, ADF_CAS_result, ADF_CAS_apprVector, ADF_CAS_groupName];
	if (ADF_CAS_log) then {
		ADF__LOGBK;
		player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: " +ADF_CAS_callSign+ "</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>"+ ADF_CAS_pilotName +": Read back. PRIORIY: #1, TARGET: " +ADF_CAS_targetName+ ", " +ADF_CAS_targetDesc+ ", LOCATION: "+ _p +", "+ str _m +" MSL, NLT "+ _t +", RESULT: " +ADF_CAS_result+ ", CONTROL: " +ADF_CAS_groupName+ ", REMARKS: Vectors "+ ADF_CAS_apprVector +", Friendlies close. Over.</font><br/><br/>"]];
	};
	sleep 18;
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_clanLogo+ "'/><br/><br/><t color='#6C7169' align='left'>Read back correct. Execute %1. Cleared %1. How Copy?</t><br/><br/>", ADF_CAS_station];
	if (ADF_CAS_log) then {
		ADF__LOGBK;
		player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: " +ADF_CAS_groupName+ "</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>Read back correct. Execute " +ADF_CAS_station+ ". Cleared " +ADF_CAS_station+ ". How Copy?</font><br/><br/>"]];
	};
	sleep 8;
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_CAS_image+ "'/><br/><br/><t color='#6C7169' align='left'>%1: Go on %2. ETA %3 Mikes. Out.</t><br/><br/>", ADF_CAS_pilotName, ADF_CAS_station, _d];
	if (ADF_CAS_log) then {
		ADF__LOGBK;
		player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: " +ADF_CAS_callSign+ "</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>" +ADF_CAS_callSign+ ": Go on " +ADF_CAS_station+ ". ETA "+ _d +" Mikes. Out.</font><br/><br/>"]];
	};
	
	sleep ADF_CAS_delay; // Time from map entrance it will take CAS to reach the AO

	ADF_CAS_active = true; publicVariableServer "ADF_CAS_active"; // Inform the server to create the CAS vehicle
	
	waitUntil {sleep 3; ADF_CAS_bingoFuel}; // Wait till the CAS ao timer runs out
	
	if (!alive ADF_vCAS) exitWith { // CAS is kia!
		hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_clanLogo+ "'/><br/><br/><t color='#6C7169' align='left'>%1 this is %3. %2 is down. How copy?</t><br/><br/>", ADF_HQ_callSign, ADF_CAS_callSign, ADF_CAS_groupName];
		sleep 9;
		hintSilent parseText"<img size= '5' shadow='false' image='image='" +ADF_HQ_image+ "'/>'/><br/><br/><t color='#6C7169' align='left'>" +ADF_CAS_groupName+ " this is" +ADF_HQ_callSign+ ". Solid Copy. We'll inform AOC. Stay on mission. Out.</t><br/><br/>";
		if (ADF_CAS_log) then {
			ADF__LOGBK;
			player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: " +ADF_HQ_callSign+ "</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>" +ADF_CAS_groupName+ " this is " +ADF_HQ_callSign+ ". Solid copy. We'll inform AOC. Stay on mission. Out.</font><br/><br/>"]];
		};		
		sleep 12;
		hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_clanLogo+ "'/><br/><br/><t color='#6C7169' align='left'>%1 this is %3. Roger. Out.</t><br/><br/>", ADF_HQ_callSign, ADF_CAS_callSign, ADF_CAS_groupName];
		call ADF_fnc_CAS_destroyVars;
	};	
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_CAS_image+ "'/><br/><br/><t color='#6C7169' align='left'>%2: %3 this is %1 with bingo fuel. We are RTB. Over.</t><br/><br/>", ADF_CAS_callSign, ADF_CAS_pilotName, ADF_CAS_groupName];
	if (ADF_CAS_log) then {
		ADF__LOGBK;
		player createDiaryRecord [ADF_CAS_logName, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: "+ ADF_CAS_callSign +"</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>"+ ADF_CAS_pilotName +": " +ADF_CAS_groupName+ " this is " +ADF_CAS_callSign+ " with bingo fuel. We are RTB. Over.</font><br/><br/>"]];
	};
	sleep 11;
	hintSilent parseText format ["<img size= '5' shadow='false' image='" +ADF_clanLogo+ "'/><br/><br/><t color='#6C7169' align='left'>%1 this is %3. Roger. Thanks for the assist. Out.</t><br/><br/>", ADF_CAS_callSign, ADF_CAS_groupName];
	call ADF_fnc_CAS_destroyVars;
};

ADF_fnc_CAS_destroyVars = {
	// Destroy not needed variables:
	ADF_vCAS 			= nil; 
	ADF_CAS_pos 			= nil;
	ADF_CAS_active 		= nil;
	ADF_CAS_marker		= nil;
	ADF_CAS_bingoFuel 	= nil; 
	ADF_CAS_spawn			= nil;
	ADF_CAS_vector		= nil;
	ADF_CAS_delay			= nil;
	ADF_CAS_onSite		= nil;
	ADF_fnc_CAS_supportRq = nil;
	ADF_fnc_CAS_Activated = nil;
	ADF_CAS_callSign		= nil;
	ADF_CAS_station		= nil;
	ADF_CAS_targetName	= nil;
	ADF_CAS_targetDesc	= nil;
	ADF_CAS_result		= nil;
	ADF_CAS_apprVector	= nil;
	ADF_HQ_callSign		= nil;
	ADF_CAS_aoTriggerRad	= nil;
	ADF_CAS_log			= nil;
	ADF_CAS_logName		= nil;
	ADF_CAS_groupName		= nil;
	if (!isServer) exitWith {};
	diag_log	"-----------------------------------------------------";
	diag_log "ADF RPT: CAS (server) terminated";
	diag_log	"-----------------------------------------------------";
};

// From here on server only. Create the CAS vehicle, create markers etc.
ADF_fnc_CAS_server = {
	// init
	private _mc = "";
	private _vc = "";

	waitUntil {sleep 1; ADF_CAS_marker}; // wait till the CAS request action was executed

	diag_log	"-----------------------------------------------------";
	diag_log "ADF RPT: CAS (server) activated";
	diag_log	"-----------------------------------------------------";

	// Create the CAS circle marker
	switch ADF_CAS_side do {
		case west		: {_mc = "ColorWEST"; _vc = "B_Heli_Attack_01_F"};
		case east		: {_mc = "ColorEAST"; _vc = "O_Heli_Attack_02_black_F"};
		case independent	: {_mc = "ColorGUER"; _vc = "I_Heli_light_03_F"};
	};	
	
	private _m = createMarker ["mCAS_SAD", ADF_CAS_pos];
	_m setMarkerSize [500, 500];
	_m setMarkerShape "ELLIPSE";
	_m setMarkerBrush "Border";
	_m setMarkerColor _mc;
	_m setMarkerDir 0;

	// Create the CAS AO triggerActivated
	tCAS = createTrigger ["EmptyDetector", ADF_CAS_pos];
	tCAS setTriggerActivation [str ADF_CAS_side, "PRESENT", true];
	tCAS setTriggerArea [ADF_CAS_aoTriggerRad, ADF_CAS_aoTriggerRad, 0, false];
	tCAS setTriggerStatements ["(vehicle ADF_vCAS in thisList && ((getPosATL ADF_vCAS) select 2) > 25)", "", ""];

	waitUntil {sleep 1; ADF_CAS_active}; // wait till the 9-liners are finished and CAS-delay timer is 0. 

	// Create CAS aircraft
	private _c = createGroup ADF_CAS_side;
	_c setGroupIdGlobal [format ["%1", ADF_CAS_callSign]];
	private _v = [ADF_CAS_spawn, 90, _vc, _c] call BIS_fnc_spawnVehicle;
	ADF_vCAS = _v select 0; publicVariable "ADF_vCAS";

	// Add an EH to the CAS aircraft. If the aircraft is killed/shot down it will trigger a CAS KIA message and exit the script
	ADF_vCAS addEventHandler ["killed", "ADF_CAS_bingoFuel = true; publicVariable 'ADF_CAS_bingoFuel';ADF_CAS_kia = true;"];

	// Attach marker to CAS aircraft
	[ADF_vCAS] spawn {	
		private _m = createMarker ["mCasIcon", getPosASL ADF_vCAS];
		_m setMarkerSize [.8, .8];
		_m setMarkerShape "ICON";
		_m setMarkerType "b_air";
		_m setMarkerColor "Colorwest";
		_m setMarkerText format [" %1", ADF_CAS_callSign];
		while {alive ADF_vCAS} do {"mCasIcon" setMarkerPos (getPosASL ADF_vCAS); sleep .5};
		_m setMarkerColor "ColorGrey"; // CAS aircraft is no more...
	};

	// Create waypoints for CAS aircraft based on appraoch vectors
	private _wp = _c addWaypoint [ADF_CAS_vector, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointCombatMode "BLUE";
	_wp setWaypointCompletionRadius 250;

	private _wp = _c addWaypoint [ADF_CAS_pos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "RED";

	waitUntil {triggerActivated tCAS}; // Let CAS aircraft reach the AO

	ADF_vCAS flyInHeight 25;

	if (ADF_CAS_kia) exitWith {call ADF_fnc_CAS_destroyVars};
	sleep ADF_CAS_onSite; // Limited time in AO
	if (ADF_CAS_kia) exitWith {call ADF_fnc_CAS_destroyVars};

	// RTB Bingo Fuel
	deleteMarker "mCAS_SAD";
	{[_x] call ADF_fnc_objectHeliPilot} forEach units _c;
	ADF_CAS_bingoFuel = true; publicVariable "ADF_CAS_bingoFuel";
	ADF_vCAS setFuel 0.3;	

	private _wp = _c addWaypoint [ADF_CAS_vector, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointCombatMode "BLUE";
	_wp setWaypointCompletionRadius 350;

	private _wp = _c addWaypoint [ADF_CAS_spawn, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointCombatMode "BLUE";
	_wp setWaypointCompletionRadius 350;
	ADF_vCAS flyInHeight 100;
	waitUntil {if (ADF_CAS_kia) exitWith {call ADF_fnc_CAS_destroyVars};(currentWaypoint (_wp select 0)) > (_wp select 1)};

	// Delete Raptor and Raptor crew
	if !(isNull ADF_vCAS) then {[ADF_vCAS] call ADF_fnc_deleteCrewedVehicles;};
	deleteMarker "mCasIcon";

	call ADF_fnc_CAS_destroyVars;
};