/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: CAS request with 9-liner
Author: Whiztler
Script version: 1.10

File: ADF_cas.sqf
**********************************************************************************
This script will create a CAS request radio trigger with 9-liner simulated
communication messages.

Instructions:
The script needs configuration. See the top part of the script for options. All
are required!

To prepare the map, you'll need to place two markers
1. marker where the aircraft will spawn. 
2. marker for the approach vector (North, east, South or west) of the AO.
You define the marker names below.

The CAS request can only be called by 1 player. WIP
********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_cas.sqf");

///// CONFIGURATION

// the name of the unit that can request the CAS. Use a commander or JTAC.
ADF_CAS_requester		= "INF_PC";
if (isNil ADF_CAS_requester) exitWith {}; // If the CAS authorized player is not ingame, exit the script

// the call sign of your squad/platoon/coy/unit
ADF_CAS_groupName		= "ALPHA 1-1";

// This is where the CAS aircraft will spawn. Place a marker on the edge of map far from the AO. Name the marker: "mAirSupport"
ADF_CAS_spawn			= getMarkerPos "mAirSupport"; 

 // Approach vector marker. The CAS aircraft will first fly to an appraoch vector before he flies to the CAS AO. Name the marker: "mAirSupportVector"
ADF_CAS_vector		= getMarkerPos "mAirSupportVector";

// Delay (in seconds) for the CAS to be created. This is simulate that the CAS aircraft needs to depart from a distant airbase + time to go through emergency start-up procedures.
ADF_CAS_delay			= round (180 + (random 60)); 

 // Time spend in the CAS area. After which the CAS aircraft returns to the spawn location and is deleted.
ADF_CAS_onSite		= round (120 + (random 120));

// Size of the CAS radius. Blue circular marker that shows the CAS AO. Default is 800 meters
ADF_CAS_aoTriggerRad	= 800; 

// Side of the CAS aircraft/crew
ADF_CAS_side			= west;

// ingame callsign of CAS aircraft. Used for hint messages to simulate CAS request radio transmissions.
ADF_CAS_callSign		= "HAWK"; 

// ingame name of the pilot of the CAS aircraft. Used for hint messages to simulate CAS request radio transmissions.
ADF_CAS_pilotName		= "Lt. Jim (Blackjack) Decker";

// ingame call sign  of the CAS station. Used for hint messages to simulate CAS request radio transmissions.
ADF_CAS_station		= "OSCAR";

// ingame call sign of OpFor. E.g. TANGO, CSAT, etc. Used for hint messages to simulate CAS request radio transmissions.
ADF_CAS_targetName	= "ELVIS"; 

// Ingame decription of target (keep it short). 
ADF_CAS_targetDesc	= "victors, small arms"; 

// CAS requirements (interdict, destroy, area security, laser target, etc. Used for hint messages to simulate CAS request radio transmissions.
ADF_CAS_result		= "interdict";

// directrion of the apprach vector (from AO). Depends on ADF_CAS_vector marker placement. Used for hint messages to simulate CAS request radio transmissions.
ADF_CAS_apprVector	= "west";

// Callsign of HQ / Command / Base. Used for hint messages to simulate CAS request radio transmissions.
ADF_HQ_callSign		= "FIRESTONE";

// Callsign image (filetype PAA) of CAS unit. Used for hint messages to simulate CAS request radio transmissions. The default image is of 6 Shooters 6CAV squadron.
ADF_CAS_image			= 'ADF\bin\images\logo_CAS.paa';

// Callsign image (filetype PAA) of HQ / Command / Base. Used for hint messages to simulate CAS request radio transmissions.
ADF_HQ_image			= "";

// Log message in logbook (true/false)? If true, what is the logbook name?
ADF_CAS_log			= false;
ADF_CAS_logName		= "";


/***** DO NOT EDIT BELOW ***************************************************************************************/


ADF_CAS_pos 			= []; 
ADF_CAS_active 		= false;
ADF_CAS_marker		= false;
ADF_CAS_bingoFuel 	= false;
ADF_CAS_requesterStr	= ADF_CAS_requester;
ADF_CAS_requester		= call compile format ["%1", ADF_CAS_requester];
ADF_CAS_kia			= false;
ADF_CAS_clanName		= toUpper ADF_clanName;

// Add the action to the unit that can request CAS
if !(isNil ADF_CAS_requesterStr) then {
	if (player != ADF_CAS_requester) exitWith {};
	private _t = format ["<t align='left' color='#92b680' shadow='false'>Request CAS: %1", ADF_CAS_callSign];
	ADF_CAS_requester addAction [_t,{[_this select 1, _this select 2] remoteExec ["ADF_fnc_CAS_SupportRq", 0, true]},[],-95, false, true,"", ""];
};

if (hasInterface) then {
	if (ADF_CAS_active) exitWith {};
	if (ADF_debug) then {sleep 5} else {sleep ((random 150) + (random 150))};
	if (ADF_CAS_active) exitWith {};
	private _n	= format ["%1 log", ADF_clanName];
	hintSilent parseText format ["<img size= '5' shadow='false' image='%4'/><br/><br/><t color='#6C7169' align='left'>%1: %5 this is %2. Standing by with %3. Out.</t><br/><br/>", ADF_CAS_pilotName, ADF_CAS_callSign, ADF_CAS_station, ADF_CAS_image, ADF_CAS_groupName];
	if (ADF_CAS_log) then {
		ADF__LOGBK
		player createDiaryRecord [_n, [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: "+ ADF_CAS_callSign +"</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>" +ADF_CAS_pilotName+ ": " +ADF_CAS_groupName+ " this is " +ADF_CAS_callSign+ ". Standing by with " +ADF_CAS_station+ ". Out.</font><br/><br/>"]];	
	};
};
