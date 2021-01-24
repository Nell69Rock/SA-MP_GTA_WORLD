#include <a_samp>
#include <a_mysql>
#include <md5>
#include <previewModelDialog> // NON-plugin so, compiling time fucking loooooooooooong
#include <streamer>
#include <foreach>
#include <audio>
#include "uservariable.pwn"
#include "userfunction.pwn"


 //�Ǽ��縮 ��� ����. (���� ����� �������, ���� ���� �ϴ� ��� ��������. ���̶� ���� ����) 

					   
// ���� ���� �� ������ ���� �� �� �ֵ��� �ؾ���. -- > �̰� ���� ��. 

// ����, ����, ������ �� �����ϸ� ���� �ɵ�.

// ������, ���� ����� ����� (�� ������ �߰� / ����, �ǹ� �߰� ����, NPC�߰� ���� ��)

// ����ǰ ���� 


main()
{
	print("\n----------------------------------");
	print(" WELCOME TO Unlimited Role Playing Game Made By. Nell����");
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
			format(string,sizeof string,"NOTICE)"#C_WHITE" %s(%d)���� ���� �Ͽ����ϴ�.", PlayerName(playerid), playerid);
			SendClientMessageToAll(COLOR_YELLOW, string);

			SetPlayerVirtualWorld(playerid, 1 + random(10));
			SetSpawnInfo(playerid, 0, 26, 1685.5864,-2333.1328,13.5469,0.0,0,0,0,0,0,0); // �켱 CJ�� ���� �� �� �ش� ĳ���� �ҷ������� �ؾ���.
			SetPlayerColor(playerid, COLOR_WHITE);
			
			print(string);

			g_Gear[playerid] = "P";
			CreatePersonalizedTextdraws(playerid);
			return 1;
		}
		SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�̸� ����� ���� �ʽ��ϴ�. �̸�_(�߰��̸�)_�� ������ �����ϼ���.");
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
		format(szString, sizeof szString, "NOTICE)"#C_WHITE" %s(%d)���� ���� ���� �Ͽ����ϴ�. ����:(%s).", PlayerName(playerid),playerid, szDisconnectReason[reason]);
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
			if(Player[playerid][PHONE] == Player[i][SEED]) // �� ��ȣ�� ���� ���Ⱑ ������. �� �ڽ��� �����ϰ�.
			{
				givePlayerid = i; // �׻��� �ε��� ��ȣ
				format(string,sizeof(string),"(��ȭ��)��%d: %s",Player[playerid][PHONE],text); //�⺻ ��� ������.
				SendClientMessage(playerid, COLOR_YELLOW, string);
				SendClientMessage(givePlayerid, COLOR_YELLOW, string);			
				break;
			}
		}
		if(givePlayerid == -1)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"������� ������ ������ϴ�. NŰ -> ��ȭ ����.");
		}
	}
    if(strlen(text) <= sizeof(string)) // ���� text���� string �� ���� �۾ƾ���.
    {
		format(string,sizeof(string),"%s: %s", PlayerName(playerid),text); //�⺻ ��� ������.
		for(new i = 0; i < sizeof(string); i++)
		{
			if(string[i] == '*') // ���� ���� ������
			{
				textTime++; // *�� �׳� �Ѱ���.
				if(textTime == 1)
				{
					positionStart = i;
				}
				if(textTime == 2)
				{
					
					format(strinsStr, sizeof(strinsStr), ""#C_PURPLE"");
					strins(string, strinsStr, positionStart, sizeof(string)); //Insert a string into another string.
					// ������ ����ִ� string�� PositionStart ���� sizeof ũ�� ��ŭ ��������� ���� �Ѵٴ� ��.

					i += 9; //#C_PURPLE DEFINE {C2A2DA} �� �پ� ��??�� �ϴµ� 8�� -> 9��° �ڸ� ���� 
					positionEnd = i;

					format(strinsStr,sizeof(strinsStr),""#C_WHITE"");
					strins(string,strinsStr,positionEnd, sizeof(string));
					// ������ ����ִ� string�� PositionStart ���� sizeof ũ�� ��ŭ �ٽ� ������� �����Ѵٴ� ��.
					break;
				}
			}
		}
		SetPlayerChatBubble(playerid,string,COLOR_FADE1,15.0,10000); // ���� Ÿ�� ���� ê�� �Ⱥ����� �ϴ°� ����.
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
	if(strcmp(cmd, "/me", true) == 0 || strcmp(cmd, "/�ൿ", true) == 0 )
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /me [�ൿ] �Ǵ� /�ൿ [�ൿ]");
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" ex) /me ��迡 ���� ���δ�.");
			return 1;
		}
		format(string, sizeof(string), "*(�ൿ) %s(��)�� %s", PlayerName(playerid), tmp);
		ProxDetector(15.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 1;
	}

	if(strcmp(cmd, "/whisper", true) == 0 || strcmp(cmd, "/w", true) == 0 || strcmp(cmd, "/�ӼӸ�", true) == 0)
	{
		new givePlayerid = -1;
		new Float:X, Float:Y, Float:Z;
		tmp = strtok(cmdtext, idx, 0);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(w)hisper [�÷��̾� ��ȣ] [��] �Ǵ� /�ӼӸ� [�÷��̾� ��ȣ] [��]");
			return 1;
		}
		givePlayerid = strval(tmp);
		if(givePlayerid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" �Է��� �÷��̾� ��ȣ�� ���� ��ȣ �Դϴ�.");
			return 1;
		}
		tmp2 = strtok(cmdtext, idx, 1);
		if(!strlen(tmp2))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(w)hisper [�÷��̾� ��ȣ] [�� ��] �Ǵ� /�ӼӸ� [�÷��̾� ��ȣ] [�� ��]");
			return 1;
		}
		GetPlayerPos(givePlayerid, X, Y, Z);
		//IsPlayerInRangeOfPoint(playerid, Float:range, Float:x, Float:y, Float:z)
		if(IsPlayerInRangeOfPoint(playerid, 2.0, X, Y, Z))
		{
			format(string, sizeof(string), "/me %s���� �ӻ��Դϴ�.", PlayerName(givePlayerid));
			OnPlayerCommandText(playerid, string);

			format(string, sizeof(string), "*(�ӼӸ�) �� %s: %s", PlayerName(playerid), tmp2);
			SendClientMessage(givePlayerid, COLOR_YELLOW, string);

			format(string, sizeof(string), "*(�ӼӸ�) �� %s: %s", PlayerName(givePlayerid), tmp2);
			SendClientMessage(playerid,  COLOR_YELLOW, string);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" �ش� �÷��̾ �� ���� �����ϴ�.");
			return 1;
		}
	}
	if(strcmp(cmd, "/r", true) == 0 || strcmp(cmd, "/radio", true) == 0 || strcmp(cmd, "/����", true) == 0)
	{
		if(GetPlayerItem(playerid, "������"))
		{
			tmp = strtok(cmdtext, idx, 0);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(r)radio [�Ҹ�/���ļ�/�Ҹ�] (0 ~ 999) �Ǵ� /���� [�Ҹ�/���ļ�/�Ҹ�] (0 ~ 999)");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" frequency < 0 = Device OFF");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" sound < 0 = Earphone");
				return 1;
			}
			if(strcmp(tmp, "���ļ�") != 0 || strcmp(tmp, "�Ҹ�") != 0)
			{
				if(Player[playerid][RFREQ] >= 0)
				{
					// ���ļ��� �ƴϸ� �׳� �ش� ���ļ��� �� �� �� �ֵ��� �ϸ� �� ����? ���� ��������.
					OnPlayerCommandText(playerid, "/me �����⸦ ������ �Ÿ��ϴ�.");
					format(string,sizeof(string),"*(Radio �߽�) %s: %s",PlayerName(playerid), tmp);
					ProxDetector(Player[playerid][RFREQ_SOUND],playerid,string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
					format(string,sizeof(string),"*(Radio ����) %s: %s",PlayerName(playerid), string);
					SendRadioMessage(playerid, COLOR_RADIO, string, Player[playerid][RFREQ]);
					return 1;
				}
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"������ �����ֽ��ϴ�. ���ļ��� ������ �ּ���.");
				return 1;
			}
			tmp2 = strtok(cmdtext, idx, 1);
			if(!strlen(tmp2))
			{
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(r)radio [�Ҹ�/���ļ�/�Ҹ�] (0 ~ 999) �Ǵ� /���� [�Ҹ�/���ļ�/�Ҹ�] (0 ~ 999)");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" frequency < 0 = Device OFF");
				SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" sound < 0 = Earphone");
				return 1;
			}
			if(strcmp(tmp, "���ļ�") == 0 )
			{
				if(strval(tmp2) > 999)
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"���ļ� ä�� ������ 0 ~ 999 �Դϴ�.");
					return 1;
				}
				if(strval(tmp2) >= 0)
				{
					Player[playerid][RFREQ] = strval(tmp2);
					format(string, sizeof(string), "SYSTEM) "#C_WHITE"���ļ��� %d(��)�� ���� �Ͽ����ϴ�.", Player[playerid][RFREQ]);
					SendClientMessage(playerid, COLOR_YELLOW, string);	
				}
				else
				{
					Player[playerid][RFREQ] = strval(tmp2);
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"�����⸦ �����մϴ�.");
				}
				OnPlayerCommandText(playerid, "/me �����⸦ ������ �Ÿ��ϴ�.");
				mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET frequency = %d WHERE id = '%s';",Player[playerid][RFREQ], PlayerName(playerid));
				mysql_tquery(g_Sql, string);
				return 1;
			}
			if(strcmp(tmp, "�Ҹ�") == 0)
			{
				if(strval(tmp2) > 15)
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"������ �Ҹ� ������ 1 ~ 15 �Դϴ�.");
					return 1;
				}
				if(strval(tmp2) >= 1)
				{
					Player[playerid][RFREQ_SOUND] = strval(tmp2);
					format(string, sizeof(string), "SYSTEM) "#C_WHITE"������ �Ҹ��� %d(��)�� ���� �Ͽ����ϴ�.", Player[playerid][RFREQ_SOUND]);
					SendClientMessage(playerid, COLOR_YELLOW, string);	
				}
				else
				{
					Player[playerid][RFREQ_SOUND] = strval(tmp2);
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"�����⿡ �̾����� �����մϴ�.");
				}
				OnPlayerCommandText(playerid, "/me �����⸦ ������ �Ÿ��ϴ�.");
				mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET freqSound = %d WHERE id = '%s';",Player[playerid][RFREQ_SOUND], PlayerName(playerid));
				mysql_tquery(g_Sql, string);
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�����⸦ ������ ���� �ʽ��ϴ�.");
			return 1;
		}
	}
	if(strcmp(cmd,"/shout",true)== 0 || strcmp(cmd,"/s",true)== 0 || strcmp(cmd,"/��ħ",true)==0)
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /s(hout) [�� ��] �Ǵ� /��ħ [�� ��]");
			return 1;
		}
		/*if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1,0,1,1,1,1,1);		
		}*/
		format(string, sizeof(string), "*(��ħ) %s: %s!", PlayerName(playerid), tmp);
		ProxDetector(30.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3);
		return 1;
	}

	if(strcmp(cmd,"/close",true)== 0 || strcmp(cmd,"/c",true)== 0 || strcmp(cmd,"/�۰�",true)== 0)
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" (/c)lose [�� ��] �Ǵ� /�۰� [�� ��]");
			return 1;
		}
		format(string, sizeof(string), "*(�۰� �� ��) %s: %s", PlayerName(playerid), tmp);
		ProxDetector(2.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		return 1;
	}
	
	if(strcmp(cmd, "/st", true) == 0 || strcmp(cmd, "/����", true) == 0 || strcmp(cmd, "/state", true) == 0) 
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /st(ate) [����] �Ǵ� /���� [����]");
			return 1;
		}
		format(string, sizeof(string), "*(����) %s: %s",  PlayerName(playerid), tmp);
		ProxDetector(15.0, playerid, string, COLOR_STATE, COLOR_STATE, COLOR_STATE, COLOR_STATE, COLOR_STATE);
		return 1;
	}
	if(strcmp(cmd, "/ooc", true) == 0 || strcmp(cmd, "/o", true) == 0)
	{
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /o(oc) [�� ��]");
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
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /b [�Ҹ�]");
			return 1;
		}
		format(string, sizeof(string), "*(��ó OOC) %s(%d): %s", PlayerName(playerid),playerid , tmp);
		ProxDetector(30.0, playerid, string, COLOR_FADE3, COLOR_FADE3, COLOR_FADE3, COLOR_FADE3, COLOR_FADE3);
		return 1;	
	}
	if(strcmp(cmd, "/oocpm", true) == 0 || strcmp(cmd, "/op", true) == 0) //���� ������ ������ �ѵ� �ѹ� ����� �غ�����.
	{
		new givePlayerid = -1;
		tmp = strtok(cmdtext, idx, 0);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /oocpm [�÷��̾� ��ȣ] [�� ��]");
			return 1;
		}
		givePlayerid = strval(tmp);
		if(givePlayerid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" �Է��� �÷��̾� ��ȣ�� ���� ��ȣ �Դϴ�.");
			return 1;
		}
		tmp2 = strtok(cmdtext, idx, 1);
		if(!strlen(tmp2))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /oocpm [�÷��̾��ȣ/�̸��� �κ�] [��]");
			return 1;
		}
		format(string, sizeof(string), "(( OOCPM �� %s(%d): %s ))", PlayerName(playerid), playerid, tmp2);
		SendClientMessage(givePlayerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "(( OOCPM �� %s(%d): %s ))", PlayerName(givePlayerid), givePlayerid, tmp2);
		SendClientMessage(playerid,  COLOR_YELLOW, string);
		return 1;
	}
	//--------------------------------------------------- Admin Command ----------------------------------------------------//
	if(strcmp(cmd, "/����ȯ", true) == 0)
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
	if(strcmp(cmd, "/notice", true) == 0 || strcmp(cmd, "/����", true) == 0)
	{
		if(Player[playerid][ADMIN] == 1)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" �� ��ɾ ����� ������ �����ϴ�.");
			return 1;
		}
		tmp = strtok(cmdtext, idx, 1);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /���� [����] �Ǵ� /notice");
			return 1;
		}
		format(string, sizeof(string), "*[Admin ����] ADMIN: %s", tmp);
		SendClientMessageToAll(0xFFB9B9FF, string);
		return 1;
	}
	format(errorString,sizeof(errorString),"ERROR)"#C_WHITE" [%s](��)�� ���� ��ɾ� �Դϴ�. �ٽ��ѹ� Ȯ���� �ֽñ� �ٶ��ϴ�.",cmdtext);
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
		SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE" ���� �α����� �Ͻʽÿ�.");
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
				ShowPlayerDialog(playerid, DIALOG_SHOW_BOOMBOX_ADD_URL, DIALOG_STYLE_INPUT, "����� �߰��ϱ�", "�߰��� URL�� �Է��Ͻʽÿ�.\n���� ������ ���� *.mp3, *.wav, *ogg\n��Ʃ��, ���� Ŭ���� ���� ���� ��", "�߰��ϱ�", "���");
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
			SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"�չڽ��� URL�� �߰��Ͽ����ϴ�.");
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
				ShowPlayerDialog(playerid,DIALOG_INVENTORY_USE_ID,DIALOG_STYLE_LIST,"����","����ϱ�\n������","Ȯ��","");
			}
			if(strcmp(inputtext,"����������",true,strlen("����������") )==0)
	            ShowPlayerBag(playerid,ViewPage[playerid]+1);
			if(strcmp(inputtext,"����������",true,strlen("����������") )==0)
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
			else  //������
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
			if(listitem == 0 || listitem == 1) // ���� ��ư Ŭ��
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
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�ܾ��� �����մϴ�.");
				return 0;
			}
			if(userVehicleID > -1)
			{
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�̹� ������ ������ �ֽ��ϴ�.");
				return 0;
			}
			SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"���� ���Ÿ� �Ϸ� �Ͽ����ϴ�. �̴ϸʿ� ������ ��ġ�� ǥ�� �Ͽ����ϴ�.");
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
				case 0..1: //�õ�
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //� ���� ����.
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); 
						if(engine != 0)  //�õ��� �ɷ��־�.
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, 0, alarm, doors, bonnet, boot, objective); 
							GameTextForPlayer(playerid, "~y~Engine ~r~OFF", 2000, 4);
							SaveUserVehicle(playerid, GetPlayerVehicleID(playerid));
							KillTimer(GetPVarInt(playerid, "FuelTimer"));
							DeletePVar(playerid, "FuelTimer");
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"�õ��� �����ϴ�.");
							return 1;
						}
						if(GetPlayerVehicleID(playerid) == vehicleid || Player[playerid][JOB] == VEHICLE_DATA[GetPlayerVehicleID(playerid)][vJob]) //���� ���� ������ �õ� �� �� �ְ� �ؾ���
						{
							GameTextForPlayer(playerid, "~y~Engine ~p~Starting", 2000, 4);
							SetTimerEx("PlayerVehicleEngineStart", 3000, false, "dd", playerid, GetPlayerVehicleID(playerid));
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"�õ��� �� �� ���� ���� �Դϴ�.");
						return 1;
					}
					if(vehicleid != -1) //�ٵ� �� ���� ���� ��
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, VEHICLE_DATA[vehicleid][vX], VEHICLE_DATA[vehicleid][vY], VEHICLE_DATA[vehicleid][vZ])) //���� �� �� ��ó�� �־�.
						{
							GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective); //������ ���¸� ���غ���
							if(engine != 0) //�õ��� �ɷ� �־�.
							{
								SendClientMessage(playerid,COLOR_RED, "VEHICLE) "#C_WHITE"�������� �õ��� �� �� �����ϴ�.");
								return 1;
							}
							GameTextForPlayer(playerid, "~y~Engine ~p~Starting", 2000, 4);
							SetTimerEx("PlayerVehicleEngineStart", 3000, false, "dd", playerid, vehicleid);
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"�ֺ��� �� ������ �������� �ʽ��ϴ�. ���� �� �����̿��� �õ� �Ͻʽÿ�.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"���� �����ϰ� �ִ� ������ �����ϴ�.");
					return 1;
				}
				case 2: // ������
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //� ���� ����
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //�õ��� �ɸ��� Ȯ��
						if(lights == 1) //�ɷ� �־�
						{	
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 0, alarm, doors, bonnet, boot, objective); //�õ� ����ۿ�? ����
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"�������� �����ϴ�.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 1, alarm, doors, bonnet, boot, objective); //�õ� ����ۿ�? ����
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"�������� �׽��ϴ�.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"���� �������� Ÿ������ �ʽ��ϴ�.");
					return 1;
				}
				case 3: // Ʈ��ũ
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //� ���� ����
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //�õ��� �ɸ��� Ȯ��
						if(boot == 1) //�ɷ� �־�
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 0, objective); //�õ� ����ۿ�? ����
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"Ʈ��ũ�� �ݾҽ��ϴ�.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 1, objective); //�õ� ����ۿ�? ����
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"Ʈ��ũ�� �������ϴ�");
						return 1;
					}
					if(vehicleid != -1) //�� ���� ���� ��
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, VEHICLE_DATA[vehicleid][vX], VEHICLE_DATA[vehicleid][vY], VEHICLE_DATA[vehicleid][vZ])) //�� ���� ��ó.
						{
							GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective); //�õ� ����?
							if(boot == 1) //�ɷ� �־�
							{
								SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 0, objective); //�õ� ����
								SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"Ʈ��ũ�� �ݾҽ��ϴ�.");
								return 1;
							}
							SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 1, objective); //�õ� ����ۿ�? ����
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"Ʈ��ũ�� �������ϴ�.");
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"�ֺ��� �� ������ �������� �ʽ��ϴ�. ���� �� �����̿��� �õ� �Ͻʽÿ�.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"���� �����ϰ� �ִ� ������ �����ϴ�.");
					return 1;
				}
				case 4: // ����
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //� ���� ����
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //�õ��� �ɸ��� Ȯ��
						if(bonnet == 1) //�ɷ� �־�
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 0, boot, objective); //�õ� ����ۿ�? ����
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"������ �ݾҽ��ϴ�.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 1, boot, objective); //�õ� ����ۿ�? ����
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"������ �������ϴ�.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"���� �������� Ÿ������ �ʽ��ϴ�.");
					return 1;
				}
				case 5: // ���� ��
				{
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) //� ���� ����
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective); //�õ��� �ɸ��� Ȯ��
						if(doors == 1) //�ɷ� �־�
						{
							SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 0, bonnet, boot, objective); //�õ� ����ۿ�? ����
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"���� �������ϴ�.");
							return 1;
						}
						SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 1, bonnet, boot, objective); //�õ� ����ۿ�? ����
						SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"���� ��ɽ��ϴ�.");
						return 1;
					}
					if(vehicleid != -1) //�� ���� ���� �ִ��� ������ üũ.
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, VEHICLE_DATA[vehicleid][vX], VEHICLE_DATA[vehicleid][vY], VEHICLE_DATA[vehicleid][vZ])) //�� ���� ��ó.
						{
							GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective); //�õ� ����?
							if(doors == 1) //�ɷ� �־�
							{
								SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective); //�õ� ����
								SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"���� �������ϴ�.");
								return 1;
							}
							SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective); //�õ� ����ۿ�? ����
							SendClientMessage(playerid, COLOR_YELLOW, "VEHICLE) "#C_WHITE"���� ��ɽ��ϴ�.");
							return 1;
						}
						SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"�ֺ��� �� ������ �������� �ʽ��ϴ�. ���� �� �����̿��� �õ� �Ͻʽÿ�.");
						return 1;
					}
					SendClientMessage(playerid, COLOR_RED, "VEHICLE) "#C_WHITE"���� �����ϰ� �ִ� ������ �����ϴ�.");
					return 1;
				}
				case 6..7: //�뷡���
				{
					ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST, "���ϴ� ����� �����Ͻÿ�", "����\n�߶��/��/��\n����/R&B\nƮ��Ʈ\n��/��Ż\n�˼�\nOST\n����","Ȯ��","");
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
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"���� �ȿ����� ��� �����մϴ�.");
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
				if(Player[playerid][PHONE] == Player[i][SEED]) // �� ��ȣ�� ���� ���Ⱑ ������.
				{
					givePlayerid = i; // �׻��� �ε��� ��ȣ
					Player[playerid][SEED] = Player[i][PHONE]; // �¶� ���� ����.
					SendClientMessage(givePlayerid, COLOR_PURPLE, "INFO) "#C_WHITE"����� ����Ǿ����ϴ�.");
					SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"����� ����Ǿ����ϴ�.");
					break;
				}
			}
			if(givePlayerid == -1)
			{
				SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"������ ������ �������ϴ�. ��ȭ�� ����˴ϴ�.");
				Player[playerid][SEED] = 0;
			}
		}
		else
		{
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(Player[playerid][PHONE] == Player[i][SEED]) // �� ��ȣ�� ���� ���Ⱑ ������.
				{
					givePlayerid = i; // �׻��� �ε��� ��ȣ
					break;
				}
			}
			Player[givePlayerid][SEED] = 0;
			Player[playerid][SEED] = 0;
			SendClientMessage(givePlayerid, COLOR_PURPLE, "INFO) "#C_WHITE"������ ��ȭ�� ���� �Ͽ����ϴ�.");
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
				ShowPlayerDialog(playerid, DIALOG_REG, DIALOG_STYLE_PASSWORD, "ȸ������","��й�ȣ�� �ѹ� �� �Է����ּ���.","��","�ƴϿ�");
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_PASSWORD, "ȸ������","������ �Է��� �� �����ϴ�. �ٽ� �Է��� �ּ���.","��","�ƴϿ�");
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
				if(ComparePassword(playerid, md5Hash, 1) != 0) //��й�ȣ�� ���� ������ �ٽ� �Է� �ϵ��� ��.
				{
					ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_PASSWORD, "ȸ������","�Է��� ��й�ȣ�� ���� �ʽ��ϴ�. ������ ��й�ȣ�� ������ �ּ���","��","�ƴϿ�");
				}
				else // ������ ��й�ȣ�� ������.
				{
					new query[128];
					mysql_format(g_Sql, query, sizeof(query), "INSERT INTO account(id, password) VALUES ('%s', '%s')", PlayerName(playerid), md5Hash);
					mysql_tquery(g_Sql, query, "AddUser", "iii", playerid, PlayerName(playerid), md5Hash);
				}
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_PASSWORD, "LOGIN_ERROR", "������ �Է��� �� �����ϴ�. ȸ�� ������ ���� ��й�ȣ�� �Է��ϼ���.","��","�ƴϿ�");
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
					SendClientMessage(playerid, COLOR_RED, "SYSTEM)"#C_WHITE" ���������� �α����� �Ǿ����ϴ�. ��ſ� ���� �ǽñ� �ٶ��ϴ�.");
					if(!Player[playerid][TUTORIAL])
					{
						ShowPlayerDialog(playerid,DIALOG_TUT,DIALOG_STYLE_MSGBOX,"USER_TUTORIAL", ShowUserText("tutorial_RP.txt"), "����","");
					}
					else
					{
						SpawnPlayer(playerid);
					}
				}
				else
				{
				    ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN","���� ��й�ȣ�� ��ġ���� �ʽ��ϴ�. �ٽ� �Է����ּ���.","�Է�", "���");
				}
			}
			else
			{
			    ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN","���� ��й�ȣ�� ��ġ���� �ʽ��ϴ�. �ٽ� �Է����ּ���..","�Է�", "���");
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
			ShowPlayerDialog(playerid, DIALOG_USER_SEX, DIALOG_STYLE_LIST, "������ �����ϼ���", "����\n����", "����", "����"); 
		}
		else
		{
			ShowPlayerDialog(playerid,DIALOG_TUT,DIALOG_STYLE_MSGBOX,"USER_TUTORIAL", ShowUserText("tutorial_RP.txt"), "����","");
		}
		return 1;
	}
	if(dialogid == DIALOG_USER_SEX)
	{
		if(response)
		{
			if(listitem == 0)
			{
				Player[playerid][SEX] = 0; // ����
			}
			else
			{
				Player[playerid][SEX] = 1; // ����.
			}
			new size = sizeof(CLOTH);
			ShowPlayerDialog(playerid, DIALOG_USER_SELECT_CHARACTER, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, CLOTH, Player[playerid][SEX], -1, size), "SELECT", "CANCEL");
			
		}
		else
		{
			ShowPlayerDialog(playerid,DIALOG_TUT,DIALOG_STYLE_MSGBOX,"USER_TUTORIAL", ShowUserText("tutorial_RP.txt"), "����","");
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
			ShowPlayerDialog(playerid, DIALOG_USER_DONE, DIALOG_STYLE_INPUT, "USER_TUTORIAL", "�¾ ������ �Է��ϼ���. (1975 ~ 2000)", "����","����");
			return 1;
		}
	}
	if(dialogid == DIALOG_USER_DONE)
	{
		if(response)
		{
			if(strval(inputtext) < 1975 || strval(inputtext) > 2000)
			{
				ShowPlayerDialog(playerid, DIALOG_USER_DONE, DIALOG_STYLE_INPUT, "USER_TUTORIAL", "(�Է� ���� ������ ������ϴ�!)�¾ ������ �Է��ϼ���. (1975 ~ 2000)", "����","����"); 
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
			ShowPlayerDialog(playerid, DIALOG_USER_SEX, DIALOG_STYLE_LIST, "������ �����ϼ���", "����\n����", "����", "����"); 
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
				
					format(playerInfo, sizeof(playerInfo), "%s�� ����", PlayerName(playerid));
					format(string, sizeof(string), "�̸�[%s] ����[%d] ����[%s]\n��ȣ[%d]\n����[$%d] ����[$%d]\n�÷��̽ð�[%d�ð� %d�� %d��]",
						PlayerName(playerid), 
						(2020- Player[playerid][YEAR]), 
						Player[playerid][SEX] == 0 ? ("����") : ("����"),
						Player[playerid][PHONE],
						Player[playerid][MONEY],
						Player[playerid][BANK],
						Player[playerid][TIME][0],
						Player[playerid][TIME][1],
						Player[playerid][TIME][2]
					);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_INFO, DIALOG_STYLE_MSGBOX, playerInfo, string, "Ȯ��", "");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_MODIFY, DIALOG_STYLE_LIST, "��ȣ �ۿ�", "����\n�Ȱ�\n����ũ\n�ð�", "����", "���");
				}
				case 3..4:
				{

				}
				case 5..6:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_CALL, DIALOG_STYLE_INPUT, "��ȣ�ۿ�", "���� �� ��ȣ�� �Է��ϼ���(8�ڸ�)", "��ȭ�ϱ�", "���");
				}
				case 7:
				{
					Player[playerid][SEED] = 0;
					SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"��ȭ�� �������ϴ�.");
				}
				case 8:
				{
					//����(����, ����, ��ȭ), �߰�
					ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS, DIALOG_STYLE_LIST, "��ȣ�ۿ�", "����\n�߰�", "����", "���");
				}
				case 9:
				{
					//����, ������
					ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_MESSAGE, DIALOG_STYLE_LIST, "��ȣ�ۿ�", "����\n������", "����", "���");
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
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"���� �� ��ġ�� �߰� �Ͽ����ϴ�. !�� ������ ���� ��! ���׸��� �̵��� ���� �ݵ�� ���� ��ġ�� ���� ���ּ���.");	
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_CONSTRUCTION_LIST, DIALOG_STYLE_LIST, "BUILDING SELECT", ShowUserText("building_list.txt"), "��ġ �̵�","���");
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
						
						TextPickup("���� �Ϸ��� ["#C_RED"F"#C_WHITE"]Ű�� ��������.", COLOR_WHITE, 1239, 1, ENTER_EXIT[index][ENTER][0], ENTER_EXIT[index][ENTER][1], ENTER_EXIT[index][ENTER][2]+0.3, 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,ENTER_EXIT[index][ENTER_VIRTUAL_WORLD], ENTER_EXIT[index][ENTER_INT]);
						TextPickup("���� �Ϸ��� ["#C_RED"F"#C_WHITE"]Ű�� ��������.", COLOR_WHITE, 1239, 1, ENTER_EXIT[index][EXIT][0], ENTER_EXIT[index][EXIT][1], ENTER_EXIT[index][EXIT][2]+0.3, 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ENTER_EXIT[index][EXIT_VIRTUAL_WORLD], ENTER_EXIT[index][EXIT_INT]);
						SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�ǹ� �Ǽ��� �Ϸ� �Ͽ����ϴ�.");
					}	
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_CONSTRUCTION_ICON, DIALOG_STYLE_LIST, "MAPICON SELECT", ShowUserText("mapicon_list.txt") , "����", "���");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_PICK, DIALOG_STYLE_INPUT, "��ȣ�ۿ�", ShowUserText("admin_buy_pick.txt"),"�Է�","���");		
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
					ShowPlayerDialog(playerid, DIALOG_PLAYER_CONSTRUCTION_LISTOK, DIALOG_STYLE_LIST, "��ȣ�ۿ�", string, "����", "���");
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
					ShowPlayerDialog(playerid, DIALOG_ADMIN_ADD_JOB_LIST, DIALOG_STYLE_INPUT, "��ȣ�ۿ�", "�߰��� ���� �̸��� �Է��ϼ���.", "�Է�", "���");
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
			ShowPlayerDialog(playerid, DIALOG_ADMIN_ADD_JOB_LIST2, DIALOG_STYLE_INPUT, "��ȣ�ۿ�", "�ѹ� �� �Է����ּ���.", "�Է�", "���");
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
				format(query, sizeof(query), "ADMIN) "#C_WHITE"���� �߰��� ���� �Ͽ����ϴ�. %s", str);
				SendClientMessage(playerid, COLOR_YELLOW, query);
				mysql_format(g_Sql, query, sizeof(query), "INSERT INTO joblist (jobname, number) VALUES ('%s', %d);", PlayerJobName[jobid], jobid);
				mysql_tquery(g_Sql, query); // ����� ���� ����
			
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_ADMIN_ADD_JOB_LIST, DIALOG_STYLE_INPUT, "��ȣ�ۿ�", "�Է��� �̸��� ��ġ ���� �ʽ��ϴ�. \n�߰��� ���� �̸��� �Է��ϼ���.", "�Է�", "���");
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
			if(PlayerAddActor(CLOTH[listitem][MODELID], X, Y, Z, Angle, GetPlayerVirtualWorld(playerid), 1, 1) == 0)// ���� ����
			{
				SendClientMessage(playerid, COLOR_RED, "ADMIN) "#C_WHITE"�Ҵ� ������ �ڸ��� �����ϴ�. �����ڿ��� ���� �ϼ���.");
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
				SendClientMessage(playerid, COLOR_ERROR, "ERROR) "#C_WHITE"������ �� ���� �Է��Դϴ�.");
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
			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�� ������ ���� �Ϸ�! ���׸��� �̵� �� ���� ��ġ�� ������ �ּ���.");
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
			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"��ġ �̵� �Ϸ�.");
		}
	}
	if(dialogid == DIALOG_PLAYER_CONSTRUCTION_LISTOK)
	{
		if(response)
		{
			new query[256];
			mysql_format(g_Sql, query, sizeof(query), "DELETE ENTER/EXIT FROM ENTER/EXIT WHERE exitX= %f;", ENTER_EXIT[listitem][EXIT][0]);
			mysql_tquery(g_Sql, query);

			SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�ش� �ǹ� ����");
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
			SendClientMessage(playerid, COLOR_RED, "PHONE) "#C_WHITE"��ȭ�� �������ϴ�.");
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
				ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_PHONE, DIALOG_STYLE_INPUT, "�ּҷ�", "�߰��� ������� ��ȣ�� �Է��ϼ���.", "Ȯ��", "���");
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_PHONE)
	{
		if(response)
		{
			Player[playerid][SAVE_PHONE] = strval(inputtext); // ����� ��ȣ ����
			ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_NAME, DIALOG_STYLE_INPUT, "�ּҷ�", "������ �̸��� �Է��ϼ���.", "Ȯ��", "���");
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_ADD_FRIEND_NAME)
	{
		if(response)
		{
			new string[128];
			new query[256];
			mysql_format(g_Sql, query, sizeof(query), "INSERT INTO phoneaddress (`phoneNum`, `address`, `name`) VALUES (%d, %d, '%s');", Player[playerid][PHONE],Player[playerid][SAVE_PHONE], inputtext);
			mysql_tquery(g_Sql, query); // ����� ���� ����
			format(string, sizeof(string), "PHONE) "#C_WHITE"[�ּҷ� ����]��%d, �̸�:%s",Player[playerid][SAVE_PHONE], inputtext);
			SendClientMessage(playerid, COLOR_RED, string);
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_SHOW) // �ּҷ� ���� �� ���� �߾� �׷��� ���� ��� ����.
	{
		if(response)
		{
			if(listitem > 0)
			{
				Player[playerid][SAVE_PHONE] = Player[playerid][SAVE_NUM][listitem-1];
				ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS_SHOW_CONTENT, DIALOG_STYLE_LIST, "�ּҷ�", "��ȭ\n����\n����", "Ȯ��", "���");
			}
		}
	}
	if(dialogid == DIALOG_PLAYER_PHONE_ADDRESS_SHOW_CONTENT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // ��ȭ
				{
					SetCallUser(playerid, Player[playerid][SAVE_PHONE]);
				}
				case 1: //����
				{
					SendMessageUserDialog(playerid);
				}
				case 2: //����
				{
					new query[128];
					mysql_format(g_Sql, query, sizeof(query), "DELETE FROM phoneaddress WHERE phoneNum = %d AND address = %d", Player[playerid][PHONE], Player[playerid][SAVE_PHONE]);
					mysql_tquery(g_Sql, query);
					SendClientMessage(playerid, COLOR_RED, "PHONE) "#C_WHITE"�ش� ����ڸ� �����Ͽ����ϴ�.");
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
				ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_MESSAGE_GET_NUMBER, DIALOG_STYLE_INPUT, "�޽��� ����", "���� ��ȣ�� �Է��ϼ���.", "Ȯ��", "���");
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
			mysql_tquery(g_Sql, query); // �������� �޽��� ������.
			SendClientMessage(playerid, COLOR_RED, "MOBILE) "#C_WHITE"���ڸ� ���½��ϴ�.");
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
				format(string, sizeof(string), "MOBILE) "#C_WHITE"��%d��ȣ�� ���ڰ� �Խ��ϴ�. ����: %s", Player[senderid][PHONE], inputtext);
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
				SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE" �ش� ������ ���� �ϰ� ���� �ʽ��ϴ�.");
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
				case 0..1: //���� �Ա��� ���� �Ա� ���� �Ա��� �� ���¿��� ������ ������ �ؾ���.
				{
					ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK_INSERT, DIALOG_STYLE_INPUT, "Bank", "�Ա� �� ���¸� �Է��ϼ���.(����ȭ��ȣ)\n��, ���ο��� �Ա��� '����/ATM'������ �̿� �����մϴ�.", "�Ա�", "���")
					// ����, ���� �Ա� �ΰ��� ������ �ؾ���.
				}
				case 2: //���
				{
					new string[128];
					format(string, sizeof(string), "%s���� ���� �ܾ��� �Ʒ��� �����ϴ�.\n���� �ܾ� : %d$\n�󸶸� ���� �Ͻðڽ��ϱ�?",PlayerName(playerid), Player[playerid][BANK]);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK_PUT, DIALOG_STYLE_INPUT, "bank", string, "���", "���");
					//ATM Ȥ�� ���࿡���� �����ϵ��� �ؾ���.
				}
				case 3: //�ܰ�Ȯ��.
				{
					new string[64];
					format(string, sizeof(string), "���� :%d$, ���� : %d$", Player[playerid][MONEY],Player[playerid][BANK]);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK_INSERT_EXPEND, DIALOG_STYLE_MSGBOX, "bank", string, "Ȯ��", "");
					//����Ͽ����� �ǽð� Ȯ�� ����.
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
					if(BUY_PICK[i][FEATURE] == 1) // ����
					{
						value = 1;
						break;
					}
				}
			}
			if(value == 0) //���� ATM�� �ƴ� ���.
			{
				SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"����� ����/ATM������ �̿� �����մϴ�.");
			}
			else
			{
				if(Player[playerid][BANK] > cash) //��� �Ϸ��� �ݾ� ���� ���� ���� �ݾ� ���� �ؾ���.
				{
					new query[128];
					Player[playerid][MONEY] +=cash;
					Player[playerid][BANK] -=cash;
					mysql_format(g_Sql, query, sizeof(query), "UPDATE `bank` SET `money`= `money`+%d, `account`=`account`-%d WHERE phoneNum = %d", cash,cash,Player[playerid][PHONE]);
					mysql_tquery(g_Sql, query); 
					format(query, sizeof(query), "SYSTEM) "#C_WHITE"���¿��� %d$�� ���� �Ͽ����ϴ�. ���� ���� �ܾ� : %d$", cash, Player[playerid][BANK]);
					SendClientMessage(playerid, COLOR_YELLOW, query);
					PlayerUpdateMoney(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�Է��� �ݾ��� ��� �� �� �����ϴ�. ���� �ܾ��� �����ϰų� �� �� ���� �Է� �Դϴ�.");
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
			if(Player[playerid][PHONE] == Player[playerid][SAVE_PHONE]) //������ ������ ���� ������ �Ա� �ؾ���.
			{
				if(cash > 0 || Player[playerid][MONEY] > cash) // �翬�� 0���� ū �ݾ��� �Է� �ؾ� �ϰ� �Է��� �� ���� ���� ��
				{
					
					Player[playerid][MONEY] -=cash;
					mysql_format(g_Sql, query, sizeof(query), "UPDATE `bank` SET `money`= `money`-%d, `account`=`account`+%d WHERE phoneNum = %d", cash,cash,Player[playerid][PHONE]);
					mysql_tquery(g_Sql, query); 		
					PlayerUpdateMoney(playerid);			
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�Է��� �ݾ��� �Ա� �� �� �����ϴ�. �ݾ��� �����ϰų� �� �� ���� �Է� �Դϴ�.");
					return -1;
				}
			}
			else //�޴� ����� �� �ڽžƴ� ���.
			{
				if(cash > 0 || Player[playerid][BANK] > cash) //�翬�� �������� �ݾ׺��� ���� ���¸� ������ �־�� ���� ���� 0���� Ŀ�� �ϰ�. 
				{
					new givePlayerid = -1;
					Player[playerid][BANK] -=cash;
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
						if(Player[playerid][SAVE_NUM] == Player[i][PHONE]) //���� ���� ������ ��ȣ�� ���� ���� ������
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
					mysql_tquery(g_Sql, query); //���� ���¿� �� �÷���

					mysql_format(g_Sql, query, sizeof(query), "UPDATE `bank` SET `account`=`account`-%d WHERE phoneNum = %d", cash,cash,Player[playerid][PHONE]);
					mysql_tquery(g_Sql, query); //�� ���¿� �� ����.
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�Է��� �ݾ��� �Ա� �� �� �����ϴ�. �ݾ��� �����ϰų� �� �� ���� �Է� �Դϴ�.");
					return -1;
				}
			}
			format(query, sizeof(query), "BANK) "#C_WHITE"%d���·� %d$ �Ա� �Ϸ�.",Player[playerid][SAVE_NUM], cash);
			SendClientMessage(playerid, COLOR_YELLOW, query);
		}
	}
	if(dialogid == DIALOG_PLAYER_SHOW_BANK_INSERT)
	{
		new phoneNumber = strval(inputtext);
		if(response)
		{
			if(phoneNumber == Player[playerid][PHONE]) // �Ա� ��ȣ�� �� ��ȣ �� ���
			{ 
				new value = 0;
				for(new i = 0; i < MAX_PICK; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, BUY_PICK[i][BUY][0], BUY_PICK[i][BUY][1], BUY_PICK[i][BUY][2]))
					{
						if(BUY_PICK[i][FEATURE] == 1) // ����
						{
							value = 1;
							break;
						}
					}
				}
				if(value == 0) //���� ATM�� �ƴ� ���.
				{
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"���ο��� �Ա��� ����/ATM������ �̿� �����մϴ�.");
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
			if(listitem == 2 || listitem == 3) //�Ǽ��縮 ����. ����
			{
				new size = sizeof(HAT_ACC);
				PlayerIndex = 0;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, HAT_ACC, 0, 0, size), "BUY", "CANCEL");
			}
			if(listitem == 4) //�Ǽ��縮 ����. �Ȱ�
			{
				new size = sizeof(GLASSES_ACC);
				PlayerIndex = 1;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, GLASSES_ACC, 0, 0, size), "BUY", "CANCEL");
			}
			if(listitem == 5) //�Ǽ��縮 ����. ����ũ
			{
				new size = sizeof(MASK_ACC);
				PlayerIndex = 2;
				ShowPlayerDialog(playerid, DIALOG_PLAYER_BUY_CLOTH, DIALOG_STYLE_PREVIEW_MODEL, "", ShowPlayerAccDialog(playerid, MASK_ACC, 0, 0, size), "BUY", "CANCEL");
			}
			if(listitem == 6) //�Ǽ��縮 ����. �ð�
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
			if(PlayerIndex == -1) // ��
			{
				if(Player[playerid][MONEY] > Player[playerid][SAVE_PRICE][listitem])
				{
					Player[playerid][SKIN] = Player[playerid][SAVE_NUM][listitem];
					SetPlayerSkin(playerid, Player[playerid][SKIN]);
					mysql_format(g_Sql, query, sizeof(query), "UPDATE information SET skin = %d WHERE id = '%s'",Player[playerid][SKIN], PlayerName(playerid));
					mysql_tquery(g_Sql, query);
					Player[playerid][MONEY] -= Player[playerid][SAVE_PRICE][listitem];
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�ش� ���� �����Ͽ����ϴ�. ���� ���� ���� ���忡 �����Ǿ����ϴ�.");
					DeletePVar(playerid, "PlayerIndex");
					PlayerUpdateMoney(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�ش� ������ �����ϱ� ���� ���� �����մϴ�.");
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
					mysql_tquery(g_Sql, query, "CheckAccPlayer", "iiii", playerid, PlayerIndex, Player[playerid][SAVE_NUM][listitem], Player[playerid][SAVE_NUM][listitem+1]); //�ش� �Ǽ��縮�� �̹� ���� �Ѵٴ� ��.
					DeletePVar(playerid, "PlayerIndex");
					PlayerUpdateMoney(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�ش� ������ �����ϱ� ���� ���� �����մϴ�.");
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
				case 0: //ű
				{
					Kick(givePlayerid);
				}
				case 1: //��
				{

					Ban(givePlayerid);
				}
				case 2: //�ش� �÷��̾�� �̵�
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
					SendClientMessage(playerid, COLOR_YELLOW, "ADMIN) "#C_WHITE"�ش� �÷��̾�� �̵� �Ͽ����ϴ�.");
					return 1;
				}
				case 3: //�ش� �÷��̾� ��ȯ
				{
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(playerid, X, Y, Z);
					SetPlayerPos(givePlayerid, X,Y,Z);
					SetPlayerVirtualWorld(givePlayerid, GetPlayerVirtualWorld(playerid));
					SetPlayerInterior(givePlayerid, GetPlayerInterior(playerid));
					SendClientMessage(playerid, COLOR_YELLOW, "ADMIN) "#C_WHITE"�ش� �÷��̾ ��ȯ �Ͽ����ϴ�.");
					return 1;
				}
				case 4: //����
				{
					TogglePlayerSpectating(playerid, 1);
					PlayerSpectatePlayer(playerid, givePlayerid, SPECTATE_MODE_NORMAL);
					SendClientMessage(playerid, COLOR_YELLOW, "ADMIN) "#C_WHITE"�ش� �÷��̾ ���� �մϴ�. ���� ����� \"���� ����\"Ŭ��!");
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
				case 0..1: //�Ի�
				{
					if(Player[playerid][JOB] != 0) //������ �ƴ� ��쿡��.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"�̹� ������ ������ �ֽ��ϴ�. (����� ���� : %s)", PlayerJobName[Player[playerid][JOB]]);
						SendClientMessage(playerid, COLOR_RED, string);
						DeletePVar(playerid, "jobid");
						return 1;
					}
					format(string, sizeof(string), "SYSTEM) "#C_WHITE"����� %s ��(��) �Ǿ����ϴ�.", PlayerJobName[jobid]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					Player[playerid][JOB] = jobid;
					DeletePVar(playerid, "jobid");
					mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET job = %d WHERE id = '%s'",Player[playerid][JOB], PlayerName(playerid));
					mysql_tquery(g_Sql, string);
					return 1;
				}
				case 2: //���
				{
					if(Player[playerid][JOB] != jobid ) // �ش� ������ �����ڰ� �ƴϾ� �ϴ�.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"�ش� ���� �����ڰ� �ƴմϴ�. (����� ���� : %s)", PlayerJobName[Player[playerid][JOB]]);
						SendClientMessage(playerid, COLOR_RED, string);
						DeletePVar(playerid, "jobid");
						return 1;
					}
					SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"��簡 �Ϸ� �Ǿ����ϴ�.");
					Player[playerid][JOB] = 0;
					DeletePVar(playerid, "jobid");
					mysql_format(g_Sql, string, sizeof(string), "UPDATE information SET job = %d WHERE id = '%s'",Player[playerid][JOB], PlayerName(playerid));
					mysql_tquery(g_Sql, string);
					return 1;
				}
				case 3: // ���� ����
				{
					if(Player[playerid][JOB] != jobid) // �ش� ������ �����ڰ� �ƴϾ� �ϴ�.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"�ش� ���� �����ڰ� �ƴմϴ�. (����� ���� : %s)", PlayerJobName[Player[playerid][JOB]]);
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
				case 4: //���� ����
				{
					new job_start = GetPVarInt(playerid, "job_status");
					if(job_start == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"������ �����ϰ� ���� �ʽ��ϴ�.");
						return 1;
					}
					if(Player[playerid][JOB] != jobid) // �ش� ������ �����ڰ� �ƴϾ� �ϴ�.
					{
						format(string, sizeof(string), "SYSTEM) "#C_WHITE"�ش� ���� �����ڰ� �ƴմϴ�. (����� ���� : %s)", PlayerJobName[Player[playerid][JOB]]);
						SendClientMessage(playerid, COLOR_RED, string);
						DeletePVar(playerid, "jobid");
						return 1;
					}
					else
					{
						job_start = 0;
						SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"������ ���� �մϴ�. ��� �����̽��ϴ�.");
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
			SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"������ �����մϴ�.");
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
				if(strcmp(CONV_LIST[listitem][NAME], "���", true) == 0)
				{
					GivePlayerItem(playerid, CONV_LIST[listitem][NAME], 20);
				}
				else
				{
					GivePlayerItem(playerid, CONV_LIST[listitem][NAME], 1);
				}
				Player[playerid][MONEY] -= CONV_LIST[listitem][PRICE];
				format(string, sizeof(string), "SYSTEM) "#C_WHITE"%s(��)�� ���� �Ͽ����ϴ�. (���� : $%d)",  CONV_LIST[listitem][NAME], CONV_LIST[listitem][PRICE]);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				PlayerUpdateMoney(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"�ش� ������ �����ϱ� ���� ���� �����մϴ�.");
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
		mysql_tquery(g_Sql, query); //�ش� �Ǽ��縮�� �̹� ���� �Ѵٴ� ��.
		SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"�Ǽ��縮 ���� / ���� �Ϸ�.");
		return 1; 
	}
	else
	{
		SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"�Ǽ��縮 ���� / ���� ���.");
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
		ShowPlayerDialog(playerid, DIALOG_PLAYER_ADMIN_CLICK_PLAYER, DIALOG_STYLE_LIST, "��ȣ�ۿ�", "ű\n��\n�̵�\n��ȯ\n����\n���� ����", "����", "���");
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