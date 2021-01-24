/* USER DIALOG */

#pragma dynamic 9999999
#pragma tabsize 0

#define COLOR_ERROR 			 		0xFF6347AA
#define COLOR_PURPLE 					0xC2A2DAAA
#define COLOR_RED 						0xFF0000FF
#define COLOR_WHITE 					0xFFFFFFFF
#define COLOR_YELLOW 					0xFFFF00FF
#define COLOR_LIGHTBLUE 				0x33CCFFAA//ï¿½ï¿½ï¿½ï¿½ï¿½Ä¶ï¿½
#define COLOR_STATE						0x62B382AA
#define COLOR_RADIO						0x86D2F8FF

#define COLOR_FADE1						0xE6E6E6E6
#define COLOR_FADE2						0xC8C8C8C8
#define COLOR_FADE3						0xAAAAAAAA
#define COLOR_FADE4						0x8C8C8C8C
#define COLOR_FADE5						0x6E6E6E6E

#define COLOR_YELLOW_FADE1 				0xBFBF30AA
#define COLOR_YELLOW_FADE2 				0x8F8F24AA
#define COLOR_YELLOW_FADE3 				0x6B6B1BAA
#define COLOR_YELLOW_FADE4 				0x505014AA

#define C_dRED 							"{110000}"
#define C_dGREEN 						"{001100}"
#define C_dBLUE 						"{000011}"
#define C_mRED 							"{BB0000}"
#define C_YELLOW						"{FDF901}"
#define C_mGREEN 						"{00BB00}"
#define C_mBLUE 						"{0000BB}"
#define C_RED 							"{FF0000}"
#define C_GREEN 						"{00FF00}"
#define C_BLUE 							"{0000FF}"
#define C_lGREY 						"{AAAAAA}"
#define C_dGREY 						"{222222}"
#define C_WHITE 						"{FFFFFF}"
#define C_PURPLE 						"{C2A2DA}"


#define SCRIPT_VERSION 					"Ver:1.0.0"
#define WEBSITE							"cafe.daum.net/turp"
#define SERVER1							"[Closed Beta]The Unlimited Role Playing Game"
#define SERVER2							"[Closed Beta]´õ ¾ð¸®¹ÌÆ¼µå ·Ñ ÇÃ·¹ÀÌ °ÔÀÓ"

native IsValidVehicle(vehicleid);

#define DIALOG_ID 							        	  0
#define DIALOG_LOG 							        	  1
#define DIALOG_REG 							        	  2
#define DIALOG_TUT 							        	  3
#define DIALOG_USER_SEX						        	  4
#define DIALOG_USER_AGE						        	  5
#define DIALOG_USER_DONE					        	  6
#define DIALOG_PLAYER						        	  7
#define DIALOG_PLAYER_INFO					        	  8
#define DIALOG_PLAYER_SHOW_CLOTH			        	  9
#define DIALOG_PLAYER_BUY_CLOTH				        	  10
#define DIALOG_PLAYER_MODIFY				        	  11			
#define DIALOG_PLAYER_MODIFY_ACC			        	  12
#define DIALOG_PLAYER_MODIFY_HAT			        	  13
#define DIALOG_PLAYER_MODIFY_MASK			        	  14
#define DIALOG_PLAYER_MODIFY_WATCH			        	  15	
#define DIALOG_PLAYER_PHONE_CALL			        	  16
#define DIALOG_PLAYER_PHONE_ADDRESS			        	  17
#define DIALOG_PLAYER_PHONE_MESSAGE	    	        	  18
#define DIALOG_PLAYER_CONSTRUCTION_LIST 	        	  19
#define DIALOG_PLAYER_CONSTRUCTION_ICON 	        	  20
#define DIALOG_PLAYER_CONSTRUCTION_BUY		        	  21
#define DIALOG_PLAYER_CONSTRUCTION_LISTOK           	  22
#define DIALOG_PLAYER_PHONE_CALL_TO_PLAYER          	  23
#define DIALOG_PLAYER_PHONE_SEND_TO_PLAYER          	  24
#define DIALOG_PLAYER_PHONE_MESSAGE_SHOW            	  25
#define DIALOG_PLAYER_PHONE_MESSAGE_SHOW_CONTENT    	  26
#define DIALOG_PLAYER_PHONE_MESSAGE_GET_NUMBER			  27
#define DIALOG_PLAYER_PHONE_MESSAGE_SEND				  28
#define DIALOG_PLAYER_PHONE_ADDRESS_SHOW				  29
#define DIALOG_PLAYER_PHONE_ADDRESS_SHOW_CONTENT    	  30
#define DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_PHONE      31
#define DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_NAME       32
#define DIALOG_PLAYER_SHOW_BANK							  33
#define DIALOG_PLAYER_SHOW_BANK_INSERT	          		  34
#define DIALOG_PLAYER_SHOW_BANK_INSERT_ACCOUNT    		  35
#define DIALOG_PLAYER_SHOW_BANK_PUT			     		  36
#define DIALOG_PLAYER_SHOW_BANK_PUT_ACCOUNT				  37
#define DIALOG_PLAYER_SHOW_BANK_INSERT_EXPEND     		  38
#define DIALOG_PLAYER_SHOW_VEHICLE_STATUS				  39
#define DIALOG_PLAYER_SHOW_VEHICLE				  		  40
#define DIALOG_PLAYER_BUY_VEHICLE						  41
#define DIALOG_PLAYER_BUY_PICK							  42
#define DIALOG_PLAYER_ADMIN_CLICK_PLAYER				  43
#define DIALOG_PLAYER_ADMIN_INTER_ACTIVE				  44
#define DIALOG_PLAYER_JOB							      45
#define DIALOG_PLAYER_JOB_START						      46
#define DIALOG_RADIO									  47
#define DIALOG_PLAYER_ADMIN_ADD_ACTOR					  48
#define DIALOG_PLAYER_SHOW_CONV							  49
#define DIALOG_INVENTORY_ID 							  50
#define DIALOG_INVENTORY_USE_ID 						  51
#define DIALOG_ADMIN_SHOW_JOB_LIST						  52
#define DIALOG_ADMIN_ADD_JOB_LIST						  53
#define DIALOG_ADMIN_ADD_JOB_LIST2						  54
#define DIALOG_USER_SELECT_CHARACTER					  55
#define DIALOG_SHOW_BOOMBOX_LIST						  56
#define DIALOG_SHOW_BOOMBOX_ADD_URL						  57










/* USER DEFINE */
#define MAX_PICK							4096
#define MAX_MODELS							2000					

#define ACC_POS][%1][%2] ACC_POS][((%1)*ACC_POS_size2)+(%2)]

#define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))


#define _FOREACH_NO_TEST
#if !defined EPSILON
    #define  EPSILON 0.0001
#endif

/* user bag define */
#define MAX_ITEM 					40
#define MAX_ITEM_LENGTH 			32
#define PAGE_ITEM 					9
#define DIALOG_TEXT_SPACING 		7

// Is floating point number zero
#define IsFloatZero%1(%0)   ((EPSILON >= (%0)) && ((-EPSILON) <= (%0)))

// Is floating point number NaN
#define IsFloatNaN%1(%0)   ((%0) != (%0))

