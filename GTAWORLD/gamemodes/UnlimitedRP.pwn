#include <a_samp>
#include <a_mysql>
#include <md5>
#include <previewModelDialog> // NON-plugin so, compiling time fucking loooooooooooong
#include <streamer>
#include <foreach>
#include <audio>
#include "uservariable.pwn"
#include "userfunction.pwn"


 //악세사리 기능 생성. (구매 기능은 만들었고, 집에 저장 하는 기능 만들어야함. 옷이랑 같이 ㅇㅇ) 

					   
// 은행 계좌 및 이자율 설정 할 수 있도록 해야함. -- > 이건 설정 함. 

// 페이, 차량, 편의점 등등만 구현하면 거진 될듯.

// 편의점, 어드민 명려어 재수정 (맵 아이콘 추가 / 삭제, 건물 추가 삭제, NPC추가 삭제 등)

// 소지품 관리 


main()
{
	print("\n----------------------------------");
	print(" WELCOME TO Unlimited Role Playing Game Made By. Nell완자");
	print("----------------------------------\n");
}

public OnGameModeInit()
{

	new hour = gettime(hour);
	new weather = random(10);
	new string[64];

	/* Initialize WORLD */
	
	SetWorldTime(hour);
	SetWeather(weather);
	format(string, sizeof(string), "hostname %s", SERVER1);
	SendRconCommand(string);

	format(string, sizeof(string), "hostname %s", SERVER2);
	SendRconCommand(string);
	format(string, sizeof(string), "%s", SCRIPT_VERSION);
	SendRconCommand(string);
	SetGameModeText(string);
	format(string, sizeof(string), "weburl %s", WEBSITE);
	SendRconCommand(string);

	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	ShowPlayerMarkers(0);
	AllowInteriorWeapons(1);
	DisableNameTagLOS();
	ManualVehicleEngineAndLights();
	
	for (new t; t < sizeof g_textdraws; t++)
	{
		g_Speedometer[t] = TextDrawCreate(g_textdraws[t][ETDInfo_x], g_textdraws[t][ETDInfo_y], g_textdraws[t][ETDInfo_text]);
		TextDrawLetterSize(g_Speedometer[t], g_textdraws[t][ETDInfo_letterSizeX], g_textdraws[t][ETDInfo_letterSizeY]);
		if ((g_textdraws[t][ETDInfo_textSizeX] != 0.0) || (g_textdraws[t][ETDInfo_textSizeY] != 0.0))
		{
			TextDrawTextSize(g_Speedometer[t], g_textdraws[t][ETDInfo_textSizeX], g_textdraws[t][ETDInfo_textSizeY]);
		}
		TextDrawAlignment(g_Speedometer[t], g_textdraws[t][ETDInfo_alignment]);
		TextDrawColor(g_Speedometer[t], g_textdraws[t][ETDInfo_color]);
		TextDrawUseBox(g_Speedometer[t], g_textdraws[t][ETDInfo_useBox]);
		TextDrawBoxColor(g_Speedometer[t], g_textdraws[t][ETDInfo_boxColor]);
		TextDrawSetShadow(g_Speedometer[t], g_textdraws[t][ETDInfo_shadow]);
		TextDrawSetOutline(g_Speedometer[t], g_textdraws[t][ETDInfo_outline]);
		TextDrawBackgroundColor(g_Speedometer[t], g_textdraws[t][ETDInfo_backgroundColor]);
		TextDrawFont(g_Speedometer[t], g_textdraws[t][ETDInfo_font]);
		TextDrawSetProportional(g_Speedometer[t], g_textdraws[t][ETDInfo_proportional]);
	}
    foreach (new p : Player)
    {
        CreatePersonalizedTextdraws(p);
        if (GetPlayerState(p) == PLAYER_STATE_DRIVER)
        {
            ShowSpeedometer(p);
        }
    }

    // Probably deprecated
    

    print("  -> XSpeedo has been loaded. Project: https://github.com/XeonMaster/Xeon-SpeedoMeter");

	

	/* SQL SETTINGS */
	g_Sql = mysql_connect_file();
	if(mysql_errno() != 0)
	{
		print("SQL: Could not connect to database!");
	}
	else
	{
	    print("SQL: Success connect to database!");
	}
	mysql_log(ALL); //logs everything (errors, warnings and debug messages)
	mysql_set_charset("euckr", g_Sql);

	/* PlaerJobName Initialize */

	for(new i = 0; i < sizeof(PlayerJobName); i++)
	{
		strcpy(PlayerJobName[i], "0", 1);
	}

	/* SQL_CALL_FUNC */
	SQL_CALL_LoadEnterExitData();
	SQL_CALL_LoadBuyData();
	SQL_CALL_LoadVehicleData();
	SQL_CALL_LoadMapIcon();
	SQL_CALL_LoadActorData();
	SQL_CALL_LoadJobList();


	/* Set Player Timer */
	SetTimer("ServerStatus", 1000*5, true);
	SetTimer("SetEnviroment",(1000*60)*30,true);
	SetTimer("PlayerStatus", 1000*1, true);
	return 1;
}

