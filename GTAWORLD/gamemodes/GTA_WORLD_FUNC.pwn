////////////////////////////////////////////////////////////////////////////////stock
stock PlayerName(playerid)
{
	new UserName[64];
	GetPlayerName(playerid, UserName, sizeof(UserName));
	return UserName;
}
stock ShowUserText(string[])
{
	new str[128],warndstr[2048];
	new File:handle = fopen(string,io_read);
	if(handle)
	{
		while(fread(handle, str))
		{
			strcat(warndstr, str); // 읽은 크기만큼 일단 추가.
		}
		fclose(handle);
		return warndstr;
	}			
	return warndstr;
}
stock ShowPlayerAccDialog(playerid, Array[][SHOP_DATA], sex, jobid, size)
{
	new subString[64];
	new string[10240 * sizeof(subString)];
	new j = 0;
	for (new i = 0; i < size; i++)
	{
		if(Array[i][SEX] == sex && Array[i][JOB_ID] == jobid)
		{
			Player[playerid][SAVE_NUM][j] = Array[i][MODELID];
			Player[playerid][SAVE_PRICE][j] = Array[i][PRICE];
			format(subString, sizeof(subString), "%i(0.0, 0.0, -50.0, 1.5)\t%s~n~~g~~h~$%i\n", 
			Array[i][MODELID], Array[i][NAME], Array[i][PRICE]);
			strcat(string, subString);
			j = j + 1;
		}
		else if(jobid == -1) //모든 직업을 다 보여줌.
		{
			if(Array[i][SEX] == sex)
			{
				Player[playerid][SAVE_NUM][j] = Array[i][MODELID];
				Player[playerid][SAVE_PRICE][j] = Array[i][PRICE];
				format(subString, sizeof(subString), "%i(0.0, 0.0, -50.0, 1.5)\t%s~n~~g~~h~$%i\n", 
				Array[i][MODELID], Array[i][NAME], Array[i][PRICE]);
				strcat(string, subString);
				j = j + 1;
			}
		}
		else if(Player[playerid][JOB] > 8 && Array[i][SEX] == sex ) //모든 직업을 다 보여줌.
		{
			format(subString, sizeof(subString), "%i(0.0, 0.0, -50.0, 1.5)\t%s~n~~g~~h~$%i\n", 
			Array[i][MODELID], Array[i][NAME], Array[i][PRICE]);
			strcat(string, subString);
		}
	}
	return string;
}
//////////////////////////////////////////////////////////////////////////////public
public CheckAccount(playerid)
{
    new string[256];
    if(cache_num_rows() > 0)
    {
		format(string,sizeof(string),"웹 페이지 계정\"%s\"의 회원 정보를 찾았습니다. 계정 비밀번호를 입력하세요.\n(계정 비밀번호는 사이트의 비밀번호와 동일합니다.)",PlayerName(playerid));
		ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN",string,"입력", "취소");
		cache_get_value_name(0, "password", Player[playerid][PWD], 65);
	}
    else
    {
	    ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_MSGBOX, "LOGIN_ERROR", "계정 정보가 확인되지 않습니다.\n\"jsea.myq-see.com\"\n혹은 샘프 서버 정보창에서 보이는 URL을 클릭하여 사이트 가입 후 이용해 주시기 바랍니다.","확인","");
    }
}
public CheckPassword(playerid, password[])
{
	if(strcmp(password, Player[playerid][PWD]) == 0)
	    return 0;
    return -1;
}
public InitUserData(playerid)
{
	/*
		enum PLAYER_INFO
		{
			NAME[64],
			PWD[65],
			TUTORIAL,
		    LEVEL,
			EXP,
			PLAY_TIME[3],
			Float:POS[3]
		};
	*/
	Player[playerid][NAME] = PlayerName(playerid);
    Player[playerid][TUTORIAL] = 0;
    Player[playerid][LEVEL] = 0;
    Player[playerid][EXP] = 0;
    Player[playerid][SPAWN] = 0;
    Player[playerid][PLAY_TIME][0] = 0;
    Player[playerid][PLAY_TIME][1] = 0;
    Player[playerid][PLAY_TIME][2] = 0;
    Player[playerid][POS][0] = 0;
    Player[playerid][POS][1] = 0;
    Player[playerid][POS][2] = 0;
}
public CreateGangZone()
{
    for(new i = 0; i < sizeof(ZoneInfo); i++)
		ZoneID[i] = GangZoneCreate(ZoneInfo[i][zMinX], ZoneInfo[i][zMinY], ZoneInfo[i][zMaxX], ZoneInfo[i][zMaxY]);
}
public ShowForGZ(playerid)
{
    if(Player[playerid][SPAWN] == 0)
	{
	    for(new i=0; i < sizeof(ZoneInfo); i++)
		    GangZoneShowForPlayer(playerid, ZoneID[i], ZoneInfo[i][zColor]);
		Player[playerid][SPAWN] = 1;
	}
	return 1;
}
public HideForGZ(playerid)
{
	for(new i=0; i < sizeof(ZoneInfo); i++)
	    GangZoneHideForPlayer(playerid, ZoneID[i]);
	return 1;
}
public ShowForICON(playerid)
{
	/*
	    enum iZone
		{
			Float:X,
			Float:Y,
			Float:Z
			MARKERTYPE,
			COLOR,
			STYLE
		 }
	*/
	for(new i = 0; i < sizeof(IconInfo); i++)
		SetPlayerMapIcon(playerid, i, IconInfo[i][iX], IconInfo[i][iY], IconInfo[i][iZ], IconInfo[i][MARKERTYPE], IconInfo[i][COLOR], IconInfo[i][STYLE]);
}
public IsPlayerInArea(playerid)
{
	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);
	if(Player[playerid][LEVEL] < 10)
	{
		if(ZoneInfo[5][zMinX] < X <= ZoneInfo[5][zMaxX]
		&& ZoneInfo[5][zMinY]  < Y <= ZoneInfo[5][zMaxY]
		|| ZoneInfo[6][zMinX] < X <= ZoneInfo[6][zMaxX]
		&& ZoneInfo[6][zMinY]  < Y <= ZoneInfo[6][zMaxY]
		|| ZoneInfo[7][zMinX] < X <= ZoneInfo[7][zMaxX]
		&& ZoneInfo[7][zMinY]  < Y <= ZoneInfo[7][zMaxY])
		{
		    GameTextForPlayer(playerid, "You out of the mission ~r~area", 1000, 3);
		}
	}
	if(Player[playerid][LEVEL] < 20)
	{
		if(ZoneInfo[8][zMinX] < X <= ZoneInfo[8][zMaxX]
		&& ZoneInfo[8][zMinY]  < Y <= ZoneInfo[8][zMaxY]
		|| ZoneInfo[9][zMinX] < X <= ZoneInfo[9][zMaxX]
		&& ZoneInfo[9][zMinY]  < Y <= ZoneInfo[9][zMaxY]
		|| ZoneInfo[10][zMinX] < X <= ZoneInfo[10][zMaxX]
		&& ZoneInfo[10][zMinY]  < Y <= ZoneInfo[10][zMaxY]
		|| ZoneInfo[11][zMinX] < X <= ZoneInfo[11][zMaxX]
		&& ZoneInfo[11][zMinY]  < Y <= ZoneInfo[11][zMaxY]
		|| ZoneInfo[12][zMinX] < X <= ZoneInfo[12][zMaxX]
		&& ZoneInfo[12][zMinY]  < Y <= ZoneInfo[12][zMaxY])
		{
		    GameTextForPlayer(playerid, "You out of the mission ~r~area", 1000, 3);
		}
	}
	return 1;
}
public SetPlayerEnvironment()
{
	
	new string[64];
	new weather = random(10);
	SetWorldTime(worldHour++);
	if(worldHour > 23)
	{
	    worldHour = 0;
	}
	SetWeather(weather);

	format(string, sizeof(string),"SYSTEM)"#C_WHITE" 현재 게임시간은 "#C_GREEN"(%d)"#C_WHITE"시 입니다.",worldHour);
	SendClientMessageToAll(COLOR_RED, string);
}

//##################USER FUNCTION#########################