// Is null vector (2D)
#define IsNullVector2%2(%0,%1) (IsFloatZero(%0) && IsFloatZero(%1))

// HOLDING(keys)
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

// PRESSED(keys)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))


/* USER FORWARD */ 
forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward CheckAccount(playerid);
forward CheckPassword(playerid, password[]);
forward ComparePassword(playerid, password[], flag);
forward AddUser(playerid, name[], password[]);
forward SetEnviroment(hour);
forward ServerStatus();
forward RegisterUserData(playerid);
forward SQL_CALL_LoadUserData(playerid);
forward SQL_CALL_LoadUserLocationData(playerid);
forward SQL_CALL_LoadUserStatusData(playerid);
forward SQL_CALL_LoadEnterExitData();
forward SQL_CALL_LoadBuyData();
forward SQL_CALL_LoadVehicleData();
forward SQL_CALL_LoadUserAccData(playerid);
forward SQL_CALL_LoadMapIcon();
forward SQL_CALL_LoadActorData();
forward SQL_CALL_LoadJobList();
forward SQL_CALL_LoadUserBankData(playerid);
forward SQL_CALL_LoadUserAudioData(playerid);
forward LoadAudioInfo(playerid);
forward LoadUserBankData(playerid);
forward LoadJobList();
forward LoadMapIcon();
forward LoadVehicleData();
forward LoadUserAccData(playerid);
forward LoadBuyData();
forward LoadEnterExitData();
forward LoadUserData(playerid);
forward LoadUserLocationData(playerid);
forward LoadUserStatusData(playerid);
forward LoadActorData();
forward SaveUserData(playerid);
forward SaveMapIcon(Float:X, Float:Y, Float:Z, iconNum);
forward PlayerStatus(playerid);
forward DelaySpawnPlayer(playerid);
forward ShowUserJobActive(playerid);
forward ShowInterActive(playerid);
forward ShowVehicleActive(playerid);
forward ShowClothBuyDialog(playerid);
forward ShowBankDialog(playerid);
forward CheckAccPlayer(playerid, index, modelid, price); // SELECT 
forward GetPlayerAddPick();
forward SetCallUser(playerid, phoneNumber);
forward CallUser(playerid, givePlayerid, phoneNumber);
forward InitializeUserData(playerid);
forward LoadUserMessage(playerid);
forward LoadUserMessageContents(playerid);
forward LoadUserAddress(playerid);
forward SendMessageUserDialog(playerid); 
forward SendMessageCheckNumber(playerid);
forward SetCreateBuyPick(playerid, feature);
forward SendPlayerCash(playerid, phoneNumber);
forward PlayerVehicleEngineStart(playerid, userVehNum);
forward ShowVehicleDialog(playerid);
forward SaveUserVehicle(playerid, vehicleNum);
forward PlayerVehicleUtil(userVehNum);
forward PlayerKeyEnter(playerid);
forward TextPickup(string[], color, model, type, Float:X, Float:Y, Float:Z, distance, attachedplayer, attachedvehicle, testlos, vWorld, vInt);
forward PlayerUpdateMoney(playerid);
forward PlayerJobStart(playerid);
forward PlayerStartTruckJob(playerid);
forward PlayerStartPoliceJob(playerid);
forward SetPlayerObjective(playerid, checkpoint);
forward PlayerAddActor(skinNum, Float:X, Float:Y, Float:Z, Float:Angle, vWorld, attack, flag);
forward ShowConvDialog(playerid);
forward ShowJobDialog(playerid);
forward OnPlayerUseItem(playerid,item[]);
forward LoadPlayerItem(playerid);
forward SendRadioMessage(playerid, color, text[], frequency);
forward PlayerAnimEnd(playerid);
forward DelayedKick(playerid);



/* USER VARIABLE */
enum ETextDrawInfo
{
    // X
    Float:ETDInfo_x,

    // Y
    Float:ETDInfo_y,

    // Text
    ETDInfo_text[149],

    // Letter size X
    Float:ETDInfo_letterSizeX,

    // Letter size Y
    Float:ETDInfo_letterSizeY,

    // Text size X
    Float:ETDInfo_textSizeX,

    // Text size Y
    Float:ETDInfo_textSizeY,

    // Alignment
    ETDInfo_alignment,

    // Color
    ETDInfo_color,

    // Use box
    ETDInfo_useBox,

    // Box color
    ETDInfo_boxColor,

    // Shadow
    ETDInfo_shadow,

    // Outline
    ETDInfo_outline,

    // Background
    ETDInfo_backgroundColor,

    // Font
    ETDInfo_font,

    // Proportional
    ETDInfo_proportional
}

// Player text draw information structure
enum EPlayerTextDrawInfo
{
    // X
    Float:EPTDInfo_x,

    // Y
    Float:EPTDInfo_y,

    // Text
    EPTDInfo_text[10],

    // Letter size X
    Float:EPTDInfo_letterSizeX,

    // Letter size Y
    Float:EPTDInfo_letterSizeY,

    // Text size X
    Float:EPTDInfo_textSizeX,

    // Text size Y
    Float:EPTDInfo_textSizeY,

    // Alignment
    EPTDInfo_alignment,

    // Color
    EPTDInfo_color,

    // Shadow
    EPTDInfo_shadow,

    // Outline
    EPTDInfo_outline,

    // Background
    EPTDInfo_backgroundColor,

    // Font
    EPTDInfo_font,

    // Proportional
    EPTDInfo_proportional
}

// Vector (2D) structure
enum EVector2
{
    // X
    Float:EVector2_x,

    // Y
    Float:EVector2_y
}

// Vector (3D) structure
enum EVector3
{
    // X
    Float:EVector3_x,

    // Y
    Float:EVector3_y,

    // Z
    Float:EVector3_z
}

