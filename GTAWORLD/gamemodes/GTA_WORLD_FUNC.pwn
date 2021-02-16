//##################stock FUNCTION#########################
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

//##################USER_SQL FUNCTION#########################

public SQL_CALL_CheckUserData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "select * from user_account where exists (select * from user_account where name='%s';"), PlayerName(playerid));
	mysql_tquery(g_Sql, query, "CheckUserData", "d", playerid);
}
public CheckUserData(playerid)
{
	if(cache_num_rows() > 0)
	{
		Player[playerid][RESULT] = 1;
		return Player[playerid][RESULT]; // success
	}
	Player[playerid][RESULT] = 0;
	return Player[playerid][RESULT]; // fail
}
public SQL_CALL_SetupUserData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "INSERT INTO user_account (name, tutorial, skin, money, vehid) VALUES ('%s', 0, 0, 0, 0);", PlayerName(playerid));
	mysql_tquery(g_Sql, query);

	mysql_format(g_Sql, query, sizeof(query), "INSERT INTO user_loacation (name, x_pos, y_pos, z_pos) VALUES ('%s', 0, 0, 0);", PlayerName(playerid));
	mysql_tquery(g_Sql, query);
}
public SQL_CALL_LoadUserData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM user_account WHERE name = '%s';", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "LoadUserData", "d", playerid);
}
public LoadUserData(playerid)
{
	if(cache_num_rows() > 0){
		cache_get_value_name_int(0, "tutorial", Player[playerid][TUTORIAL]);
		cache_get_value_name_int(0, "skin", Player[playerid][SKIN]);
		cache_get_value_name_int(0, "money", Player[playerid][MONEY]);
		cache_get_value_name_int(0, "vehid", Player[playerid][VEHICLE_ID]);
	}
	return printf("LoadUserData Done!!!!");
}
public SQL_CALL_LoadLocationData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM user_location WHERE name = '%s';", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "LoadLocationData", "d", playerid);
}
public LoadLocationData(playerid)
{
	new Float:X, Float:Y, Float:Z;
	if(cache_num_rows() > 0){
		cache_get_value_name_float(0, "x_pos", X);
		cache_get_value_name_float(0, "y_pos", Y);
		cache_get_value_name_float(0, "z_pos", Z);
	}
	SetPlayerPos(playerid, X, Y, Z);
	return printf("LoadLocationData Done!!!!");
}
public SaveLocationData(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid);
	mysql_format(g_Sql, query, sizeof(query), "UPDATE user_location SET x_pos = %f, y_pos = %f, z_pos = %f  WHERE name = '%s';", 
		PlayerName(playerid), X, Y, Z);
	mysql_tquery(g_Sql, query);

}
public SQL_CALL_LoadVehicleData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM user_vehicle WHERE name = '%s' AND vehid = %d;", PlayerName(playerid), Player[playerid][VEHICLE_ID]);
	mysql_tquery(g_Sql, query, "LoadVehicleData", "d", playerid);
}
public LoadVehicleData(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	new Color[2];
	if(cache_num_rows() > 0){
		cache_get_value_name_int(0, "1_color", Color[0]);
		cache_get_value_name_int(0, "2_color", Color[1]);
	}
	new my_vehicle_id = CreateVehicle(Player[playerid][VEHICLE_ID], X, Y, Z, 0, Color[0], Color[1], -1);
	PutPlayerInVehicle(playerid, my_vehicle_id, 0);
	return printf("LoadVehicleData Done!!!!");
}
public CheckAccount(playerid)
{
    new string[256];
	if(cache_num_rows() < 0)
		ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_MSGBOX, "LOGIN_ERROR", "계정 정보가 확인되지 않습니다.\n\"Nell69Rock.myq-see.com/outpost\"\n혹은 샘프 서버 정보창에서 보이는 URL을 클릭하여 사이트 가입 후 이용해 주시기 바랍니다.","확인","");
	
	format(string,sizeof(string),"웹 페이지 계정\"%s\"의 회원 정보를 찾았습니다. 계정 비밀번호를 입력하세요.\n(계정 비밀번호는 사이트의 비밀번호와 동일합니다.)",PlayerName(playerid));
	ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"USER_LOGIN",string,"입력", "취소");
	cache_get_value_name(0, "password", Player[playerid][PWD], 65);
}
public CheckPassword(playerid, password[])
{
	if(strcmp(password, Player[playerid][PWD]) == 0)
	    return 0;
    return -1;
}
//##################USER FUNCTION#########################

public InitUserData(playerid)
{
    Player[playerid][TUTORIAL] = 0;
    Player[playerid][LEVEL] = 0;
    Player[playerid][EXP] = 0;
	Player[playerid][MONEY] = 0;
	Player[playerid][SKIN] = 0;
	Player[playerid][VEHICLE_ID] = 0;
	for(new i = 0; i < 3; i++)
		Player[playerid][PLAY_TIME][i] = 0;
	return ;
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
	for(new i=0; i < sizeof(ZoneInfo); i++)
		GangZoneShowForPlayer(playerid, ZoneID[i], ZoneInfo[i][zColor]);
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
	/* GAS STATION*/
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

	format(string, sizeof(string),"SYSTEM)"#C_WHITE" 현재 게임시간은 "#C_GREEN"(%d)"#C_WHITE"시 입니다.",worldHour);
	SendClientMessageToAll(COLOR_RED, string);
}

public CheckUserTutorial(playerid)
{
	if(Player[playerid][TUTORIAL] > 0)
		return;
	Player[playerid][TUTORIAL] = 1;
	return;
}
public CheckUserVehicle(playerid, vehidleid)
{
	new query[128];
	new ret = 0;
	mysql_format(g_Sql, query, sizeof(query), "select * from user_vehicle where exists (select * from user_vehicle where name='%s' and vehid=%d;"), PlayerName(playerid), vehidleid);
	mysql_tquery(g_Sql, query, "CheckUserData", "d", playerid);

	ret = CheckUserData(playerid);
	if(ret)
		ret = 0;
	return ret;
}

