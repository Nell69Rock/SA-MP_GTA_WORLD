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
			strcat(warndstr, str); // ���� ũ�⸸ŭ �ϴ� �߰�.
		}
		fclose(handle);
		return warndstr;
	}			
	return warndstr;
}
stock ShowPlayerModelDialog(playerid, Array[][E_VEHILCE_SHOP_DATA], size)
{
	new subString[64];
	new string[10240 * sizeof(subString)];
	InitUserTempData(playerid);
	for (new i = 0; i < size; i++)
	{
		format(subString, sizeof(subString), "%i(0.0, 0.0, -50.0, 1.5)\t%s~n~~g~~h~$%i\n", 
		Array[i][VEHILCE_MODELID], Array[i][VEHILCE_NAME], Array[i][VEHILCE_PRICE]);
		Player[playerid][TEMP_MODEL_NUM][i] = Array[i][VEHILCE_MODELID];
		Player[playerid][TEMP_MODEL_PRICE][i] = Array[i][VEHILCE_PRICE];
		strcat(string, subString);
	}
	return string;
}
stock SetPlayerMoney(playerid, money)
{
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, money);
}
//////////////////////////////////////////////////////////////////////////////public
public CheckAccount(playerid)
{
    new string[256];
	if(cache_num_rows() < 0)
		ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_MSGBOX, "LOGIN_ERROR", "���� ������ Ȯ�ε��� �ʽ��ϴ�.\n\"Nell69Rock.myq-see.com/outpost\"\nȤ�� ���� ���� ����â���� ���̴� URL�� Ŭ���Ͽ� ����Ʈ ���� �� �̿��� �ֽñ� �ٶ��ϴ�.","Ȯ��","");
	
	format(string,sizeof(string),"�� ������ ����\"%s\"�� ȸ�� ������ ã�ҽ��ϴ�. ���� ��й�ȣ�� �Է��ϼ���.\n(���� ��й�ȣ�� ����Ʈ�� ��й�ȣ�� �����մϴ�.)",PlayerName(playerid));
	ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN",string,"�Է�", "���");
	cache_get_value_name(0, "password", Player[playerid][PWD], 65);
}
public CheckPassword(playerid, password[])
{
	if(strcmp(password, Player[playerid][PWD]) == 0)
	    return 0;
    return -1;
}
public InitUserData(playerid)
{
	Player[playerid][NAME] = PlayerName(playerid);
    Player[playerid][TUTORIAL] = 0;
    Player[playerid][LEVEL] = 0;
    Player[playerid][EXP] = 0;
    Player[playerid][SPAWN] = 0;
	Player[playerid][MONEY] = 15000;
	for(new i = 0; i < 3; i++)
	{
		Player[playerid][PLAY_TIME][i] = 0;
		Player[playerid][POS][i] = 0;
	}
}
public InitUserTempData(playerid)
{
	for(new i = 0; i < 50; i++)
	{
		Player[playerid][TEMP_MODEL_NUM][i] = -1;
		Player[playerid][TEMP_MODEL_PRICE][i] = 0;
	}
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
	    worldHour = 0;

	SetWeather(weather);

	format(string, sizeof(string),"SYSTEM)"#C_WHITE" ���� ���ӽð��� "#C_GREEN"(%d)"#C_WHITE"�� �Դϴ�.",worldHour);
	SendClientMessageToAll(COLOR_RED, string);
}

//##################USER FUNCTION#########################