new
    // Textdraws
    g_textdraws[][ETextDrawInfo] =
    {
        {406.888854, 330.871154, "_",         -0.00711, 8.546487,  635.0, 0.0,            1, -1, 1, 70, 0, 0, 255, 1, 1},
        {480.755920, 335.848937, "_",         -0.063887, 0.850619, 558.800048, 0.0,       1, 2680, 1, 70, 0, 0, 255, 1, 1},
        {484.355957, 335.351165, ".",         -0.063887, 0.850619, 494.300231, 0.0,       1, 2680, 1, 70, 0, 0, 255, 1, 1},
        {499.656890, 335.351165, ".",         -0.063887, 0.850619, 510.101043, 0.0,       1, 2680, 1, 70, 0, 0, 255, 1, 1},
        {515.156799, 335.453399, ".",         -0.063887, 0.830618, 526.0, 0.049998,       1, 2680, 1, 70, 0, 0, 255, 1, 1},
        {530.656250, 335.351165, ".",         0.411606, 0.850618,  541.101013, 0.0,       1, 2680, 1, 70, 0, 0, 255, 1, 1},
        {545.811157, 335.351165, ".",         -0.063887, 0.850619, 555.400146, 0.0,       1, 2680, 1, 70, 0, 0, 255, 1, 1},
        {413.733459, 351.777770, "_",         -0.004664, 5.895215, 630.45996, 0.0,        1, 2680, 1, 50, 0, 0, 255, 1, 1},
        {406.690002, 311.162200, "_",         -0.009998, 3.713803, 635.409973, -1.049998, 1, 2680, 1, 50, 0, 0, 255, 1, 1},
        {567.766784, 332.862121, "Gear:",     0.313775, 1.002665,  0.0, 0.0,              1, -1, 0, 0, 0, 0, 255, 1, 1},
        {451.367126, 333.711914, "km/h",      0.200442, 0.9728,    0.0, 0.0,              1, -1, 0, 0, 0, 0, 255, 1, 1},
        {415.306274, 353.351165, "_",         0.00311, 5.450621,   628.500915, 0.0,       1, 2680, 1, 70, 0, 0, 255, 1, 1},
        {412.344360, 388.802062, "--------------------------------------~y~--------------------------------------~r~------------------",
                                              0.188887, 1.500444,  0.0, 0.0,              1, -1378294017, 0, 0, 0, 0, 255, 0, 1},
        {417.025695, 367.752471, "0             20             40             60             80            100____________120____________140____________160____________180_________200",
                                              0.099007, 1.053754,  0.0, 0.0,              1, -1, 0, 0, 0, 0, 255, 2, 1},
        {602.888793, 330.425048, "_",         -0.059555, 1.46062,  611.970031, 0.0,       1, -1, 1, 50, 0, 0, 255, 1, 1},
        {416.050964, 347.751831, "I    I    I    I    I    I    I    I    I    I    I    I    I    I    I    I    I    I    I    I____I",
                                              0.147055, 2.471087,  0.0, 0.0,              1, -1, 0, 0, 0, 0, 255, 1, 1},
        {416.849334, 350.782257, "IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIII IIIIIIIIIIIIIIIIIIIIIIIIIIIIII",
                                              0.150943, 1.216711,  0.0, 0.0,              1, -1, 0, 0, 0, 0, 255, 1, 1}
    },

    // Player textdraws
    g_playerTextdraws[][EPlayerTextDrawInfo] =
    {
        {483.011145, 334.866699, "00000", 0.568221, 0.992708, 0.0, 0.0,       1, -1378294017, 0, 0, 255, 2, 1},
        {423.017700, 333.711914, "0000", 0.200442, 0.9728,    0.0, 0.0,       1, -1, 0, 0, 255, 2, 1},
        {604.573242, 333.711914, "P", 0.200442, 0.9728,       0.0, 0.0,       1, -1, 0, 0, 255, 2, 1},
        {413.444549, 375.456115, "hud:arrow", 0.0, 0.0,       8.0, 32.039978, 1, -1378294017, 0, 0, 255, 4, 0}
    },

    // Speedometer
    Text:g_Speedometer[sizeof g_textdraws],
	  // Gear
    g_Gear[MAX_PLAYERS][2];

// Player speedometer information structure
enum EPlayerSpeedometerInfo
{
    EPSInfo_enabled,
    PlayerText:EPSInfo_textdraws[sizeof g_playerTextdraws]
}

// Player speedometer
new g_playerSpeedometer[MAX_PLAYERS][EPlayerSpeedometerInfo];


new MySQL:g_Sql;

/* USER ENUM */

