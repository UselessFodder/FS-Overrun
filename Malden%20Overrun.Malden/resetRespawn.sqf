/*
	Deletes previous DECON Truck and creates new one at base
*/

//Check if DECON Truck is alive to prevent using
// 	this to speed up a regular respawn
if(isNull mobileRespawn == false) then {
	if (isServer) then {
		//delete previous deconTruck
		deleteVehicle mobileRespawn;
		
		//Wait 15 seconds for any outstanding effects to completedFSM
		sleep 15;
		
		
		//create new mobileRespawn
		mobileRespawn = "c_Truck_02_covered_F" createVehicle getMarkerPos "mobileRespawnPoint"; 
		mobileRespawn setDir 130;

		//add new eventHandler to new vic
		mobileRespawn addEventHandler ["Killed",{execVM "mobileRespawnDestroyed.sqf"}];
	};
	
	/*
	
	//item list for arsenal
	ArsenalItems = [
		// Vanilla Standard Items
		"Binocular",                                                    // Binoculars
		"DroneDetector",                                                // Drone Detector
		"FirstAidKit",                                                  // First Aid Kit
		"ItemCompass",                                                  // Compass
		"ItemGPS",                                                      // GPS
		"ItemMap",                                                      // Map
		"ItemRadio",                                                    // Radio
		"ItemWatch",                                                    // Watch
		"Medikit",                                                      // Medikit
		"MineDetector",                                                 // Mine Detector
		"ToolKit",                                                      // Toolkit

		// Uniforms
		"U_B_CombatUniform_mcam_wdl_f",                                 // Combat Fatigues (Woodland)
		"U_B_CombatUniform_tshirt_mcam_wdL_f",                          // Combat Fatigues (Woodland, Tee)
		"U_B_CombatUniform_vest_mcam_wdl_f",                            // Recon Fatigues (Woodland)
		"U_B_HeliPilotCoveralls",                                       // Heli Pilot Coveralls [NATO]
		"U_B_FullGhillie_lsh",                                          // Full Ghillie (Lush) [NATO]
		
		// Facegear
		"G_Aviator",                                                    // Aviator Glasses
		"G_B_Diving",                                                   // Diving Goggles [NATO]
		"G_Lowprofile",                                                 // Low Profile Goggles
		"G_Shades_Black",                                               // Shades (Black)
		"G_Shades_Blue",                                                // Shades (Blue)
		"G_Shades_Green",                                               // Shades (Green)
		"G_Shades_Red",                                                 // Shades (Red)
		"G_Spectacles",                                                 // Spectacle Glasses
		"G_Spectacles_Tinted",                                          // Tinted Spectacles
		"G_AirPurifyingRespirator_01_F",                                // APR [NATO]
		"G_Squares_Tinted",                                             // Square Shades
		"G_Squares",                                                    // Square Spectacles
		"G_Tactical_Clear",                                             // Tactical Glasses
		"G_Tactical_Black",                                             // Tactical Shades

		// Vests
		"V_PlateCarrierGL_rgr",                                         // Carrier GL Rig (Green)
		"V_PlateCarrierGL_mtp",                                         // Carrier GL Rig (MTP)
		"V_PlateCarrier1_rgr",                                          // Carrier Lite (Green)
		"V_PlateCarrier2_rgr",                                          // Carrier Rig (Green)
		"V_PlateCarrierSpec_rgr",                                       // Carrier Special Rig (Green)
		"V_PlateCarrierSpec_mtp",                                       // Carrier Special Rig (MTP)
		"V_Chestrig_rgr",                                               // Chest Rig (Green)
		"V_RebreatherB",                                                // Rebreather [NATO]
		"V_BandollierB_rgr",                                            // Slash Bandolier (Green)
		"V_TacVest_blk",                                                // Tactical Vest (Black)
		"V_Safety_orange_F",                                            // Safety Vest (Orange)
		"V_Safety_yellow_F",                                            // Safety Vest (Yellow)
		"V_DeckCrew_yellow_F",                                          // Deck Crew Vest (Yellow)

		// Headgear
		"H_Watchcap_camo",                                              // Beanie (Green)
		"H_Beret_02",                                                   // Beret [NATO]
		"H_Beret_Colonel",                                              // Beret [NATO] (Colonel)
		"H_HelmetCrew_B",                                               // Crew Helmet [NATO]
		"H_CrewHelmetHeli_B",                                           // Heli Crew Helmet [NATO]
		"H_PilotHelmetHeli_B",                                          // Heli Pilot Helmet [NATO]
		"H_Booniehat_wdl",                                              // Booniehat (Woodland)
		"H_HelmetB_plain_wdl",                                          // Combat Helmet (Woodland)
		"H_HelmetSpecB_wdl",                                            // Enhanced Combat Helmet (Woodland)
		"H_HelmetB_light_wdl",                                          // Light Combat Helmet (Woodland)
		"H_MilCap_wdl",                                                 // Military Cap (Woodland)

		// Items
		"acc_pointer_IR",                                               // IR Laser Pointer
		"acc_flashlight",                                               // Flashlight
		"acc_flashlight_smg_01",                                        // Flashlight
		"acc_flashlight_pistol",                                        // Pistol Flashlight
		"optic_mrd",                                                    // MRD
		"optic_yorris",                                                 // Yorris J2
		"optic_DMS",                                                    // DMS
		"optic_Aco",                                                    // ACO (Red)
		"optic_holosight_blk_f",                                        // Mk17 Holosight (Black)
		"optic_holosight_smg_blk_f",                                    // Mk17 Holosight SMG (Black)
		"optic_Hamr",                                                   // RCO
		"optic_SOS",                                                    // MOS
		"optic_lrps",                                                   // LRPS
		"optic_AMS",                                                    // AMS (Black)
		"bipod_01_f_blk",                                               // Bipod (Black) [NATO]
		
		// ACE Items
		"ACE_acc_pointer_green",                                        // Laser Pointer (green)
		"ACE_adenosine",                                                // Adenosine autoinjector
		"ACE_Altimeter",                                                // Altimeter Watch
		"ACE_artilleryTable",                                           // Artillery Rangetable
		"ACE_ATragMX",                                                  // ATragMX
		"ACE_Banana",                                                   // Banana
		"ACE_bloodIV_250",                                              // Blood IV (250 ml)
		"ACE_bloodIV_500",                                              // Blood IV (500 ml)
		"ACE_bloodIV",                                                  // Blood IV (1000 ml)
		"ACE_bodyBag",                                                  // Bodybag
		"ACE_CableTie",                                                 // Cable Tie
		"ACE_Cellphone",                                                // Cellphone
		"ACE_Chemlight_Shield",                                         // Chemlight Shield (Empty)
		"ACE_Clacker",                                                  // M57 Firing Device
		"ACE_DAGR",                                                     // DAGR
		"ACE_DeadManSwitch",                                            // Dead Man's Switch
		"ACE_DefusalKit",                                               // Defusal Kit
		"ace_dragon_sight",                                             // SU-36/P Daysight
		"ACE_EarPlugs",                                                 // Earplugs
		"ACE_elasticBandage",                                           // Bandage (Elastic)
		"ACE_EntrenchingTool",                                          // Entrenching Tool
		"ACE_epinephrine",                                              // Epinephrine autoinjector
		"ACE_fieldDressing",                                            // Bandage (Basic)
		"ACE_Flashlight_KSF1",                                          // KSF-1
		"ACE_Flashlight_Maglite_ML300L",                                // Maglite ML300L
		"ACE_Flashlight_MX991",                                         // Fulton MX-991
		"ACE_Flashlight_XL50",                                          // Maglite XL50
		"ACE_HuntIR_monitor",                                           // HuntIR monitor
		"ACE_IR_Strobe_Item",                                           // IR Strobe
		"ACE_Kestrel4500",                                              // Kestrel 4500NV
		"ACE_M26_Clacker",                                              // M152 Firing Device
		"ACE_MapTools",                                                 // Map Tools
		"ACE_microDAGR",                                                // MicroDAGR GPS
		"ACE_morphine",                                                 // Morphine autoinjector
		"ACE_packingBandage",                                           // Bandage (Packing)
		"ACE_personalAidKit",                                           // Personal Aid Kit
		"ACE_plasmaIV_250",                                             // Plasma IV (250 ml)
		"ACE_plasmaIV_500",                                             // Plasma IV (500 ml)
		"ACE_plasmaIV",                                                 // Plasma IV (1000 ml)
		"ACE_quikclot",                                                 // Bandage (QuickClot)
		"ACE_RangeCard",                                                // Range Card
		"ACE_RangeTable_82mm",                                          // 82 mm Rangetable
		"ACE_rope12",                                                   // Rope 12.2 meters
		"ACE_rope15",                                                   // Rope 15.2 meters
		"ACE_rope18",                                                   // Rope 18.3 meters
		"ACE_rope27",                                                   // Rope 27.4 meters
		"ACE_rope36",                                                   // Rope 36.6 meters
		"ACE_salineIV_250",                                             // Saline IV (250 ml)
		"ACE_salineIV_500",                                             // Saline IV (500 ml)
		"ACE_salineIV",                                                 // Saline IV (1000 ml)
		"ACE_Sandbag_empty",                                            // Sandbag (empty)
		"ACE_splint",                                                   // Splint
		"ACE_SpraypaintBlack",                                          // Spray Paint (Black)
		"ACE_SpraypaintBlue",                                           // Spray Paint (Blue)
		"ACE_SpraypaintGreen",                                          // Spray Paint (Green)
		"ACE_SpraypaintRed",                                            // Spray Paint (Red)
		"ACE_surgicalKit",                                              // Surgical Kit
		"ACE_tourniquet",                                               // Tourniquet (CAT)
		"ACE_Tripod",                                                   // SSWT Kit
		"ACE_UAVBattery",                                               // UAV Battery
		"ACE_VectorDay",                                                // Vector 21
		"ACE_VMH3",                                                     // VMH3
		"ACE_VMM3",                                                     // VMM3
		"ACE_wirecutter",                                               // Wirecutter
		"ACE_Yardage450",                                               // Yardage 450	
		
		//TFAR Items
		"tf_anprc148jem",                                               // AN/PRC-148 JEM
		"tf_anprc152",                                                  // AN/PRC-152
		"tf_anprc154_1",                                                // AN/PRC-154
		"tf_fadak",                                                     // FADAK
		"tf_microdagr",                                                 // MicroDAGR Radio Programmer
		"tf_pnr1000a_1",                                                // PNR-1000A
		"tf_rf7800str",                                                  // PF-7800S-TR	
		
		//CUP Optics
		"CUP_optic_PSO_1",
		"CUP_optic_PSO_1_AK",
		"CUP_optic_PSO_3",
		"CUP_optic_Kobra",
		"CUP_optic_PechenegScope",
		"CUP_optic_ekp_8_02_01",
		"CUP_optic_PSO_1_1",
		"CUP_optic_HoloBlack",
		"CUP_optic_HoloWdl",
		"CUP_optic_HoloDesert",
		"CUP_optic_Eotech533",
		"CUP_optic_Eotech533Grey",
		"CUP_optic_Eotech553_Black",
		"CUP_optic_Eotech553_Coyote",
		"CUP_optic_Eotech553_OD",
		"CUP_optic_CompM2_Black",
		"CUP_optic_CompM2_Woodland",
		"CUP_optic_CompM2_Desert",
		"CUP_optic_CompM2_OD",
		"CUP_optic_CompM2_Coyote",
		"CUP_optic_CompM2_low",
		"CUP_optic_CompM2_low_OD",
		"CUP_optic_CompM2_low_coyote",
		"CUP_optic_CompM4",
		"CUP_optic_MicroT1",
		"CUP_optic_MicroT1_low",
		"CUP_optic_MARS",
		"CUP_optic_SUSAT",
		"CUP_optic_ACOG",
		"CUP_optic_ACOG_Reflex_Desert",
		"CUP_optic_ACOG_Reflex_Wood",
		"CUP_optic_ACOG2",
		"CUP_optic_RCO",
		"CUP_optic_RCO_desert",
		"CUP_optic_ACOG_TA01NSN_Tan",
		"CUP_optic_ACOG_TA01NSN_OD",
		"CUP_optic_ACOG_TA01NSN_RMR_Black",
		"CUP_optic_ACOG_TA01NSN_RMR_Coyote",
		"CUP_optic_ACOG_TA01NSN_RMR_Tan",
		"CUP_optic_ACOG_TA01NSN_RMR_OD",
		"CUP_optic_LeupoldMk4",
		"CUP_optic_LeupoldMk4_pip",
		"CUP_optic_Leupold_VX3",
		"CUP_optic_LeupoldM3LR",
		"CUP_optic_LeupoldMk4_10x40_LRT_Desert",
		"CUP_optic_LeupoldMk4_10x40_LRT_Woodland",
		"CUP_optic_LeupoldMk4_CQ_T",
		"CUP_optic_LeupoldMk4_MRT_tan",
		"CUP_optic_SB_11_4x20_PM",
		"CUP_optic_SB_11_4x20_PM_tan",
		"CUP_optic_SB_3_12x50_PMII",
		"CUP_optic_ZDDot",
		"CUP_optic_MRad",
		"CUP_optic_TrijiconRx01_desert",
		"CUP_optic_TrijiconRx01_black",
		"CUP_optic_ElcanM145",
		"CUP_optic_ELCAN_SpecterDR",
		"CUP_optic_Elcan",
		"CUP_optic_Elcan_OD",
		"CUP_optic_Elcan_Coyote",
		"CUP_optic_Elcan_reflex",
		"CUP_optic_Elcan_reflex_OD",
		"CUP_optic_Elcan_reflex_Coyote",
		"CUP_optic_Elcan_3D",
		"CUP_optic_Elcan_OD_3D",
		"CUP_optic_Elcan_Coyote_3D",
		"CUP_optic_Elcan_reflex_3D",
		"CUP_optic_Elcan_reflex_OD_3D",
		"CUP_optic_Elcan_reflex_Coyote_3D",
		"CUP_optic_ZeissZPoint",
					
		//CUP Attachment
		"CUP_acc_Glock17_Flashlight",
		"CUP_acc_ANPEQ_15",
		"CUP_acc_ANPEQ_15_Black",
		"CUP_acc_ANPEQ_15_OD",
		"CUP_acc_ANPEQ_15_Tan_Top",
		"CUP_acc_ANPEQ_15_Black_Top",
		"CUP_acc_ANPEQ_15_OD_Top",
		"CUP_acc_ANPEQ_2",
		"CUP_acc_ANPEQ_2_camo",
		"CUP_acc_ANPEQ_2_desert",
		"CUP_acc_ANPEQ_2_grey",
		"CUP_acc_ANPEQ_2_Black_Top",
		"CUP_acc_ANPEQ_2_OD_Top",
		"CUP_acc_ANPEQ_2_Coyote_Top",
		"CUP_acc_Flashlight",
		"CUP_acc_Flashlight_wdl",
		"CUP_acc_Flashlight_desert",
		"CUP_acc_MLPLS_Laser",
		"CUP_acc_LLM",
		"CUP_acc_LLM_Flashlight",
		"CUP_acc_ANPEQ_2_Flashlight_Black_L",
		"CUP_acc_ANPEQ_2_Flashlight_Black_F",
		"CUP_acc_ANPEQ_2_Flashlight_Coyote_L",
		"CUP_acc_ANPEQ_2_Flashlight_Coyote_F",
		"CUP_acc_ANPEQ_2_Flashlight_OD_L",
		"CUP_acc_ANPEQ_2_Flashlight_OD_F",
		"CUP_acc_ANPEQ_15_Flashlight_Tan_L",
		"CUP_acc_ANPEQ_15_Flashlight_Tan_F",
		"CUP_acc_ANPEQ_15_Flashlight_OD_L",
		"CUP_acc_ANPEQ_15_Flashlight_OD_F",
		"CUP_acc_ANPEQ_15_Flashlight_Black_L",
		"CUP_acc_ANPEQ_15_Flashlight_Black_F",
		"CUP_acc_ANPEQ_15_Top_Flashlight_Tan_L",
		"CUP_acc_ANPEQ_15_Top_Flashlight_Tan_F",
		"CUP_acc_ANPEQ_15_Top_Flashlight_OD_L",
		"CUP_acc_ANPEQ_15_Top_Flashlight_OD_F",
		"CUP_acc_ANPEQ_15_Top_Flashlight_Black_L",
		"CUP_acc_ANPEQ_15_Top_Flashlight_Black_F",
		"CUP_bipod_Harris_1A2_L",
		"CUP_acc_sffh",
		"CUP_muzzle_mfsup_Flashhider_West_Base",
		"CUP_muzzle_mfsup_Flashhider_556x45_Black",
		"CUP_muzzle_mfsup_Flashhider_556x45_OD",
		"CUP_muzzle_mfsup_Flashhider_556x45_Tan",
		"CUP_muzzle_mfsup_Flashhider_762x51_Black",
		"CUP_muzzle_mfsup_Flashhider_762x51_OD",
		"CUP_muzzle_mfsup_Flashhider_762x51_Tan",
		"CUP_Bipod_G36",
		"CUP_Bipod_G36_desert",
		"CUP_Bipod_G36_wood",
		"CUP_muzzle_mfsup_SCAR_L",
		"CUP_muzzleFlash2SCAR_L",
		"CUP_muzzle_mfsup_SCAR_H"	
	];
	//publicVariable "ArsenalItems";
	
	//Backpacks for arsenal
	ArsenalBackpacks = [
		"B_AssaultPack_blk",                                            // Assault Pack (Black)
		"B_AssaultPack_rgr",                                            // Assault Pack (Green)
		"B_AssaultPack_wdl_F",                                          // Assault Pack (Woodland)
		"B_Carryall_wdl_F",                                             // Carryall Backpack (Woodland)
		"B_Kitbag_rgr",                                                 // Kitbag (Green)
		
		// TFAR Backpacks
		"tf_anprc155_coyote",                                           // AN/PRC 155 Coyote
		"tf_mr3000",                                                    // MR3000
		"tf_rt1523g_black",                                             // RT-1523G (ASIP) Black
		"tf_rt1523g_green",                                             // RT-1523G (ASIP) Green
		"tf_rt1523g_sage"                                               // RT-1523G (ASIP) Sage	
	];
	//publicVariable "ArsenalBackpacks";
	
	//Weapons for arsenal
	ArsenalWeapons = [
		// Primary
		"arifle_MX_Black_F",                                            // MX 6.5 mm (Black)
		"arifle_MX_GL_Black_F",                                         // MX 3GL 6.5 mm (Black)
		"arifle_MX_SW_Black_F",                                         // MX SW 6.5 mm (Black)
		"arifle_MXC_Black_F",                                           // MXC 6.5 mm (Black)
		"arifle_MXM_Black_F",                                           // MXM 6.5 mm (Black)
		"arifle_SDAR_F",                                                // SDAR 5.56 mm
		"srifle_LRR_F",                                                 // M320 LRR .408
		"SMG_01_F",                                                     // Vermin SMG .45 ACP
		"MMG_02_black_F",                                               // SPMG .338 (Black)
		"srifle_DMR_02_F",                                              // MAR-10 .338 (Black)
		"srifle_DMR_03_F",                                              // Mk-I EMR 7.62 mm (Black)
		
		//CUP Weapons
		"CUP_srifle_LeeEnfield",
		"CUP_srifle_LeeEnfield_rail",
		"CUP_srifle_M14_DMR",
		"CUP_srifle_M24_des",
		"CUP_srifle_M24_wdl",
		"CUP_srifle_M24_blk",
		"CUP_srifle_M40A3",
		"CUP_hgun_Phantom",
		"CUP_sgun_AA12",
		"CUP_hgun_MicroUzi",
		"CUP_smg_MP5A5",
		"CUP_smg_MP5A5_flashlight",
		"CUP_hgun_PB6P9",
		"CUP_sgun_Saiga12K",
		"CUP_arifle_AUG_A1",
		"CUP_srifle_SVD_top_rail",
		"CUP_arifle_AKM_top_rail",
		"CUP_arifle_AKM_GL_top_rail",
		"CUP_arifle_AKMS_top_rail",
		"CUP_arifle_AKMS_GL_top_rail",
		"CUP_arifle_AKS74U_top_rail",
		"CUP_arifle_AKS74U_railed",
		"CUP_arifle_AK47_top_rail",
		"CUP_arifle_AK47_GL_top_rail",
		"CUP_arifle_AKS_top_rail",
		"CUP_arifle_AK74_top_rail",
		"CUP_arifle_AK74_GL_top_rail",
		"CUP_arifle_AKS74_top_rail",
		"CUP_arifle_AKS74_GL_top_rail",
		"CUP_arifle_AK74M_camo",
		"CUP_arifle_AK74M_top_rail",
		"CUP_arifle_AK74M_GL_top_rail",
		"CUP_arifle_AK74M_railed",
		"CUP_arifle_AK74M_GL_railed",
		"CUP_arifle_AK101_top_rail",
		"CUP_arifle_AK101_GL_top_rail",
		"CUP_arifle_AK101_railed",
		"CUP_arifle_AK101_GL_railed",
		"CUP_arifle_AK103_top_rail",
		"CUP_arifle_AK103_GL_top_rail",
		"CUP_arifle_AK103_railed",
		"CUP_arifle_AK103_GL_railed",
		"CUP_arifle_AK107_top_rail",
		"CUP_arifle_AK107_GL_top_rail",
		"CUP_arifle_AK107_railed",
		"CUP_arifle_AK107_GL_railed",
		"CUP_arifle_AK108_top_rail",
		"CUP_arifle_AK108_GL_top_rail",
		"CUP_arifle_AK108_railed",
		"CUP_arifle_AK108_GL_railed",
		"CUP_arifle_AK109_top_rail",
		"CUP_arifle_AK109_GL_top_rail",
		"CUP_arifle_AK109_railed",
		"CUP_arifle_AK109_GL_railed",
		"CUP_arifle_AK102_top_rail",
		"CUP_arifle_AK102_railed",
		"CUP_arifle_AK104_top_rail",
		"CUP_arifle_AK104_railed",
		"CUP_arifle_AK105_top_rail",
		"CUP_arifle_AK105_railed",
		"CUP_arifle_RPK74_top_rail",
		"CUP_arifle_RPK74_45_top_rail",
		"CUP_arifle_RPK74M_top_rail",
		"CUP_arifle_RPK74M_railed",
		"CUP_arifle_SAIGA_MK03_top_rail",
		"CUP_srifle_AWM_des",
		"CUP_srifle_AWM_wdl",
		"CUP_smg_bizon",
		"CUP_smg_vityaz_top_rail",
		"CUP_arifle_FNFAL_railed",
		"CUP_smg_EVO",
		"CUP_smg_EVO_MRad_Flashlight",
		"CUP_arifle_G36A",
		"CUP_arifle_G36A_RIS",
		"CUP_arifle_G36A_wdl",
		"CUP_arifle_G36A_RIS_wdl",
		"CUP_arifle_G36A_camo",
		"CUP_arifle_G36A_RIS_camo",
		"CUP_arifle_AG36",
		"CUP_arifle_G36A_AG36_RIS",
		"CUP_arifle_G36K",
		"CUP_arifle_G36K_VFG",
		"CUP_arifle_G36K_RIS",
		"CUP_arifle_G36K_RIS_hex",
		"CUP_arifle_G36K_AG36",
		"CUP_arifle_G36K_RIS_AG36",
		"CUP_arifle_G36K_RIS_AG36_hex",
		"CUP_arifle_G36C",
		"CUP_arifle_G36C_VFG",
		"CUP_arifle_MG36",
		"CUP_arifle_HK416_CQB_Black",
		"CUP_arifle_HK416_CQB_Desert",
		"CUP_arifle_HK416_CQB_Wood",
		"CUP_arifle_HK416_CQB_M203_Black",
		"CUP_arifle_HK416_CQB_M203_Desert",
		"CUP_arifle_HK416_CQB_M203_Wood",
		"CUP_arifle_HK416_CQB_AG36",
		"CUP_arifle_HK416_CQB_AG36_Desert",
		"CUP_arifle_HK416_CQB_AG36_Wood",
		"CUP_arifle_HK416_Black",
		"CUP_arifle_HK416_Desert",
		"CUP_arifle_HK416_Wood",
		"CUP_arifle_HK416_M203_Black",
		"CUP_arifle_HK416_M203_Desert",
		"CUP_arifle_HK416_M203_Wood",
		"CUP_arifle_HK416_AGL_Black",
		"CUP_arifle_HK416_AGL_Desert",
		"CUP_arifle_HK416_AGL_Wood",
		"CUP_arifle_HK417_20",
		"CUP_arifle_HK417_20_Wood",
		"CUP_arifle_HK417_20_Desert",
		"CUP_arifle_HK417_12",
		"CUP_arifle_HK417_12_Wood",
		"CUP_arifle_HK417_12_Desert",
		"CUP_arifle_HK417_12_M203",
		"CUP_arifle_HK417_12_AG36",
		"CUP_sgun_CZ584",
		"CUP_lmg_L110A1",
		"CUP_l85a2",
		"CUP_l85a2_ris_ng",
		"CUP_l85a2_ugl",
		"CUP_arifle_L86A2",
		"CUP_sgun_M1014",
		"CUP_srifle_M107_Base",
		"CUP_srifle_M110",
		"CUP_arifle_M16A2",
		"CUP_arifle_M16A2_GL",
		"CUP_arifle_M16A4_Base",
		"CUP_arifle_M16A4_GL",
		"CUP_arifle_M4A1_black",
		"CUP_arifle_M4A1_camo",
		"CUP_arifle_M4A1_desert",
		"CUP_arifle_M4A1_BUIS_GL",
		"CUP_arifle_mk18_black",
		"CUP_arifle_mk18_m203_black",
		"CUP_arifle_SBR_black",
		"CUP_arifle_SBR_od",
		"CUP_lmg_M240",
		"CUP_lmg_minimi",
		"CUP_lmg_m249_para",
		"CUP_lmg_M249",
		"CUP_lmg_m249_pip3",
		"CUP_lmg_M60E4",
		"CUP_lmg_Mk48",
		"CUP_lmg_Mk48_des",
		"CUP_lmg_Mk48_wdl",
		"CUP_lmg_PKM",
		"CUP_arifle_Mk16_STD",
		"CUP_arifle_Mk16_STD_EGLM",
		"CUP_arifle_Mk16_SV",
		"CUP_arifle_Mk16_CQC",
		"CUP_arifle_Mk16_CQC_EGLM",
		"CUP_arifle_Mk16_CQC_black",
		"CUP_arifle_Mk16_CQC_EGLM_black",
		"CUP_arifle_Mk16_STD_black",
		"CUP_arifle_Mk16_STD_EGLM_black",
		"CUP_arifle_Mk16_SV_black",
		"CUP_arifle_Mk16_CQC_FG_woodland",
		"CUP_arifle_Mk16_STD_woodland",
		"CUP_arifle_Mk16_SV_woodland",
		"CUP_arifle_Mk17_CQC",
		"CUP_arifle_Mk17_CQC_EGLM",
		"CUP_arifle_Mk17_STD",
		"CUP_arifle_Mk17_STD_EGLM",
		"CUP_arifle_Mk20",
		"CUP_arifle_Mk17_CQC_Black",
		"CUP_arifle_Mk17_STD_black",
		"CUP_arifle_Mk20_black",
		"CUP_arifle_Mk17_CQC_woodland",
		"CUP_arifle_Mk17_STD_woodland",
		"CUP_arifle_Mk20_woodland",
			
		//CUP Secondary
		"CUP_hgun_Glock17",
		"CUP_hgun_Glock17_blk",
		"CUP_hgun_Glock17_tan",
		"CUP_hgun_M9",
		"CUP_hgun_Makarov",
		"CUP_hgun_PMM",
		"CUP_hgun_TaurusTracker455",
		"CUP_hgun_Colt1911",
		"CUP_hgun_Deagle",
		
		// Handgun
		"hgun_P07_khk_F",                                              // P07 9 mm (Khaki)
		"hgun_Pistol_heavy_01_F"                                       // 4-five .45 ACP
	];
	
	//publicVariable "ArsenalWeapons";

	//All magazines in arsenal
	ArsenalMagazines = [
		//---- Arma 3 Base magazines ----//
		
		//  -- rifles --
		//5.56
		"30Rnd_556x45_Stanag",
		"30Rnd_556x45_Stanag_green",
		"30Rnd_556x45_Stanag_red",
		"30Rnd_556x45_Stanag_Tracer_Red",
		"30Rnd_556x45_Stanag_Tracer_Green",
		"30Rnd_556x45_Stanag_Tracer_Yellow",
		"30Rnd_556x45_Stanag_Sand",
		"30Rnd_556x45_Stanag_Sand_green",
		"30Rnd_556x45_Stanag_Sand_red",
		"30Rnd_556x45_Stanag_Sand_Tracer_Red",
		"30Rnd_556x45_Stanag_Sand_Tracer_Green",
		"30Rnd_556x45_Stanag_Sand_Tracer_Yellow",
		"20Rnd_556x45_UW_mag",
		
		//6.5
		"30Rnd_65x39_caseless_mag",
		"30Rnd_65x39_caseless_khaki_mag",
		"30Rnd_65x39_caseless_black_mag",
		"30Rnd_65x39_caseless_green",
		"30Rnd_65x39_caseless_mag_Tracer",
		"30Rnd_65x39_caseless_khaki_mag_Tracer",
		"30Rnd_65x39_caseless_black_mag_Tracer",
		"30Rnd_65x39_caseless_green_mag_Tracer",
		"100Rnd_65x39_caseless_mag",
		"100Rnd_65x39_caseless_khaki_mag",
		"100Rnd_65x39_caseless_black_mag",
		"100Rnd_65x39_caseless_mag_Tracer",
		"100Rnd_65x39_caseless_khaki_mag_tracer",
		"100Rnd_65x39_caseless_black_mag_tracer",
		"200Rnd_65x39_cased_Box",
		"200Rnd_65x39_cased_Box_Tracer",
		"200Rnd_65x39_cased_Box_Red",
		"200Rnd_65x39_cased_Box_Tracer_Red",
		
		//7.62
		"20Rnd_762x51_Mag",
		
		//.408
		"7Rnd_408_Mag",
		
		//12.7
		"5Rnd_127x108_Mag",
		
		
		//  -- SMGs & Pistols --
		//9mm
		"30Rnd_9x21_Mag",
		"30Rnd_9x21_Red_Mag",
		"30Rnd_9x21_Yellow_Mag",
		"30Rnd_9x21_Green_Mag",
		"16Rnd_9x21_Mag",
		"30Rnd_9x21_Mag_SMG_02",
		"30Rnd_9x21_Mag_SMG_02_Tracer_Red",
		"30Rnd_9x21_Mag_SMG_02_Tracer_Yellow",
		"30Rnd_9x21_Mag_SMG_02_Tracer_Green",
		"16Rnd_9x21_red_Mag",
		"16Rnd_9x21_green_Mag",
		"16Rnd_9x21_yellow_Mag",
		
		
		//  -- Underbarrel Launcher --
		"1Rnd_HE_Grenade_shell",
		"3Rnd_HE_Grenade_shell",
		"1Rnd_Smoke_Grenade_shell",
		"3Rnd_Smoke_Grenade_shell",
		"1Rnd_SmokeRed_Grenade_shell",
		"3Rnd_SmokeRed_Grenade_shell",
		"1Rnd_SmokeGreen_Grenade_shell",
		"3Rnd_SmokeGreen_Grenade_shell",
		"1Rnd_SmokeYellow_Grenade_shell",
		"3Rnd_SmokeYellow_Grenade_shell",
		"1Rnd_SmokePurple_Grenade_shell",
		"3Rnd_SmokePurple_Grenade_shell",
		"1Rnd_SmokeBlue_Grenade_shell",
		"3Rnd_SmokeBlue_Grenade_shell",
		"1Rnd_SmokeOrange_Grenade_shell",
		"3Rnd_SmokeOrange_Grenade_shell",
		
		
		// -- Launcher --
		/*
		"RPG32_F",
		"RPG32_HE_F",
		"NLAW_F",
		*/
	/*
		// -- Grenades --
		"HandGrenade",
		"MiniGrenade",
		"HandGrenade_Stone",
		"SmokeShell",
		"	SmokeShellRed	",	//	Smoke Grenade (Red)	SmokeShellRed
		"	SmokeShellGreen	",	//	Smoke Grenade (Green)	SmokeShellGreen
		"	SmokeShellYellow	",	//	Smoke Grenade (Yellow)	SmokeShellYellow
		"	SmokeShellPurple	",	//	Smoke Grenade (Purple)	SmokeShellPurple
		"	SmokeShellBlue	",	//	Smoke Grenade (Blue)	SmokeShellBlue
		"	SmokeShellOrange	",	//	Smoke Grenade (Orange)	SmokeShellOrange
		"	Chemlight_green	",	//	Chemlight (Green)	Chemlight_green
		"	Chemlight_red	",	//	Chemlight (Red)	Chemlight_red
		"	Chemlight_yellow	",	//	Chemlight (Yellow)	Chemlight_yellow
		"	Chemlight_blue	",	//	Chemlight (Blue)	Chemlight_blue
		"	60Rnd_CMFlareMagazine	",	//	'	CMflareAmmo
		"	120Rnd_CMFlareMagazine	",	//	'	CMflareAmmo
		"	240Rnd_CMFlareMagazine	",	//	'	CMflareAmmo
		"	60Rnd_CMFlare_Chaff_Magazine	",	//	'	CMflare_Chaff_Ammo
		"	120Rnd_CMFlare_Chaff_Magazine	",	//	'	CMflare_Chaff_Ammo
		"	240Rnd_CMFlare_Chaff_Magazine	",	//	'	CMflare_Chaff_Ammo
		"	192Rnd_CMFlare_Chaff_Magazine	",	//	'	CMflare_Chaff_Ammo
		"	168Rnd_CMFlare_Chaff_Magazine	",	//	'	CMflare_Chaff_Ammo
		"	300Rnd_CMFlare_Chaff_Magazine	",	//	'	CMflare_Chaff_Ammo
		"	SmokeLauncherMag	",	//	'	SmokeLauncherAmmo
		"	SmokeLauncherMag_Single	",	//	'	SmokeLauncherAmmo
		"	SmokeLauncherMag_boat	",	//	'	SmokeLauncherAmmo_boat
		"	200Rnd_65x39_Belt	",	//	6.5 mm 200Rnd Belt Case	B_65x39_Caseless
		"	200Rnd_65x39_Belt_Tracer_Red	",	//	6.5 mm 200Rnd Belt Case Tracer (Red)	B_65x39_Caseless
		"	200Rnd_65x39_Belt_Tracer_Green	",	//	6.5 mm 200Rnd Belt Case Tracer (Green)	B_65x39_Case_green
		"	200Rnd_65x39_Belt_Tracer_Yellow	",	//	6.5 mm 200Rnd Belt Tracer (Yellow)	B_65x39_Case_yellow
		"	1000Rnd_65x39_Belt	",	//	6.5 mm 1000Rnd LMG Belt	B_65x39_Caseless
		"	1000Rnd_65x39_Belt_Tracer_Red	",	//	6.5 mm 1000Rnd LMG Tracer (Red) Belt	B_65x39_Caseless
		"	1000Rnd_65x39_Belt_Green	",	//	6.5 mm 1000Rnd LMG Belt	B_65x39_Case_green
		"	1000Rnd_65x39_Belt_Tracer_Green	",	//	6.5 mm 1000Rnd LMG Tracer (Green) Belt	B_65x39_Case_green
		"	1000Rnd_65x39_Belt_Yellow	",	//	6.5 mm 1000Rnd LMG Belt	B_65x39_Case_Yellow
		"	1000Rnd_65x39_Belt_Tracer_Yellow	",	//	6.5 mm 1000Rnd LMG Tracer (Yellow) Belt	B_65x39_Case_Yellow
		"	2000Rnd_65x39_Belt	",	//	6.5 mm 2000Rnd LMG Belt	B_65x39_Caseless
		"	2000Rnd_65x39_Belt_Tracer_Red	",	//	6.5 mm 2000Rnd LMG Tracer (Red) Belt	B_65x39_Minigun_Caseless_Red_splash
		"	2000Rnd_65x39_Belt_Green	",	//	6.5 mm 2000Rnd LMG Belt	B_65x39_Case_Green
		"	2000Rnd_65x39_Belt_Tracer_Green	",	//	6.5 mm 2000Rnd LMG Tracer (Green) Belt	B_65x39_Case_Green
		"	2000Rnd_65x39_Belt_Tracer_Green_Splash	",	//	6.5 mm 2000Rnd LMG Tracer (Green) Belt	B_65x39_Minigun_Caseless_Green_splash
		"	2000Rnd_65x39_Belt_Yellow	",	//	6.5 mm 2000Rnd LMG Belt	B_65x39_Case_Yellow
		"	2000Rnd_65x39_Belt_Tracer_Yellow	",	//	6.5 mm 2000Rnd LMG Tracer (Yellow) Belt	B_65x39_Case_Yellow
		"	2000Rnd_65x39_Belt_Tracer_Yellow_Splash	",	//	6.5 mm 2000Rnd LMG Tracer (Yellow) Belt	B_65x39_Minigun_Caseless_Yellow_splash
		"	5000Rnd_762x51_Belt	",	//	7.62 mm Minigun Belt	B_762x51_Minigun_Tracer_Red_splash
		"	5000Rnd_762x51_Yellow_Belt	",	//	7.62 mm Minigun Belt	B_762x51_Minigun_Tracer_Yellow_splash
		"	500Rnd_127x99_mag	",	//	12.7 mm AA MG Mag	B_127x99_Ball
		"	500Rnd_127x99_mag_Tracer_Red	",	//	12.7 mm AA MG Tracer (Red) Mag	B_127x99_Ball_Tracer_Red
		"	500Rnd_127x99_mag_Tracer_Green	",	//	12.7 mm AA MG Tracer (Green) Mag	B_127x99_Ball_Tracer_Green
		"	500Rnd_127x99_mag_Tracer_Yellow	",	//	12.7 mm AA MG Tracer (Yellow) Mag	B_127x99_Ball_Tracer_Yellow
		"	200Rnd_127x99_mag	",	//	12.7 mm RCWS HMG	B_127x99_Ball
		"	200Rnd_127x99_mag_Tracer_Red	",	//	12.7 mm RCWS HMG Tracer (Red)	B_127x99_Ball_Tracer_Red
		"	200Rnd_127x99_mag_Tracer_Green	",	//	12.7 mm RCWS HMG Tracer (Green)	B_127x99_Ball_Tracer_Green
		"	200Rnd_127x99_mag_Tracer_Yellow	",	//	12.7 mm RCWS HMG Tracer (Yellow)	B_127x99_Ball_Tracer_Yellow
		"	100Rnd_127x99_mag	",	//	12.7 mm M2 HMG Belt	B_127x99_Ball
		"	100Rnd_127x99_mag_Tracer_Red	",	//	12.7 mm M2 HMG Tracer (Red) Belt	B_127x99_Ball_Tracer_Red
		"	100Rnd_127x99_mag_Tracer_Green	",	//	12.7 mm M2 HMG Tracer (Green) Belt	B_127x99_Ball_Tracer_Green
		"	100Rnd_127x99_mag_Tracer_Yellow	",	//	12.7 mm M2 HMG Tracer (Yellow) Belt	B_127x99_Ball_Tracer_Yellow
		"	450Rnd_127x108_Ball	",	//	NSVT-M	B_127x108_Ball
		"	150Rnd_127x108_Ball	",	//	NSVT-M	B_127x108_Ball
		"	50Rnd_127x108_Ball	",	//	NSVT-M	B_127x108_Ball
		"	200Rnd_40mm_G_belt	",	//	40 mm HE Grenade Mag	G_40mm_HEDP
		"	96Rnd_40mm_G_belt	",	//	40 mm HE Grenade Mag	G_40mm_HEDP
		"	64Rnd_40mm_G_belt	",	//	40 mm HE Grenade Mag	G_40mm_HEDP
		"	32Rnd_40mm_G_belt	",	//	40 mm HE Grenade Mag	G_40mm_HEDP
		"	200Rnd_20mm_G_belt	",	//	20 mm Grenade Mag	G_20mm_HE
		"	40Rnd_20mm_G_belt	",	//	20 mm HE Grenade Mag	G_20mm_HE
		"	24Rnd_PG_missiles	",	//	DAGR	M_PG_AT
		"	12Rnd_PG_missiles	",	//	DAGR	M_PG_AT
		"	24Rnd_missiles	",	//	DAR	M_AT
		"	12Rnd_missiles	",	//	DAR	M_AT
		"	32Rnd_155mm_Mo_shells	",	//	155 mm HE Shells	Sh_155mm_AMOS
		"	32Rnd_155mm_Mo_shells_O	",	//	155 mm HE Shells	Sh_155mm_AMOS
		"	8Rnd_82mm_Mo_shells	",	//	HE Mortar Shells	Sh_82mm_AMOS
		"	8Rnd_82mm_Mo_Flare_white	",	//	Flare (White)	Flare_82mm_AMOS_White
		"	8Rnd_82mm_Mo_Smoke_white	",	//	Smoke Shell (White)	Smoke_82mm_AMOS_White
		"	8Rnd_82mm_Mo_guided	",	//	Guided	Sh_82mm_AMOS_guided
		"	8Rnd_82mm_Mo_LG	",	//	Laser Guided	Sh_82mm_AMOS_LG
		"	6Rnd_155mm_Mo_smoke	",	//	Smoke (White)	Smoke_120mm_AMOS_White
		"	6Rnd_155mm_Mo_smoke_O	",	//	Smoke (White)	Smoke_120mm_AMOS_White
		"	2Rnd_155mm_Mo_guided	",	//	Guided	Sh_155mm_AMOS_guided
		"	2Rnd_155mm_Mo_guided_O	",	//	Guided	Sh_155mm_AMOS_guided
		"	4Rnd_155mm_Mo_guided	",	//	Guided	Sh_155mm_AMOS_guided
		"	4Rnd_155mm_Mo_guided_O	",	//	Guided	Sh_155mm_AMOS_guided
		"	2Rnd_155mm_Mo_LG	",	//	Laser Guided	Sh_155mm_AMOS_LG
		"	4Rnd_155mm_Mo_LG	",	//	Laser Guided	Sh_155mm_AMOS_LG
		"	4Rnd_155mm_Mo_LG_O	",	//	Laser Guided	Sh_155mm_AMOS_LG
		"	6Rnd_155mm_Mo_mine	",	//	Mine Cluster	Mine_155mm_AMOS_range
		"	6Rnd_155mm_Mo_mine_O	",	//	Mine Cluster	Mine_155mm_AMOS_range
		"	6Rnd_155mm_Mo_AT_mine	",	//	AT Mine Cluster	AT_Mine_155mm_AMOS_range
		"	6Rnd_155mm_Mo_AT_mine_O	",	//	AT Mine Cluster	AT_Mine_155mm_AMOS_range
		"	2Rnd_155mm_Mo_Cluster	",	//	Cluster Shells	Cluster_155mm_AMOS
		"	2Rnd_155mm_Mo_Cluster_O	",	//	Cluster Shells	Cluster_155mm_AMOS
		"	UGL_FlareWhite_F	",	//	Flare Round (White)	F_40mm_White
		"	3Rnd_UGL_FlareWhite_F	",	//	3Rnd 3GL Flares (White)	F_40mm_White
		"	UGL_FlareGreen_F	",	//	Flare Round (Green)	F_40mm_Green
		"	3Rnd_UGL_FlareGreen_F	",	//	3Rnd 3GL Flares (Green)	F_40mm_Green
		"	UGL_FlareRed_F	",	//	Flare Round (Red)	F_40mm_Red
		"	3Rnd_UGL_FlareRed_F	",	//	3Rnd 3GL Flares (Red)	F_40mm_Red
		"	UGL_FlareYellow_F	",	//	Flare Round (Yellow)	F_40mm_Yellow
		"	3Rnd_UGL_FlareYellow_F	",	//	3Rnd 3GL Flares (Yellow)	F_40mm_Yellow
		"	UGL_FlareCIR_F	",	//	Flare Round (IR)	F_40mm_CIR
		"	3Rnd_UGL_FlareCIR_F	",	//	3Rnd 3GL Flares (IR)	F_40mm_CIR
		"	FlareWhite_F	",	//	Flare (White)	F_20mm_White
		"	FlareGreen_F	",	//	Flare (Green)	F_20mm_Green
		"	FlareRed_F	",	//	Flare (Red)	F_20mm_Red
		"	FlareYellow_F	",	//	Flare (Yellow)	F_20mm_Yellow
		"	Laserbatteries	",	//	Designator Batteries	Laserbeam
		"	30Rnd_45ACP_Mag_SMG_01	",	//	.45 ACP 30Rnd Vermin Mag	B_45ACP_Ball
		"	30Rnd_45ACP_Mag_SMG_01_Tracer_Green	",	//	.45 ACP 30Rnd Vermin Tracers (Green) Mag	B_45ACP_Ball_Green
		"	30Rnd_45ACP_Mag_SMG_01_Tracer_Red	",	//	.45 ACP 30Rnd Vermin Tracers (Red) Mag	B_45ACP_Ball
		"	30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow	",	//	.45 ACP 30Rnd Vermin Tracers (Yellow) Mag	B_45ACP_Ball_Yellow
		"	9Rnd_45ACP_Mag	",	//	.45 ACP 9Rnd Mag	B_45ACP_Ball_Green
		"	150Rnd_762x51_Box	",	//	7.62 mm 150Rnd Box	B_762x51_Tracer_Green
		"	150Rnd_762x51_Box_Tracer	",	//	7.62 mm 150Rnd Tracer (Green) Box	B_762x51_Tracer_Green
		"	150Rnd_762x54_Box	",	//	7.62 mm 150Rnd Box	B_762x54_Tracer_Green
		"	150Rnd_762x54_Box_Tracer	",	//	7.62 mm 150Rnd Tracer (Green) Box	B_762x54_Tracer_Green
		"	Titan_AA	",	//	Titan AA Missile	M_Titan_AA
		"	Titan_AP	",	//	Titan AP Missile	M_Titan_AP
		"	Titan_AT	",	//	Titan AT Missile	M_Titan_AT
		"	300Rnd_20mm_shells	",	//	20 mm Shells	B_20mm
		"	1000Rnd_20mm_shells	",	//	20 mm Shells	B_20mm_Tracer_Red
		"	2000Rnd_20mm_shells	",	//	20 mm Shells	B_20mm
		"	300Rnd_25mm_shells	",	//	25 mm Shells	B_25mm
		"	1000Rnd_25mm_shells	",	//	25 mm Shells	B_25mm
		"	250Rnd_30mm_HE_shells	",	//	30 mm HE Shells	B_30mm_HE
		"	250Rnd_30mm_HE_shells_Tracer_Red	",	//	30 mm HE Tracer (Red) Shells	B_30mm_HE_Tracer_Red
		"	250Rnd_30mm_HE_shells_Tracer_Green	",	//	30 mm HE Tracer (Green) Shells	B_30mm_HE_Tracer_Green
		"	250Rnd_30mm_APDS_shells	",	//	30 mm APDS shells	B_30mm_AP
		"	250Rnd_30mm_APDS_shells_Tracer_Red	",	//	30 mm APDS Tracer (Red) Shells	B_30mm_AP_Tracer_Red
		"	250Rnd_30mm_APDS_shells_Tracer_Green	",	//	30 mm APDS Tracer (Green) Shells	B_30mm_AP_Tracer_Green
		"	250Rnd_30mm_APDS_shells_Tracer_Yellow	",	//	30 mm APDS Tracer (Yellow) Shells	B_30mm_AP_Tracer_Yellow
		"	140Rnd_30mm_MP_shells	",	//	30 mm Multi-purpose	B_30mm_MP
		"	140Rnd_30mm_MP_shells_Tracer_Red	",	//	30 mm MP-T	B_30mm_MP_Tracer_Red
		"	140Rnd_30mm_MP_shells_Tracer_Green	",	//	30 mm MP-T	B_30mm_MP_Tracer_Green
		"	140Rnd_30mm_MP_shells_Tracer_Yellow	",	//	30 mm MP-T	B_30mm_MP_Tracer_Yellow
		"	60Rnd_30mm_APFSDS_shells	",	//	30 mm APFSDS	B_30mm_APFSDS
		"	60Rnd_30mm_APFSDS_shells_Tracer_Red	",	//	30 mm APFSDS-T	B_30mm_APFSDS_Tracer_Red
		"	60Rnd_30mm_APFSDS_shells_Tracer_Green	",	//	30 mm APFSDS	B_30mm_APFSDS_Tracer_Green
		"	60Rnd_30mm_APFSDS_shells_Tracer_Yellow	",	//	30 mm APFSDS-T	B_30mm_APFSDS_Tracer_Yellow
		"	60Rnd_40mm_GPR_shells	",	//	40 mm GPR	B_40mm_GPR
		"	60Rnd_40mm_GPR_Tracer_Red_shells	",	//	40 mm GPR-T	B_40mm_GPR_Tracer_Red
		"	60Rnd_40mm_GPR_Tracer_Green_shells	",	//	40 mm GPR-T	B_40mm_GPR_Tracer_Green
		"	60Rnd_40mm_GPR_Tracer_Yellow_shells	",	//	40 mm GPR-T	B_40mm_GPR_Tracer_Yellow
		"	40Rnd_40mm_APFSDS_shells	",	//	40 mm APFSDS	B_40mm_APFSDS
		"	40Rnd_40mm_APFSDS_Tracer_Red_shells	",	//	40 mm APFSDS-T	B_40mm_APFSDS_Tracer_Red
		"	40Rnd_40mm_APFSDS_Tracer_Green_shells	",	//	40 mm APFSDS-T	B_40mm_APFSDS_Tracer_Green
		"	40Rnd_40mm_APFSDS_Tracer_Yellow_shells	",	//	40 mm APFSDS-T	B_40mm_APFSDS_Tracer_Yellow
		"	8Rnd_LG_scalpel	",	//	Scalpel E2	M_Scalpel_AT
		"	6Rnd_LG_scalpel	",	//	Scalpel E2	M_Scalpel_AT
		"	2Rnd_LG_scalpel	",	//	Scalpel E2	M_Scalpel_AT
		"	2Rnd_LG_scalpel_hidden	",	//	Scalpel E2	M_Scalpel_AT_hidden
		"	14Rnd_80mm_rockets	",	//	Skyfire	R_80mm_HE
		"	38Rnd_80mm_rockets	",	//	Skyfire	R_80mm_HE
		"	12Rnd_230mm_rockets	",	//	230 mm Rocket	R_230mm_HE
		"	12Rnd_230mm_rockets_cluster	",	//	230 mm Cluster Rocket	R_230mm_Cluster
		"	2Rnd_AAA_missiles	",	//	ASRAAM	M_Air_AA
		"	2Rnd_AAA_missiles_MI02	",	//	ASRAAM	M_Air_AA_MI02
		"	2Rnd_AAA_missiles_MI06	",	//	ASRAAM	M_Air_AA_MI06
		"	4Rnd_AAA_missiles	",	//	ASRAAM	M_Air_AA
		"	4Rnd_AAA_missiles_MI02	",	//	ASRAAM	M_Air_AA_MI02
		"	4Rnd_GAA_missiles	",	//	Zephyr	M_Zephyr
		"	4Rnd_Titan_long_missiles	",	//	Titan Missile	M_Titan_AA_long
		"	4Rnd_Titan_long_missiles_O	",	//	Titan Missile	M_Titan_AA_long
		"	5Rnd_GAT_missiles	",	//	Titan Missile	M_Titan_AT_long
		"	2Rnd_GAT_missiles	",	//	Titan Missile	M_Titan_AT_long
		"	2Rnd_GAT_missiles_O	",	//	Titan Missile	M_Titan_AT_long
		"	30Rnd_120mm_HE_shells	",	//	HE Shells	Sh_120mm_HE
		"	30Rnd_120mm_HE_shells_Tracer_Red	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Red
		"	30Rnd_120mm_HE_shells_Tracer_Green	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Green
		"	30Rnd_120mm_HE_shells_Tracer_Yellow	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Yellow
		"	16Rnd_120mm_HE_shells	",	//	HE Shells	Sh_120mm_HE
		"	16Rnd_120mm_HE_shells_Tracer_Red	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Red
		"	16Rnd_120mm_HE_shells_Tracer_Green	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Green
		"	16Rnd_120mm_HE_shells_Tracer_Yellow	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Yellow
		"	14Rnd_120mm_HE_shells	",	//	HE Shells	Sh_120mm_HE
		"	14Rnd_120mm_HE_shells_Tracer_Red	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Red
		"	14Rnd_120mm_HE_shells_Tracer_Green	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Green
		"	14Rnd_120mm_HE_shells_Tracer_Yellow	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Yellow
		"	12Rnd_120mm_HE_shells	",	//	HE Shells	Sh_120mm_HE
		"	12Rnd_120mm_HE_shells_Tracer_Red	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Red
		"	12Rnd_120mm_HE_shells_Tracer_Green	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Green
		"	12Rnd_120mm_HE_shells_Tracer_Yellow	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Yellow
		"	8Rnd_120mm_HE_shells	",	//	HE Shells	Sh_120mm_HE
		"	8Rnd_120mm_HE_shells_Tracer_Red	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Red
		"	8Rnd_120mm_HE_shells_Tracer_Green	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Green
		"	8Rnd_120mm_HE_shells_Tracer_Yellow	",	//	120mm HE-T	Sh_120mm_HE_Tracer_Yellow
		"	30Rnd_120mm_APFSDS_shells	",	//	120mm APFSDS	Sh_120mm_APFSDS
		"	30Rnd_120mm_APFSDS_shells_Tracer_Red	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Red
		"	30Rnd_120mm_APFSDS_shells_Tracer_Green	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Green
		"	30Rnd_120mm_APFSDS_shells_Tracer_Yellow	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Yellow
		"	32Rnd_120mm_APFSDS_shells	",	//	120mm APFSDS	Sh_120mm_APFSDS
		"	32Rnd_120mm_APFSDS_shells_Tracer_Red	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Red
		"	32Rnd_120mm_APFSDS_shells_Tracer_Green	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Green
		"	32Rnd_120mm_APFSDS_shells_Tracer_Yellow	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Yellow
		"	28Rnd_120mm_APFSDS_shells	",	//	120mm APFSDS	Sh_120mm_APFSDS
		"	28Rnd_120mm_APFSDS_shells_Tracer_Red	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Red
		"	28Rnd_120mm_APFSDS_shells_Tracer_Green	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Green
		"	28Rnd_120mm_APFSDS_shells_Tracer_Yellow	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Yellow
		"	24Rnd_120mm_APFSDS_shells	",	//	120mm APFSDS	Sh_120mm_APFSDS
		"	24Rnd_120mm_APFSDS_shells_Tracer_Red	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Red
		"	24Rnd_120mm_APFSDS_shells_Tracer_Green	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Green
		"	24Rnd_120mm_APFSDS_shells_Tracer_Yellow	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Yellow
		"	20Rnd_120mm_APFSDS_shells	",	//	120mm APFSDS	Sh_120mm_APFSDS
		"	20Rnd_120mm_APFSDS_shells_Tracer_Red	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Red
		"	20Rnd_120mm_APFSDS_shells_Tracer_Green	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Green
		"	20Rnd_120mm_APFSDS_shells_Tracer_Yellow	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Yellow
		"	12Rnd_120mm_APFSDS_shells	",	//	120mm APFSDS	Sh_120mm_APFSDS
		"	12Rnd_120mm_APFSDS_shells_Tracer_Red	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Red
		"	12Rnd_120mm_APFSDS_shells_Tracer_Green	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Green
		"	12Rnd_120mm_APFSDS_shells_Tracer_Yellow	",	//	120mm APFSDS-T	Sh_120mm_APFSDS_Tracer_Yellow
		"	20Rnd_120mm_HEAT_MP	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP
		"	20Rnd_120mm_HEAT_MP_T_Red	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Red
		"	20Rnd_120mm_HEAT_MP_T_Green	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Green
		"	20Rnd_120mm_HEAT_MP_T_Yellow	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Yellow
		"	12Rnd_120mm_HEAT_MP	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP
		"	12Rnd_120mm_HEAT_MP_T_Red	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Red
		"	12Rnd_120mm_HEAT_MP_T_Green	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Green
		"	12Rnd_120mm_HEAT_MP_T_Yellow	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Yellow
		"	8Rnd_120mm_HEAT_MP	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP
		"	8Rnd_120mm_HEAT_MP_T_Red	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Red
		"	8Rnd_120mm_HEAT_MP_T_Green	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Green
		"	8Rnd_120mm_HEAT_MP_T_Yellow	",	//	120mm HEAT-MP-T	Sh_120mm_HEAT_MP_T_Yellow
		"	12Rnd_125mm_HE	",	//	125mm HE	Sh_125mm_HE
		"	12Rnd_125mm_HE_T_Red	",	//	125mm HE-T	Sh_125mm_HE_T_Red
		"	12Rnd_125mm_HE_T_Green	",	//	125mm HE-T	Sh_125mm_HE_T_Green
		"	12Rnd_125mm_HE_T_Yellow	",	//	125mm HE-T	Sh_125mm_HE_T_Yellow
		"	8Rnd_125mm_HE	",	//	125mm HE	Sh_125mm_HE
		"	8Rnd_125mm_HE_T_Red	",	//	125mm HE-T	Sh_125mm_HE_T_Red
		"	8Rnd_125mm_HE_T_Green	",	//	125mm HE-T	Sh_125mm_HE_T_Green
		"	8Rnd_125mm_HE_T_Yellow	",	//	125mm HE-T	Sh_125mm_HE_T_Yellow
		"	20Rnd_125mm_APFSDS	",	//	125mm APFSDS-T	Sh_125mm_APFSDS
		"	20Rnd_125mm_APFSDS_T_Red	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Red
		"	20Rnd_125mm_APFSDS_T_Green	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Green
		"	20Rnd_125mm_APFSDS_T_Yellow	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Yellow
		"	24Rnd_125mm_APFSDS	",	//	125mm APFSDS-T	Sh_125mm_APFSDS
		"	24Rnd_125mm_APFSDS_T_Red	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Red
		"	24Rnd_125mm_APFSDS_T_Green	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Green
		"	24Rnd_125mm_APFSDS_T_Yellow	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Yellow
		"	16Rnd_125mm_APFSDS	",	//	125mm APFSDS-T	Sh_125mm_APFSDS
		"	16Rnd_125mm_APFSDS_T_Red	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Red
		"	16Rnd_125mm_APFSDS_T_Green	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Green
		"	16Rnd_125mm_APFSDS_T_Yellow	",	//	125mm APFSDS-T	Sh_125mm_APFSDS_T_Yellow
		"	12Rnd_125mm_HEAT	",	//	125mm HEAT	Sh_125mm_HEAT
		"	12Rnd_125mm_HEAT_T_Red	",	//	125mm HEAT-T	Sh_125mm_HEAT_T_Red
		"	12Rnd_125mm_HEAT_T_Green	",	//	125mm HEAT-T	Sh_125mm_HEAT_T_Green
		"	12Rnd_125mm_HEAT_T_Yellow	",	//	125mm HEAT-T	Sh_125mm_HEAT_T_Yellow
		"	40Rnd_105mm_APFSDS	",	//	105mm APFSDS	Sh_105mm_APFSDS
		"	40Rnd_105mm_APFSDS_T_Red	",	//	105mm APFSDS-T	Sh_105mm_APFSDS_T_Red
		"	40Rnd_105mm_APFSDS_T_Green	",	//	105mm APFSDS-T	Sh_105mm_APFSDS_T_Green
		"	40Rnd_105mm_APFSDS_T_Yellow	",	//	105mm APFSDS-T	Sh_105mm_APFSDS_T_Yellow
		"	20Rnd_105mm_HEAT_MP	",	//	105mm HEAT-MP	Sh_105mm_HEAT_MP
		"	20Rnd_105mm_HEAT_MP_T_Red	",	//	105mm HEAT-MP-T	Sh_105mm_HEAT_MP_T_Red
		"	20Rnd_105mm_HEAT_MP_T_Green	",	//	105mm HEAT-MP-T	Sh_105mm_HEAT_MP_T_Green
		"	20Rnd_105mm_HEAT_MP_T_Yellow	",	//	105mm HEAT-MP-T	Sh_105mm_HEAT_MP_T_Yellow
		"	680Rnd_35mm_AA_shells	",	//	35 mm AA Shells	B_35mm_AA
		"	680Rnd_35mm_AA_shells_Tracer_Red	",	//	35 mm AA Shells	B_35mm_AA_Tracer_Red
		"	680Rnd_35mm_AA_shells_Tracer_Green	",	//	35 mm AA Shells	B_35mm_AA_Tracer_Green
		"	680Rnd_35mm_AA_shells_Tracer_Yellow	",	//	35 mm AA Shells	B_35mm_AA_Tracer_Yellow
		"	6Rnd_AAT_missiles	",	//	AG Missiles	M_Air_AT
		"	4Rnd_AAT_missiles	",	//	AG Missiles	M_Air_AT
		"	1Rnd_GAA_missiles	",	//	Zephyr	M_Titan_AA_static
		"	1Rnd_GAT_missiles	",	//	Titan Missile	M_Titan_AT_static
		"	2Rnd_GBU12_LGB	",	//	GBU-12	Bo_GBU12_LGB
		"	2Rnd_GBU12_LGB_MI10	",	//	GBU-12	Bo_GBU12_LGB_MI10
		"	2Rnd_Mk82	",	//	Mk82	Bo_Mk82
		"	2Rnd_Mk82_MI08	",	//	Mk82	Bo_Mk82_MI08
		"	11Rnd_45ACP_Mag	",	//	.45 ACP 11Rnd Mag	B_45ACP_Ball
		"	6Rnd_45ACP_Cylinder	",	//	.45 ACP 6Rnd Cylinder	B_45ACP_Ball
		"	10Rnd_762x51_Mag	",	//	7.62 mm 10Rnd Mag	B_762x51_Ball
		"	10Rnd_762x54_Mag	",	//	7.62 mm 10Rnd Mag	B_762x54_Ball
		"	5Rnd_127x108_APDS_Mag	",	//	12.7 mm 5Rnd APDS Mag	B_127x108_APDS
		"	B_IR_Grenade	",	//	IR Grenade [NATO]	B_IRStrobe
		"	O_IR_Grenade	",	//	IR Grenade [CSAT]	O_IRStrobe
		"	I_IR_Grenade	",	//	IR Grenade [AAF]	I_IRStrobe
		"	200Rnd_762x51_Belt	",	//	7.62 mm Minigun Belt	B_762x51_Ball
		"	200Rnd_762x51_Belt_Red	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Red
		"	200Rnd_762x51_Belt_T_Red	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Red
		"	200Rnd_762x51_Belt_Green	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Green
		"	200Rnd_762x51_Belt_T_Green	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Green
		"	200Rnd_762x51_Belt_Yellow	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Yellow
		"	200Rnd_762x51_Belt_T_Yellow	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Yellow
		"	1000Rnd_762x51_Belt	",	//	7.62 mm Minigun Belt	B_762x51_Ball
		"	1000Rnd_762x51_Belt_Red	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Red
		"	1000Rnd_762x51_Belt_T_Red	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Red
		"	1000Rnd_762x51_Belt_Green	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Green
		"	1000Rnd_762x51_Belt_T_Green	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Green
		"	1000Rnd_762x51_Belt_Yellow	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Yellow
		"	1000Rnd_762x51_Belt_T_Yellow	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Yellow
		"	2000Rnd_762x51_Belt	",	//	7.62 mm Minigun Belt	B_762x51_Ball
		"	2000Rnd_762x51_Belt_Red	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Red
		"	2000Rnd_762x51_Belt_T_Red	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Red
		"	2000Rnd_762x51_Belt_Green	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Green
		"	2000Rnd_762x51_Belt_T_Green	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Green
		"	2000Rnd_762x51_Belt_Yellow	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Yellow
		"	2000Rnd_762x51_Belt_T_Yellow	",	//	7.62 mm Minigun Belt	B_762x51_Tracer_Yellow
		"	1000Rnd_Gatling_30mm_Plane_CAS_01_F	",	//	'	Gatling_30mm_HE_Plane_CAS_01_F
		"	2Rnd_Missile_AA_04_F	",	//	'	Missile_AA_04_F
		"	6Rnd_Missile_AGM_02_F	",	//	'	Missile_AGM_02_F
		"	7Rnd_Rocket_04_HE_F	",	//	'	Rocket_04_HE_F
		"	7Rnd_Rocket_04_AP_F	",	//	'	Rocket_04_AP_F
		"	4Rnd_Bomb_04_F	",	//	'	Bomb_04_F
		"	500Rnd_Cannon_30mm_Plane_CAS_02_F	",	//	'	Cannon_30mm_HE_Plane_CAS_02_F
		"	2Rnd_Missile_AA_03_F	",	//	'	Missile_AA_03_F
		"	4Rnd_Missile_AGM_01_F	",	//	'	Missile_AGM_01_F
		"	20Rnd_Rocket_03_HE_F	",	//	'	Rocket_03_HE_F
		"	20Rnd_Rocket_03_AP_F	",	//	'	Rocket_03_AP_F
		"	2Rnd_Bomb_03_F	",	//	'	Bomb_03_F
		"	PylonRack_1Rnd_Missile_AA_04_F	",	//	Falchion-22	Missile_AA_04_F
		"	PylonMissile_1Rnd_Missile_AA_04_F	",	//	Falchion-22	Missile_AA_04_F
		"	PylonRack_1Rnd_AAA_missiles	",	//	ASRAAM	M_Air_AA
		"	PylonMissile_1Rnd_AAA_missiles	",	//	ASRAAM	M_Air_AA
		"	PylonRack_1Rnd_GAA_missiles	",	//	Zephyr	M_Zephyr
		"	PylonMissile_1Rnd_GAA_missiles	",	//	Zephyr	M_Zephyr
		"	PylonRack_1Rnd_Missile_AGM_02_F	",	//	Macer	Missile_AGM_02_F
		"	PylonRack_3Rnd_Missile_AGM_02_F	",	//	Macer 3x	Missile_AGM_02_F
		"	PylonRack_1Rnd_LG_scalpel	",	//	Scalpel	M_Scalpel_AT
		"	PylonMissile_1Rnd_LG_scalpel	",	//	Scalpel	M_Scalpel_AT
		"	PylonRack_3Rnd_LG_scalpel	",	//	Scalpel 3x	M_Scalpel_AT
		"	PylonRack_4Rnd_LG_scalpel	",	//	Scalpel 4x	M_Scalpel_AT
		"	PylonRack_7Rnd_Rocket_04_HE_F	",	//	Shrieker 7x HE	Rocket_04_HE_F
		"	PylonRack_7Rnd_Rocket_04_AP_F	",	//	Shrieker 7x AP	Rocket_04_AP_F
		"	PylonRack_12Rnd_PG_missiles	",	//	DAGR	M_PG_AT
		"	PylonRack_12Rnd_missiles	",	//	DAR	M_AT
		"	PylonMissile_1Rnd_Bomb_04_F	",	//	GBU-12	Bomb_04_F
		"	PylonMissile_1Rnd_Mk82_F	",	//	Mk82	Bo_Mk82
		"	PylonWeapon_300Rnd_20mm_shells	",	//	Twin Cannon 20mm	B_20mm
		"	PylonWeapon_2000Rnd_65x39_belt	",	//	Minigun 6.5 mm	B_65x39_Minigun_Caseless_Green_splash
		"	PylonRack_20Rnd_Rocket_03_HE_F	",	//	Tratnyr 20x HE	Rocket_03_HE_F
		"	PylonRack_20Rnd_Rocket_03_AP_F	",	//	Tratnyr 20x AP	Rocket_03_AP_F
		"	PylonRack_19Rnd_Rocket_Skyfire	",	//	Skyfire 19x	R_80mm_HE
		"	PylonRack_1Rnd_Missile_AA_03_F	",	//	Sahr-3	Missile_AA_03_F
		"	PylonMissile_1Rnd_Missile_AA_03_F	",	//	Sahr-3	Missile_AA_03_F
		"	PylonRack_1Rnd_Missile_AGM_01_F	",	//	Sharur	Missile_AGM_01_F
		"	PylonMissile_1Rnd_Bomb_03_F	",	//	LOM-250G	Bomb_03_F
		"	ATMine_Range_Mag	",	//	AT Mine	ATMine_Range_Ammo
		"	APERSMine_Range_Mag	",	//	APERS Mine	APERSMine_Range_Ammo
		"	APERSBoundingMine_Range_Mag	",	//	APERS Bounding Mine	APERSBoundingMine_Range_Ammo
		"	SLAMDirectionalMine_Wire_Mag	",	//	M6 SLAM Mine	SLAMDirectionalMine_Wire_Ammo
		"	APERSTripMine_Wire_Mag	",	//	APERS Tripwire Mine	APERSTripMine_Wire_Ammo
		"	ClaymoreDirectionalMine_Remote_Mag	",	//	Claymore Charge	ClaymoreDirectionalMine_Remote_Ammo
		"	SatchelCharge_Remote_Mag	",	//	Explosive Satchel	SatchelCharge_Remote_Ammo
		"	DemoCharge_Remote_Mag	",	//	Explosive Charge	DemoCharge_Remote_Ammo
		"	IEDUrbanBig_Remote_Mag	",	//	Large IED (Urban)	IEDUrbanBig_Remote_Ammo
		"	IEDLandBig_Remote_Mag	",	//	Large IED (Dug-in)	IEDLandBig_Remote_Ammo
		"	IEDUrbanSmall_Remote_Mag	",	//	Small IED (Urban)	IEDUrbanSmall_Remote_Ammo
		"	IEDLandSmall_Remote_Mag	",	//	Small IED (Dug-in)	IEDLandSmall_Remote_Ammo
		"	6Rnd_GreenSignal_F	",	//	6Rnd Signal Cylinder (Green)	Sub_F_Signal_Green
		"	6Rnd_RedSignal_F	",	//	6Rnd Signal Cylinder (Red)	Sub_F_Signal_Red
		"	10Rnd_338_Mag	",	//	.338 LM 10Rnd Mag	B_338_Ball
		"	130Rnd_338_Mag	",	//	.338 NM 130Rnd Belt	B_338_NM_Ball
		"	10Rnd_127x54_Mag	",	//	12.7 mm 10Rnd Mag	B_127x54_Ball
		"	150Rnd_93x64_Mag	",	//	9.3mm 150Rnd Belt	B_93x64_Ball
		"	10Rnd_93x64_DMR_05_Mag	",	//	9.3 mm 10Rnd Mag	B_93x64_Ball
		"	50Rnd_570x28_SMG_03	",	//	5.7 mm 50Rnd ADR-97 Mag	B_570x28_Ball
		"	10Rnd_9x21_Mag	",	//	9 mm 10Rnd Mag	B_9x21_Ball
		"	30Rnd_580x42_Mag_F	",	//	5.8 mm 30Rnd Mag	B_580x42_Ball_F
		"	30Rnd_580x42_Mag_Tracer_F	",	//	5.8 mm 30Rnd Tracer (Green) Mag	B_580x42_Ball_F
		"	100Rnd_580x42_Mag_F	",	//	5.8 mm 100Rnd Mag	B_580x42_Ball_F
		"	100Rnd_580x42_Mag_Tracer_F	",	//	5.8 mm 100Rnd Tracer (Green) Mag	B_580x42_Ball_F
		"	100Rnd_580x42_hex_Mag_F	",	//	5.8 mm 100Rnd Hex Mag	B_580x42_Ball_F
		"	100Rnd_580x42_hex_Mag_Tracer_F	",	//	5.8 mm 100Rnd Tracer (Green) Hex Mag	B_580x42_Ball_F
		"	100Rnd_580x42_ghex_Mag_F	",	//	5.8 mm 100Rnd Green Hex Mag	B_580x42_Ball_F
		"	100Rnd_580x42_ghex_Mag_Tracer_F	",	//	5.8 mm 100Rnd Tracer (Green) Green Hex Mag	B_580x42_Ball_F
		"	20Rnd_650x39_Cased_Mag_F	",	//	6.5 mm 20Rnd Mag	B_65x39_Case_green
		"	10Rnd_50BW_Mag_F	",	//	.50 BW 10Rnd Caseless Mag	B_50BW_Ball_F
		"	150Rnd_556x45_Drum_Mag_F	",	//	5.56 mm 150Rnd Mag	B_556x45_Ball_Tracer_Red
		"	150Rnd_556x45_Drum_Sand_Mag_F	",	//	5.56 mm 150Rnd Sand Mag	B_556x45_Ball_Tracer_Red
		"	150Rnd_556x45_Drum_Sand_Mag_Tracer_F	",	//	5.56 mm 150Rnd Tracer (Red) Sand Mag	B_556x45_Ball_Tracer_Red
		"	150Rnd_556x45_Drum_Green_Mag_F	",	//	5.56 mm 150Rnd Green Mag	B_556x45_Ball_Tracer_Red
		"	150Rnd_556x45_Drum_Green_Mag_Tracer_F	",	//	5.56 mm 150Rnd Tracer (Red) Green Mag	B_556x45_Ball_Tracer_Red
		"	150Rnd_556x45_Drum_Mag_Tracer_F	",	//	5.56 mm 150Rnd Tracer (Red) Mag	B_556x45_Ball_Tracer_Red
		"	30Rnd_762x39_Mag_F	",	//	7.62 mm 30Rnd AKM Reload Tracer (Yellow) Mag	B_762x39_Ball_F
		"	30Rnd_762x39_Mag_Green_F	",	//	7.62 mm 30Rnd AKM Reload Tracer (Green) Mag	B_762x39_Ball_Green_F
		"	30Rnd_762x39_Mag_Tracer_F	",	//	7.62 mm 30Rnd AKM Tracer (Yellow) Mag	B_762x39_Ball_F
		"	30Rnd_762x39_Mag_Tracer_Green_F	",	//	7.62 mm 30Rnd AKM Tracer (Green) Mag	B_762x39_Ball_Green_F
		"	30Rnd_762x39_AK12_Mag_F	",	//	7.62 mm 30rnd AK12 Mag	B_762x39_Ball_Green_F
		"	30Rnd_762x39_AK12_Mag_Tracer_F	",	//	7.62 mm 30rnd AK12 Tracer Mag	B_762x39_Ball_Green_F
		"	30Rnd_545x39_Mag_F	",	//	5.45 mm 30Rnd Reload Tracer (Yellow) Mag	B_545x39_Ball_F
		"	30Rnd_545x39_Mag_Green_F	",	//	5.45 mm 30Rnd Reload Tracer (Green) Mag	B_545x39_Ball_Green_F
		"	30Rnd_545x39_Mag_Tracer_F	",	//	5.45 mm 30Rnd Tracer (Yellow) Mag	B_545x39_Ball_F
		"	30Rnd_545x39_Mag_Tracer_Green_F	",	//	5.45 mm 30Rnd Tracer (Green) Mag	B_545x39_Ball_Green_F
		"	200Rnd_556x45_Box_F	",	//	5.56 mm 200Rnd Reload Tracer (Yellow) Box	B_556x45_Ball_Tracer_Yellow
		"	200Rnd_556x45_Box_Red_F	",	//	5.56 mm 200Rnd Reload Tracer (Red) Box	B_556x45_Ball_Tracer_Red
		"	200Rnd_556x45_Box_Tracer_F	",	//	5.56 mm 200Rnd Tracer (Yellow) Box	B_556x45_Ball_Tracer_Yellow
		"	200Rnd_556x45_Box_Tracer_Red_F	",	//	5.56 mm 200Rnd Tracer (Red) Box	B_556x45_Ball_Tracer_Red
		"	500Rnd_65x39_Belt	",	//	6.5 mm 500Rnd Belt Case	B_65x39_Caseless
		"	500Rnd_65x39_Belt_Tracer_Red_Splash	",	//	6.5 mm 500Rnd Belt Case Tracer (Red)	B_65x39_Minigun_Caseless_Red_splash
		"	500Rnd_65x39_Belt_Tracer_Green_Splash	",	//	6.5 mm 500Rnd Belt Case Tracer (Green)	B_65x39_Minigun_Caseless_Green_splash
		"	500Rnd_65x39_Belt_Tracer_Yellow_Splash	",	//	6.5 mm 500Rnd Belt Case Tracer (Yellow)	B_65x39_Minigun_Caseless_Yellow_splash
		"	RPG7_F	",	//	PG-7VM HEAT Grenade	R_PG7_F
		"	4Rnd_LG_Jian	",	//	Jian	M_Jian_AT
		"	4000Rnd_20mm_Tracer_Red_shells	",	//	20 mm Shells	B_20mm_Tracer_Red
		"	160Rnd_40mm_APFSDS_Tracer_Red_shells	",	//	40 mm APFSDS-T	B_40mm_APFSDS_Tracer_Red
		"	240Rnd_40mm_GPR_Tracer_Red_shells	",	//	40 mm GPR-T	B_40mm_GPR_Tracer_Red
		"	100Rnd_105mm_HEAT_MP	",	//	105mm HEAT-MP	Sh_105mm_HEAT_MP
		"	magazine_Missile_rim116_x21	",	//	Spartan AA	ammo_Missile_rim116
		"	magazine_Missile_rim162_x8	",	//	Centurion AA	ammo_Missile_rim162
		"	magazine_Cannon_Phalanx_x1550	",	//	Praetorian 20mm	ammo_AAA_Gun35mm_AA
		"	magazine_Fighter01_Gun20mm_AA_x450	",	//	M61 20mm 450 rnd	ammo_Fighter01_Gun20mm_AA
		"	magazine_Fighter04_Gun20mm_AA_x150	",	//	M61 20mm 150 rbd	ammo_Fighter04_Gun20mm_AA
		"	magazine_Fighter04_Gun20mm_AA_x250	",	//	M61 20mm 150 rbd	ammo_Fighter04_Gun20mm_AA
		"	magazine_Missile_AMRAAM_C_x1	",	//	AMRAAM C AA x1	ammo_Missile_AMRAAM_C
		"	magazine_Missile_AMRAAM_D_x1	",	//	AMRAAM D AA x1	ammo_Missile_AMRAAM_D
		"	magazine_Missile_BIM9X_x1	",	//	BIM 9X AA x1	ammo_Missile_BIM9X
		"	magazine_Missile_AGM_02_x1	",	//	Macer II AGM x1	Missile_AGM_02_F
		"	magazine_Bomb_GBU12_x1	",	//	GBU 12 LGB x1	Bomb_04_F
		"	PylonMissile_Missile_AMRAAM_C_x1	",	//	AMRAAM C AA x1	ammo_Missile_AMRAAM_C
		"	PylonRack_Missile_AMRAAM_C_x1	",	//	AMRAAM C AA x1	ammo_Missile_AMRAAM_C
		"	PylonRack_Missile_AMRAAM_C_x2	",	//	AMRAAM C AA x2	ammo_Missile_AMRAAM_C
		"	PylonMissile_Missile_AMRAAM_D_x1	",	//	AMRAAM D AA x1	ammo_Missile_AMRAAM_D
		"	PylonMissile_Missile_AMRAAM_D_INT_x1	",	//	AMRAAM D AA x1	ammo_Missile_AMRAAM_D
		"	PylonRack_Missile_AMRAAM_D_x1	",	//	AMRAAM D AA x1	ammo_Missile_AMRAAM_D
		"	PylonRack_Missile_AMRAAM_D_x2	",	//	AMRAAM D AA x2	ammo_Missile_AMRAAM_D
		"	PylonMissile_Missile_BIM9X_x1	",	//	BIM 9X AA x1	ammo_Missile_BIM9X
		"	PylonRack_Missile_BIM9X_x1	",	//	BIM 9X AA x1	ammo_Missile_BIM9X
		"	PylonRack_Missile_BIM9X_x2	",	//	BIM 9X AA x2	ammo_Missile_BIM9X
		"	PylonMissile_Missile_AGM_02_x1	",	//	Macer II AGM x1	Missile_AGM_02_F
		"	PylonMissile_Missile_AGM_02_x2	",	//	Macer II AGM x2	Missile_AGM_02_F
		"	PylonRack_Missile_AGM_02_x1	",	//	Macer II AGM x1	Missile_AGM_02_F
		"	PylonRack_Missile_AGM_02_x2	",	//	Macer II AGM x2	Missile_AGM_02_F
		"	PylonMissile_Bomb_GBU12_x1	",	//	GBU 12 LGB x1	Bomb_04_F
		"	PylonRack_Bomb_GBU12_x2	",	//	GBU 12 LGB x2	Bomb_04_F
		"	magazine_Fighter02_Gun30mm_AA_x180	",	//	Gsh 30mm 180 rnd	ammo_Fighter02_Gun30mm_AA
		"	magazine_Missile_AA_R73_x1	",	//	R73 SR AA x1	ammo_Missile_AA_R73
		"	magazine_Missile_AA_R77_x1	",	//	R77 MR AA x1	ammo_Missile_AA_R77
		"	magazine_Missile_AGM_KH25_x1	",	//	KH25 AGM x1	Missile_AGM_01_F
		"	magazine_Bomb_KAB250_x1	",	//	KAB 250 LGB x1	Bomb_03_F
		"	PylonMissile_Missile_AA_R73_x1	",	//	R73 SR AA x1	ammo_Missile_AA_R73
		"	PylonMissile_Missile_AA_R77_x1	",	//	R77 MR AA x1	ammo_Missile_AA_R77
		"	PylonMissile_Missile_AA_R77_INT_x1	",	//	R77 MR AA x1	ammo_Missile_AA_R77
		"	PylonMissile_Missile_AGM_KH25_x1	",	//	KH25 AGM x1	Missile_AGM_01_F
		"	PylonMissile_Missile_AGM_KH25_INT_x1	",	//	KH25 AGM x1	Missile_AGM_01_F
		"	PylonMissile_Bomb_KAB250_x1	",	//	KAB 250 LGB x1	Bomb_03_F
		"	1Rnd_Leaflets_West_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_East_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Guer_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Civ_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_01_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_02_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_03_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_04_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_05_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_06_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_07_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_08_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_09_F	",	//	Leaflets	Bo_Leaflets
		"	1Rnd_Leaflets_Custom_10_F	",	//	Leaflets	Bo_Leaflets
		"	4Rnd_BombCluster_01_F	",	//	CBU-85	BombCluster_01_Ammo_F
		"	4Rnd_BombCluster_02_F	",	//	RBK-500F	BombCluster_02_Ammo_F
		"	4Rnd_BombCluster_03_F	",	//	BL778	BombCluster_03_Ammo_F
		"	PylonRack_4Rnd_BombDemine_01_F	",	//	Demining Charge	BombDemine_01_Ammo_F
		"	PylonRack_4Rnd_BombDemine_01_Dummy_F	",	//	Demining Charge (Dummy)	BombDemine_01_DummyAmmo_F
		"	PylonMissile_1Rnd_BombCluster_01_F	",	//	CBU-85 Cluster x1	BombCluster_01_Ammo_F
		"	PylonRack_2Rnd_BombCluster_01_F	",	//	CBU-85 Cluster x2	BombCluster_01_Ammo_F
		"	PylonMissile_1Rnd_BombCluster_02_F	",	//	RBK-500F Cluster x1	BombCluster_02_Ammo_F
		"	PylonMissile_1Rnd_BombCluster_02_cap_F	",	//	RBK-500F Cluster x1	BombCluster_02_cap_Ammo_F
		"	PylonMissile_1Rnd_BombCluster_03_F	",	//	BL778 Cluster x1	BombCluster_03_Ammo_F
		"	PylonRack_2Rnd_BombCluster_03_F	",	//	BL778 Cluster x2	BombCluster_03_Ammo_F
		"	Pylon_1Rnd_Leaflets_West_F	",	//	Leaflets (NATO)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_East_F	",	//	Leaflets (CSAT)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Guer_F	",	//	Leaflets (AAF)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Civ_F	",	//	Leaflets (IDAP)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_01_F	",	//	Leaflets (Custom 01)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_02_F	",	//	Leaflets (Custom 02)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_03_F	",	//	Leaflets (Custom 03)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_04_F	",	//	Leaflets (Custom 04)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_05_F	",	//	Leaflets (Custom 05)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_06_F	",	//	Leaflets (Custom 06)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_07_F	",	//	Leaflets (Custom 07)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_08_F	",	//	Leaflets (Custom 08)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_09_F	",	//	Leaflets (Custom 09)	Bo_Leaflets
		"	Pylon_1Rnd_Leaflets_Custom_10_F	",	//	Leaflets (Custom 10)	Bo_Leaflets
		"	APERSMineDispenser_Mag	",	//	APERS Mine Dispenser	APERSMineDispenser_Ammo
		"	TrainingMine_Mag	",	//	Training Mine	TrainingMine_Ammo
		"	200Rnd_338_Mag	",	//	.338 NM 130Rnd Belt	B_338_NM_Ball
		"	4Rnd_120mm_cannon_missiles	",	//	120mm ATGM	M_120mm_cannon_ATGM
		"	4Rnd_120mm_LG_cannon_missiles	",	//	120mm ATGM LG	M_120mm_cannon_ATGM_LG
		"	4Rnd_125mm_cannon_missiles	",	//	125mm ATGM	M_125mm_cannon_ATGM
		"	60Rnd_30mm_MP_shells_Tracer_Green	",	//	30 mm MP-T	B_30mm_MP_Tracer_Green
		"	Vorona_HEAT	",	//	9M135 HEAT Missile	M_Vorona_HEAT
		"	Vorona_HE	",	//	9M135 HE Missile	M_Vorona_HE
		"	SPG9_HEAT	",	//	PG-9N Round	M_SPG9_HEAT
		"	12rnd_SPG9_HEAT	",	//	PG-9N Round	M_SPG9_HEAT
		"	SPG9_HE	",	//	OG-9VM Round	M_SPG9_HE
		"	8rnd_SPG9_HE	",	//	OG-9VM Round	M_SPG9_HE
		"	4Rnd_70mm_SAAMI_missiles	",	//	SAAMI Missile	M_70mm_SAAMI
		"	2Rnd_127mm_Firefist_missiles	",	//	FireFIST ATGM Missile	M_127mm_Firefist_AT
		"	MRAWS_HEAT_F	",	//	MAAWS HEAT 75 Round	R_MRAAWS_HEAT_F
		"	MRAWS_HE_F	",	//	MAAWS HE 44 Round	R_MRAAWS_HE_F
		"	MRAWS_HEAT55_F	",	//	MAAWS HEAT 55 Round	R_MRAAWS_HEAT55_F
		"	60Rnd_20mm_HE_shells	",	//	20 mm Shells	B_20mm
		"	60Rnd_20mm_AP_shells	",	//	20 mm Shells	B_20mm_AP
		"	magazine_Missiles_Cruise_01_x18	",	//	Cruise Missile HE	ammo_Missile_Cruise_01
		"	magazine_Missiles_Cruise_01_Cluster_x18	",	//	Cruise Missile Cluster	ammo_Missile_Cruise_01_Cluster
		"	magazine_ShipCannon_120mm_HE_shells_x32	",	//	HE Shells	ammo_ShipCannon_120mm_HE
		"	magazine_ShipCannon_120mm_smoke_shells_x6	",	//	Smoke (White)	ammo_ShipCannon_120mm_smoke
		"	magazine_ShipCannon_120mm_HE_guided_shells_x2	",	//	Guided	ammo_ShipCannon_120mm_HE_guided
		"	magazine_ShipCannon_120mm_HE_LG_shells_x2	",	//	Laser Guided	ammo_ShipCannon_120mm_HE_LG
		"	magazine_ShipCannon_120mm_mine_shells_x6	",	//	Mine Cluster	ammo_ShipCannon_120mm_mine
		"	magazine_ShipCannon_120mm_HE_cluster_shells_x2	",	//	Cluster Shells	ammo_ShipCannon_120mm_HE_cluster
		"	magazine_ShipCannon_120mm_AT_mine_shells_x6	",	//	AT Mine Cluster	ammo_ShipCannon_120mm_AT_mine
		"	magazine_Missile_mim145_x4	",	//	Defender AA	ammo_Missile_mim145
		"	magazine_Missile_s750_x4	",	//	Rhea AA	ammo_Missile_s750
		"	magazine_Missile_HARM_x1	",	//	AGM-88C HARM x1	ammo_Missile_HARM
		"	magazine_Bomb_SDB_x1	",	//	GBU SDB x1	ammo_Bomb_SDB
		"	PylonMissile_Missile_HARM_x1	",	//	AGM-88C HARM x1	ammo_Missile_HARM
		"	PylonRack_Missile_HARM_x1	",	//	AGM-88C HARM x1	ammo_Missile_HARM
		"	PylonMissile_Missile_HARM_INT_x1	",	//	AGM-88C HARM x1	ammo_Missile_HARM
		"	PylonRack_Bomb_SDB_x4	",	//	GBU SDB x4	ammo_Bomb_SDB
		"	magazine_Missile_KH58_x1	",	//	KH58 ARM x1	ammo_Missile_KH58
		"	PylonMissile_Missile_KH58_x1	",	//	KH58 ARM x1	ammo_Missile_KH58
		"	PylonMissile_Missile_KH58_INT_x1	",	//	KH58 ARM x1	ammo_Missile_KH58
		"	75Rnd_762x39_Mag_F	",	//	7.62 mm 75Rnd AKM Mag	B_762x39_Ball_F
		"	75Rnd_762x39_Mag_Tracer_F	",	//	7.62 mm 75Rnd AKM Tracer Mag	B_762x39_Ball_F
		"	30Rnd_762x39_AK12_Mag_Green_F	",	//	'	
		"	30Rnd_762x39_AK12_Mag_Tracer_Green_F	",	//	'	
		"	30rnd_762x39_AK12_Lush_Mag_F	",	//	7.62 mm 30rnd AK12 Khaki Mag	B_762x39_Ball_Green_F
		"	30rnd_762x39_AK12_Lush_Mag_Tracer_F	",	//	7.62 mm 30rnd AK12 Tracer Khaki Mag	B_762x39_Ball_Green_F
		"	30rnd_762x39_AK12_Arid_Mag_F	",	//	7.62 mm 30rnd AK12 Sand Mag	B_762x39_Ball_Green_F
		"	30rnd_762x39_AK12_Arid_Mag_Tracer_F	",	//	7.62 mm 30rnd AK12 Tracer Sand Mag	B_762x39_Ball_Green_F
		"	75rnd_762x39_AK12_Mag_F	",	//	7.62 mm 75rnd AK12 Mag	B_762x39_Ball_Green_F
		"	75rnd_762x39_AK12_Mag_Tracer_F	",	//	7.62 mm 75rnd AK12 Tracer Mag	B_762x39_Ball_Green_F
		"	75rnd_762x39_AK12_Lush_Mag_F	",	//	7.62 mm 75rnd AK12 Lush Mag	B_762x39_Ball_Green_F
		"	75rnd_762x39_AK12_Lush_Mag_Tracer_F	",	//	7.62 mm 75rnd AK12 Tracer Lush Mag	B_762x39_Ball_Green_F
		"	75rnd_762x39_AK12_Arid_Mag_F	",	//	7.62 mm 75rnd AK12 Arid Mag	B_762x39_Ball_Green_F
		"	75rnd_762x39_AK12_Arid_Mag_Tracer_F	",	//	7.62 mm 75rnd AK12 Tracer Arid Mag	B_762x39_Ball_Green_F
		"	10Rnd_Mk14_762x51_Mag	",	//	7.62 mm 10rnd Mk14 Mag	B_762x51_Ball
		"	30Rnd_65x39_caseless_msbs_mag	",	//	6.5 mm 30Rnd Promet Mag	B_65x39_Caseless
		"	30Rnd_65x39_caseless_msbs_mag_Tracer	",	//	6.5 mm 30Rnd Promet Tracer Mag	B_65x39_Caseless
		"	2Rnd_12Gauge_Pellets	",	//	12 Gauge 2Rnd Pellets	B_12Gauge_Pellets_Submunition
		"	2Rnd_12Gauge_Slug	",	//	12 Gauge 2Rnd Slug	B_12Gauge_Slug_NoCartridge
		"	6Rnd_12Gauge_Pellets	",	//	12 Gauge 6Rnd Pellets	B_12Gauge_Pellets_Submunition
		"	6Rnd_12Gauge_Slug	",	//	12 Gauge 6Rnd Slug	B_12Gauge_Slug_NoCartridge
		"	15Rnd_12Gauge_Pellets	",	//	12 Gauge 15Rnd Pellets	B_12Gauge_HD_Pellets_Submunition
		"	15Rnd_12Gauge_Slug	",	//	12 Gauge 15Rnd Slug	B_12Gauge_Slug_NoCartridge
		"	O_R_IR_Grenade	",	//	IR Grenade [Spetsnaz]	O_IRStrobe
		"	I_E_IR_Grenade	",	//	IR Grenade [LDF]	I_IRStrobe
		"	ProbingWeapon_01_magazine	",	//	'	ProbingBeam_01_F
		"	ProbingWeapon_02_magazine	",	//	'	ProbingBeam_02_F
		"	Dummy_Magazine_Base	",	//	'	Default
		"	ESD_01_DummyMagazine_base	",	//	'	Default
		"	ESD_01_DummyMagazine_1	",	//	'	Default
		"	ESD_01_DummyMagazine_2	",	//	'	Default
		"	ESD_01_DummyMagazine_3	",	//	'	Default
		"	ESD_01_DummyMagazine_4	",	//	'	Default
		"	ESD_01_DummyMagazine_5	",	//	'	Default
		"	ESD_01_DummyMagazine_6	",	//	'	Default
		"	ESD_01_DummyMagazine_7	",	//	'	Default
		"	ESD_01_DummyMagazine_8	",	//	'	Default
		"	ESD_01_DummyMagazine_9	",	//	'	Default
		"	ESD_01_DummyMagazine_10	",	//	'	Default
		"	ESD_01_DummyMagazine_11	",	//	'	Default
		"	ESD_01_DummyMagazine_12	",	//	'	Default
		"	ESD_01_DummyMagazine_13	",	//	'	Default
		"	ESD_01_DummyMagazine_14	",	//	'	Default
		"	ESD_01_DummyMagazine_15	",	//	'	Default
		"	ESD_01_DummyMagazine_16	",	//	'	Default
		"	ESD_01_DummyMagazine_17	",	//	'	Default
		"	ESD_01_DummyMagazine_18	",	//	'	Default
		"	ESD_01_DummyMagazine_19	",	//	'	Default
		"	ESD_01_DummyMagazine_20	",	//	'	Default
		"	OM_Magazine	",	//	'	
		"	Antibiotic	",	//	Antibiotics	
		"	Antimalaricum	",	//	Antimalarial Pills	
		"	AntimalaricumVaccine	",	//	Atrox Counteragent	
		"	Bandage	",	//	Bandages	
		"	Files	",	//	Files	
		"	Files_diary	",	//	Journal	
		"	Files_researchNotes	",	//	Research Notes	
		"	FileTopSecret	",	//	File (Top Secret)	
		"	FileNetworkStructure	",	//	Network Structure Plans	
		"	FilesSecret	",	//	File (Top Secret)	
		"	DocumentsSecret	",	//	File	
		"	Wallet_ID	",	//	Wallet (ID)	
		"	Keys	",	//	Keys	
		"	Csat_Id_01	",	//	Access Card (v1) [CSAT]	
		"	Csat_Id_02	",	//	Access Card (v2) [CSAT]	
		"	Csat_Id_03	",	//	Access Card (v3) [CSAT]	
		"	Csat_Id_04	",	//	Access Card (v4) [CSAT]	
		"	Csat_Id_05	",	//	Access Card (v5) [CSAT]	
		"	Laptop_Unfolded	",	//	Laptop (Open)	
		"	Laptop_Closed	",	//	Laptop (Closed)	
		"	SatPhone	",	//	Satellite Phone	
		"	MobilePhone	",	//	Mobile Phone (Old)	
		"	SmartPhone	",	//	Mobile Phone (New)	
		"	FlashDisk	",	//	Flash Drive	
		"	ButaneCanister	",	//	Butane Canister (Full)	
		"	Money	",	//	Money	
		"	Money_bunch	",	//	Money (Notes)	
		"	Money_roll	",	//	Money (Roll)	
		"	Money_stack	",	//	Money (Stack)	
		"	Money_stack_quest	",	//	Money (Large Stack)	
		"	Sleeping_bag_folded_01	",	//	Sleeping Bag (Folded)	
		"	Drone_Range_Mag	",	//	AT Mine	Drone_explosive_ammo
		"	Drone_Range_Mag_dummy	",	//	AT Mine	Drone_explosive_ammo_dummy
		"	Alien_Magazine_Base	",	//	'	
		"	AlienBeam_01_Base_Mag	",	//	'	
		"	AlienBeam_01_Mag	",	//	Beam	AlienBeam_01_Ammo_F
		"	GravityCannon_01_Base_Magazine	",	//	'	
		"	GravityCannon_01_DummyMagazine	",	//	'	Default
		"	GravityCannon_01_Magazine	",	//	Gravity cannon	GravityCannon_Projectile_01_F
		"	GravityShotgun_01_Magazine	",	//	Gravity shotgun	GravityCannon_SmallProjectile_01_F
		"	GravityCannon_01_AIMagazine	",	//	'	GravityCannon_Projectile_01_AI_F
		"	CM_Base_Magazine	",	//	'	
		"	300Rnd_Refract_Magazine	",	//	Refract	CM_Refract_Ammo
		"	300Rnd_Visual_Magazine	",	//	Visual	CM_Visual_Ammo
		"	300Rnd_Light_Magazine	",	//	Light	CM_Light_Ammo
		"	300Rnd_Light_Fake_Magazine	",	//	Light	CM_Light_Fake_Ammo
		"	300Rnd_Decoy_Magazine	",	//	Decoy	CM_Decoy_Ammo
		"	300Rnd_Universal_Magazine	",	//	Universal	CM_Universal_Ammo
		"	300Rnd_AntiMissile_Magazine	",	//	Hardkill	CM_AntiMissile_Ammo
		"	300Rnd_GravityBurst_Magazine	",	//	Gravity Burst	CM_GravityBurst_Ammo
		"	300Rnd_GrenadeDefence_Magazine	",	//	Gravity Burst	CM_GrenadeDefence_Ammo
		"	AlienDrone_01_Sounds_DummyMagazine	",	//	'	AlienDrone_01_Sounds_DummyAmmo
		"	AlienDrone_02_Sounds_DummyMagazine	",	//	'	AlienDrone_01_Sounds_DummyAmmo
		"	AlienDrone_03_Sounds_DummyMagazine	",	//	'	AlienDrone_01_Sounds_DummyAmmo
		"	AlienDrone_04_Sounds_DummyMagazine	",	//	'	AlienDrone_01_Sounds_DummyAmmo
		"	AlienDrone_05_Sounds_DummyMagazine	",	//	'	AlienDrone_01_Sounds_DummyAmmo
		"	AlienDrone_06_Sounds_DummyMagazine	",	//	'	AlienDrone_01_Sounds_DummyAmmo
		"	AlienDrone_07_Sounds_DummyMagazine	",	//	'	AlienDrone_01_Sounds_DummyAmmo
		"	30Rnd_556x45_Stanag_Blank	",	//	Blank round magazine	B_BlankRound
		"	30Rnd_65x39_caseless_blank_mag	",	//	6.5 mm 30Rnd Blank Mag	B_BlankRound_caseless
		"	100Rnd_65x39_caseless_blank_mag	",	//	6.5 mm 100Rnd Blank Mag	B_BlankRound_caseless
		"	30Rnd_65x39_caseless_msbs_blank_mag	",	//	6.5 mm 30Rnd Promet Blank Mag	B_BlankRound_caseless
		"	200Rnd_65x39_cased_box_blank	",	//	6.5 mm 200Rnd Blank Belt	B_BlankRound_caseless
		"	30Rnd_65x39_caseless_green_blank_mag	",	//	6.5 mm 30Rnd Blank Mag	B_BlankRound_caseless
		"	SwarmMissile_01_mag	",	//	'	SwarmMissile_01_Ammo_F

				
		//CUP Magazines Class List
		//	AA-12	Shotgun		CUP_sgun_AA12
		"CUP_20Rnd_B_AA12_Pellets",
		"CUP_20Rnd_B_AA12_74Slug",
		//"CUP_20Rnd_B_AA12_HE",
		//	AK-74	Assault Rifle		CUP_arifle_AK74
		"CUP_30Rnd_545x39_AK_M",
		"CUP_30Rnd_TE1_Green_Tracer_545x39_AK_M",
		"CUP_30Rnd_TE1_Red_Tracer_545x39_AK_M",
		"CUP_30Rnd_TE1_White_Tracer_545x39_AK_M",
		"CUP_30Rnd_TE1_Yellow_Tracer_545x39_AK_M",
		//	AKM	Assault Rifle		CUP_arifle_AKM
		"CUP_30Rnd_762x39_AK47_M",
		//	RPK	Assault Rifle		CUP_arifle_RPK74
		"CUP_75Rnd_TE4_LRT4_Green_Tracer_545x39_RPK_M",
		//	AS50	Sniper Rifle		CUP_srifle_AS50_SBPMII
		"CUP_5Rnd_127x99_as50_M",
		//	L115A1 (Desert)	Sniper Rifle		CUP_srifle_AWM_des_SBPMII
		"CUP_5Rnd_86x70_L115A1",
		//	PP-19 Bizon	SMG		CUP_smg_bizon
		"CUP_64Rnd_9x19_Bizon_M",
		"CUP_64Rnd_Green_Tracer_9x19_Bizon_M",
		"CUP_64Rnd_Red_Tracer_9x19_Bizon_M",
		"CUP_64Rnd_White_Tracer_9x19_Bizon_M",
		"CUP_64Rnd_Yellow_Tracer_9x19_Bizon_M",
		//	M1911	Handgun		CUP_hgun_Colt1911
		"CUP_7Rnd_45ACP_1911",
		//	CZ 75 P-07 Compact	Handgun		CUP_hgun_Compact
		"CUP_10Rnd_9x19_Compact",
		//	CZ 75 P-07 Duty	Handgun		CUP_hgun_Duty_M3X
		"16Rnd_9x21_Mag",
		//	CZ 750 S1 M1	Sniper Rifle		CUP_srifle_CZ750_SOS_bipod
		"CUP_10Rnd_762x51_CZ750_Tracer",
		"CUP_10Rnd_762x51_CZ750",
		//	CZ 805 A1	Assault Rifle		CUP_arifle_CZ805_A1_ZDDot_Laser
		"CUP_30Rnd_556x45_Stanag",
		"CUP_30Rnd_556x45_G36",
		"CUP_30Rnd_TE1_Red_Tracer_556x45_G36",
		"CUP_30Rnd_TE1_Green_Tracer_556x45_G36",
		"CUP_30Rnd_TE1_Yellow_Tracer_556x45_G36",
		"CUP_100Rnd_556x45_BetaCMag",
		"CUP_100Rnd_TE1_Red_Tracer_556x45_BetaCMag",
		"CUP_100Rnd_TE1_Green_Tracer_556x45_BetaCMag",
		"CUP_100Rnd_TE1_Yellow_Tracer_556x45_BetaCMag",
		"30Rnd_556x45_Stanag",
		"30Rnd_556x45_Stanag_Tracer_Red",
		"30Rnd_556x45_Stanag_Tracer_Green",
		"30Rnd_556x45_Stanag_Tracer_Yellow",
		"CUP_20Rnd_556x45_Stanag",
		//	CZ 805 B GL	Assault Rifle		CUP_arifle_CZ805B_GL_ACOG_Laser
		"CUP_20Rnd_762x51_CZ805B",
		"CUP_20Rnd_TE1_Yellow_Tracer_762x51_CZ805B",
		"CUP_20Rnd_TE1_Red_Tracer_762x51_CZ805B",
		"CUP_20Rnd_TE1_Green_Tracer_762x51_CZ805B",
		"CUP_20Rnd_TE1_White_Tracer_762x51_CZ805B",
		//	M14 DMR	Sniper Rifle		CUP_srifle_DMR_LeupoldMk4
		"CUP_20Rnd_762x51_DMR",
		"CUP_20Rnd_TE1_Yellow_Tracer_762x51_DMR",
		"CUP_20Rnd_TE1_Red_Tracer_762x51_DMR",
		"CUP_20Rnd_TE1_Green_Tracer_762x51_DMR",
		"CUP_20Rnd_TE1_White_Tracer_762x51_DMR",
		//	SMG		CUP_smg_EVO_MRad_Flashlight
		"CUP_30Rnd_9x19_EVO",
		"30Rnd_9x21_Mag",
		//	FN FAL	Assault Rifle		CUP_arifle_FNFAL
		"CUP_20Rnd_762x51_FNFAL_M",
		//	Glock 17	Handgun		CUP_hgun_glock17_flashlight
		"CUP_17Rnd_9x19_glock17",
		//	M32	Grenadelauncher		CUP_glaunch_M32
		"CUP_6Rnd_HE_M203",
		"CUP_6Rnd_FlareWhite_M203",
		"CUP_6Rnd_FlareGreen_M203",
		"CUP_6Rnd_FlareRed_M203",
		"CUP_6Rnd_FlareYellow_M203",
		"CUP_6Rnd_Smoke_M203",
		"CUP_6Rnd_SmokeRed_M203",
		"CUP_6Rnd_SmokeGreen_M203",
		"CUP_6Rnd_SmokeYellow_M203",
		"CUP_1Rnd_HE_M203",
		"CUP_1Rnd_HEDP_M203",
		"CUP_FlareWhite_M203",
		"CUP_FlareGreen_M203",
		"CUP_FlareRed_M203",
		"CUP_FlareYellow_M203",
		"CUP_1Rnd_Smoke_M203",
		"CUP_1Rnd_SmokeRed_M203",
		"CUP_1Rnd_SmokeGreen_M203",
		"CUP_1Rnd_SmokeYellow_M203",
		"1Rnd_HE_Grenade_shell",
		"UGL_FlareWhite_F",
		"UGL_FlareGreen_F",
		"UGL_FlareRed_F",
		"UGL_FlareYellow_F",
		"UGL_FlareCIR_F",
		"1Rnd_Smoke_Grenade_shell",
		"1Rnd_SmokeRed_Grenade_shell",
		"1Rnd_SmokeGreen_Grenade_shell",
		"1Rnd_SmokeYellow_Grenade_shell",
		"1Rnd_SmokePurple_Grenade_shell",
		"1Rnd_SmokeBlue_Grenade_shell",
		"1Rnd_SmokeOrange_Grenade_shell",
		//	CZ 550	Sniper Rifle		CUP_srifle_CZ550
		"CUP_5x_22_LR_17_HMR_M",
		//	Igla 9K38	Launcher		CUP_launch_Igla
		"CUP_Igla_M",
		//	FGM-148 Javelin	Launcher		CUP_launch_Javelin
		//"CUP_Javelin_M",
		//	KSVK	Assault Rifle		CUP_arifle_ksvk_PSO3
		"CUP_5Rnd_127x108_KSVK_M",
		//	L7A2	Machinegun		CUP_lmg_L7A2
		"CUP_100Rnd_TE4_LRT4_White_Tracer_762x51_Belt_M",
		"CUP_100Rnd_TE4_LRT4_Red_Tracer_762x51_Belt_M",
		//	L110A1	Machinegun		CUP_lmg_L110A1_Aim_Laser
		"CUP_200Rnd_TE4_Red_Tracer_556x45_M249",
		"CUP_200Rnd_TE4_Yellow_Tracer_556x45_M249",
		"CUP_200Rnd_TE1_Red_Tracer_556x45_M249",
		"CUP_100Rnd_TE4_Green_Tracer_556x45_M249",
		"CUP_100Rnd_TE4_Red_Tracer_556x45_M249",
		"CUP_100Rnd_TE4_Yellow_Tracer_556x45_M249",
		"CUP_200Rnd_TE4_Green_Tracer_556x45_L110A1",
		"CUP_200Rnd_TE4_Red_Tracer_556x45_L110A1",
		"CUP_200Rnd_TE4_Yellow_Tracer_556x45_L110A1",
		//	Lee Enfield	Sniper Rifle		CUP_srifle_LeeEnfield
		"CUP_10x_303_M",
		//	M9	Handgun		CUP_hgun_M9
		"CUP_15Rnd_9x19_M9",
		//	M14	Sniper Rifle		CUP_srifle_M15_Aim
		"20Rnd_762x51_Mag",
		//	M24 (woodland)	Sniper Rifle		CUP_srifle_M24_wdl_LeupoldMk4LRT
		"CUP_5Rnd_762x51_M24",
		//	M47 Dragon	Launcher		CUP_launch_M47
		"CUP_Dragon_EP1_M",
		//	M107	Sniper Rifle		CUP_srifle_M107_LeupoldVX3
		"CUP_10Rnd_127x99_m107",
		//	M110	Sniper Rifle		CUP_srifle_M110_ANPAS13c2
		"CUP_20Rnd_762x51_B_M110",
		"CUP_20Rnd_TE1_Yellow_Tracer_762x51_M110",
		"CUP_20Rnd_TE1_Red_Tracer_762x51_M110",
		"CUP_20Rnd_TE1_Green_Tracer_762x51_M110",
		"CUP_20Rnd_TE1_White_Tracer_762x51_M110",
		//	M136 AT-4 launcher	Launcher		CUP_launch_M136
		//"CUP_M136_M",
		//	M1014	Shotgun		CUP_sgun_M1014
		"CUP_8Rnd_B_Beneli_74Slug",
		//	M3 MAAWS	Launcher		CUP_launch_MAAWS_Scope
		//"CUP_MAAWS_HEAT_M",
		//"CUP_MAAWS_HEDP_M",
		//	Makarov	Handgun		CUP_hgun_Makarov
		"CUP_8Rnd_9x18_Makarov_M",
		"CUP_8Rnd_9x18_MakarovSD_M",
		//	Metis Launcher	Launcher		CUP_launch_Metis
		//"CUP_AT13_M",
		//	Micro UZI PDW	Handgun		CUP_hgun_MicroUzi
		"CUP_30Rnd_9x19_UZI",
		//	MP5 SD6	SMG		CUP_smg_MP5SD6
		"CUP_30Rnd_9x19_MP5",
		//	NLAW	Launcher		CUP_launch_NLAW
		//"CUP_NLAW_M",
		//	CZ 75 SP-01 Phantom	Handgun		CUP_hgun_Phantom_Flashlight
		"CUP_18Rnd_9x19_Phantom",
		//	PKM	Machinegun		CUP_lmg_PKM
		"CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M",
		//	Taurus Tracker Model 455	Handgun		CUP_hgun_TaurusTracker455
		"CUP_6Rnd_45ACP_M",
		//	RPG-7V	Launcher		CUP_launch_RPG7V
		"CUP_PG7V_M",
		"CUP_PG7VL_M",
		"CUP_PG7VR_M",
		"CUP_OG7_M",
		//	RPG 18	Launcher		CUP_launch_RPG18
		"CUP_RPG18_M",
		//	vz. 58 P	Assault Rifle		CUP_arifle_Sa58P
		"CUP_30Rnd_Sa58_M_TracerG",
		"CUP_30Rnd_Sa58_M_TracerR",
		"CUP_30Rnd_Sa58_M_TracerY",
		"CUP_30Rnd_Sa58_M",
		//	Saiga12K	Shotgun		CUP_sgun_Saiga12K
		"CUP_8Rnd_B_Saiga12_74Slug_M",
		//	Mk17 Mod 0 CQC SureFire	Assault Rifle		CUP_arifle_Mk17_CQC_SFG_Aim_mfsup
		"CUP_20Rnd_762x51_B_SCAR",
		"CUP_20Rnd_TE1_Yellow_Tracer_762x51_SCAR",
		"CUP_20Rnd_TE1_Red_Tracer_762x51_SCAR",
		"CUP_20Rnd_TE1_Green_Tracer_762x51_SCAR",
		"CUP_20Rnd_TE1_White_Tracer_762x51_SCAR",
		//	Mk153 Mod 0 SMAW	Launcher		CUP_launch_Mk153Mod0_SMAWOptics
		//"CUP_SMAW_HEAA_M",
		//"CUP_SMAW_HEDP_M",
		//	FIM-92 Stinger	Launcher		CUP_launch_FIM92Stinger
		"CUP_Stinger_M",
		//	Dragunov SVD	Sniper Rifle		CUP_srifle_SVD_pso
		"CUP_10Rnd_762x54_SVD_M",
		//	UK59	Machinegun		CUP_lmg_UK59
		"CUP_50Rnd_UK59_762x54R_Tracer",
		//	SA-61	Handgun		CUP_hgun_SA61
		"CUP_20Rnd_B_765x17_Ball_M",
		"CUP_20Rnd_B_765x17_Ball_M",
		//	Strela-2 9K32	Launcher		CUP_launch_9K32Strela
		"CUP_Strela_2_M",
		//	VSS Vintorez	Sniper Rifle		CUP_srifle_VSSVintorez
		"CUP_10Rnd_9x39_SP5_VSS_M",
		"CUP_20Rnd_9x39_SP5_VSS_M"

	];
	//publicVariable "ArsenalMagazines";


	[mobileRespawn,ArsenalItems,true,true] remoteExecCall ["BIS_fnc_addVirtualItemCargo", 0];
	[mobileRespawn,ArsenalBackpacks,true,true] remoteExecCall ["BIS_fnc_addVirtualBackpackCargo", 0];
	[mobileRespawn,ArsenalWeapons,true,true] remoteExecCall ["BIS_fnc_addVirtualWeaponCargo", 0];
	[mobileRespawn,ArsenalMagazines,true,true] remoteExecCall ["BIS_fnc_addVirtualMagazineCargo", 0];

};

*/