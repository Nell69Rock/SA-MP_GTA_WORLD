#include <a_samp>
#include <a_mysql>
#include <md5>
#include <previewModelDialog>
#include "GTA_WORLD_VARIABLE.pwn"
#include "GTA_WORLD_FUNC.pwn"


main()
{

}

//##################USER FUNCTION#########################


public OnGameModeInit()
{
	new string[128];
	
	format(string, sizeof(string), "hostname %s", SERVER1);
	SendRconCommand(string);

	format(string, sizeof(string), "%s", SCRIPT_VERSION);
	SendRconCommand(string);
	SetGameModeText(string);
	format(string, sizeof(string), "weburl %s", WEBSITE);
	SendRconCommand(string);

	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	DisableNameTagLOS();
	ManualVehicleEngineAndLights();
	
	/*	NONE Logs absolutely nothing.
	    ERROR Logs errors.
	    WARNING Logs warnings.
 		INFO Logs informational messages.
	    DEBUG Logs debug messages.
	    ALL Logs everything.
	*/
	
	//##############SQL####################
	g_Sql = mysql_connect_file();
	if(mysql_errno() != 0)
		print("SQL: Could not connect to database!");
	else
	    print("SQL: Success connect to database!");
	mysql_log(ALL); //logs everything (errors, warnings and debug messages)
	//##############GANGZONE##############
	CreateGangZone();
	//##############TIMER#################
	SetTimer("IsPlayerInArea",1000, true);
	SetTimer("setPlayerEnvironment", HOURS, true);	
	return 1;
}

public OnGameModeExit()
{
	mysql_close(g_Sql);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	new query[128];
	
	SetPlayerCameraPos(playerid, -246.1735, 9.5516, 28.9669);
	SetPlayerCameraLookAt(playerid, -245.2445, 9.9320, 28.0619);
	GameTextForPlayer(playerid, "~w~WELECOME TO ~r~~h~GTA:WORLD",5000,3);
	
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM `xe_member` WHERE `user_id` LIKE '%s'", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "CheckAccount", "i", playerid);

	return 1;
}