enum SHOP_DATA {
    MODELID,
    NAME[35],
    PRICE,
	SEX,
	JOB_ID
};
new CLOTH[][SHOP_DATA] = {
    {1, "", 50, 0, 2},
    {2, "", 50, 0, 0},
    {3, "", 50, 0, 999},
    {4, "", 50, 0, 999},
	{5, "", 50, 0, 999},
	{6, "", 50, 0, 2},
	{7, "", 50, 0, 1}, //taxi
	{8, "", 50, 0, 2},
	{9, "", 50, 1, 0},
	{10, "", 50, 1, 0},

	{11, "", 50, 1, 0},
    {12, "", 50, 1, 0},
    {13, "", 50, 1, 0},
    {14, "", 50, 0, 0},
	{15, "", 50, 0, 0},
	{16, "", 50, 0, 0},
	{17, "", 50, 0, 4},
	{18, "", 50, 0, 0},
	{19, "", 50, 0, 0},
	{20, "", 50, 0, 0},

	{21, "", 50, 0, 0},
    {22, "", 50, 0, 0},
    {23, "", 50, 0, 0},
    {24, "", 50, 0, 0},
	{25, "", 50, 0, 0},
	{26, "", 50, 0, 0},
	{27, "", 50, 0, 5},
	{28, "", 50, 0, 0},
	{29, "", 50, 0, 0},
	{30, "", 50, 0, 999},

	{31, "", 50, 1, 5},
    {32, "", 50, 0, 0},
    {33, "", 50, 0, 0},
    {34, "", 50, 0, 0},
	{35, "", 50, 0, 0},
	{36, "", 50, 0, 5},
	{37, "", 50, 0, 0},
	{38, "", 50, 1, 0},
	{39, "", 50, 1, 0},
	{40, "", 50, 1, 0},

	{41, "", 50, 1, 0},
    {42, "", 50, 0, 0},
    {43, "", 50, 0, 0},
    {44, "", 50, 0, 0},
	{45, "", 50, 0, 0},
	{46, "", 50, 0, 999},
	{47, "", 50, 0, 999},
	{48, "", 50, 0, 999},
	{49, "", 50, 0, 999},
	{50, "", 50, 0, 2},

	{51, "", 50, 0, 0},
    {52, "", 50, 0, 0},
    {53, "", 50, 1, 0},
    {54, "", 50, 1, 0},
	{55, "", 50, 1, 0},
	{56, "", 50, 1, 0},
	{57, "", 50, 0, 0},
	{58, "", 50, 0, 0},
	{59, "", 50, 0, 999},
	{60, "", 50, 0, 999},
	{61, "", 50, 0, 0},
    {62, "", 50, 0, 0},
    {63, "", 50, 1, 0},
    {64, "", 50, 1, 0},
	{65, "", 50, 1, 0},
	{66, "", 50, 0, 999},
	{67, "", 50, 0, 999},
	{68, "", 50, 0, 0},
	{69, "", 50, 1, 0},

	{70, "", 50, 0, 0},
	{71, "", 50, 6, 0},
    {72, "", 50, 0, 0},
    {73, "", 50, 0, 0},
	{75, "", 50, 1, 0},
	{76, "", 50, 1, 4},
	{77, "", 50, 1, 0},
	{78, "", 50, 0, 0},
	{79, "", 50, 0, 0},

	{80, "", 50, 0, 0},
	{81, "", 50, 0, 0},
    {82, "", 50, 0, 0},
    {83, "", 50, 0, 0},
    {84, "", 50, 0, 0},
	{85, "", 50, 1, 0},
	{86, "", 50, 0, 999},
	{87, "", 50, 1, 0},
	{88, "", 50, 1, 0},
	{89, "", 50, 1, 0},

	{90, "", 50, 1, 0},
	{91, "", 50, 1, 0},
    {92, "", 50, 1, 0},
    {93, "", 50, 1, 4},
    {94, "", 50, 0, 0},
	{95, "", 50, 0, 0},
	{96, "", 50, 0, 0},
	{97, "", 50, 0, 0},
	{98, "", 50, 0, 999},
	{99, "", 50, 0, 0},

	{100, "", 50, 0, 999},
	{101, "", 50, 0, 0},
    {102, "", 50, 0, 999},
    {103, "", 50, 0, 999},
    {104, "", 50, 0, 999},
	{105, "", 50, 0, 999},
	{106, "", 50, 0, 999},
	{107, "", 50, 0, 999},
	{108, "", 50, 0, 999},
	{109, "", 50, 0, 999},

	{110, "", 50, 0, 999},
	{111, "", 50, 0, 999},
    {112, "", 50, 0, 999},
    {113, "", 50, 0, 999},
    {114, "", 50, 0, 999},
	{115, "", 50, 0, 999},
	{116, "", 50, 0, 999},
	{117, "", 50, 0, 999},
	{118, "", 50, 0, 999},
	{119, "", 50, 0, 999},

	{120, "", 50, 0, 999},
	{121, "", 50, 0, 999},
    {122, "", 50, 0, 999},
    {123, "", 50, 0, 999},
    {124, "", 50, 0, 999},
	{125, "", 50, 0, 999},
	{126, "", 50, 0, 999},
	{127, "", 50, 0, 999},
	{128, "", 50, 0, 0},
	{129, "", 50, 1, 0},

	{130, "", 50, 1, 0},
	{131, "", 50, 1, 0},
    {132, "", 50, 0, 0},
    {133, "", 50, 0, 0},
    {134, "", 50, 0, 0},
	{135, "", 50, 0, 0},
	{136, "", 50, 0, 0},
	{137, "", 50, 0, 0},
	{138, "", 50, 1, 0},
	{139, "", 50, 1, 0},

	{140, "", 50, 1, 0},
	{141, "", 50, 1, 4},
    {142, "", 50, 0, 0},
    {143, "", 50, 0, 0},
    {144, "", 50, 0, 5},
	{145, "", 50, 1, 0},
	{146, "", 50, 0, 0},
	{147, "", 50, 0, 4},
	{148, "", 50, 1, 4},
	{149, "", 50, 0, 999},

	{150, "", 50, 1, 4},
	{151, "", 50, 1, 1},
    {152, "", 50, 1, 0},
    {153, "", 50, 0, 4},
    {154, "", 50, 0, 0},
	{155, "", 50, 0, 3},
	{156, "", 50, 0, 0},
	{157, "", 50, 1, 2},
	{158, "", 50, 0, 0},
	{159, "", 50, 0, 0},

	{160, "", 50, 0, 0},
	{161, "", 50, 0, 0},
    {162, "", 50, 0, 0},
    {163, "", 50, 0, 6},
    {164, "", 50, 0, 6},
	{165, "", 50, 0, 6},
	{166, "", 50, 0, 6},
	{167, "", 50, 0, 3},
	{168, "", 50, 0, 0},
	{169, "", 50, 1, 0},

	{170, "", 50, 0, 0},
	{171, "", 50, 0, 0},
    {172, "", 50, 1, 0},
    {173, "", 50, 0, 999},
    {174, "", 50, 0, 999},
	{175, "", 50, 0, 999},
	{176, "", 50, 0, 999},
	{177, "", 50, 0, 999},
	{178, "", 50, 1, 0},
	{179, "", 50, 0, 0},

	{180, "", 50, 0, 999},
	{181, "", 50, 0, 999},
    {182, "", 50, 0, 0},
    {183, "", 50, 0, 0},
    {184, "", 50, 0, 0},
	{185, "", 50, 0, 999},
	{186, "", 50, 0, 999},
	{187, "", 50, 0, 4},
	{188, "", 50, 0, 0},
	{189, "", 50, 0, 0},

	{190, "", 50, 1, 0},
	{191, "", 50, 1, 0},
    {192, "", 50, 1, 0},
    {193, "", 50, 1, 0},
    {194, "", 50, 1, 0},
	{195, "", 50, 1, 0},
	{196, "", 50, 1, 0},
	{197, "", 50, 1, 0},
	{198, "", 50, 1, 0},
	{199, "", 50, 1, 0},

	{200, "", 50, 0, 0},
	{201, "", 50, 1, 0},
    {202, "", 50, 0, 0},
    {203, "", 50, 0, 0},
    {204, "", 50, 0, 0},
	{205, "", 50, 1, 4},
	{206, "", 50, 0, 0},
	{207, "", 50, 1, 0},
	{208, "", 50, 0, 999},
	{209, "", 50, 0, 0},

	{210, "", 50, 0, 0},
	{211, "", 50, 1, 4},
    {212, "", 50, 0, 0},
    {213, "", 50, 0, 0},
    {214, "", 50, 1, 0},
	{215, "", 50, 1, 0},
	{216, "", 50, 1, 0},
	{217, "", 50, 0, 0},
	{218, "", 50, 1, 0},
	{219, "", 50, 1, 0},

	{220, "", 50 ,0, 0},
	{221, "", 50, 0, 0},
    {222, "", 50, 0, 0},
    {223, "", 50, 0, 999},
    {224, "", 50, 1, 0},
	{225, "", 50, 1, 0},
	{226, "", 50, 1, 0},
	{227, "", 50, 0, 999},
	{228, "", 50, 0, 999},
	{229, "", 50, 0, 999},

	{230, "", 50, 0, 0},
	{231, "", 50, 1, 0},
    {232, "", 50, 1, 0},
    {233, "", 50, 1, 4},
    {234, "", 50, 0, 0},
	{235, "", 50, 0, 0},
	{236, "", 50, 0, 0},
	{237, "", 50, 1, 0},
	{238, "", 50, 1, 0},
	{239, "", 50, 0, 0},

	{240, "", 50, 0, 4},
	{241, "", 50, 0, 0},
    {242, "", 50, 0, 0},
    {243, "", 50, 1, 0},
    {244, "", 50, 1, 0},
	{245, "", 50, 1, 0},
	{246, "", 50, 1, 0},
	{247, "", 50, 0, 999},
	{248, "", 50, 0, 99},
	{249, "", 50, 0, 999},

	{250, "", 50, 0, 0},
	{251, "", 50, 1, 0},
    {252, "", 50, 0, 0},
    {253, "", 50, 0, 0},
    {254, "", 50, 0, 999},
	{255, "", 50, 0, 0},
	{256, "", 50, 1, 0},
	{257, "", 50, 1, 0},
	{258, "", 50, 0, 999},
	{259, "", 50, 0, 999},

	{260, "", 50, 0, 5},
	{261, "", 50, 0, 0},
    {262, "", 50, 0, 0},
    {263, "", 50, 1, 999},
    {264, "", 50, 0, 0},
	{265, "", 50, 0, 6},
	{266, "", 50, 0, 6},
	{267, "", 50, 0, 6},
	{268, "", 50, 0, 0},
	{269, "", 50, 0, 999},

	{270, "", 50, 0, 999},
	{271, "", 50, 0, 999},
    {272, "", 50, 0, 999},
    {273, "", 50, 0, 999},
    {274, "", 50, 0, 0},
	{275, "", 50, 0, 0},
	{276, "", 50, 0, 0},
	{277, "", 50, 0, 0},
	{278, "", 50, 0, 0},
	{279, "", 50, 0, 0},

	{280, "", 50, 0, 6},
	{281, "", 50, 0, 6},
    {282, "", 50, 0, 6},
    {283, "", 50, 0, 6},
    {284, "", 50, 0, 9},
	{285, "", 50, 0, -999},
	{286, "", 50, 0, -999},
	{287, "", 50, 0, -999},
	{288, "", 50, 0, 6},
	{289, "", 50, 0, 0},

	{290, "", 50, 0, 0},
	{291, "", 50, 0, 0},
    {292, "", 50, 0, 999},
    {293, "", 50, 0, 999},
    {294, "", 50, 0, 999},
	{295, "", 50, 0, 999},
	{296, "", 50, 0, 999},
	{297, "", 50, 0, 999},
	{298, "", 50, 1, 999},
	{299, "", 50, 0, 0},

	{300, "", 50, 0, 6},
	{301, "", 50, 0, 6},
    {302, "", 50, 0, 6},
    {303, "", 50, 0, 6},
    {304, "", 50, 0, 6},
	{305, "", 50, 0, 6},
	{306, "", 50, 1, 6},
	{307, "", 50, 1, 6},
	{308, "", 50, 1, 6},
	{309, "", 50, 1, 6},
	{310, "", 50, 0, 6},
	{311, "", 50, 0, 6}
};
new GLASSES_ACC[][SHOP_DATA] = {
	{19025, "", 20, 0, 0},
	{19026, "", 20, 0, 0},
	{19031, "", 20, 0, 0},
	{19028, "", 20, 0, 0},
	{19023, "", 20, 0, 0},
	{19010, "", 20, 0, 0},
	{19024, "", 20, 0, 0},
	{19138, "", 20, 0, 0},
	{19007, "", 20, 0, 0},
	{19035, "", 20, 0, 0},
	{19034, "", 20, 0, 0},
	{19033, "", 20, 0, 0},
	{19032, "", 20, 0, 0},
	{19030, "", 20, 0, 0},
	{19029, "", 20, 0, 0},
	{19027, "", 20, 0, 0},
	{19006, "", 20, 0, 0},
	{19022, "", 20, 0, 0},
	{19014, "", 20, 0, 0},
	{19008, "", 20, 0, 0},
	{19009, "", 20, 0, 0},
	{19011, "", 20, 0, 0},
	{19012, "", 20, 0, 0},
	{19021, "", 20, 0, 0},
	{19013, "", 20, 0, 0},
	{19015, "", 20, 0, 0},
	{19016, "", 20, 0, 0},
	{19017, "", 20, 0, 0},
	{19018, "", 20, 0, 0},
	{19019, "", 20, 0, 0},
	{19020, "", 20, 0, 0},
	{19139, "", 20, 0, 0},
	{19140, "", 20, 0, 0}
};
new WATCH_ACC[][SHOP_DATA] = {
	{19039, "", 30, 0, 0},
	{19042, "", 30, 0, 0},
	{19053, "", 30, 0, 0},
	{19052, "", 30, 0, 0},
	{19051, "", 30, 0, 0},
	{19050, "", 30, 0, 0},
	{19049, "", 30, 0, 0},
	{19048, "", 30, 0, 0},
	{19047, "", 30, 0, 0},
	{19046, "", 30, 0, 0},
	{19045, "", 30, 0, 0},
	{19044, "", 30, 0, 0},
	{19043, "", 30, 0, 0},
	{19041, "", 30, 0, 0},
	{19040, "", 30, 0, 0}
};
new MASK_ACC[][SHOP_DATA] = {
	{19038, "", 15, 0, 0},
	{19036, "", 15, 0, 0},
	{19163, "", 15, 0, 0},
	{18919, "", 15, 0, 0},
	{18912, "", 15, 0, 0},
	{18913, "", 15, 0, 0},
	{18914, "", 15, 0, 0},
	{18915, "", 15, 0, 0},
	{18916, "", 15, 0, 0},
	{18917, "", 15, 0, 0},
	{18918, "", 15, 0, 0},
	{18911, "", 15, 0, 0},
	{18920, "", 15, 0, 0},
	{18974, "", 15, 0, 0},
	{19472, "", 15, 0, 0},
	{11704, "", 15, 0, 0},
	{19037, "", 15, 0, 0},
	{19557, "", 15, 0, 0},
	{18891,	"", 15, 0, 0},
	{18892,	"", 15, 0, 0},
	{18893,	"", 15, 0, 0},
	{18894,	"", 15, 0, 0},
	{18895,	"", 15, 0, 0},
	{18896,	"", 15, 0, 0},
	{18897,	"", 15, 0, 0},
	{18898,	"", 15, 0, 0},
	{18899,	"", 15, 0, 0},
	{18900,	"", 15, 0, 0},
	{18901,	"", 15, 0, 0},
	{18902,	"", 15, 0, 0},
	{18903,	"", 15, 0, 0},
	{18904,	"", 15, 0, 0},
	{18905,	"", 15, 0, 0},
	{18906,	"", 15, 0, 0},
	{18907,	"", 15, 0, 0},
	{18908,	"", 15, 0, 0},
	{18909,	"", 15, 0, 0},
	{18910,	"", 15, 0, 0}
};
new HAT_ACC[][SHOP_DATA] = {
	{18941, "", 20, 0, 0},
	{18943, "", 20, 0, 0},
	{18953, "", 20, 0, 0},
	{18954, "", 20, 0, 0},
	{18956, "", 20, 0, 0},
	{18955, "", 20, 0, 0},
	{18958, "", 20, 0, 0},
	{18959, "", 20, 0, 0},
	{18939, "", 20, 0, 0},
	{18940, "", 20, 0, 0},
	{18929, "", 20, 0, 0},
	{18933, "", 20, 0, 0},
	{18942, "", 20, 0, 0},
	{18961, "", 20, 0, 0},
	{18960, "", 20, 0, 0},
	{18947, "", 20, 0, 0},
	{18969, "", 20, 0, 0},
	{19137, "", 20, 0, 0},
	{18944, "", 20, 0, 0},
	{18945, "", 20, 0, 0},
	{19068, "", 20, 0, 0},
	{18951, "", 20, 0, 0},
	{18962, "", 20, 0, 0},
	{19066, "", 20, 0, 0},
	{19064, "", 20, 0, 0},
	{19065, "", 20, 0, 0},
	{19528, "", 20, 0, 0},
	{19069, "", 20, 0, 0},
	{19096, "", 20, 0, 0},
	{19098, "", 20, 0, 0},
	{19099, "", 20, 0, 0},
	{2054, "", 20, 0, 0},
	{18935, "", 20, 0, 0},
	{18968, "", 20, 0, 0},
	{18934, "", 20, 0, 0},
	{18933, "", 20, 0, 0},
	{18926, "", 20, 0, 0},
	{18973, "", 20, 0, 0},
	{18972, "", 20, 0, 0},
	{18971, "", 20, 0, 0},
	{18970, "", 20, 0, 0},
	{19488, "", 20, 0, 0},
	{18967, "", 20, 0, 0},
	{18927, "", 20, 0, 0},
	{18932, "", 20, 0, 0},
	{18950, "", 20, 0, 0},
	{18928, "", 20, 0, 0},
	{18948, "", 20, 0, 0},
	{18946, "", 20, 0, 0},
	{18930, "", 20, 0, 0},
	{18931, "", 20, 0, 0},
	{18949, "", 20, 0, 0},
	{2053, "", 20, 0, 0},
	{2052, "", 20, 0, 0},
	{2054, "", 20, 0, 0},
	{19521, "", 20, 0, 0},
	{19161, "", 20, 0, 0},
	{19520, "", 20, 0, 0},
	{19553, "", 20, 0, 0},
	{19487, "", 20, 0, 0},
	{19352, "", 20, 0, 0},
	{19331, "", 20, 0, 0},
	{19330, "", 20, 0, 0},
	{19558, "", 20, 0, 0},
	{19162, "", 20, 0, 0},
	{19067, "", 20, 0, 0},
	{19160, "", 20, 0, 0},
	{18638, "", 20, 0, 0},
	{18639, "", 20, 0, 0},
	{18930, "", 20, 0, 0},
	{19093, "", 20, 0, 0},
	{19094, "", 20, 0, 0},
	{19095, "", 20, 0, 0},
	{19097, "", 20, 0, 0},
	{19113, "", 20, 0, 0},
	{19424, "", 20, 0, 0},
	{18894, "", 20, 0, 0},
	{19107, "", 20, 0, 0},
	{19106, "", 20, 0, 0},
	{18976, "", 20, 0, 0},
	{18957, "", 20, 0, 0},
	{18903, "", 20, 0, 0},
	{18899, "", 20, 0, 0},
	{18636, "", 20, 0, 0},
	{19100, "", 20, 0, 0},
	{18964, "", 20, 0, 0},
	{18965, "", 20, 0, 0},
	{18966, "", 20, 0, 0}
};
new VEHICLE_MODEL[][SHOP_DATA] = {
	//{448, "Pizzaboy", 0},
	{461, "PCJ-600", 0},
	{462, "Faggio", 0},
	{463, "Freeway", 0},
	{468, "Sanchez", 0},
	{471, "Quad", 0},
	{481, "BMX", 0},
	{509, "Bike", 0},
	{510, "Mountain Bike", 0},
	{521, "FCR-900", 0},
	{522, "NRG-500", 0},
	//{523, "HPV1000", 0},
	{581, "BF-400", 0},
	{586, "Wayfarer", 0},
	{439, "Stallion", 0},
	{480, "Comet", 0},
	{533, "Feltzer", 0},
	{555, "Windsor", 0},
	{403, "Linerunner", 0},
	{408, "Trashmaster", 0},
	{413, "Pony", 0},
	{414, "Mule", 0},
	{422, "Bobcat", 0},
	{440, "Rumpo", 0},
	{443, "Packer", 0},
	{455, "Flatbed", 0},
	{456, "Yankee", 0},
	{459, "Topfun Van", 0},
	{478, "Walton", 0},
	{482, "Burrito", 0},
	{498, "Boxville", 0},
	{499, "Benson", 0},
	{514, "Tanker", 0},
	{515, "Roadtrain", 0},
	{524, "Cement Truck", 0},
	{531, "Tractor", 0},
	{543, "Sadler", 0},
	{552, "Utility Van", 0},
	{554, "Yosemite", 0},
	{578, "DFT-30", 0},
	//{582, "Newsvan", 0},
	{600, "Picador", 0},
	{605, "Sadler Shit", 0},
	{609, "Boxville", 0},
	{412, "Voodoo", 0},
	{534, "Remington", 0},
	{535, "Slamvan", 0},
	{536, "Blade", 0},
	{566, "Tahoma", 0},
	{567, "Savanna", 0},
	{575, "Broadway", 0},
	{576, "Tornado", 0},
	{400, "Landstalker", 0},
	{424, "BF Injection", 0},
	{444, "Monster", 0},
	//{470, "Patriot", 0},
	{489, "Rancher", 0},
	{495, "Sandking", 0},
	{500, "Mesa", 0},
	{505, "Rancher Lure", 0},
	{556, "Monster A", 0},
	{557, "Monster B", 0},
	{568, "Bandito", 0},
	{573, "Dune", 0},
	{579, "Huntley", 0},
	{401, "Bravura", 0},
    {405, "Sentinel", 0},
    {410, "Manana", 0},
    {419, "Esperanto", 0},
    {421, "Washington", 0},
    {426, "Premier", 0},
    {436, "Previon", 0},
    {445, "Admiral", 0},
    {466, "Glendale", 0},
    {467, "Oceanic", 0},
    {474, "Hermes", 0},
    {491, "Virgo", 0},
    {492, "Greenwood", 0},
    {504, "Bloodring Banger", 0},
    {507, "Elegant", 0},
    {516, "Nebula", 0},
    {517, "Majestic", 0},
    {518, "Buccaneer", 0},
    {526, "Fortune", 0},
    {527, "Cadrona", 0},
    {529, "Willard", 0},
    {540, "Vincent", 0},
    {542, "Clover", 0},
    {546, "Intruder", 0},
    {547, "Primo", 0},
    {549, "Tampa", 0},
    {550, "Sunrise", 0},
    {551, "Merit", 0},
    {560, "Sultan", 0},
    {562, "Elegy", 0},
    {580, "Stafford", 0},
    {585, "Emperor", 0},
    //{604, "Glendale Shit", 0},
	{402, "Buffalo", 0},
    {411, "Infernus", 0},
    {415, "Cheetah", 0},
    {429, "Banshee", 0},
    {421, "Washington", 0},
    {451, "Turismo", 0},
    {475, "Sabre", 0},
    {477, "ZR-350", 0},
    {494, "Hotring Racer", 0},
    {496, "Blista Compact", 0},
    {502, "Hotring Racer A", 0},
    {503, "Hotring Racer B", 0},
    {506, "Super GT", 0},
    {541, "Bullet", 0},
    {558, "Uranus", 0},
    {559, "Jester", 0},
    {565, "Flash", 0},
    {587, "Euros", 0},
    {589, "Club", 0},
    {602, "Alpha", 0},
    {603, "Phoenix", 0},
	{404, "Perenniel", 0},
    {418, "Moonbeam", 0},
    {458, "Solair", 0},
    {479, "Regina", 0},
    {561, "Stratum", 0},
	//{406, "Dumper", 0},
    {409, "Stretch", 0},
    {423, "Mr. Whoopee", 0},
    {428, "Securicar", 0},
    {434, "Hotknife", 0},
	{442, "Romero", 0},
	//{449, "Tram", 0},
	//{457, "Caddy", 0},
	{483, "Camper", 0},
	{485, "Baggage", 0},
	//{486, "Dozer", 0},
	{508, "Journey", 0},
	{525, "Towtruck", 0},
	//{530, "Forklift", 0},
	//{532, "Combine Harvester", 0},
	//{537, "Freight (Train)", 0},
	//{538, "Brownstreak (Train)", 0},
	{539, "Vortex", 0},
	{545, "Hustler", 0},
	{571, "Kart", 0},
	{572, "Mower", 0},
	{574, "Sweeper", 0},
	{583, "Tug", 0},
	{588, "Hotdog", 0}

};
new CONV_LIST[][SHOP_DATA] = 
{
	{0, "¹«Àü±â", 50},
	{0, "´ã¹è", 10},
	{0, "»óÁ¡ °¡ÆÇ´ë", 500},
	{0, "¼ú", 10},
	{0, "ºÕ¹Ú½º/¿Àµð¿À", 5000},
	{0, "À½·á¼ö", 2},
	{0, "ÁÖ»çÀ§", 5},
	{0, "ÃÊÄÚ¹Ù", 2},
	{0, "Æ÷Ä¿ Ä«µå", 5}	
};

