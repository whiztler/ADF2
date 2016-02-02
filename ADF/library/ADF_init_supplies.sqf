/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.00 / MARCH 2016

Script: Mission init - Vehicle/Crate Supplies
Author: Whiztler
Script version: 1.10

File: ADF_init_supplies.sqf
**********************************************************************************
This loads preconfigured supplies onto crates and vehicles. the
script checks if the crate or vehicle exists before adding supplies.
Supply scripts can be tailored for each mission.
See the 'ADF\library\C\' folder for all supply scripts.

This script is (to be) executed on the server only.
*********************************************************************************/

#include "\ADF\ADF_macros.hpp"
ADF__ERPT("ADF_init_supplies.sqf");

// Crates
ADF__SUPP(crate_IFT_1, "ADF_cCargo_B_IFT.sqf");
ADF__SUPP(crate_IFT_2, "ADF_cCargo_B_IFT.sqf");
ADF__SUPP(crate_IWT_1, "ADF_cCargo_B_IWT.sqf");
ADF__SUPP(crate_CAV_1, "ADF_cCargo_B_CAV.sqf");
ADF__SUPP(crate_SOR_1, "ADF_cCargo_B_SpecOps.sqf");
ADF__SUPP(crate_SOD_1, "ADF_cCargo_B_WetGear.sqf");
ADF__SUPP(crate_SOP_1, "ADF_cCargo_B_RcnJTC.sqf");

// Vehicles
ADF__SUPP(MRAP_XO, "ADF_vCargo_B_Car.sqf");
ADF__SUPP(MEDITRUCK_XO, "ADF_vCargo_B_TruckMedi.sqf");
ADF__SUPP(MHQ, "ADF_vCargo_B_MHQ.sqf");
ADF__SUPP(SUPPLYTRUCK_AMMO, "ADF_vCargo_B_TruckAmmo.sqf");
ADF__SUPP(SUPPLYTRUCK_FUEL, "ADF_vCargo_B_TruckFuel.sqf");
ADF__SUPP(SUPPLYTRUCK_REPAIR, "ADF_vCargo_B_TruckRepair.sqf");
ADF__SUPP(MRAP_INF_PC, "ADF_vCargo_B_CarSQD.sqf");
ADF__SUPP(MRAP_1INF_1, "ADF_vCargo_B_CarIFT.sqf");
ADF__SUPP(MRAP_1INF_2, "ADF_vCargo_B_CarIFT.sqf");
ADF__SUPP(MRAP_1INF_3, "ADF_vCargo_B_CarIFT.sqf");
ADF__SUPP(MRAP_1INF_4, "ADF_vCargo_B_CarIFT.sqf");
ADF__SUPP(TRPTTRUCK_INF1, "ADF_vCargo_B_TruckTrpt.sqf");
ADF__SUPP(TRPTTRUCK_INF2, "ADF_vCargo_B_TruckTrpt.sqf");
ADF__SUPP(MRAP_1INF_WT1, "ADF_vCargo_B_CarIWT.sqf");
ADF__SUPP(MRAP_1INF_WT2, "ADF_vCargo_B_CarIWT.sqf");
ADF__SUPP(TRPTTRUCK_INF3, "ADF_vCargo_B_CarIWT.sqf");
ADF__SUPP(APC_2BAT, "ADF_vCargo_B_Mech.sqf");
ADF__SUPP(APC_2BAT_A, "ADF_vCargo_B_Mech.sqf");
ADF__SUPP(APC_2BAT_B, "ADF_vCargo_B_Mech.sqf");
ADF__SUPP(APC_2BAT_C, "ADF_vCargo_B_Mech.sqf");
ADF__SUPP(MBT_2BAT_A, "ADF_vCargo_B_Armor.sqf");
ADF__SUPP(MBT_2BAT_B, "ADF_vCargo_B_Armor.sqf");
ADF__SUPP(MLRS_2BAT, "ADF_vCargo_B_Armor.sqf");
ADF__SUPP(M4_2BAT, "ADF_vCargo_B_Armor.sqf");
ADF__SUPP(MH9_3WING_DC, "ADF_vCargo_B_AirHeli.sqf");
ADF__SUPP(AH99_3WING_1, "ADF_vCargo_B_AirHeli.sqf");
ADF__SUPP(AH9_3WING_1, "ADF_vCargo_B_AirHeli.sqf");
ADF__SUPP(UH80_3WING_A, "ADF_vCargo_B_AirHeli.sqf");
ADF__SUPP(UH80_3WING_B, "ADF_vCargo_B_AirHeli.sqf");
ADF__SUPP(CH67_3WING_C, "ADF_vCargo_B_AirHeli.sqf");
ADF__SUPP(MRAP_4SOR_SSC, "ADF_vCargo_B_CarRecon.sqf");
ADF__SUPP(MRAP_4SOR_M, "ADF_vCargo_B_CarRecon.sqf");
ADF__SUPP(MRAP_4SOR_R, "ADF_vCargo_B_CarRecon.sqf");
ADF__SUPP(MRAP_4SOR_Y, "ADF_vCargo_B_CarRecon.sqf");
ADF__SUPP(SOV_4SOD_1, "ADF_vCargo_B_CarRecon.sqf");