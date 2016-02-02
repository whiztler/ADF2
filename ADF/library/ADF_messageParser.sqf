/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Message Parser (radio sim)
Author: Whiztler
Script version: 1.12

File: ADF_messageParser.sqf
********************************************************************************
This script will create and log hint messages using ppredefined templates. It
simulations radio communications between the player squad/company and a third
party (HQ, CAS, etc.). See Wolfpack / Two Sierra mission for live example.

Configure the script below.
Note that ALL LOGOS must be placed in the 'mission\4-assets\images' folder!!

Usage (client side only)

[	
	"A1",		// sender ID
	"Cmd"		// Receiver ID
	"Message"		// Message (ouse <br> for new line.)
] call ADF_fnc_MessageParser;

e.g.: ["A1", "Cmd", "We are at OP BRAVO. Awaiting orders. Over."] call ADF_fnc_MessageParser; sleep 10;
Output on Screen: "MOTHER this is ALPHA-1. We are at OP BRAVO. Awaiting orders. Over."

or: : ["Cmd", "A1", "Stand by for trafiic. Over."] call ADF_fnc_MessageParser; sleep 10;
Output on Screen: "ALPHA-1 this is MOTHER. Stand by for trafiic. Over."
********************************************************************************/

// Color of the text in the hint message (HTML code - white is: #FFFFFF)
ADF_messageParserColor	= "#6C7169";

// Do you want the messages (hints) to be logged in a logbook?
ADF_messageParserLog		= true;

// If you want the messages to be logged, the what is the name of the logbook? 
// The logbook will be created by the script.
ADF_messageParserLogName	= "Comm Log";

// Below configure the message parties.
ADF_messageParserConfig 	= [

// Make sure your unit/squad is the FIRST entry

/******** 1.  Your Squad/Unit ********/
	"A1",					// ID to identify in your scripts
	"ALPHA-1",				// Full callsign/name of your unit
	"logo_TwoSierra.paa",	// If you want the use a logo, enter the logo filename here. Use "" for no logo. 

/******** 2.  HQ/Command ********/
	"Cmd",					// ID to identify in your scripts
	"MOTHER",				// Full callsign/name of your unit
	"logo_ACO.paa",			// If you want the use a logo, enter the logo filename here.  Use "" for no logo. 

/******** 3.  Other Callsign ********/
	"ID",					// ID to identify in your scripts
	"CALLSIGN",				// Full callsign/name of your unit
	"CallsignLogo.paa",		// If you want the use a logo, enter the logo filename here. Use "" for no logo.

/******** 4.  Other Callsign ********/
	"ID",					// ID to identify in your scripts
	"CALLSIGN",				// Full callsign/name of your unit
	"CallsignLogo.paa",		// If you want the use a logo, enter the logo filename here. Use "" for no logo.

/******** 5.  Other Callsign ********/
	"ID",					// ID to identify in your scripts
	"CALLSIGN",				// Full callsign/name of your unit
	"CallsignLogo.paa",		// If you want the use a logo, enter the logo filename here. Use "" for no logo.

/******** 6.  Other Callsign ********/
	"ID",					// ID to identify in your scripts
	"CALLSIGN",				// Full callsign/name of your unit
	"CallsignLogo.paa",		// If you want the use a logo, enter the logo filename here. Use "" for no logo.
	
/******** 7.  Other Callsign ********/
	"ID",					// ID to identify in your scripts
	"CALLSIGN",				// Full callsign/name of your unit
	"CallsignLogo.paa",		// If you want the use a logo, enter the logo filename here. Use "" for no logo..

/******** 8.  Other Callsign ********/
	"ID",					// ID to identify in your scripts
	"CALLSIGN",				// Full callsign/name of your unit
	"CallsignLogo.paa"		// If you want the use a logo, enter the logo filename here. Use "" for no logo.
];

/***** DO NOT EDIT BELOW ***************************************************************************************/

if (!ADF_messageParserLog) exitWith {};
player createDiarySubject [ADF_messageParserLogName, ADF_messageParserLogName];
private _o = ADF_messageParserConfig select 1;
private _m = format ["<br/><br/><font color='#6c7169'>The %1 is a logbook of all operational radio comms between %2 and other involved parties<br/>The messages are logged once displayed on screen. All messages are time-stamped and saved in order of appearance.</font><br/><br/>", ADF_messageParserLogName, _o];
player createDiaryRecord [ADF_messageParserLogName, [ADF_messageParserLogName, _m]];