const ACC_POS_size1 = 9;
const ACC_POS_size2 = 4;
const sizeof_ACC_POS = ACC_POS_size1 * ACC_POS_size2;

enum PLAYER_INFO {
	NAME[64],
	PWD[60],
	SEED,
	SEX,
	SKIN,
	JOB,
	bool:LOGIN,
	ADMIN,
	TUTORIAL, // TUTORIAL
	TUTORIALCOMPLETE,
	YEAR,
	PHONE,
	MONEY,
	BANK, //ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½
	INTERIOR,
	SAVE_PHONE,
	SAVE_NUM[255],
	SAVE_PRICE[255],
	VIRTUALWORLD,
	ACC_MODEL_ID[4],
	ACC_INDEX[4],
	RFREQ,
	RFREQ_SOUND,
	Float:ACC_POS[36],
	Float:HEALTH,
	Float:ARMOUR,
	Float:POS[3],
	TIME[3] // hour, minute, second.
};
new Player[MAX_PLAYERS][PLAYER_INFO];
enum ENTER_EXIT_INFO {
	ENTER_INT,
	ENTER_VIRTUAL_WORLD,
	Float:ENTER[3],
	EXIT_INT,
	EXIT_VIRTUAL_WORLD,
	Float:EXIT[3],
	COMMENT[50]
};
new ENTER_EXIT[MAX_PICK][ENTER_EXIT_INFO];

