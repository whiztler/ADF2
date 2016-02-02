/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Headless Client init
Author: Whiztler
Script version: 3.00

File: ADF_HC.sqf
************************************************************************************
INSTRUCTIONS::

To configure one or more HC's on the server please visit and read:
https://community.bistudio.com/wiki/Arma_3_Headless_Client

If you are not using the ADF template mission than name the headless lcients:
ADF_HC1, ADF_HC2, ADF_HC3

################## IN CASE OF 1 HC (ADF_HC1) ##################

In your scripts that you use to spawn objects/units, replace
if (!isserver) exitWith {};
with 
if (!ADF_HC_execute) exitWith {}; // Autodetect: execute on the HC else execute on the server

You can disable the load balancer in the ADF_mission_settings.sqf

################## IN CASE OF MULTIPLE HC'S ##################

The ADF headless clients supports automatic load balancing (when enabled in the
mission config). When using 2 or 3 HC's the script will distribute  newly spawned AI
groups across the available HC's every 60 seconds.

The loadbalancer is effective when at least 2 HC's are active. Note that it is
best to spawn the AI's on the server when multiple HC's are active. The
Loadbalancer kicks in after 2 minutes after mission start and will start
distributing the AI's across the HC's

You can enable/disable the load balancer in the ADF_mission_settings.sqf