public OnGameModeExit()
{
	foreach (new i : Player)
    {
        printf("Removing for player ID %d", i);
        DestroyPersonalizedTextdraws(i);
        printf("Removing for player ID %d done.", i);
    }
    for (new i = 0; i < sizeof g_Speedometer; i++)
    {
        TextDrawDestroy(g_Speedometer[i]);
    }
    print("  -> XSpeedo has been unloaded. Project: https://github.com/XeonMaster/Xeon-SpeedoMeter");
	mysql_close(g_Sql);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	new query[128];
	SetPlayerCameraPos(playerid, -246.1735, 9.5516, 28.9669);
	SetPlayerCameraLookAt(playerid, -245.2445, 9.9320, 28.0619);
	
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM account WHERE id = '%s'", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "CheckAccount", "i", playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
    new string[64];
	if(!IsPlayerNPC(playerid))
	{
		if(RPnamecheck(playerid))
		{
			format(string,sizeof string,"NOTICE)"#C_WHITE" %s(%d)님이 접속 하였습니다.", PlayerName(playerid), playerid);
			SendClientMessageToAll(COLOR_YELLOW, string);

			SetPlayerVirtualWorld(playerid, 1 + random(10));
			SetSpawnInfo(playerid, 0, 26, 1685.5864,-2333.1328,13.5469,0.0,0,0,0,0,0,0); // 우선 CJ로 스폰 한 후 해당 캐릭터 불러오도록 해야함.
			SetPlayerColor(playerid, COLOR_WHITE);
			
			print(string);

			g_Gear[playerid] = "P";
			CreatePersonalizedTextdraws(playerid);
			return 1;
		}
		SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"이름 양식이 맞지 않습니다. 이름_(중간이름)_성 식으로 수정하세요.");
		SetTimerEx("DelayedKick", 1000, false, "i", playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new szString[96];
    new szDisconnectReason[3][] =
    {
        "Timeout/Crash",
        "Quit",
        "Kick/Ban"
    };
	if(!IsPlayerNPC(playerid))
	{
		SaveUserData(playerid);
		Player[playerid][LOGIN] = false;
		Player[playerid][SEED] = 0;
		format(szString, sizeof szString, "NOTICE)"#C_WHITE" %s(%d)님이 접속 종료 하였습니다. 사유:(%s).", PlayerName(playerid),playerid, szDisconnectReason[reason]);
		SendClientMessageToAll(COLOR_YELLOW, szString);
		print(szString);
	}
	DestroyPersonalizedTextdraws(playerid);
    for (new i = 0; i < sizeof g_Speedometer; i++)
    {
        TextDrawHideForPlayer(playerid, g_Speedometer[i]);
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
		GameTextForPlayer(playerid, "Load Player Information...", 3000, 4);
		SetTimerEx("DelaySpawnPlayer", 3000, false, "i", playerid);		
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    new string[MAX_CHATBUBBLE_LENGTH+1];
	new strinsStr[MAX_CHATBUBBLE_LENGTH+1];
	new textTime, positionStart, positionEnd;
	new givePlayerid = -1;

	if(Player[playerid][SEED] > 0)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(Player[playerid][PHONE] == Player[i][SEED]) // 내 번호를 가진 새기가 있으면. 나 자신을 제외하고.
			{
				givePlayerid = i; // 그새기 인덱스 번호
				format(string,sizeof(string),"(통화중)☏%d: %s",Player[playerid][PHONE],text); //기본 양식 생성함.
				SendClientMessage(playerid, COLOR_YELLOW, string);
				SendClientMessage(givePlayerid, COLOR_YELLOW, string);			
				break;
			}
		}
		if(givePlayerid == -1)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"상대방과의 연결이 끊겼습니다. N키 -> 통화 종료.");
		}
	}
    if(strlen(text) <= sizeof(string)) // 읽은 text값이 string 값 보다 작아야함.
    {
		format(string,sizeof(string),"%s: %s", PlayerName(playerid),text); //기본 양식 생성함.
		for(new i = 0; i < sizeof(string); i++)
		{
			if(string[i] == '*') // 각주 형식 나오면
			{
				textTime++; // *이 그냥 한개면.
				if(textTime == 1)
				{
					positionStart = i;
				}
				if(textTime == 2)
				{
					
					format(strinsStr, sizeof(strinsStr), ""#C_PURPLE"");
					strins(string, strinsStr, positionStart, sizeof(string)); //Insert a string into another string.
					// 기존에 들어있는 string에 PositionStart 부터 sizeof 크기 만큼 보라색으로 변경 한다는 뜻.

					i += 9; //#C_PURPLE DEFINE {C2A2DA} 를 뛰어 넘??야 하는데 8개 -> 9번째 자리 부터 
					positionEnd = i;

					format(strinsStr,sizeof(strinsStr),""#C_WHITE"");
					strins(string,strinsStr,positionEnd, sizeof(string));
					// 기존에 들어있는 string에 PositionStart 부터 sizeof 크기 만큼 다시 흰색으로 변경한다는 뜻.
					break;
				}
			}
		}
		SetPlayerChatBubble(playerid,string,COLOR_FADE1,15.0,10000); // 차에 타면 버블 챗이 안보여야 하는게 정상.
		ProxDetector(15.0,playerid,string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	}        
    return false;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new errorString[128], string[128], tmp[128], cmd[128], tmp2[128];
	new idx;
	cmd = strtok(cmdtext, idx, 0);
	//--------------------------------------------------- User Command ----------------------------------------------------//
	if(strcmp(cmd, "/me", true) == 0 || strcmp(cmd, "/행동", true) == 0 )
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /me [행동] 또는 /행동 [행동]");
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" ex) /me 담배에 불을 붙인다.");
			return 1;
		}
		format(string, sizeof(string), "*(행동) %s(이)가 %s", PlayerName(playerid), tmp);
		ProxDetector(15.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 1;
	}

	if(strcmp(cmd, "/whisper", true) == 0 || strcmp(cmd, "/w", true) == 0 || strcmp(cmd, "/귓속말", true) == 0)
	{
		new givePlayerid = -1;
		new Float:X, Float:Y, Float:Z;
		tmp = strtok(cmdtext, idx, 0);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(w)hisper [플레이어 번호] [말] 또는 /귓속말 [플레이어 번호] [말]");
			return 1;
		}
		givePlayerid = strval(tmp);
		if(givePlayerid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" 입력한 플레이어 번호는 없는 번호 입니다.");
			return 1;
		}
		tmp2 = strtok(cmdtext, idx, 1);
		if(!strlen(tmp2))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(w)hisper [플레이어 번호] [할 말] 또는 /귓속말 [플레이어 번호] [할 말]");
			return 1;
		}
		GetPlayerPos(givePlayerid, X, Y, Z);
		//IsPlayerInRangeOfPoint(playerid, Float:range, Float:x, Float:y, Float:z)
		if(IsPlayerInRangeOfPoint(playerid, 2.0, X, Y, Z))
		{
			format(string, sizeof(string), "/me %s에게 속삭입니다.", PlayerName(givePlayerid));
			OnPlayerCommandText(playerid, string);

			format(string, sizeof(string), "*(귓속말) ◀ %s: %s", PlayerName(playerid), tmp2);
			SendClientMessage(givePlayerid, COLOR_YELLOW, string);

			format(string, sizeof(string), "*(귓속말) ▶ %s: %s", PlayerName(givePlayerid), tmp2);
			SendClientMessage(playerid,  COLOR_YELLOW, string);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" 해당 플레이어가 내 옆에 없습니다.");
			return 1;
		}
	}
	if(strcmp(cmd, "/r", true) == 0 || strcmp(cmd, "/radio", true) == 0 || strcmp(cmd, "/무전", true) == 0)
	{
		if(GetPlayerItem(playerid, "무전기"))
		{
			tmp = strtok(cmdtext, idx, 0);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(r)radio [소리/주파수/할말] (0 ~ 999) 또는 /무전 [소리/주파수/할말] (0 ~ 999)");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" frequency < 0 = Device OFF");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" sound < 0 = Earphone");
				return 1;
			}
			if(strcmp(tmp, "주파수") != 0 || strcmp(tmp, "소리") != 0)
			{
				if(Player[playerid][RFREQ] >= 0)
				{
					// 주파수가 아니면 그냥 해당 주파수에 말 할 수 있도록 하면 됨 ㅇㅈ? ㅇㅇ 나만인정.
					OnPlayerCommandText(playerid, "/me 무전기를 만지작 거립니다.");
					format(string,sizeof(string),"*(Radio 발신) %s: %s",PlayerName(playerid), tmp);
					ProxDetector(Player[playerid][RFREQ_SOUND],playerid,string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
					format(string,sizeof(string),"*(Radio 수신) %s: %s",PlayerName(playerid), string);
					SendRadioMessage(playerid, COLOR_RADIO, string, Player[playerid][RFREQ]);
					return 1;
				}
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"전원이 꺼져있습니다. 주파수를 설정해 주세요.");
				return 1;
			}
			tmp2 = strtok(cmdtext, idx, 1);
			if(!strlen(tmp2))
			{
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(r)radio [소리/주파수/할말] (0 ~ 999) 또는 /무전 [소리/주파수/할말] (0 ~ 999)");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" frequency < 0 = Device OFF");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" sound < 0 = Earphone");
				return 1;
			}
			if(strcmp(tmp, "주파수") == 0 )
			{
				if(strval(tmp2) > 999)
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"주파수 채널 범위는 0 ~ 999 입니다.");
					return 1;
				}
				if(strval(tmp2) >= 0)
				{
					Player[playerid][RFREQ] = strval(tmp2);
					format(string, sizeof(string), "SYSTEM) "#C_WHITE"주파수를 %d(으)로 변경 하였습니다.", Player[playerid][RFREQ]);
					SendClientMessage(playerid, COLOR_YELLOW, string);	
				}
				else
				{
					Player[playerid][RFREQ] = strval(tmp2);
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"무전기를 종료합니다.");
				}
				OnPlayerCommandText(playerid, "/me 무전기를 만지작 거립니다.");
				mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET frequency = %d WHERE id = '%s';",Player[playerid][RFREQ], PlayerName(playerid));
				mysql_tquery(g_Sql, string);
				return 1;
			}
			if(strcmp(tmp, "소리") == 0)
			{
				if(strval(tmp2) > 15)
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"무전기 소리 범위는 1 ~ 15 입니다.");
					return 1;
				}
				if(strval(tmp2) >= 1)
				{
					Player[playerid][RFREQ_SOUND] = strval(tmp2);
					format(string, sizeof(string), "SYSTEM) "#C_WHITE"무전기 소리를 %d(으)로 변경 하였습니다.", Player[playerid][RFREQ_SOUND]);
					SendClientMessage(playerid, COLOR_YELLOW, string);	
				}
				else
				{
					Player[playerid][RFREQ_SOUND] = strval(tmp2);
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"무전기에 이어폰을 착용합니다.");
				}
				OnPlayerCommandText(playerid, "/me 무전기를 만지작 거립니다.");
				mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET freqSound = %d WHERE id = '%s';",Player[playerid][RFREQ_SOUND], PlayerName(playerid));
				mysql_tquery(g_Sql, string);
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"무전기를 가지고 있지 않습니다.");
			return 1;
		}
	}
	if(strcmp(cmd,"/shout",true)== 0 || strcmp(cmd,"/s",true)== 0 || strcmp(cmd,"/외침",true)==0)
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /s(hout) [할 말] 또는 /외침 [할 말]");
			return 1;
		}
		/*if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1,0,1,1,1,1,1);		
		}*/
		format(string, sizeof(string), "*(외침) %s: %s!", PlayerName(playerid), tmp);
		ProxDetector(30.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3);
		return 1;
	}

	if(strcmp(cmd,"/close",true)== 0 || strcmp(cmd,"/c",true)== 0 || strcmp(cmd,"/작게",true)== 0)
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" (/c)lose [할 말] 또는 /작게 [할 말]");
			return 1;
		}
		format(string, sizeof(string), "*(작게 말 함) %s: %s", PlayerName(playerid), tmp);
		ProxDetector(2.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		return 1;
	}
	
	if(strcmp(cmd, "/st", true) == 0 || strcmp(cmd, "/상태", true) == 0 || strcmp(cmd, "/state", true) == 0) 
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /st(ate) [상태] 또는 /상태 [상태]");
			return 1;
		}
		format(string, sizeof(string), "*(상태) %s: %s",  PlayerName(playerid), tmp);
		ProxDetector(15.0, playerid, string, COLOR_STATE, COLOR_STATE, COLOR_STATE, COLOR_STATE, COLOR_STATE);
		return 1;
	}
	if(strcmp(cmd, "/ooc", true) == 0 || strcmp(cmd, "/o", true) == 0)
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /o(oc) [할 말]");
			return 1;
		}
		format(string, sizeof(string), "*(OOC) %s(%d): %s" ,PlayerName(playerid), playerid, tmp);
		SendClientMessageToAll(COLOR_LIGHTBLUE,string);
		return 1;
	}
	if(strcmp(cmd, "/b", true) == 0)
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /b [할말]");
			return 1;
		}
		format(string, sizeof(string), "*(근처 OOC) %s(%d): %s", PlayerName(playerid),playerid , tmp);
		ProxDetector(30.0, playerid, string, COLOR_FADE3, COLOR_FADE3, COLOR_FADE3, COLOR_FADE3, COLOR_FADE3);
		return 1;	
	}
	if(strcmp(cmd, "/oocpm", true) == 0 || strcmp(cmd, "/op", true) == 0) //좆목 때문에 좆같긴 한데 한번 고려는 해봐야지.
	{
		new givePlayerid = -1;
		tmp = strtok(cmdtext, idx, 0);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /oocpm [플레이어 번호] [할 말]");
			return 1;
		}
		givePlayerid = strval(tmp);
		if(givePlayerid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" 입력한 플레이어 번호는 없는 번호 입니다.");
			return 1;
		}
		tmp2 = strtok(cmdtext, idx, 1);
		if(!strlen(tmp2))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /oocpm [플레이어번호/이름의 부분] [말]");
			return 1;
		}
		format(string, sizeof(string), "(( OOCPM ◀ %s(%d): %s ))", PlayerName(playerid), playerid, tmp2);
		SendClientMessage(givePlayerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "(( OOCPM ▶ %s(%d): %s ))", PlayerName(givePlayerid), givePlayerid, tmp2);
		SendClientMessage(playerid,  COLOR_YELLOW, string);
		return 1;
	}
	//--------------------------------------------------- Admin Command ----------------------------------------------------//
	if(strcmp(cmd, "/차소환", true) == 0)
	{
		new modelid;
		new jobid;
		new Float:X, Float:Y, Float:Z;
		new query[256];
		tmp = strtok(cmdtext, idx, 0);
		modelid = strval(tmp);
		tmp2 = strtok(cmdtext, idx, 1);
		jobid = strval(tmp2);

		GetPlayerPos(playerid, X, Y, Z);
		mysql_format(g_Sql, query, sizeof(query), "INSERT INTO vehicle(id, vModel, vHealth, X, Y, Z, vAngle, vFuel, vJob, vColor1, vColor2) VALUES ('%s', %d, 1000, %f,%f,%f,%f, 3600, %d, 0, 0)", CreateVehicleEx(modelid, 1000 , X, Y, Z, 180.0, 3600, jobid, 0, 0, PlayerName(playerid)), modelid, X,Y,Z,180.00,jobid);
		mysql_tquery(g_Sql, query);
		return 1;
	}

	if(strcmp(cmd, "/asdf", true) == 0)
	{
		Player[playerid][ADMIN] = 1;
		return 1;
	}
	if(strcmp(cmd, "/notice", true) == 0 || strcmp(cmd, "/공지", true) == 0)
	{
		if(Player[playerid][ADMIN] == 1)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" 이 명령어를 사용할 권한이 없습니다.");
			return 1;
		}
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /공지 [내용] 또는 /notice");
			return 1;
		}
		format(string, sizeof(string), "*[Admin 공지] ADMIN: %s", tmp);
		SendClientMessageToAll(0xFFB9B9FF, string);
		return 1;
	}
	format(errorString,sizeof(errorString),"ERROR)"#C_WHITE" [%s](은)는 없는 명령어 입니다. 다시한번 확인해 주시길 바랍니다.",cmdtext);
	print(errorString);
	return SendClientMessage(playerid, COLOR_ERROR, errorString);

	
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
    {
        ShowSpeedometer(playerid);
    }
    else
    {
        HideSpeedometer(playerid);
    }
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(Player[playerid][LOGIN] == false)
	{
		SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE" 먼저 로그인을 하십시오.");
		return 0;
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	//IsPlayerInRangeOfPoint(playerid, Float:range, Float:x, Float:y, Float:z)
	if(PRESSED(KEY_NO))
	{
		ShowInterActive(playerid);
		return 1;
	}
	if(PRESSED(KEY_YES))
	{
		ShowVehicleActive(playerid);
		return 1;
	}
	if(PRESSED(KEY_SECONDARY_ATTACK))
	{
		if(PlayerAnimEnd(playerid) == 0)
			PlayerKeyEnter(playerid);
		return 1;
	}
	if(PRESSED(KEY_LOOK_BEHIND))
	{
	    ShowPlayerBag(playerid);
		return 1;
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
		new Float:speed = GetPlayerAnyVelocityMagnitude(playerid) * 181.5;
		if (IsFloatNaN(speed))
		{
			speed = 0.0;
		}
		if (IsFloatZero(speed))
		{
			g_Gear[playerid] = "P";
			PlayerTextDrawDestroy(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3]);
			g_playerSpeedometer[playerid][EPSInfo_textdraws][3] = CreatePlayerTextDraw(playerid, 413.444549, 375.456115, "hud:arrow");
		}
		else
		{
			new Float:graphical_speed = speed > 200.0 ? 200.0 : speed;
			if (speed > 0.0)
			{
				if (IsVehicleDrivingBackwards(GetPlayerVehicleID(playerid)))
				{
					g_Gear[playerid] = "R";
				}
				else
				{
					g_Gear[playerid] = "D";
				}
			}
			PlayerTextDrawDestroy(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3]);
			g_playerSpeedometer[playerid][EPSInfo_textdraws][3] = CreatePlayerTextDraw(playerid, 414 + graphical_speed, 375.456115, "hud:arrow");
		}

		PlayerTextDrawLetterSize(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 8.000000, 32.039978);
		PlayerTextDrawAlignment(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 1);
		PlayerTextDrawColor(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], -1378294017);
		PlayerTextDrawSetShadow(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 0);
		PlayerTextDrawSetOutline(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 0);
		PlayerTextDrawBackgroundColor(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 255);
		PlayerTextDrawFont(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 4);
		PlayerTextDrawSetProportional(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 0);
		PlayerTextDrawSetShadow(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3], 0);
		PlayerTextDrawShow(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][3]);

		PlayerTextDrawSetString(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][2], g_Gear[playerid]);

		new str[6];
		format(str, sizeof str, "%04d", floatround(speed, floatround_floor));
		PlayerTextDrawSetString(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][1], str);
		format(str, sizeof str, "%03d%%", VEHICLE_DATA[GetPlayerVehicleID(playerid)][vFuel] / 36);
		PlayerTextDrawSetString(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][0], str);
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SHOW_BOOMBOX_LIST)
	{
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, DIALOG_SHOW_BOOMBOX_ADD_URL, DIALOG_STYLE_INPUT, "오디오 추가하기", "추가할 URL을 입력하십시오.\n지원 가능한 포맷 *.mp3, *.wav, *ogg\n유튜브, 사운드 클라우드 수정 진행 중", "추가하기", "취소");
			}
			if(listitem > 0)
			{

				new audioHandleId = GetPVarInt(playerid, "audioHandleId");
				if(audioHandleId> 0)
				{
					Audio_Stop(playerid, audioHandleId);
				}
				audioHandleId = Audio_PlayStreamed(playerid, inputtext, false,true,false);
				SetPVarInt(playerid, "audioHandleId", audioHandleId);
			}
		}
	}
	if(dialogid == DIALOG_SHOW_BOOMBOX_ADD_URL)
	{
		if(response)
		{
			new query[512];
			mysql_format(g_Sql, query, sizeof(query), "INSERT INTO boombox (id, list) VALUES ('%s', '%s');", PlayerName(playerid), inputtext);
			mysql_tquery(g_Sql, query);
			SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"붐박스에 URL을 추가하였습니다.");
		}
	}
	if(dialogid==DIALOG_INVENTORY_ID)
	{
	    if(!response)
		{
	        _GetPage(MAX_ITEM,ViewPage[playerid]-1,PAGE_ITEM) && ShowPlayerBag(playerid,ViewPage[playerid]-1);
	    }
		else if(listitem >= 0)
	    {	
			if(GetPlayerItem(playerid, inputtext))
			{
				f_strpack(SelectItem[playerid], inputtext);
				ShowPlayerDialog(playerid,DIALOG_INVENTORY_USE_ID,DIALOG_STYLE_LIST,"선택","사용하기\n버리기","확인","");
			}
			if(strcmp(inputtext,"다음페이지",true,strlen("다음페이지") )==0)
	            ShowPlayerBag(playerid,ViewPage[playerid]+1);
			if(strcmp(inputtext,"이전페이지",true,strlen("이전페이지") )==0)
	  			ShowPlayerBag(playerid,ViewPage[playerid]-1);
		}
		else ShowPlayerBag(playerid,ViewPage[playerid]);
	}
	if(dialogid==DIALOG_INVENTORY_USE_ID)
	{
	    if(response)
		{
		    if(listitem == 0)
			{
				OnPlayerUseItem(playerid, f_strunpack(SelectItem[playerid]));
				ShowPlayerBag(playerid,ViewPage[playerid]);
			}
			else  //버리기
			{
				GivePlayerItem(playerid,f_strunpack(SelectItem[playerid]),-1),
				ShowPlayerBag(playerid,ViewPage[playerid]);
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_SHOW_VEHICLE)
	{
		if(response)
		{
			if(listitem == 0 || listitem == 1) // 구매 버튼 클릭
			{
				new size = sizeof(VEHICLE_MODEL);
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_VEHICLE, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, VEHICLE_MODEL, Player[playerid][SEX], -2, size), "BUY", "CANCEL");

			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_BUY_VEHICLE)
	{
		if(response)
		{
			new userVehicleID = GetUserVehicleID(playerid);
			new query[256];
			if(Player[playerid][MONEY] < Player[playerid][SAVE_PRICE][listitem])
			{
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"잔액이 부족합니다.");
				return 0;
			}
			if(userVehicleID > -1)
			{
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"이미 차량을 가지고 있습니다.");
				return 0;
			}
			SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"차량 구매를 완료 하였습니다. 미니맵에 차량의 위치를 표시 하였습니다.");
			SetPlayerCheckpoint(playerid, 2155.1904,-1171.5243,23.8209,10);
			Player[playerid][MONEY] -= Player[playerid][SAVE_PRICE][listitem];
			CreateVehicleEx(Player[playerid][SAVE_NUM][listitem], 1000 , 2155.1904,-1171.5243,23.8209,180.0, 3600, 255, 0, 0, PlayerName(playerid));
			mysql_format(g_Sql, query, sizeof(query), "INSERT INTO vehicle(id, vModel, vHealth, X, Y, Z, vAngle, vFuel, vJob, vColor1, vColor2) VALUES ('%s', %d, 1000, 2155.1904,-1171.5243,23.8209,180.0, 3600, 255, 0, 0)", PlayerName(playerid), VEHICLE_MODEL[listitem][MODELID]);
			mysql_tquery(g_Sql, query);
			PlayerUpdateMoney(playerid);
			SaveUserData(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_SHOW_VEHICLE_STATUS) //
	{
		if(response)
		{
			new string[128]; 
			new engine, lights, alarm, doors, bonnet, boot, objective;
			new vehicleid = GetUserVehicleID(playerid);
			switch(listitem)
			{
				case 0..1: //시동
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //어떤 차에 탔어.
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); 
						if(engine != 0)  //시동이 걸려있어.
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, 0, alarm, doors, bonnet, boot, objective); 
							GameTextForPlayer(playerid, "~y~Engine ~r~OFF", 2000, 4);
							SaveUserVehicle(playerid, GetPlayerVehicleID(playerid));
							KillTimer(GetPVarInt(playerid, "FuelTimer"));
							DeletePVar(playerid, "FuelTimer");
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"시동을 껐습니다.");
							return 1;
						}
						if(GetPlayerVehicleID(playerid) == vehicleid || Player[playerid][JOB] == VEHICLE_DATA[GetPlayerVehicleID(playerid)][vJob]) //같은 당파 차량은 시동 걸 수 있게 해야지
						{
							GameTextForPlayer(playerid, "~y~Engine ~p~Starting", 2000, 4);
							SetTimerEx("PlayerVehicleEngineStart", 3000, false, "dd", playerid, GetPlayerVehicleID(playerid));
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"시동을 걸 수 없는 차량 입니다.");
						return 1;
					}
					if(vehicleid != -1) //근데 내 차는 존재 해
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, VEHICLE_DATA[vehicleid][vX], VEHICLE_DATA[vehicleid][vY], VEHICLE_DATA[vehicleid][vZ])) //내가 내 차 근처에 있어.
						{
							GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective); //차량의 상태를 구해보고
							if(engine != 0) //시동이 걸려 있어.
							{
								SendClientMessage(playerid,COLOR_RED, "VEHICLE) "#C_WHITE"원격으로 시동을 끌 순 없습니다.");
								return 1;
							}
							GameTextForPlayer(playerid, "~y~Engine ~p~Starting", 2000, 4);
							SetTimerEx("PlayerVehicleEngineStart", 3000, false, "dd", playerid, vehicleid);
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"주변에 내 차량이 존재하지 않습니다. 조금 더 가까이에서 시도 하십시오.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"현재 보유하고 있는 차량이 없습니다.");
					return 1;
				}
				case 2: // 전조등
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //占쏘떤 占쏙옙占쏙옙 占쏙옙占쏙옙
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //占시듸옙占쏙옙 占심몌옙占쏙옙 확占쏙옙
						if(lights == 1) //占심뤄옙 占쌍억옙
						{	
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 0, alarm, doors, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"전조등을 껐습니다.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 1, alarm, doors, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"전조등을 켰습니다.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"차량 운전석에 타고있지 않습니다.");
					return 1;
				}
				case 3: // 트렁크
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //占쏘떤 占쏙옙占쏙옙 占쏙옙占쏙옙
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //占시듸옙占쏙옙 占심몌옙占쏙옙 확占쏙옙
						if(boot == 1) //占심뤄옙 占쌍억옙
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 0, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"트렁크를 닫았습니다.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 1, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"트렁크를 열었습니다");
						return 1;
					}
					if(vehicleid != -1) //내 차가 존재 해
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, VEHICLE_DATA[vehicleid][vX], VEHICLE_DATA[vehicleid][vY], VEHICLE_DATA[vehicleid][vZ])) //占쏙옙 占쏙옙占쏙옙 占쏙옙처.
						{
							GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙?
							if(boot == 1) //占심뤄옙 占쌍억옙
							{
								SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 0, objective); //占시듸옙 占쏙옙占쏙옙
								SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"트렁크를 닫았습니다.");
								return 1;
							}
							SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 1, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"트렁크를 열었습니다.");
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"주변에 내 차량이 존재하지 않습니다. 조금 더 가까이에서 시도 하십시오.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"현재 보유하고 있는 차량이 없습니다.");
					return 1;
				}
				case 4: // 본넷
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //占쏘떤 占쏙옙占쏙옙 占쏙옙占쏙옙
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //占시듸옙占쏙옙 占심몌옙占쏙옙 확占쏙옙
						if(bonnet == 1) //占심뤄옙 占쌍억옙
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 0, boot, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"본넷을 닫았습니다.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 1, boot, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"본넷을 열었습니다.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"차량 운전석에 타고있지 않습니다.");
					return 1;
				}
				case 5: // 차량 문
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //占쏘떤 占쏙옙占쏙옙 占쏙옙占쏙옙
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //占시듸옙占쏙옙 占심몌옙占쏙옙 확占쏙옙
						if(doors == 1) //占심뤄옙 占쌍억옙
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 0, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"문을 열었습니다.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 1, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"문을 잠궜습니다.");
						return 1;
					}
					if(vehicleid != -1) //占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙 占쌍댐옙占쏙옙 占쏙옙占쏙옙占쏙옙 체크.
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, VEHICLE_DATA[vehicleid][vX], VEHICLE_DATA[vehicleid][vY], VEHICLE_DATA[vehicleid][vZ])) //占쏙옙 占쏙옙占쏙옙 占쏙옙처.
						{
							GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙?
							if(doors == 1) //占심뤄옙 占쌍억옙
							{
								SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙
								SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"문을 열었습니다.");
								return 1;
							}
							SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective); //占시듸옙 占쏙옙占쏙옙謗占? 占쏙옙占쏙옙
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"문을 잠궜습니다.");
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"주변에 내 차량이 존재하지 않습니다. 조금 더 가까이에서 시도 하십시오.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"현재 보유하고 있는 차량이 없습니다.");
					return 1;
				}
				case 6..7: //노래듣기
				{
					ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST, "원하는 목록을 선택하시오", "종합\n발라드/댄스/팝\n힙합/R&B\n트로트\n락/메탈\n팝송\nOST\n종료","확인","");
					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_RADIO)
	{
	    if(response)
	    {
			if(!IsPlayerInAnyVehicle(playerid))
			{
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"차량 안에서만 사용 가능합니다.");
				return 1;
			}
			switch(listitem)
			{
				case 0: PlayAudioStreamForPlayer(playerid, "http://ch01.saycast.com/");
				case 1: PlayAudioStreamForPlayer(playerid, "http://ch02.saycast.com/");
				case 2: PlayAudioStreamForPlayer(playerid, "http://ch04.saycast.com/");
				case 3: PlayAudioStreamForPlayer(playerid, "http://ch05.saycast.com/");
				case 4: PlayAudioStreamForPlayer(playerid, "http://ch06.saycast.com/");
				case 5: PlayAudioStreamForPlayer(playerid, "http://ch07.saycast.com/");
				case 6: PlayAudioStreamForPlayer(playerid, "http://ch08.saycast.com/");
				case 7: StopAudioStreamForPlayer(playerid);
			}
	    }
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_PHONE_CALL_TO_PLAYER)
	{
		new givePlayerid = -1;
		if(response)
		{
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(Player[playerid][PHONE] == Player[i][SEED]) // 내 번호를 가진 새기가 있으면.
				{
					givePlayerid = i; // 그새기 인덱스 번호
					Player[playerid][SEED] = Player[i][PHONE]; // 걔랑 나랑 연결.
					SendClientMessage(givePlayerid, COLOR_PURPLE, "INFO) "#C_WHITE"상대방과 연결되었습니다.");
					SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"상대방과 연결되었습니다.");
					break;
				}
			}
			if(givePlayerid == -1)
			{
				SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"상대방이 연결을 끊었습니다. 통화가 종료됩니다.");
				Player[playerid][SEED] = 0;
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(Player[playerid][PHONE] == Player[i][SEED]) // 내 번호를 가진 새기가 있으면.
				{
					givePlayerid = i; // 그새기 인덱스 번호
					break;
				}
			}
			Player[givePlayerid][SEED] = 0;
			Player[playerid][SEED] = 0;
			SendClientMessage(givePlayerid, COLOR_PURPLE, "INFO) "#C_WHITE"상대방이 통화를 거절 하였습니다.");
		}
		return 1;
	}
    if(dialogid == DIALOG_ID)
	{
		if(response)
		{
			if(strlen(inputtext) != 0)
	        {
				new md5Hash[64];
				md5(md5Hash, inputtext, sizeof(md5Hash));
				ComparePassword(playerid, md5Hash, 0);
				ShowPlayerDialog(playerid, DIALOG_REG, DIALOG_STYLE_PASSWORD, "회원가입","비밀번호를 한번 더 입력해주세요.","예","아니오");
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_PASSWORD, "회원가입","공백은 입력할 수 없습니다. 다시 입력해 주세요.","예","아니오");
			}
		}
		else
		{
		    Kick(playerid);
		}
		return 1;
	}
    if(dialogid == DIALOG_REG)
    {
        if(response)
        {
			if(strlen(inputtext) != 0)
	        {
				new md5Hash[64];
				md5(md5Hash, inputtext, sizeof(md5Hash));
				if(ComparePassword(playerid, md5Hash, 1) != 0) //비밀번호가 같지 않으면 다시 입력 하도록 함.
				{
					ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_PASSWORD, "회원가입","입력한 비밀번호가 같지 않습니다. 가입할 비밀번호를 설정해 주세요","예","아니오");
				}
				else // 가입할 비밀번호가 같으면.
				{
					new query[128];
					mysql_format(g_Sql, query, sizeof(query), "INSERT INTO account(id, password) VALUES ('%s', '%s')", PlayerName(playerid), md5Hash);
					mysql_tquery(g_Sql, query, "AddUser", "iii", playerid, PlayerName(playerid), md5Hash);
				}
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_PASSWORD, "LOGIN_ERROR", "공백을 입력할 수 없습니다. 회원 가입을 위해 비밀번호를 입력하세요.","예","아니오");
			}
        }
        else
        {
            Kick(playerid);
        }
        return 1;
    }
	if(dialogid == DIALOG_LOG)
	{
	    if(response)
	    {	       
			new Str[256];
	        md5(Str, inputtext, 64);
	        if(strlen(inputtext) != 0)
	        {
				if(CheckPassword(playerid, Str) == 0)
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM)"#C_WHITE" 성공적으로 로그인이 되었습니다. 즐거운 게임 되시길 바랍니다.");
					if(!Player[playerid][TUTORIAL])
					{
						ShowPlayerDialog(playerid,DIALOG_TUT,DIALOG_STYLE_MSGBOX,"USER_TUTORIAL", ShowUserText("tutorial_RP.txt"), "다음","");
					}
					else
					{
						SpawnPlayer(playerid);
					}
				}
				else
				{
				    ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN","계정 비밀번호가 일치하지 않습니다. 다시 입력해주세요.","입력", "취소");
				}
			}
			else
			{
			    ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN","계정 비밀번호가 일치하지 않습니다. 다시 입력해주세요..","입력", "취소");
			}
			
		}
		else
		{
			Kick(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_TUT)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_USER_SEX, DIALOG_STYLE_LIST, "성별을 선택하세요", "남자\n여자", "다음", "이전"); 
		}
		else
		{
			ShowPlayerDialog(playerid,DIALOG_TUT,DIALOG_STYLE_MSGBOX,"USER_TUTORIAL", ShowUserText("tutorial_RP.txt"), "다음","");
		}
		return 1;
	}
	if(dialogid == DIALOG_USER_SEX)
	{
		if(response)
		{
			if(listitem == 0)
			{
				Player[playerid][SEX] = 0; // 남자
			}
			else
			{
				Player[playerid][SEX] = 1; // 여자.
			}
			new size = sizeof(CLOTH);
			ShowPlayerDialog(playerid, DIALOG_USER_SELECT_CHARACTER, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, CLOTH, Player[playerid][SEX], -1, size), "SELECT", "CANCEL");
			
		}
		else
		{
			ShowPlayerDialog(playerid,DIALOG_TUT,DIALOG_STYLE_MSGBOX,"USER_TUTORIAL", ShowUserText("tutorial_RP.txt"), "다음","");
		}
		return 1;
	}
	if(dialogid == DIALOG_USER_SELECT_CHARACTER)
	{
		new query[256];
		if(response)
		{
			Player[playerid][SKIN] = Player[playerid][SAVE_NUM][listitem];
			SetPlayerSkin(playerid, Player[playerid][SKIN]);
			mysql_format(g_Sql, query, sizeof(query), "UPDATE information SET skin = %d WHERE id = '%s'",Player[playerid][SKIN], PlayerName(playerid));
			mysql_tquery(g_Sql, query);
			ShowPlayerDialog(playerid, DIALOG_USER_DONE, DIALOG_STYLE_INPUT, "USER_TUTORIAL", "태어난 연도를 입력하세요. (1975 ~ 2000)", "다음","이전");
			return 1;
		}
	}
	if(dialogid == DIALOG_USER_DONE)
	{
		if(response)
		{
			if(strval(inputtext) < 1975 || strval(inputtext) > 2000)
			{
				ShowPlayerDialog(playerid, DIALOG_USER_DONE, DIALOG_STYLE_INPUT, "USER_TUTORIAL", "(입력 값의 범위를 벗어났습니다!)태어난 연도를 입력하세요. (1975 ~ 2000)", "다음","이전"); 
			}
			else
			{
				new query[96];
				Player[playerid][YEAR] = strval(inputtext);
				Player[playerid][TUTORIAL] = 1;
				Player[playerid][TUTORIALCOMPLETE] = 1;

				mysql_format(
				g_Sql, 
				query, 
				sizeof(query), 
				"UPDATE information SET sex = %d, age = %d, tutorial = %d WHERE id = '%s';",
				Player[playerid][SEX],
				Player[playerid][YEAR],
				Player[playerid][TUTORIAL],
				PlayerName(playerid));
				mysql_tquery(g_Sql, query);
				SpawnPlayer(playerid);
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_USER_SEX, DIALOG_STYLE_LIST, "성별을 선택하세요", "남자\n여자", "다음", "이전"); 
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0..1:
				{
					new playerInfo[64];
					new string[256];
				
					format(playerInfo, sizeof(playerInfo), "%s의 정보", PlayerName(playerid));
					format(string, sizeof(string), "이름[%s] 나이[%d] 성별[%s]\n번호[%d]\n현금[$%d] 계좌[$%d]\n플레이시간[%d시간 %d분 %d초]",
						PlayerName(playerid), 
						(2020- Player[playerid][YEAR]), 
						Player[playerid][SEX] == 0 ? ("남자") : ("여자"),
						Player[playerid][PHONE],
						Player[playerid][MONEY],
						Player[playerid][BANK],
						Player[playerid][TIME][0],
						Player[playerid][TIME][1],
						Player[playerid][TIME][2]
					);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_INFO, DIALOG_STYLE_MSGBOX, playerInfo, string, "확인", "");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_MODIFY, DIALOG_STYLE_LIST, "상호 작용", "모자\n안경\n마스크\n시계", "수정", "취소");
				}
				case 3..4:
				{

				}
				case 5..6:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_CALL, DIALOG_STYLE_INPUT, "상호작용", "연락 할 번호를 입력하세요(8자리)", "통화하기", "취소");
				}
				case 7:
				{
					Player[playerid][SEED] = 0;
					SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"전화를 끊었습니다.");
				}
				case 8:
				{
					//보기(삭제, 문자, 통화), 추가
					ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS, DIALOG_STYLE_LIST, "상호작용", "보기\n추가", "선택", "취소");
				}
				case 9:
				{
					//보기, 보내기
					ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_MESSAGE, DIALOG_STYLE_LIST, "상호작용", "보기\n보내기", "선택", "취소");
				}
				case 10:
				{
					ShowBankDialog(playerid);
				}
			}	
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_ADMIN_INTER_ACTIVE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0..2:
				{
					new index = GetPlayerAddPick();
					ENTER_EXIT[index][EXIT_INT] = GetPlayerInterior(playerid);
					ENTER_EXIT[index][EXIT_VIRTUAL_WORLD] = GetPlayerVirtualWorld(playerid);
					GetPlayerPos(playerid, ENTER_EXIT[index][EXIT][0], ENTER_EXIT[index][EXIT][1], ENTER_EXIT[index][EXIT][2]);
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"입장 할 위치를 추가 하였습니다. !맵 아이콘 설정 후! 인테리어 이동을 통해 반드시 퇴장 위치도 지정 해주세요.");	
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_CONSTRUCTION_LIST, DIALOG_STYLE_LIST, "BUILDING SELECT", ShowUserText("building_list.txt"), "위치 이동","취소");
				}
				case 4:
				{
					new index = GetPlayerAddPick();
					new query[512];
					if(response)
					{
						ENTER_EXIT[index][ENTER_VIRTUAL_WORLD] = index;
						ENTER_EXIT[index][ENTER_INT] = GetPlayerInterior(playerid);
						GetPlayerPos(playerid, ENTER_EXIT[index][ENTER][0], ENTER_EXIT[index][ENTER][1], ENTER_EXIT[index][ENTER][2]);
						strcpy(ENTER_EXIT[index][COMMENT], PlayerName(playerid), 50);			

						mysql_format(
							g_Sql, 
							query, 
							sizeof(query), 
							"INSERT INTO `enter/exit` (enterInt, virtualWorld, exitVirtual, enterX, enterY, enterZ, exitInt, exitX, exitY, exitZ, comment) VALUES (%d, %d, %d, %f, %f, %f, %d, %f, %f, %f, '%s');", 
							ENTER_EXIT[index][ENTER_INT],
							ENTER_EXIT[index][ENTER_VIRTUAL_WORLD],
							ENTER_EXIT[index][EXIT_VIRTUAL_WORLD],
							ENTER_EXIT[index][ENTER][0], 
							ENTER_EXIT[index][ENTER][1], 
							ENTER_EXIT[index][ENTER][2],
							ENTER_EXIT[index][EXIT_INT],
							ENTER_EXIT[index][EXIT][0], 
							ENTER_EXIT[index][EXIT][1], 
							ENTER_EXIT[index][EXIT][2],
							ENTER_EXIT[index][COMMENT]);
							mysql_tquery(g_Sql, query);	
						
						TextPickup("퇴장 하려면 ["#C_RED"F"#C_WHITE"]키를 누르세요.", COLOR_WHITE, 1239, 1, ENTER_EXIT[index][ENTER][0], ENTER_EXIT[index][ENTER][1], ENTER_EXIT[index][ENTER][2]+0.3, 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,ENTER_EXIT[index][ENTER_VIRTUAL_WORLD], ENTER_EXIT[index][ENTER_INT]);
						TextPickup("입장 하려면 ["#C_RED"F"#C_WHITE"]키를 누르세요.", COLOR_WHITE, 1239, 1, ENTER_EXIT[index][EXIT][0], ENTER_EXIT[index][EXIT][1], ENTER_EXIT[index][EXIT][2]+0.3, 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ENTER_EXIT[index][EXIT_VIRTUAL_WORLD], ENTER_EXIT[index][EXIT_INT]);
						SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"건물 건설을 완료 하였습니다.");
					}	
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_CONSTRUCTION_ICON, DIALOG_STYLE_LIST, "MAPICON SELECT", ShowUserText("mapicon_list.txt") , "선택", "취소");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_PICK, DIALOG_STYLE_INPUT, "상호작용", ShowUserText("admin_buy_pick.txt"),"입력","취소");		
				}
				case 7..8:
				{
					new subString[64];
					new string[sizeof(ENTER_EXIT) * sizeof(subString)];
					for (new i = 0; i < MAX_PICK; i++)
					{
						if(i != 0 && ENTER_EXIT[i][ENTER_VIRTUAL_WORLD] == 0)
						{
							break;
						}
						format(subString, sizeof(subString), "X: %f Y: %f Z: %f makes: %s\n",
						ENTER_EXIT[i][EXIT][0],
						ENTER_EXIT[i][EXIT][1],
						ENTER_EXIT[i][EXIT][2],
						ENTER_EXIT[i][COMMENT]);
						strcat(string, subString);
					}
					ShowPlayerDialog(playerid, DIALOG_PLAYER_CONSTRUCTION_LISTOK, DIALOG_STYLE_LIST, "상호작용", string, "선택", "취소");
				}
				case 9..10:
				{
					new size = sizeof(CLOTH);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_ADMIN_ADD_ACTOR, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, CLOTH, Player[playerid][SEX], -2, size), "BUY", "CANCEL");
				}
				case 12..13:
				{
					ShowJobDialog(playerid);
				}
				case 14:
				{
					ShowPlayerDialog(playerid, DIALOG_ADMIN_ADD_JOB_LIST, DIALOG_STYLE_INPUT, "상호작용", "추가할 직업 이름을 입력하세요.", "입력", "취소");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_ADMIN_ADD_JOB_LIST)
	{
		if(response)
		{
			strcpy(beforeStr, inputtext, sizeof(beforeStr));
			SendClientMessage(playerid, COLOR_RED, beforeStr);
			ShowPlayerDialog(playerid, DIALOG_ADMIN_ADD_JOB_LIST2, DIALOG_STYLE_INPUT, "상호작용", "한번 더 입력해주세요.", "입력", "취소");
		}
	}
	if(dialogid == DIALOG_ADMIN_ADD_JOB_LIST2)
	{
		if(response)
		{
			new query[256];
			new str[30];
			new jobid = 0;
			strcpy(str, inputtext, sizeof(str));
			if(strcmp(str, beforeStr) == 0)
			{
				for(new i = 0; i < sizeof(PlayerJobName); i++)
				{
					if(strcmp(PlayerJobName[i], "0") == 0)
					{
						strcpy(PlayerJobName[i], str, sizeof(str));
						jobid = i;
						break;
					}
				}
				format(query, sizeof(query), "ADMIN) "#C_WHITE"직업 추가에 성공 하였습니다. %s", str);
				SendClientMessage(playerid, COLOR_YELLOW, query);
				mysql_format(g_Sql, query, sizeof(query), "INSERT INTO joblist (jobname, number) VALUES ('%s', %d);", PlayerJobName[jobid], jobid);
				mysql_tquery(g_Sql, query); // 사용자 쿼리 저장
			
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_ADMIN_ADD_JOB_LIST, DIALOG_STYLE_INPUT, "상호작용", "입력한 이름이 일치 하지 않습니다. \n추가할 직업 이름을 입력하세요.", "입력", "취소");
			}
			DeletePVar(playerid, "jobinput");
		}
	}
	if(dialogid == DIALOG_PLAYER_ADMIN_ADD_ACTOR)
	{
		if(response)
		{			
			new Float:X, Float:Y, Float:Z, Float:Angle;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, Angle);
			if(PlayerAddActor(CLOTH[listitem][MODELID], X, Y, Z, Angle, GetPlayerVirtualWorld(playerid), 1, 1) == 0)// 어택 금지
			{
				SendClientMessage(playerid, COLOR_RED, "ADMIN) "#C_WHITE"할당 가능한 자리가 없습니다. 개발자에게 문의 하세요.");
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_BUY_PICK)
	{
		if(response)
		{
			if(strval(inputtext) > -1 && strval(inputtext) < 100)
			{
				SetCreateBuyPick(playerid, strval(inputtext));
			}
			else
			{
				SendClientMessage(playerid, COLOR_ERROR, "ERROR) "#C_WHITE"이해할 수 없는 입력입니다.");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_CONSTRUCTION_ICON)
	{
		if(response)
		{
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"맵 아이콘 설정 완료! 인테리어 이동 후 퇴장 위치를 선택해 주세요.");
			SaveMapIcon(X, Y, Z, listitem);
			return 1;
		}
	}
	if(dialogid == DIALOG_PLAYER_CONSTRUCTION_LIST)
	{
		if(response)
		{
			new index = GetPlayerAddPick();
			SetPlayerVirtualWorld(playerid, index);
			SetPlayerInterior(playerid, IntArray2[listitem][0]);
			SetPlayerPos(playerid, IntArray[listitem][0], IntArray[listitem][1], IntArray[listitem][2]);
			SetPlayerFacingAngle(playerid, IntArray[listitem][3]);
			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"위치 이동 완료.");
		}
	}
	if(dialogid == DIALOG_PLAYER_CONSTRUCTION_LISTOK)
	{
		if(response)
		{
			new query[256];
			mysql_format(g_Sql, query, sizeof(query), "DELETE ENTER/EXIT FROM ENTER/EXIT WHERE exitX= %f;", ENTER_EXIT[listitem][EXIT][0]);
			mysql_tquery(g_Sql, query);

			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"해당 건물 삭제");
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_CALL)
	{
		if(response)
		{
			new toCallphoneNum = strval(inputtext);
			SetCallUser(playerid, toCallphoneNum);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "PHONE) "#C_WHITE"전화를 끊었습니다.");
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS)
	{
		if(response)
		{
			if(listitem == 0)
			{
				new query[128];
				mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM phoneaddress WHERE phoneNum = %d", Player[playerid][PHONE]);
				mysql_tquery(g_Sql, query, "LoadUserAddress", "i", playerid);
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_PHONE, DIALOG_STYLE_INPUT, "주소록", "추가할 사용자의 번호를 입력하세요.", "확인", "취소");
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_PHONE)
	{
		if(response)
		{
			Player[playerid][SAVE_PHONE] = strval(inputtext); // 사용자 번호 저장
			ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_NAME, DIALOG_STYLE_INPUT, "주소록", "저장할 이름을 입력하세요.", "확인", "취소");
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_NAME)
	{
		if(response)
		{
			new string[128];
			new query[256];
			mysql_format(g_Sql, query, sizeof(query), "INSERT INTO phoneaddress (`phoneNum`, `address`, `name`) VALUES (%d, %d, '%s');", Player[playerid][PHONE],Player[playerid][SAVE_PHONE], inputtext);
			mysql_tquery(g_Sql, query); // 사용자 쿼리 저장
			format(string, sizeof(string), "PHONE) "#C_WHITE"[주소록 저장]☏%d, 이름:%s",Player[playerid][SAVE_PHONE], inputtext);
			SendClientMessage(playerid, COLOR_RED, string);
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_SHOW) // 주소록 봐서 뭘 선택 했어 그러면 이제 어떻게 할지.
	{
		if(response)
		{
			if(listitem > 0)
			{
				Player[playerid][SAVE_PHONE] = Player[playerid][SAVE_NUM][listitem-1];
				ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS_SHOW_CONTENT, DIALOG_STYLE_LIST, "주소록", "통화\n문자\n삭제", "확인", "취소");
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_SHOW_CONTENT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // 통화
				{
					SetCallUser(playerid, Player[playerid][SAVE_PHONE]);
				}
				case 1: //문자
				{
					SendMessageUserDialog(playerid);
				}
				case 2: //삭제
				{
					new query[128];
					mysql_format(g_Sql, query, sizeof(query), "DELETE FROM phoneaddress WHERE phoneNum = %d AND address = %d", Player[playerid][PHONE], Player[playerid][SAVE_PHONE]);
					mysql_tquery(g_Sql, query);
					SendClientMessage(playerid, COLOR_RED, "PHONE) "#C_WHITE"해당 사용자를 삭제하였습니다.");
				}
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_MESSAGE)
	{
		if(response)
		{
			if(listitem == 0)
			{
				new query[128];
				mysql_format(g_Sql, query, sizeof(query), "SELECT DISTINCT * FROM phonemessage WHERE phoneNum = %d OR sender = %d", Player[playerid][PHONE], Player[playerid][PHONE]);
				mysql_tquery(g_Sql, query, "LoadUserMessage", "i", playerid);
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_MESSAGE_GET_NUMBER, DIALOG_STYLE_INPUT, "메시지 전송", "보낼 번호를 입력하세요.", "확인", "취소");
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_MESSAGE_GET_NUMBER)
	{
		if(response)
		{
			Player[playerid][SAVE_PHONE] = strval(inputtext);
			SendMessageUserDialog(playerid);	
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_MESSAGE_SHOW_CONTENT)
	{
		if(response)
		{
			SendMessageUserDialog(playerid);
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_MESSAGE_SEND)
	{
		new query[512];
		new givePlayerid = -1;
		new senderid = playerid;
		new string[256];
		if(response)
		{
			mysql_format(g_Sql, query, sizeof(query), "INSERT INTO phonemessage (`phoneNum`, `sender`, `message`) VALUES (%d, %d, '%s');", Player[playerid][SAVE_PHONE],Player[playerid][PHONE], inputtext);
			mysql_tquery(g_Sql, query); // 유저한테 메시지 보내기.
			SendClientMessage(playerid, COLOR_RED, "MOBILE) "#C_WHITE"문자를 보냈습니다.");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(Player[i][PHONE] == Player[playerid][SAVE_PHONE])
				{
					givePlayerid = i;
					break;
				}
			}
			if(givePlayerid != -1)
			{
				format(string, sizeof(string), "MOBILE) "#C_WHITE"☏%d번호로 문자가 왔습니다. 내용: %s", Player[senderid][PHONE], inputtext);
				SendClientMessage(givePlayerid, COLOR_RED, string);
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_MESSAGE_SHOW)
	{
		if(response)
		{
			new query[128];
			Player[playerid][SAVE_PHONE] = Player[playerid][SAVE_NUM][listitem];
			mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM phonemessage WHERE (phoneNum = %d AND sender = %d) OR (phoneNum = %d AND sender = %d) ", Player[playerid][PHONE], Player[playerid][SAVE_NUM][listitem],Player[playerid][SAVE_NUM][listitem], Player[playerid][PHONE]);
			mysql_tquery(g_Sql, query, "LoadUserMessageContents", "i", playerid);		
		}
	}
	if(dialogid == DIALOG_PLAYER_INFO)
	{
		if(response)
		{
			ShowInterActive(playerid);
		}
		else
		{
			ShowInterActive(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_MODIFY)
	{
		if(response)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, listitem) == 1)
			{ 
				EditAttachedObject(playerid, listitem);
			}
			else {
				SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE" 해당 물건은 착용 하고 있지 않습니다.");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_SHOW_BANK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0..1: //본인 입금은 현금 입금 게좌 입금은 내 계좌에서 나가는 식으로 해야함.
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK_INSERT, DIALOG_STYLE_INPUT, "Bank", "입금 할 계좌를 입력하세요.(☏전화번호)\n단, 본인에게 입금은 '은행/ATM'에서만 이용 가능합니다.", "입금", "취소")
					// 현금, 계좌 입금 두개로 나누어 해야함.
				}
				case 2: //출금
				{
					new string[128];
					format(string, sizeof(string), "%s님의 계좌 잔액은 아래와 같습니다.\n계좌 잔액 : %d$\n얼마를 인출 하시겠습니까?",PlayerName(playerid), Player[playerid][BANK]);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK_PUT, DIALOG_STYLE_INPUT, "bank", string, "출금", "취소");
					//ATM 혹은 은행에서만 가능하도록 해야함.
				}
				case 3: //잔고확인.
				{
					new string[64];
					format(string, sizeof(string), "현금 :%d$, 계좌 : %d$", Player[playerid][MONEY],Player[playerid][BANK]);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK_INSERT_EXPEND, DIALOG_STYLE_MSGBOX, "bank", string, "확인", "");
					//모바일에서도 실시간 확인 가능.
				}
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_SHOW_BANK_PUT)
	{
		new value = 0;
		new cash = strval(inputtext);
		if(response)
		{
			for(new i = 0; i < MAX_PICK; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, BUY_PICK[i][BUY][0], BUY_PICK[i][BUY][1], BUY_PICK[i][BUY][2]))
				{
					if(BUY_PICK[i][FEATURE] == 1) // 은행
					{
						value = 1;
						break;
					}
				}
			}
			if(value == 0) //은행 ATM이 아닌 경우.
			{
				SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"출금은 은행/ATM에서만 이용 가능합니다.");
			}
			else
			{
				if(Player[playerid][BANK] > cash) //출금 하려는 금액 보다 많은 계좌 금액 보유 해야함.
				{
					new query[128];
					Player[playerid][MONEY] +=cash;
					Player[playerid][BANK] -=cash;
					mysql_format(g_Sql, query, sizeof(query), "UPDATE `bank` SET `money`= `money`+%d, `account`=`account`-%d WHERE phoneNum = %d", cash,cash,Player[playerid][PHONE]);
					mysql_tquery(g_Sql, query); 
					format(query, sizeof(query), "SYSTEM) "#C_WHITE"계좌에서 %d$를 인출 하였습니다. 남은 계좌 잔액 : %d$", cash, Player[playerid][BANK]);
					SendClientMessage(playerid, COLOR_YELLOW, query);
					PlayerUpdateMoney(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"입력한 금액은 출금 할 수 없습니다. 계좌 잔액이 부족하거나 알 수 없는 입력 입니다.");
					return -1;
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_SHOW_BANK_INSERT_ACCOUNT)
	{
		new query[128];
		new cash = strval(inputtext);
		if(response)
		{
			if(Player[playerid][PHONE] == Player[playerid][SAVE_PHONE]) //나한테 보내는 경우는 현금을 입금 해야함.
			{
				if(cash > 0 || Player[playerid][MONEY] > cash) // 당연히 0보다 큰 금액을 입력 해야 하고 입력한 값 보다 낮은 값
				{
					
					Player[playerid][MONEY] -=cash;
					mysql_format(g_Sql, query, sizeof(query), "UPDATE `bank` SET `money`= `money`-%d, `account`=`account`+%d WHERE phoneNum = %d", cash,cash,Player[playerid][PHONE]);
					mysql_tquery(g_Sql, query); 		
					PlayerUpdateMoney(playerid);			
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"입력한 금액은 입금 할 수 없습니다. 금액이 부족하거나 알 수 없는 입력 입니다.");
					return -1;
				}
			}
			else //받는 사람이 나 자신아닌 경우.
			{
				if(cash > 0 || Player[playerid][BANK] > cash) //당연히 보내려는 금액보다 많은 게좌를 가지고 있어야 보냄 ㅇㅇ 0보다 커야 하고. 
				{
					new givePlayerid = -1;
					Player[playerid][BANK] -=cash;
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
						if(Player[playerid][SAVE_NUM] == Player[i][PHONE]) //내가 보낼 새기의 번호가 현재 들어와 았으면
						{
							givePlayerid = i;
							break;
						}
					}
					if(givePlayerid != -1)
					{
						Player[givePlayerid][BANK] +=cash;
					}
					mysql_format(g_Sql, query, sizeof(query), "UPDATE `bank` SET `account`=`account`+%d WHERE phoneNum = %d", cash,cash,Player[playerid][SAVE_NUM]);
					mysql_tquery(g_Sql, query); //상대방 계좌에 돈 올려줌

					mysql_format(g_Sql, query, sizeof(query), "UPDATE `bank` SET `account`=`account`-%d WHERE phoneNum = %d", cash,cash,Player[playerid][PHONE]);
					mysql_tquery(g_Sql, query); //내 계좌에 돈 낮춤.
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"입력한 금액은 입금 할 수 없습니다. 금액이 부족하거나 알 수 없는 입력 입니다.");
					return -1;
				}
			}
			format(query, sizeof(query), "BANK) "#C_WHITE"%d계좌로 %d$ 입금 완료.",Player[playerid][SAVE_NUM], cash);
			SendClientMessage(playerid, COLOR_YELLOW, query);
		}
	}
	if(dialogid == DIALOG_PLAYER_SHOW_BANK_INSERT)
	{
		new phoneNumber = strval(inputtext);
		if(response)
		{
			if(phoneNumber == Player[playerid][PHONE]) // 입금 번호가 내 번호 일 경우
			{ 
				new value = 0;
				for(new i = 0; i < MAX_PICK; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, BUY_PICK[i][BUY][0], BUY_PICK[i][BUY][1], BUY_PICK[i][BUY][2]))
					{
						if(BUY_PICK[i][FEATURE] == 1) // 은행
						{
							value = 1;
							break;
						}
					}
				}
				if(value == 0) //은행 ATM이 아닌 경우.
				{
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"본인에게 입금은 은행/ATM에서만 이용 가능합니다.");
				}
				else
				{
					new query[128];
					mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM bank WHERE phoneNum = %d;", phoneNumber);
					mysql_tquery(g_Sql, query, "SendPlayerCash", "ii", playerid, phoneNumber);	
				}
			}
			
		}
	}
	if(dialogid == DIALOG_PLAYER_SHOW_CLOTH)
	{
		if(response)
		{
			new PlayerIndex;
			if(listitem == 0 || listitem == 1) 
			{
				new size = sizeof(CLOTH);
				PlayerIndex = -1;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, CLOTH, Player[playerid][SEX], 0, size), "BUY", "CANCEL");
			}
			if(listitem == 2 || listitem == 3) //악세사리 구매. 모자
			{
				new size = sizeof(HAT_ACC);
				PlayerIndex = 0;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, HAT_ACC, 0, 0, size), "BUY", "CANCEL");
			}
			if(listitem == 4) //악세사리 구매. 안경
			{
				new size = sizeof(GLASSES_ACC);
				PlayerIndex = 1;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, GLASSES_ACC, 0, 0, size), "BUY", "CANCEL");
			}
			if(listitem == 5) //악세사리 구매. 마스크
			{
				new size = sizeof(MASK_ACC);
				PlayerIndex = 2;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, MASK_ACC, 0, 0, size), "BUY", "CANCEL");
			}
			if(listitem == 6) //악세사리 구매. 시계
			{
				new size = sizeof(WATCH_ACC);
				PlayerIndex = 3;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, WATCH_ACC, 0, 0, size), "BUY", "CANCEL");
			}
			SetPVarInt(playerid, "PlayerIndex", PlayerIndex);
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_BUY_CLOTH)
	{
		new PlayerIndex = GetPVarInt(playerid, "PlayerIndex");
		new query[128];
		if(response)
		{
			if(PlayerIndex == -1) // 옷
			{
				if(Player[playerid][MONEY] > Player[playerid][SAVE_PRICE][listitem])
				{
					Player[playerid][SKIN] = Player[playerid][SAVE_NUM][listitem];
					SetPlayerSkin(playerid, Player[playerid][SKIN]);
					mysql_format(g_Sql, query, sizeof(query), "UPDATE information SET skin = %d WHERE id = '%s'",Player[playerid][SKIN], PlayerName(playerid));
					mysql_tquery(g_Sql, query);
					Player[playerid][MONEY] -= Player[playerid][SAVE_PRICE][listitem];
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"해당 옷을 구매하였습니다. 기존 옷은 집의 옷장에 보관되었습니다.");
					DeletePVar(playerid, "PlayerIndex");
					PlayerUpdateMoney(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"해당 물건을 구매하기 위한 돈이 부족합니다.");
					DeletePVar(playerid, "PlayerIndex");
					return 0;
				}
			}
			else
			{
				if(Player[playerid][MONEY] > Player[playerid][SAVE_PRICE][listitem])
				{
					mysql_format(
						g_Sql, 
						query, 
						sizeof(query), 
						"SELECT modelid FROM accessories WHERE id = '%s' AND modelid =  %d", 
						PlayerName(playerid),
						Player[playerid][SAVE_NUM][listitem]
					);
					mysql_tquery(g_Sql, query, "CheckAccPlayer", "iiii", playerid, PlayerIndex, Player[playerid][SAVE_NUM][listitem], Player[playerid][SAVE_NUM][listitem+1]); //해당 악세사리가 이미 존재 한다는 뜻.
					DeletePVar(playerid, "PlayerIndex");
					PlayerUpdateMoney(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"해당 물건을 구매하기 위한 돈이 부족합니다.");
					DeletePVar(playerid, "PlayerIndex");
					return 0;
				}
			}
			
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_ADMIN_CLICK_PLAYER)
	{
		if(response)
		{
			new givePlayerid = GetPVarInt(playerid, "ClickedPlayer");
			switch(listitem)
			{
				case 0: //킥
				{
					Kick(givePlayerid);
				}
				case 1: //밴
				{

					Ban(givePlayerid);
				}
				case 2: //해당 플레이어로 이동
				{
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(givePlayerid, X, Y, Z);
					if(GetPlayerState(givePlayerid) == PLAYER_STATE_DRIVER)
					{
						new vehicleid = GetPlayerVehicleID(givePlayerid);
						PutPlayerInVehicle(playerid, vehicleid, 3);
					}
					else
					{
						SetPlayerPos(playerid, X,Y,Z);
						SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(givePlayerid));
						SetPlayerInterior(playerid, GetPlayerInterior(givePlayerid));
					}
					SendClientMessage(playerid, COLOR_YELLOW, "ADMIN) "#C_WHITE"해당 플레이어에게 이동 하였습니다.");
					return 1;
				}
				case 3: //해당 플레이어 소환
				{
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(playerid, X, Y, Z);
					SetPlayerPos(givePlayerid, X,Y,Z);
					SetPlayerVirtualWorld(givePlayerid, GetPlayerVirtualWorld(playerid));
					SetPlayerInterior(givePlayerid, GetPlayerInterior(playerid));
					SendClientMessage(playerid, COLOR_YELLOW, "ADMIN) "#C_WHITE"해당 플레이어를 소환 하였습니다.");
					return 1;
				}
				case 4: //관전
				{
					TogglePlayerSpectating(playerid, 1);
					PlayerSpectatePlayer(playerid, givePlayerid, SPECTATE_MODE_NORMAL);
					SendClientMessage(playerid, COLOR_YELLOW, "ADMIN) "#C_WHITE"해당 플레이어를 관전 합니다. 관전 종료는 \"관전 종료\"클릭!");
					return 1;
				}
				case 5:
				{
					TogglePlayerSpectating(playerid, 0);
					SetCameraBehindPlayer(playerid);
					return 1;
				}
			}
			DeletePVar(playerid, "ClickedPlayer");
		}
	}
	if(dialogid == DIALOG_PLAYER_JOB)
	{
		if(response)
		{
			new jobid = GetPVarInt(playerid, "jobid");
			new string[128];
			switch(listitem)
			{
				case 0..1: //입사
				{
					if(Player[playerid][JOB] != 0) //무직이 아닌 경우에만.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"이미 직업을 가지고 있습니다. (당신의 직업 : %s)", PlayerJobName[Player[playerid][JOB]]);
						SendClientMessage(playerid, COLOR_RED, string);
						DeletePVar(playerid, "jobid");
						return 1;
					}
					format(string, sizeof(string), "SYSTEM) "#C_WHITE"당신은 %s 이(가) 되었습니다.", PlayerJobName[jobid]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					Player[playerid][JOB] = jobid;
					DeletePVar(playerid, "jobid");
					mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET job = %d WHERE id = '%s'",Player[playerid][JOB], PlayerName(playerid));
					mysql_tquery(g_Sql, string);
					return 1;
				}
				case 2: //퇴사
				{
					if(Player[playerid][JOB] != jobid ) // 해당 직업의 보유자가 아니야 일단.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"해당 직업 보유자가 아닙니다. (당신의 직업 : %s)", PlayerJobName[Player[playerid][JOB]]);
						SendClientMessage(playerid, COLOR_RED, string);
						DeletePVar(playerid, "jobid");
						return 1;
					}
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"퇴사가 완료 되었습니다.");
					Player[playerid][JOB] = 0;
					DeletePVar(playerid, "jobid");
					mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET job = %d WHERE id = '%s'",Player[playerid][JOB], PlayerName(playerid));
					mysql_tquery(g_Sql, string);
					return 1;
				}
				case 3: // 업무 시작
				{
					if(Player[playerid][JOB] != jobid) // 해당 직업의 보유자가 아니야 일단.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"해당 직업 보유자가 아닙니다. (당신의 직업 : %s)", PlayerJobName[Player[playerid][JOB]]);
						SendClientMessage(playerid, COLOR_RED, string);
						DeletePVar(playerid, "jobid");
						return 1;
					}
					else
					{
						new size = sizeof(CLOTH);
						ShowPlayerDialog(playerid, DIALOG_PLAYER_JOB_START, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, CLOTH, Player[playerid][SEX],Player[playerid][JOB], size), "SELECT", "CANCEL");
						DeletePVar(playerid, "jobid");
					}
					return 1;
				}
				case 4: //업무 종료
				{
					new job_start = GetPVarInt(playerid, "job_status");
					if(job_start == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"업무를 시작하고 있지 않습니다.");
						return 1;
					}
					if(Player[playerid][JOB] != jobid) // 해당 직업의 보유자가 아니야 일단.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"해당 직업 보유자가 아닙니다. (당신의 직업 : %s)", PlayerJobName[Player[playerid][JOB]]);
						SendClientMessage(playerid, COLOR_RED, string);
						DeletePVar(playerid, "jobid");
						return 1;
					}
					else
					{
						job_start = 0;
						SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"업무를 종료 합니다. 고생 많으셨습니다.");
						SetPlayerSkin(playerid, Player[playerid][SKIN]);
						DeletePVar(playerid, "job_status");

					}
				}
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_JOB_START)
	{
		if(response)
		{
			new job_start = 1;
			SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"업무를 시작합니다.");
			SetPlayerSkin(playerid, Player[playerid][SAVE_NUM][listitem]);
			SetPVarInt(playerid, "job_status", job_start);
			PlayerJobStart(playerid);		
		}
		return 1;
	}
	if(dialogid == DIALOG_PLAYER_SHOW_CONV)
	{
		new string[128];
		if(response)
		{
			if(Player[playerid][MONEY] > CONV_LIST[listitem][PRICE])
			{
				if(strcmp(CONV_LIST[listitem][NAME], "담배", true) == 0)
				{
					GivePlayerItem(playerid, CONV_LIST[listitem][NAME], 20);
				}
				else
				{
					GivePlayerItem(playerid, CONV_LIST[listitem][NAME], 1);
				}
				Player[playerid][MONEY] -= CONV_LIST[listitem][PRICE];
				format(string, sizeof(string), "SYSTEM) "#C_WHITE"%s(을)를 구매 하였습니다. (가격 : $%d)",  CONV_LIST[listitem][NAME], CONV_LIST[listitem][PRICE]);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				PlayerUpdateMoney(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"해당 물건을 구매하기 위한 돈이 부족합니다.");
				return 0;
			}
		}
	}
	return 0;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    SaveUserVehicle(playerid, vehicleid);
    return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new query[256];
	if(response)
	{
		mysql_format(
			g_Sql, 
			query, 
			sizeof(query), 
			"UPDATE accessories SET posX = %f, posY = %f, posZ = %f, posrX = %f, posrY = %f, posrZ = %f, possX = %f, possY =%f, possZ = %f WHERE id = '%s' AND modelid = %d;", 
			fOffsetX,
			fOffsetY,
			fOffsetZ,

			fRotX,
			fRotY,
			fRotZ,

			fScaleX,
			fScaleY,
			fScaleZ,

			PlayerName(playerid),
			modelid
		);
		mysql_tquery(g_Sql, query); //해당 악세사리가 이미 존재 한다는 뜻.
		SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"악세사리 수정 / 구매 완료.");
		return 1; 
	}
	else
	{
		SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"악세사리 수정 / 구매 취소.");
		return 0;
	}
}

public OnPlayerEnterCheckpoint(playerid)
{
	new checkpoint = GetPVarInt(playerid, "truckcheckpoint");
	SetPlayerObjective(playerid, checkpoint);
    return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(Player[playerid][ADMIN] > 0)
	{
		SetPVarInt(playerid,"ClickedPlayer", clickedplayerid); // Save clickedplayerid in a PVar.
		ShowPlayerDialog(playerid, DIALOG_PLAYER_ADMIN_CLICK_PLAYER, DIALOG_STYLE_LIST, "상호작용", "킥\n밴\n이동\n소환\n관전\n관전 종료", "선택", "취소");
	}
	return 1;
} 
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(Player[playerid][ADMIN] > 0)
	{
		SetPlayerPosFindZ(playerid, fX, fY, fZ); 
	}
    return 1;
}