public OnPlayerConnect(playerid)
{
	new string[64];
    format(string, sizeof(string),"SYSTEM) "#C_WHITE"%s(%d)님이 들어왔습니다.", PlayerName(playerid), playerid);
    SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new string[64];

    new szDisconnectReason[3][] =
    {
        "Timeout/Crash",
        "Quit",
        "Kick/Ban"
    };

	HideForGZ(playerid);
    format(string, sizeof(string), "SYSTEM) "#C_WHITE"%s(%d)님이 게임을 종료하였습니다.(%s).", PlayerName(playerid), playerid, szDisconnectReason[reason]);
    SendClientMessageToAll(COLOR_YELLOW, string);
    return 1;
}


public OnPlayerSpawn(playerid)
{
	///########################INIT_DATA#######################
	InitUserData(playerid);
	//#########################LOAD_DATA#######################
	SQL_CALL_CheckUserData(playerid); // check first

	if(Player[playerid][RESULT] > 0) // user data exitsts
	{
		SQL_CALL_LoadUserData(playerid);
		SQL_CALL_LoadVehicleData(playerid);
		SQL_CALL_LoadLocationData(playerid);
		Player[playerid][RESULT] = 0; // user result init
	} else SQL_CALL_SetupUserData(playerid);// make sql data;
	
	//#########################ICONS###########################
    ShowForICON(playerid);
	//#########################GANGZONE########################
 	ShowForGZ(playerid);
	//#########################TUTORIAL########################
	if(Player[playerid][TUTORIAL] == 0)
	    ShowPlayerDialog(playerid, DIALOG_V_OFF, DIALOG_STYLE_MSGBOX,"튜토리얼", ShowUserText("tutorial_WORLD.txt"), "다음","");
	else //spawn user location with include vehicle
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	new Float:vHealth;
	if(IsPlayerInAnyVehicle(playerid) && GetVehicleHealth(GetPlayerVehicleID(playerid),vHealth) < 650)
	{
	    SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
	    RepairVehicle(GetPlayerVehicleID(playerid));
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256];
	switch(dialogid)
	{
		case DIALOG_ID:
		{
			if(!response) Kick(playerid);
			ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_MSGBOX, "LOGIN_ERROR", "계정 정보가 확인되지 않습니다.\n\"Nell69Rock.myq-see.com/outpost\"\n혹은 샘프 서버 정보창에서 보이는 URL을 클릭하여 사이트 가입 후 이용해 주시기 바랍니다.","확인","");
			return 1;
		}
		case DIALOG_LOG:
		{
			if(!response) Kick(playerid);
			
			if(strlen(inputtext) <= 0)
				ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN","계정 비밀번호가 일치하지 않습니다. 다시 입력해주세요.\n(계정 비밀번호는 사이트의 비밀번호와 동일합니다.)","입력", "취소");
			
			md5(str, inputtext, sizeof(str));
			
			if(CheckPassword(playerid, str) != 0)
				ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN","계정 비밀번호가 일치하지 않습니다. 다시 입력해주세요.\n(계정 비밀번호는 사이트의 비밀번호와 동일합니다.)","입력", "취소");
			
			SendClientMessage(playerid, COLOR_RED, "INFO) "#C_WHITE"성공적으로 로그인이 되었습니다. 즐거운 게임 되시길 바랍니다.");
			SpawnPlayer(playerid);
			return 1;
		}
		case DIALOG_V_CON:
		{
			new size = sizeof(VEHICLE_CONVERTIBLES);
			if (!response) return 0;
			ShowPlayerDialog(playerid, DIALOG_V_VEH, DIALOG_STYLE_PREVIEW_MODEL, "Vehicle Shop Dialog", ShowPlayerModelDialog(playerid, VEHICLE_CONVERTIBLES, size), "Purchase", "Cancel");
			return 1;
		}
		case DIALOG_V_IND:
		{
			new size = sizeof(VEHICLE_INDUSTRIAL);
			if (!response) return 0;
			ShowPlayerDialog(playerid, DIALOG_V_VEH, DIALOG_STYLE_PREVIEW_MODEL, "Vehicle Shop Dialog", ShowPlayerModelDialog(playerid, VEHICLE_INDUSTRIAL, size), "Purchase", "Cancel");
			return 1;	
		}
		case DIALOG_V_LOW:
		{
			new size = sizeof(VEHICLE_LOWRIDERS);
			if (!response) return 0;
			ShowPlayerDialog(playerid, DIALOG_V_VEH, DIALOG_STYLE_PREVIEW_MODEL, "Vehicle Shop Dialog", ShowPlayerModelDialog(playerid, VEHICLE_LOWRIDERS, size), "Purchase", "Cancel");
			return 1;
		}
		case DIALOG_V_OFF:
		{
			new size = sizeof(VEHICLE_OFFROAD);
			if (!response) return 0;
			ShowPlayerDialog(playerid, DIALOG_V_VEH, DIALOG_STYLE_PREVIEW_MODEL, "Vehicle Shop Dialog", ShowPlayerModelDialog(playerid, VEHICLE_OFFROAD, size), "Purchase", "Cancel");
			return 1;
		}
		case DIALOG_V_SAL: // 승용차
		{
			new size = sizeof(VEHICLE_SALOONS);
			if (!response) return 0;
			ShowPlayerDialog(playerid, DIALOG_V_VEH, DIALOG_STYLE_PREVIEW_MODEL, "Vehicle Shop Dialog", ShowPlayerModelDialog(playerid, VEHICLE_SALOONS, size), "Purchase", "Cancel");
			return 1;
		}
		case DIALOG_V_SPO: 
		{
			new size = sizeof(VEHICLE_SPORTS);
			if (!response) return 0;
			ShowPlayerDialog(playerid, DIALOG_V_VEH, DIALOG_STYLE_PREVIEW_MODEL, "Vehicle Shop Dialog", ShowPlayerModelDialog(playerid, VEHICLE_SPORTS, size), "Purchase", "Cancel");
			return 1;
		}
		case DIALOG_V_VEH:
		{
			new Float:X, Float: Y, Float: Z;
			if(!response) return 0;
			CheckUserTutorial(playerid);
			if(Player[playerid][MONEY] < Player[playerid][TEMP_MODEL_PRICE][listitem])
			{
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"구매하기 위한 금액이 모자랍니다.");
				return 0;
			}
			CheckUserVehicle(playerid, Player[playerid][TEMP_MODEL_NUM][listitem]);
			GetPlayerPos(playerid, X,Y,Z);
			Player[playerid][MONEY] -= Player[playerid][TEMP_MODEL_PRICE][listitem];
	        new my_vehicle_id = CreateVehicle(Player[playerid][TEMP_MODEL_NUM][listitem], X, Y, Z, 0, 0, 0, -1);
			SetPlayerMoney(playerid, Player[playerid][MONEY]);
	        PutPlayerInVehicle(playerid, my_vehicle_id, 0);
			return 1;
		}
		
	}
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