With the load balancer enabled you can blacklist groups from being transferred to the HC('s).
To do this add the following to the leader of the group:
_grp = group this;
_grp setVariable ["ADF_noHC_trfr", true];

Note that waypoint information is retained when groups are transferred to a HC. 
Other information such as garrison orders, skill information, etc is not.
You need to store the information with setVariable and re-apply the instructions
after transfer to the hC. You may use the 'local' eventhandler for this.

The ADF_fnc_defendArea function (garrison) automatically reapplies garrison
directives after HC transfer.
********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_HC.sqf");

// Init
params ["_lb"];

// HC check
if (!isServer && !hasInterface) then {	
	// init
	ADF_HC_connected 	= true; publicVariable "ADF_HC_connected";
	ADF_HC_execute 	= true;
	ADF_isHC 		= true;
	
	// Check which HC slot is occupied and count HC's
	if !(isNil "ADF_HC1") then {if (player == ADF_HC1) then {ADF_cntHC = ADF_cntHC + 1; publicVariable "ADF_cntHC"; ADF_isHC1 = true; diag_log "ADF RPT: HC - Headless Client detected: ADF_HC1";}};
	if !(isNil "ADF_HC2") then {if (player == ADF_HC2) then {ADF_cntHC = ADF_cntHC + 1; publicVariable "ADF_cntHC"; ADF_isHC2 = true; diag_log "ADF RPT: HC - Headless Client detected: ADF_HC2";}};
	if !(isNil "ADF_HC3") then {if (player == ADF_HC3) then {ADF_cntHC = ADF_cntHC + 1; publicVariable "ADF_cntHC"; ADF_isHC3 = true; diag_log "ADF RPT: HC - Headless Client detected: ADF_HC3";}};	
	
	// HC FPS reporting in RPT. The frequency of the reporting is based on HC performance.
	[60, "Headless Client", "HC"] spawn ADF_fnc_statsReporting;
} else {	
	sleep 3; // Wait for HC to publicVar ADF_HC_connected (if a HC is present)
	if (!ADF_HC_connected && isServer) then { // No HC present. Disable ADF_HC_execute on all clients except the server
		ADF_HC_execute = true;
		if (ADF_debug) then {["HC - NO Headless Client detected, using server", false] call ADF_fnc_log} else {diag_log "ADF RPT: HC - NO Headless Client detected, using server"};
	} else { 
		if (isServer || isDedicated) then {ADF_HC_execute = false; ADF_HC_connected = true;}; // HC is connected. Disable ADF_HC_execute on the server so that the HC runs scripts
		diag_log "ADF RPT: HC - Headless Client detected. Using HC for ADF_HC_execute"
	};
};

// Run the HC load balancer
if (!_lb) exitWith {};
if (!isServer) exitWith {};

[] spawn {
	diag_log "ADF RPT: Init - executing ADF_HC_loadBalancing.sqf"; // Reporting. Do NOT edit/remove

	if (!ADF_HC_connected) exitWith {ADF__RPTLOG("ADF RPT: HC - loadBalancing - NO HC detected. Terminating ADF_fnc_HC_loadbalancing.sqf")};

	waitUntil {time > 60};

	private _hc1_ID	= -1; // Will become the Client ID of HC
	private _hc2_ID	= -1; // Will become the Client ID of HC2
	private _hc3_ID	= -1; // Will become the Client ID of HC3
	private _cg		= 0; // init group count
	private _s		= 60; // Pass through sleep	

	ADF__DBGLOG("HC - loadBalancing pass through starting in %1 seconds", _s);

	while {ADF_HC_connected} do {
		// Init.
		sleep _s;
		ADF__diagInit;
		private _lb		= false;
		private _rr		= false;
		private _ht		= true;
		private _hc		= 0;
		private _id		= 0;
		private _ng 		= count allGroups;
		private _t		= 0;	
		
		///// Let's see which ADF_HC slot is populated with a HC client. If the slot is not populated the HC variable (e.g. ADF_HC2) will be ObjNull
		
		// Get ADF_HC1 Client ID else set variables to null // v1.40B01 
		if (!isNil "ADF_HC1") then {
			_hc1_ID = owner ADF_HC1;
			if (_hc1_ID > 2) then {ADF__DBGVAR1("ADF Debug: HC - HC1 with clientID %1 detected", _hc1_ID)};
		} else {	 // NO ADF_HC1 connected
			ADF_HC1 = objNull; _hc1_ID = -1;
			ADF__DBGVAR("ADF Debug: HC - ADF_HC1 is NOT connected");
		};
		
		// Get ADF_HC2 Client ID else set variables to null // v1.40B01 
		if (!isNil "ADF_HC2") then {
			_hc2_ID = owner ADF_HC2;
			if (_hc2_ID > 2) then {ADF__DBGVAR1("ADF Debug: HC - HC2 with clientID %1 detected", _hc2_ID)};
		} else {	 // NO ADF_HC2 connected
			ADF_HC2 = objNull; _hc2_ID = -1;
			ADF__DBGVAR("ADF Debug: HC - ADF_HC2 is NOT connected");
		};

		// Get ADF_HC3 Client ID else set variables to null // v1.40B01
		if (!isNil "ADF_HC3") then {
			_hc3_ID = owner ADF_HC3;
			if (_hc3_ID > 2) then {ADF__DBGVAR1("ADF Debug: HC - HC3 with clientID %1 detected", _hc3_ID)};
		} else {	 // NO ADF_HC3 connected
			ADF_HC3 = objNull; _hc3_ID = -1;
			ADF__DBGVAR("ADF Debug: HC - ADF_HC3 is NOT connected");
		};
		
		///// Let's check if 1 or more HC's is/are still populated with a client and check for 2 or more HC's

		if ((isNull ADF_HC1) && (isNull ADF_HC2) && (isNull ADF_HC3)) then {waitUntil {sleep 1; !isNull ADF_HC1 || !isNull ADF_HC2 || !isNull ADF_HC3}};		
		if (	(!isNull ADF_HC1 && !isNull ADF_HC2) || (!isNull ADF_HC1 && !isNull ADF_HC3) || (!isNull ADF_HC2 && !isNull ADF_HC3)) then {_lb = true}; 
		if (_lb) then {ADF__RPTLOG("ADF RPT: HC - starting loadBalancing to multiple HC's")};
		
		// Determine first HC to start with
		if (!isNull ADF_HC1) then {_hc = 1} else {if (!isNull ADF_HC2) then {_hc = 2} else {_hc = 3}};

		///// Transfer AI groups

		if (_ng > _cg) then {
			{
				// Set transfer to false if the group is a player group
				{if (isPlayer _x) then {_ht = false}} forEach units _x; 
				// Set transfer to false if the group is blacklisted
				if (_x getVariable ["ADF_noHC_transfer", false]) then {_ht = false};				
				// Store group directives
				if (_x getVariable ["ADF_HC_garrison_ADF", false]) then {
					ADF_HCLB_storedArr = _x getVariable ["ADF_HC_garrisonArr", []];					
					ADF__DBGVAR2("ADF Debug: HC LB ADF - ADF_HC_garrisonArr for group: %1 -- array: %2", _x, ADF_HCLB_storedArr);
				};

				// If load balance enabled, round robin between the multiple HC's - else pass all to a single HC
				if (_ht) then {					
					if (_lb) then {
						switch (_hc) do {
							case 1: {_rr = _x setGroupOwner _hc1_ID; _id = _hc1_ID; if (!isNull ADF_HC2) then {_hc = 2} else {_hc = 3}};
							case 2: {_rr = _x setGroupOwner _hc2_ID; _id = _hc2_ID; if (!isNull ADF_HC3) then {_hc = 3} else {_hc = 1}};
							case 3: {_rr = _x setGroupOwner _hc3_ID; _id = _hc3_ID; if (!isNull ADF_HC1) then {_hc = 1} else {_hc = 2}};
							default {ADF__DBGVAR1("ADF Debug: HC LB - No Valid HC to pass to. ** _hc = %1 **", _hc)};
							
						};
					} else {
						switch (_hc) do {
							case 1: {_rr = _x setGroupOwner _hc1_ID; _id = _hc1_ID};
							case 2: {_rr = _x setGroupOwner _hc2_ID; _id = _hc2_ID};
							case 3: {_rr = _x setGroupOwner _hc3_ID; _id = _hc3_ID};
							default {ADF__DBGVAR1("ADF Debug: HC LB - No Valid HC to pass to. ** _hc = %1 **", _hc)};
						};
					};
					
					// reApply group directives
					if (_x getVariable ["ADF_HC_garrison_ADF", false]) then {
						ADF__DBGVAR2("ADF Debug: HC LB - ADF_fnc_defendArea_HC remoteExec for group: %1 to HC with ID %2", _x, _id);
						[_x, ADF_HCLB_storedArr] remoteExec ["ADF_fnc_defendArea_HC", _id, false];
						_x setVariable ["ADF_noHC_transfer", true];
						ADF_HCLB_storedArr = nil;
					};
		
					// Add to the group to the 'transferred counter'
					if (_rr) then {_t = _t + 1};
				};
			} forEach allGroups;
			
			// Set the group count so that only new groups are processed on next run
			_cg = _ng;			
		};
	 
		///// Reporting
		
		if (ADF_Debug) then {
			if (_t > 0) then {
				private _c1 = 0; private _c2 = 0; private _c3 = 0;
				
				private _m = format ["ADF DEBUG: HC - Transferred %1 AI groups to HC(s)", _t];
				[_m, false] call ADF_fnc_log;				

				{
					switch (owner ((units _x) select 0)) do {
						case _hc1_ID: {_c1 = _c1 + 1};
						case _hc2_ID: {_c2 = _c2 + 1};
						case _hc3_ID: {_c3 = _c3 + 1};
					};
				} forEach (allGroups);
			   
			   private _m1 = format ["ADF DEBUG: HC - %1 AI groups currently on HC1", _c1];
			   private _m2 = format ["ADF DEBUG: HC - %1 AI groups currently on HC2", _c2];
			   private _m3 = format ["ADF DEBUG: HC - %1 AI groups currently on HC3", _c3];

				if (_c1 > 0) then {[_m1, false] call ADF_fnc_log};
				if (_c2 > 0) then {[_m2, false] call ADF_fnc_log};
				if (_c3 > 0) then {[_m3, false] call ADF_fnc_log};

				_m4 = format ["ADF DEBUG: HC - Transferred: Total %1 AI groups across all HC('s)", (_c1 + _c2 + _c3)];
				[_m4, false] call ADF_fnc_log;
			} else {
				ADF__RPTLOG("ADF RPT: HC LB - No AI groups to transfer at the moment");
			};
		} else {
			if (_t > 0) then {
				private _c1 = 0; private _c2 = 0; private _c3 = 0;
				ADF__RPTVAR1("ADF RPT: HC LB - Transferred %1 AI groups to HC(s)",_t);

				{
					switch (owner ((units _x) select 0)) do {
						case _hc1_ID: {_c1 = _c1 + 1};
						case _hc2_ID: {_c2 = _c2 + 1};
						case _hc3_ID: {_c3 = _c3 + 1};
					};
				} forEach (allGroups); 

				if (_c1 > 0) then {ADF__RPTVAR1("ADF RPT: HC LB - %1 AI groups currently on HC1",_c1)};
				if (_c2 > 0) then {ADF__RPTVAR1("ADF RPT: HC LB - %1 AI groups currently on HC2",_c2)};
				if (_c3 > 0) then {ADF__RPTVAR1("ADF RPT: HC LB - %1 AI groups currently on HC3",_c3)};				
				ADF__RPTVAR1("ADF RPT: HC LB - Transferred: Total %1 AI groups across all HC('s)",(_c1 + _c2 + _c3));

			} else {
				ADF__RPTLOG("ADF RPT: HC - No AI groups to transfer at the moment");
			};
		};

		ADF__diagTime("ADF_HC_loadBalancing");
	}; // while
	
	ADF__LOGERR("HC - <ERROR> Headless Client(s) disconnected");
};