enum BUY_INFO {
	BUY_VIRTUAL_WORLD,
	BUY_INT,
	Float:BUY[3],
	FEATURE
};
new BUY_PICK[MAX_PICK][BUY_INFO];


enum VEHICLE_INFO {
	vehicleID,
	Float:vHealth,
	Float:vX,
	Float:vY,
	Float:vZ,
	Float:vAngle,
	vColor[2],
	vJob, ///ï¿½Ø´ï¿½ ï¿½Ã·ï¿½ï¿½Ì¾ï¿½ ï¿½ï¿½ï¿½ï¿½
	vFuel,
	bool:vShare, //ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ ï¿½Ø¼ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½Ì¶ï¿½ ï¿½ï¿½ï¿½ï¿½ Å» ï¿½ï¿½ ï¿½Ö°ï¿½ ï¿½ï¿½ ï¿½ï¿½ ï¿½Ö´ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½.
	vOwner[MAX_PLAYER_NAME]
};
new VEHICLE_DATA[MAX_VEHICLES][VEHICLE_INFO];


enum ACTOR_INFO
{
	bool:ACTOR_SLOT_USED = false,
	ACTOR_VIRTUAL_WORLD,
	ACTOR_INVULNERABLE,
	Float:ACTOR_POS[4]
};
new ACTOR_DATA[MAX_ACTORS][ACTOR_INFO];

