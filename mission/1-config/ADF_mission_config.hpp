/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: mission config entries
Author: Whiztler
Script version: 1.50

File: ADF_mission_config.hpp
********************************************************************************
Config entry registration goes in here. Make sure to configure the following:
- CfgDebriefing
- CfgUnitInsignia
************************************************************************************************/


//###########################################################################
// CfgDebriefing: mission de-briefing (show when the mission ends)
//###########################################################################

class CfgDebriefing {
	
	// End1: Show on mission success
	class End1 {
		title			= "Mission Completed";
		subtitle			= "Mission Name";
		description		= "Success message goes here";
		pictureBackground	= ""; // eg. "mission\4-assets\images\yourpicture.jpg" no picture? use "";
		picture			= "b_HQ";
		pictureColor[]	= {0.0, 0.3, 0.6, 1}; // Overlay color
	};
	
	// End1: Show on mission failed
	class End2 {
		title			= "Mission Failed";
		subtitle			= "Mission Name";
		description		= "Failure message goes here";
		pictureBackground	= ""; // eg. "mission\4-assets\images\yourpicture.jpg" no picture? use "";
		pictureColor[]	= {0.0, 0.3, 0.6, 1}; // Overlay color
	};
	
	// Killed: Show when all players are dead (no respawn)
	class Killed {
		title			= "All players K.I.A.";
		subtitle			= "Mission Name";
		description		= "Failure message goes here";
		pictureBackground	= ""; // eg. "mission\4-assets\images\yourpicture.jpg" no picture? use "";
		pictureColor[]	= {0.0, 0.3, 0.6, 1}; // Overlay color
	};
};


//###########################################################################
// CfgUnitInsignia: Patch/insignia that is show in the uniform.
//###########################################################################

class CfgUnitInsignia {
	
	// CLAN insignia	
	class CLANPATCH {
		displayName		= "ADF Insignia"; // Name displayed in Arsenal
		author			= "ADF / Whiztler";
		texture			= "mission\4-assets\images\clan_patch_Nopryl.paa";
		textureVehicles	= ""; // Does nothing currently, reserved for future use
	};
};


//###########################################################################
// CfgFunctions: ADF and Third party functions
//###########################################################################

class CfgFunctions {

	//Tonic's View Distance script config
	class TAWVD 	{
		tag = "TAWVD";
		class TAW_VD {
			file = "ADF\library\e\taw_vd";
			class onSliderChange {};
			class onTerrainChange {};
			class updateViewDistance {};
			class openTAWVD {};
			class trackViewDistance {};
			class tawvdInit {postInit = 1;};
		};
	};

	// F3 Framework (http://ferstaberinde.com/f3/en/) spectator mode
	class F 	{ 
		class fspectator {
			file = "ADF\library\e\spect";
			class CamInit{};
			class OnUnload{};
			class DrawTags{};
			class EventHandler{};
			class FreeCam{};
			class GetPlayers{};
			class ReloadModes{};
			class UpdateValues{};
			class HandleCamera{};
			class ToggleGUI{};
			class OnMapClick{};
			class DrawMarkers{};
			class ForceExit{};
			class HandleMenu{};
			class showMenu{};
		};
	};
};


class CfgRespawnTemplates { 
	
	// F3 Spectator Script	
	class f_Spectator {
		onPlayerRespawn = "f_fnc_CamInit";
	};
	
	//Overwrite Vanilla Seagull
    class Seagull { 
        onPlayerRespawn = "";
    };
};


class cfgNotifications { 
	// Preconfigured messages
	
	class ADF_noticeMsg {
		title		= "NOTICE";
		description	= "%1";
		iconPicture	= "\A3\ui_f\data\map\markers\military\warning_ca.paa";
		iconText 	= "";
		color[] 		= {1, 1, 0, 1};		
		duration 	= 4;
		priority		= 7;
	};
};


class CfgSounds {

	sounds[] = {};
	
	// Transmit sound used by ADF function
	class radioTransmit {
		name = "Radio_Transmit_Sound";
		sound[] = {"ADF\bin\sound\in2c.ogg", 1, 1}; // filename, volume, pitch
		titles[] = {};
	};
};