new Float:IntArray[146][4] = {
	{2003.12,1015.19,33.01,351.58},
	{770.8,-0.7,1000.73,22.86},
	{974.02,-9.59,1001.15,22.6},
	{961.93,-51.91,1001.12,95.54},
	{830.6,5.94,1004.18,125.81},
	{1037.83,0.4,1001.28,353.93},
	{1212.15,-28.54,1000.95,170.57},
	{1290.41,1.95,1001.02,179.94},
	{1412.15,-2.28,1000.92,114.66},
	{1527.05,-12.02,1002.1,350.0},
	{1523.51,-47.82,1002.27,262.7},
	{612.22,-123.9,997.99,266.57},
	{512.93,-11.69,1001.57,198.77},
	{418.47,-80.46,1001.8,343.24},
	{386.53,173.64,1008.38,63.74},
	{288.47,170.06,1007.18,22.05},
	{206.46,-137.71,1003.09,10.93},
	{-100.27,-22.94,1000.72,17.29},
	{-201.22,-43.25,1002.27,45.86},
	{-202.94,-6.7,1002.27,204.27},
	{-25.72,-187.82,1003.55,5.08},
	{454.99,-107.25,999.44,309.02},
	{372.56,-131.36,1001.49,354.23},
	{378.03,-190.52,1000.63,141.02},
	{315.24,-140.89,999.6,7.42},
	{225.03,-9.18,1002.22,85.53},
	{611.35,-77.56,998.0,320.93},
	{246.07,108.97,1003.22,0.29},
	{6.09,-28.9,1003.55,5.04},
	{773.73,-74.7,1000.65,5.23},
	{621.45,-23.73,1000.92,15.68},
	{445.6,-6.98,1000.73,172.21},
	{285.84,-39.02,1001.52,0.75},
	{204.12,-46.8,1001.8,357.58},
	{245.23,304.76,999.15,273.44},
	{290.62,309.06,999.15,89.92},
	{322.5,303.69,999.15,8.17},
	{-2041.23,178.4,28.85,156.22},
	{-1402.66,106.39,1032.27,105.14},
	{-1403.01,-250.45,1043.53,355.86},
	{1204.67,-13.54,1000.92,350.02},
	{2016.12,1017.15,996.88,88.01},
	{-741.85,493.0,1371.98,71.78},
	{2447.87,-1704.45,1013.51,314.53},
	{2527.02,-1679.21,1015.5,260.97},
	{-1129.89,1057.54,1346.41,274.53},
	{2496.05,-1695.17,1014.74,179.22},
	{366.02,-73.35,1001.51,292.01},
	{2233.94,1711.8,1011.63,184.39},
	{269.64,305.95,999.15,215.66},
	{414.3,-18.8,1001.8,41.43},
	{1.19,-3.24,999.43,87.57},
	{-30.99,-89.68,1003.55,359.84},
	{161.4,-94.24,1001.8,0.79},
	{-2638.82,1407.34,906.46,94.68},
	{1267.84,-776.96,1091.91,231.34},
	{2536.53,-1294.84,1044.13,254.95},
	{2350.16,-1181.07,1027.98,99.19},
	{-2158.67,642.09,1052.38,86.54},
	{419.89,2537.12,10.0,67.65},
	{256.9,-41.65,1002.02,85.88},
	{204.17,-165.77,1000.52,181.76},
	{1133.35,-7.85,1000.68,165.85},
	{-1420.43,1616.92,1052.53,159.13},
	{493.14,-24.26,1000.68,356.99},
	{1727.29,-1642.95,20.23,172.42},
	{-202.84,-24.03,1002.27,252.82},
	{2233.69,-1112.81,1050.88,8.65},
	{1211.25,1049.02,359.94,170.93},
	{2319.13,-1023.96,1050.21,167.4},
	{2261.1,-1137.88,1050.63,266.88},
	{-944.24,1886.15,5.01,179.85},
	{-26.19,-140.92,1003.55,2.91},
	{2217.28,-1150.53,1025.8,273.73},
	{1.55,23.32,1199.59,359.91},
	{681.62,-451.89,-25.62,166.17},
	{234.61,1187.82,1080.26,349.48},
	{225.57,1240.06,1082.14,96.29},
	{224.29,1289.19,1082.14,359.87},
	{239.28,1114.2,1080.99,270.27},
	{207.52,-109.74,1005.13,358.62},
	{295.14,1473.37,1080.26,352.95},
	{-1417.89,932.45,1041.53,0.7},
	{446.32,509.97,1001.42,330.57},
	{2306.38,-15.24,26.75,274.49},
	{2331.9,6.78,26.5,100.24},
	{663.06,-573.63,16.34,264.98},
	{-227.57,1401.55,27.77,269.3},
	{-688.15,942.08,13.63,177.66},
	{-1916.13,714.86,46.56,152.28},
	{818.77,-1102.87,25.79,91.14},
	{255.21,-59.68,1.57,1.46},
	{446.63,1397.74,1084.3,343.96},
	{227.39,1114.66,1081.0,267.46},
	{227.76,1114.38,1080.99,266.26},
	{261.12,1287.22,1080.26,178.91},
	{291.76,-80.13,1001.52,290.22},
	{449.02,-88.99,999.55,89.66},
	{-27.84,-26.67,1003.56,184.31},
	{2135.2,-2276.28,20.67,318.59},
	{306.2,307.82,1003.3,203.14},
	{24.38,1341.18,1084.38,8.33},
	{963.06,2159.76,1011.03,175.31},
	{2548.48,2823.74,10.82,270.6},
	{215.15,1874.06,13.14,177.55},
	{221.68,1142.5,1082.61,184.96},
	{2323.71,-1147.65,1050.71,206.54},
	{345.0,307.18,999.16,193.64},
	{411.97,-51.92,1001.9,173.34},
	{-1421.56,-663.83,1059.56,170.93},
	{773.89,-47.77,1000.59,10.72},
	{246.67,65.8,1003.64,7.96},
	{-1864.94,55.73,1055.53,85.85},
	{-262.18,1456.62,1084.37,82.46},
	{22.86,1404.92,1084.43,349.62},
	{140.37,1367.88,1083.86,349.24},
	{1494.86,1306.48,1093.3,196.07},
	{-1813.21,-58.01,1058.96,335.32},
	{-1401.07,1265.37,1039.87,178.65},
	{234.28,1065.23,1084.21,4.39},
	{-68.51,1353.85,1080.21,3.57},
	{-2240.1,136.97,1035.41,269.1},
	{297.14,-109.87,1001.52,20.23},
	{316.5,-167.63,999.59,10.3},
	{-285.25,1471.2,1084.38,85.65},
	{-26.83,-55.58,1003.55,3.95},
	{442.13,-52.48,999.72,177.94},
	{2182.2,1628.58,1043.87,224.86},
	{748.46,1438.24,1102.95,0.61},
	{2807.36,-1171.7,1025.57,193.71},
	{366.0,-9.43,1001.85,160.53},
	{2216.13,-1076.31,1050.48,86.43},
	{2268.52,1647.77,1084.23,99.73},
	{2236.7,-1078.95,1049.02,2.57},
	{-2031.12,-115.83,1035.17,190.19},
	{2365.11,-1133.08,1050.88,177.39},
	{1168.51,1360.11,10.93,196.59},
	{315.45,976.6,1960.85,359.64},
	{1893.07,1017.9,31.88,86.1},
	{501.96,-70.56,998.76,171.57},
	{-42.53,1408.23,1084.43,172.07},
	{2283.31,1139.31,1050.9,19.7},
	{84.92,1324.3,1083.86,159.56},
	{260.74,1238.23,1084.26,84.31},
	{-1658.17,1215.0,7.25,103.91},
	{-1961.63,295.24,35.47,264.49}
};
new IntArray2[146][1] = {
	{11},
	{5},
	{3},
	{3},
	{3},
	{3},
	{3},
	{18},
	{1},
	{3},
	{2},
	{3},
	{3},
	{3},
	{3},
	{3},
	{3},
	{3},
	{3},
	{17},
	{17},
	{5},
	{5},
	{17},
	{7},
	{5},
	{2},
	{10},
	{10},
	{7},
	{1},
	{1},
	{1},
	{1},
	{1},
	{3},
	{5},
	{1},
	{1},
	{7},
	{2},
	{10},
	{1},
	{2},
	{1},
	{10},
	{3},
	{10},
	{1},
	{2},
	{2},
	{2},
	{18},
	{18},
	{3},
	{5},
	{2},
	{5},
	{1},
	{10},
	{14},
	{14},
	{12},
	{14},
	{17},
	{18},
	{16},
	{5},
	{6},
	{9},
	{10},
	{17},
	{16},
	{15},
	{1},
	{1},
	{3},
	{2},
	{1},
	{5},
	{15},
	{15},
	{15},
	{12},
	{0},
	{0},
	{0},
	{18},
	{0},
	{0},
	{0},
	{0},
	{2},
	{5},
	{5},
	{4},
	{4},
	{4},
	{4},
	{0},
	{4},
	{10},
	{1},
	{0},
	{0},
	{4},
	{12},
	{6},
	{12},
	{4},
	{6},
	{6},
	{14},
	{4},
	{5},
	{5},
	{3},
	{14},
	{16},
	{6},
	{6},
	{6},
	{6},
	{6},
	{15},
	{6},
	{6},
	{2},
	{6},
	{8},
	{9},
	{1},
	{1},
	{2},
	{3},
	{8},
	{0},
	{9},
	{10},
	{11},
	{8},
	{11},
	{9},
	{9},
	{0},
	{0}
};

new PlayerJobName[30][MAX_ITEM_LENGTH+1];



new bool:vehicleList[MAX_VEHICLES];

enum e_item_info
{
	item_name[(MAX_ITEM_LENGTH+1) char],
	item_amount
};
new e_player_item[MAX_PLAYERS][MAX_ITEM][e_item_info];

new ViewPage[MAX_PLAYERS];
new SelectItem[MAX_PLAYERS][32 char];
new beforeStr[30];


/* gas stations list
3714.6628 522.0750 10.7310 -1
1004.0070 -939.3102 42.1797 -2
1944.3260 -1772.9254 13.3906 -3
-90.5515 -1169.4578 2.4079 -4
-1609.7958 -2718.2048 48.5391 -5
-2029.4968 156.4366 28.9498 -6
-2408.7590 976.0934 45.4175 -7
-2243.9629 -2560.6477 31.8840 -8
-1676.6323 414.0262 6.9484 -9 and so on :)
2202.2349 2474.3494 10.5258
614.9333 1689.7418 6.6968
-1328.8250 2677.2173 49.7665
70.3882 1218.6783 18.5165
2113.7390 920.1079 10.5255
2640.3997 1115.1472 10.5930
2146.6772 2749.3394 10.5925
1595.8685 2201.7771 10.5911
1388.5361 1496.2334 10.5926
-1464.4287 1863.5211 32.4067
652.9681 -560.4437 16.1085
1383.7537 461.6335 19.8969
1763.8405 -2539.2888 13.3183
-1657.7621 -313.3628 13.9160
-403.9550 441.2943 17.7999
*/