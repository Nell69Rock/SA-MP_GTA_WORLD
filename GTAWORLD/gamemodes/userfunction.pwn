/* USER FUNCTION */ 

_GetPage(amount,currentpage,page_item)
{
	return (currentpage>-1&&(float(amount)-(float(currentpage)*float(page_item)))/float(page_item)>0);
}
_GetPageAmount(amount,currentpage,page_item)
{
	return floatround((((float(amount)-(float(currentpage)*float(page_item)))/float(page_item)>0))?
	((1.000001-((float(amount)-(float(currentpage)*float(page_item)))/float(page_item)/-1))*float(page_item))>=float(page_item)?
	(((1.000001-((float(amount)-(float(currentpage)*float(page_item)))/float(page_item)/-1))*float(page_item))-page_item)>=page_item?
	(((1.000001-((float(amount)-(float(currentpage)*float(page_item)))/float(page_item)/-1))*float(page_item))-page_item)-(((1.000001-((float(amount)-(float(currentpage)*float(page_item)))/float(page_item)/-1))*float(page_item))-page_item*2):
	((1.000001-((float(amount)-(float(currentpage)*float(page_item)))/float(page_item)/-1))*float(page_item))-page_item:0.0:0.0);
}

stock f_strpack(dest[],const source[])
	strpack(dest,source,MAX_ITEM_LENGTH);

stock f_strunpack(dest[])
{
	new string[MAX_ITEM_LENGTH+1];
	strunpack(string,dest,MAX_ITEM_LENGTH);
	return string;
}
stock _GetItemSlot(playerid,sz_item[])
{
    _SortItem(playerid);
	new checked = -1;
	for(new i=0; i<MAX_ITEM; i++)
	(strcmp(f_strunpack(e_player_item[playerid][i][item_name]), sz_item, true,strlen(f_strunpack(e_player_item[playerid][i][item_name])))==0&&
	strlen(f_strunpack(e_player_item[playerid][i][item_name]))==strlen(sz_item))&&(checked=i);
	return checked;
}
stock _GetEmptySlot(playerid)
{
	new emptyslot = -1;
	for(new i=0; i<MAX_ITEM; i++)
 	(emptyslot==-1&&!strlen(f_strunpack(e_player_item[playerid][i][item_name]))) &&(emptyslot=i);
	return emptyslot;
}
_GetSlotCount(playerid)
{
    _SortItem(playerid);
	new slotcount;
	for(slotcount=0; (slotcount<MAX_ITEM&&strlen(f_strunpack(e_player_item[playerid][slotcount][item_name]))); slotcount++)
	{
	}
	return slotcount;
}
stock SavePlayerItem(playerid)
{
	new ItemCount= _GetSlotCount(playerid);
	new sz_item[MAX_ITEM_LENGTH+10], amount;
	new query[256];
	
	for(new i=0; i < ItemCount; i++)
	{
	    GetSlotItemName(playerid,sz_item,i);
	    amount = GetPlayerItem(playerid,sz_item);
		mysql_format(g_Sql, query, sizeof(query), "INSERT INTO items (id, itemName, count) VALUES ('%s', '%s', %d);", PlayerName(playerid), sz_item, amount);
		mysql_tquery(g_Sql, query);
	}
	return 1;
}
stock SQL_CALL_LoadPlayerItem(playerid)
{
	new query[256];
	ResetPlayerItem(playerid);

	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM items WHERE id = '%s';", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "LoadPlayerItem");

	
}
public LoadPlayerItem(playerid)
{
	new itemName[30], count, query[256];
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name(i, "itemName", itemName);
		cache_get_value_name_int(i, "count", count);
		GivePlayerItem(playerid, itemName, count);
	}
	mysql_format(g_Sql, query, sizeof(query), "DELETE FROM `items` WHERE id = '%s';", PlayerName(playerid));
	mysql_tquery(g_Sql, query);
}
stock _SortItem(playerid)
{

	for(new i=0; i<MAX_ITEM; i++)
	{
	    if(strlen(f_strunpack(e_player_item[playerid][i][item_name]))&&
		e_player_item[playerid][i][item_amount]<1)
		{
			e_player_item[playerid][i][item_amount]=0;
			f_strpack(e_player_item[playerid][i][item_name],"");
		}
	}

	for(new i=0; i<MAX_ITEM; i++)
	{

	    if(!strlen(f_strunpack(e_player_item[playerid][i][item_name])) )
		{
		    for(new j=i; j<MAX_ITEM; j++)
		    {
			    if(strlen(f_strunpack(e_player_item[playerid][j][item_name])))
				{
				    f_strpack(e_player_item[playerid][i][item_name],f_strunpack(e_player_item[playerid][j][item_name]));
        			e_player_item[playerid][i][item_amount] = e_player_item[playerid][j][item_amount];
					e_player_item[playerid][j][item_amount]=0;
					f_strpack(e_player_item[playerid][j][item_name],"");
					_SortItem(playerid);
					break;
				}
		    }
	    }
	}
}
stock SetPlayerItem(playerid, item[], value)
{
    _SortItem(playerid);
	new checked = _GetItemSlot(playerid,item);
	new emptyslot = _GetEmptySlot(playerid);

	if(strlen(item)>MAX_ITEM_LENGTH+1) return ;
	if(checked!=-1)
	{
		e_player_item[playerid][checked][item_amount]=value;
		(e_player_item[playerid][checked][item_amount]<1)&&
			DeletePlayerItem(playerid,f_strunpack(e_player_item[playerid][checked][item_name]));
	}
	else if(emptyslot!=-1&&value>0)
	{
	    f_strpack(e_player_item[playerid][emptyslot][item_name],item);
        e_player_item[playerid][emptyslot][item_amount] = value;
	}
}
stock GivePlayerItem(playerid, item[], value)
{
    _SortItem(playerid);
	new checked = _GetItemSlot(playerid,item);
	new emptyslot = _GetEmptySlot(playerid);
	if(strlen(item)>MAX_ITEM_LENGTH+1) return ;

	if(checked!=-1)
	{
		e_player_item[playerid][checked][item_amount]+=value;
		(e_player_item[playerid][checked][item_amount]<1)&&
			DeletePlayerItem(playerid,f_strunpack(e_player_item[playerid][checked][item_name]));
	}
	else if(emptyslot!=-1&&value>0)
	{
	    f_strpack(e_player_item[playerid][emptyslot][item_name],item);
        e_player_item[playerid][emptyslot][item_amount] = value;
	}
	return ;
}
stock DeletePlayerItem(playerid, item[])
{
	new checked = _GetItemSlot(playerid,item);
	if(strlen(item)>MAX_ITEM_LENGTH+1) return ;
	if(checked!=-1)
	{
		e_player_item[playerid][checked][item_amount]=0;
		f_strpack(e_player_item[playerid][checked][item_name],"");
	}
	_SortItem(playerid);
}
stock GetPlayerItem(playerid, item[])
{
    _SortItem(playerid);
	new checked = _GetItemSlot(playerid,item);
	if(strlen(item)>MAX_ITEM_LENGTH+1) return 0;
	return (checked!=-1)? e_player_item[playerid][checked][item_amount]:0;
}
stock GetSlotItemName(playerid, dest[], slot)
{
	_SortItem(playerid);
	if(slot>MAX_ITEM) return ;
	strmid(dest,f_strunpack(e_player_item[playerid][slot][item_name]),0,
	strlen(f_strunpack(e_player_item[playerid][slot][item_name])),MAX_ITEM_LENGTH);
}
stock ResetPlayerItem(playerid)
{
	for(new i=0; i<MAX_ITEM; i++)
	{
		e_player_item[playerid][i][item_amount]=0;
		f_strpack(e_player_item[playerid][i][item_name],"");
	}
}


stock RPnamecheck(playerid)
{
    new pname[MAX_PLAYER_NAME],underline=0;
    GetPlayerName(playerid, pname, sizeof(pname));
    if(strfind(pname,"[",true) != (-1)) return 0;
    else if(strfind(pname,"]",true) != (-1)) return 0;
    else if(strfind(pname,"$",true) != (-1)) return 0;
    else if(strfind(pname,"(",true) != (-1)) return 0;
    else if(strfind(pname,")",true) != (-1)) return 0;
    else if(strfind(pname,"=",true) != (-1)) return 0;
    else if(strfind(pname,"@",true) != (-1)) return 0;
    else if(strfind(pname,"1",true) != (-1)) return 0;
    else if(strfind(pname,"2",true) != (-1)) return 0;
    else if(strfind(pname,"3",true) != (-1)) return 0;
    else if(strfind(pname,"4",true) != (-1)) return 0;
    else if(strfind(pname,"5",true) != (-1)) return 0;
    else if(strfind(pname,"6",true) != (-1)) return 0;
    else if(strfind(pname,"7",true) != (-1)) return 0;
    else if(strfind(pname,"8",true) != (-1)) return 0;
    else if(strfind(pname,"9",true) != (-1)) return 0;
    else if(strfind(pname,"fuck",true) != (-1)) return 0;
    else if(strfind(pname,"FUCK",true) != (-1)) return 0;
    else if(strfind(pname,"Boobies",true) != (-1)) return 0;
    else if(strfind(pname,"Pussy",true) != (-1)) return 0;
    else if(strfind(pname,"Rape",true) != (-1)) return 0;
    else if(strfind(pname,"kill",true) != (-1)) return 0;
    else if(strfind(pname,"shit",true) != (-1)) return 0;
    else if(strfind(pname,"ass",true) != (-1)) return 0;
    else if(strfind(pname,"whore",true) != (-1)) return 0;
    else if(strfind(pname,"Penis",true) != (-1)) return 0;
    else if(strfind(pname,"_Dick",true) != (-1)) return 0;
    else if(strfind(pname,"Vagina",true) != (-1)) return 0;
    else if(strfind(pname,"Cock",true) != (-1)) return 0;
    else if(strfind(pname,"Rectum",true) != (-1)) return 0;
    else if(strfind(pname,"Sperm",true) != (-1)) return 0;
    else if(strfind(pname,"Rektum",true) != (-1)) return 0;
    else if(strfind(pname,"Pistol",true) != (-1)) return 0;
    else if(strfind(pname,"AK47",true) != (-1)) return 0;
    else if(strfind(pname,"Shotgun",true) != (-1)) return 0;
    else if(strfind(pname,"Cum",true) != (-1)) return 0;
    else if(strfind(pname,"Hitler",true) != (-1)) return 0;
    else if(strfind(pname,"Jesus",true) != (-1)) return 0;
    else if(strfind(pname,"God",true) != (-1)) return 0;
    else if(strfind(pname,"Shotgun",true) != (-1)) return 0;
    else if(strfind(pname,"Desert_Eagle",true) != (-1)) return 0;
    else if(strfind(pname,"fucker",true) != (-1)) return 0;
    else if(strfind(pname,"Retard",true) != (-1)) return 0;
    else if(strfind(pname,"Tarded",true) != (-1)) return 0;
    else if(strfind(pname,"fanny",true) != (-1)) return 0;
    else if(strfind(pname,"abcdefghijklmnopqrstuvwxyz",true) != (-1)) return 0;
    new maxname = strlen(pname);
    for(new i=0; i<maxname; i++)
    {
       if(pname[i] == '_') underline ++;
    }
    if(underline != 1) return 0;
    pname[0] = toupper(pname[0]);
    for(new x=1; x<maxname; x++)
    {
        if(pname[x] == '_') pname[x+1] = toupper(pname[x+1]);
        else if(pname[x] != '_' && pname[x-1] != '_') pname[x] = tolower(pname[x]);
    }
    SetPlayerName(playerid, "New_Name");
    SetPlayerName(playerid, pname);
    return 1;
}

stock ShowPlayerBag(playerid, page=0)
{

	new szString[1024],
        sz_itemname[MAX_ITEM_LENGTH],
        g_itemamount,
		itemcount=_GetSlotCount(playerid),
		viewed = _GetPage(itemcount,page,PAGE_ITEM),
		pageamount = _GetPageAmount(itemcount,page,PAGE_ITEM);

	if(pageamount<1&&viewed==0 )
	{
		ShowPlayerBag(playerid,page-1);
		return ;
	}
	if(viewed==1)
	{
		for(new i=0; i<pageamount; i++)
		{
		    GetSlotItemName(playerid,sz_itemname,i+(page*PAGE_ITEM));
		    g_itemamount = GetPlayerItem(playerid,sz_itemname);
			new tabstring[15];
			if(strlen(sz_itemname))
		    {
		        for(new x=(strlen(sz_itemname)/DIALOG_TEXT_SPACING); x<5; x++)
		        {
		            strcat(tabstring,"\t");
		        }
				format(szString,1024,"%s\t%s%s%d\n",szString,sz_itemname,tabstring,g_itemamount);

			}
		}
	}
	format(szString,1024,"\t아이템\t\t\t\t\t갯수\n%s",szString);


	(_GetPage(itemcount,page+1,PAGE_ITEM)==1)&&
	strcat(szString,"\t다음페이지\n",1024);

	(_GetPage(itemcount,page-1,PAGE_ITEM)==1)&&
	strcat(szString,"\t이전페이지",1024);

	ViewPage[playerid]=page;
	ShowPlayerDialog(playerid,DIALOG_INVENTORY_ID,DIALOG_STYLE_TABLIST_HEADERS,"가방",szString,"사용","취소");
	return ;
}

stock GetActorSlot()
{
	for(new i = 0; i < MAX_ACTORS; i++)
	{
		if(!ACTOR_DATA[i][ACTOR_SLOT_USED]) return i;
	}
	return -1;
}
stock GetClosestVehicle(playerid, Float:range) {
   new Float:VehiclePos[4], nearestID;
   nearestID = 65535;
   for(new vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++) {
      if(IsValidVehicle(vehicleid)) {
         GetVehiclePos(vehicleid, VehiclePos[1], VehiclePos[2], VehiclePos[3]);
         if(IsPlayerInRangeOfPoint(playerid, range, VehiclePos[1], VehiclePos[2], VehiclePos[3])) {
            nearestID = vehicleid;
            break;
         }
      }
   }
   return nearestID;
} 

stock strcpy(dest[], src[], size = sizeof(dest))
{
    dest[0] = EOS;
    return strcat(dest, src, size);
}
stock PlayerName(playerid)
{
	new userName[24];
	GetPlayerName(playerid, userName, MAX_PLAYER_NAME);
	return userName;
}
stock GetVehicleSlot()
{
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(!vehicleList[i]) return i;
	}
	return -1; //FULL 
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
stock ShowUserText(string[])
{
	new str[128],warndstr[2048];
	new extraString[2048];
	new buf[10];
	new jobnum = 0;
	new File:handle = fopen(string,io_read);
	if(handle)
	{
		while(fread(handle, str))
		{
			strcat(warndstr, str); // 읽은 크기만큼 일단 추가.
		}
		fclose(handle);
		if(strcmp(string, "admin_buy_pick.txt", true) == 0)
		{
			for(new i = 1; i < sizeof(PlayerJobName); i++)
			{
				if(strcmp(PlayerJobName[i], "0") == 0)
				{
					break;
				}
				jobnum = i;
				jobnum = jobnum + 4;
				strcat(extraString, PlayerJobName[i]);
				strcat(extraString, " : ");
				valstr(buf, jobnum);
				strcat(extraString, buf);
				strcat(extraString, "\n");
			}
			strcat(warndstr, extraString);
		}
		return warndstr;
	}			
	return warndstr;
}
strtok(const string[], &index, flag = 0)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
 
	new offset = index;
	new result[128];
	if(flag == 0)
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	else
	{
		while ((index < length)  && ((index - offset) < (sizeof(result) - 1)))
		{
			result[index - offset] = string[index];
			index++;
		}
	}
	result[index - offset] = EOS;
	return result;
}

stock GetUserVehicleID(playerid) //해당 유저의 탈것이 존재하는지 체크.
{
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(!isnull(VEHICLE_DATA[i][vOwner]))
		{ 
			if(!strcmp(VEHICLE_DATA[i][vOwner], PlayerName(playerid)))
			{
				return i;
			}
		}
	}
	return -1;
}

stock CreateVehicleEx(modelid, Float:Health, Float:x, Float:y, Float:z, Float:angle, fuel, vJOB, color1, color2, ownername[MAX_PLAYER_NAME])
{
    //now put all the data into the array
    //To get the index, use the first free slot with the function before
	new jobstr[MAX_PLAYER_NAME] = "jobcar";
    new carid = GetVehicleSlot();
    VEHICLE_DATA[carid][vehicleID] = modelid;
	VEHICLE_DATA[carid][vHealth] = Health;
	VEHICLE_DATA[carid][vJob] = vJOB;
    VEHICLE_DATA[carid][vX] = x;
    VEHICLE_DATA[carid][vY] = y;
    VEHICLE_DATA[carid][vZ] = z;
    VEHICLE_DATA[carid][vAngle] = angle;
    VEHICLE_DATA[carid][vColor][0] = color1;
    VEHICLE_DATA[carid][vColor][1] = color2;
	VEHICLE_DATA[carid][vFuel] = fuel;
	
	if(VEHICLE_DATA[carid][vJob] > 0)
	{
		strcat(ownername, jobstr);
		VEHICLE_DATA[carid][vOwner] = ownername;
	}
	else
	{
		VEHICLE_DATA[carid][vOwner] = ownername;
	}
    //... you can just add any data you like
    //dont forget to mark the carslot as used in the validcar array
    vehicleList[carid] = true;
    //At last create the vehicle in the game
    AddStaticVehicleEx(modelid, x, y, z, angle, color1, color2, -1, 0);
	SetVehicleHealth(carid, Health);
	SetVehicleParamsEx(carid, 0, 0, 0, 0, 0, 0, 0);
	return VEHICLE_DATA[carid][vOwner];         //Make the function return the carid/array index. This is not necessarily needed, but good style    
}
stock DestroyVehicleEx(vehiclemodelid, vehicleid)
{
	new query[256];
	mysql_format(g_Sql, query, sizeof(query), "DELETE FROM vehicle WHERE vModel = %d AND id = '%s';", vehiclemodelid, VEHICLE_DATA[vehicleid][vOwner]);
	mysql_tquery(g_Sql, query);
	DestroyVehicle(vehicleid);
	vehicleList[vehicleid] = false;
	return 1;
}

public PlayerUpdateMoney(playerid)
{
	ResetPlayerMoney(playerid)
	GivePlayerMoney(playerid, Player[playerid][MONEY]);
}
public SaveUserVehicle(playerid, vehicleNum)
{
	new query[256];
	
	GetVehiclePos(vehicleNum, VEHICLE_DATA[vehicleNum][vX], VEHICLE_DATA[vehicleNum][vY], VEHICLE_DATA[vehicleNum][vZ]);
	GetVehicleZAngle(vehicleNum, VEHICLE_DATA[vehicleNum][vAngle]);
	GetVehicleHealth(vehicleNum, VEHICLE_DATA[vehicleNum][vHealth]);
	mysql_format(g_Sql, query, sizeof(query), "UPDATE vehicle SET vHealth=%f, X=%f,Y=%f,Z=%f,vAngle=%f,vFuel=%d WHERE id = '%s'",VEHICLE_DATA[vehicleNum][vHealth], VEHICLE_DATA[vehicleNum][vX],VEHICLE_DATA[vehicleNum][vY],VEHICLE_DATA[vehicleNum][vZ],VEHICLE_DATA[vehicleNum][vAngle],VEHICLE_DATA[vehicleNum][vFuel], VEHICLE_DATA[vehicleNum][vOwner]);
	mysql_tquery(g_Sql, query);
}
public PlayerVehicleEngineStart(playerid, userVehNum)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(userVehNum, engine, lights, alarm, doors, bonnet, boot, objective);
	GetVehicleHealth(userVehNum, VEHICLE_DATA[userVehNum][vHealth]);
	if(VEHICLE_DATA[userVehNum][vHealth] < 310 || VEHICLE_DATA[userVehNum][vFuel] <= 0)
	{
		SetVehicleParamsEx(userVehNum, 0, 0, alarm, doors, bonnet, boot, objective); //?떆?룞 耳쒓린 ?떎?젣濡? 
		GameTextForPlayer(playerid, "~y~Engine ~g~FAIL", 1500, 4);
		return 0;
	}
	SetVehicleParamsEx(userVehNum, 1, lights, alarm, doors, bonnet, boot, objective); //?떆?룞 耳쒓린 ?떎?젣濡? 
	userVehNum = SetTimerEx("PlayerVehicleUtil", (1000*1) , true, "d", userVehNum); //?떆?룞 耳쒖???뒗 吏곹썑 10遺꾨쭏?떎 ?쑀??? 湲곕쫫 1?뵫 ?떝寃? ?빐?빞?븿.
	SetPVarInt(playerid, "FuelTimer", userVehNum);
	GameTextForPlayer(playerid, "~y~Engine ~g~ON", 1500, 4);
	return 1; // success
}
public PlayerVehicleUtil(userVehNum)
{
	RepairVehicle(userVehNum);
	if(VEHICLE_DATA[userVehNum][vFuel] < 0)
	{
		VEHICLE_DATA[userVehNum][vFuel] = 0;
	}
	VEHICLE_DATA[userVehNum][vFuel] --;
}



public InitializeUserData(playerid)
{

	Player[playerid][SEED] = -1;
	for(new i = 0; i < 4; i++)
	{
		Player[playerid][ACC_MODEL_ID][i] = -1;
		Player[playerid][ACC_INDEX][i] = -1;
	}
}
public CallUser(playerid, givePlayerid, phoneNumber)
{
	new string[256];
	givePlayerid = -1;
	if(cache_num_rows() > 0)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(Player[i][PHONE] == phoneNumber)
			{
				givePlayerid = i;
				break;
			}
		}
		if(givePlayerid == -1)
		{
			SendClientMessage(playerid,COLOR_PURPLE,"PHONE) "#C_WHITE"번호는 일치하나 해당 사용자는 현재 접속 중이지 않습니다.");
			return 1;
		}
		if(Player[givePlayerid][SEED] > 0)
		{
			SendClientMessage(playerid, COLOR_PURPLE, "PHONE) "#C_WHITE"이미 통화중인 사용자 입니다. 나중에 다시 걸어 주십시오.");
			return 1;
		}
		if(Player[playerid][PHONE] == phoneNumber) //나 자신에게 전화를 건게 아니라면.
		{
			format(string, sizeof(string), "전화가 왔습니다.\n전화번호 : ☏%d\n받으시겠습니까?",phoneNumber);
			ShowPlayerDialog(givePlayerid, DIALOG_PLAYER_PHONE_CALL_TO_PLAYER, DIALOG_STYLE_MSGBOX, "전화가 왔습니다.", string, "통화", "거절");

			format(string, sizeof(string), "INFO) "#C_WHITE"%d로 연결중...",phoneNumber);
			SendClientMessage(playerid, COLOR_PURPLE, "PHONE) "#C_WHITE"연결중...");
			Player[playerid][SEED] = phoneNumber; // 송신자 -> 수신자 연결. 

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			SetPlayerSpecialAction(givePlayerid, SPECIAL_ACTION_USECELLPHONE);
		}
		else // 플레이어가 본인에게 통화를 걸려고 하면...
		{
			SendClientMessage(playerid,COLOR_PURPLE,"PHONE) "#C_WHITE"본인에게 전화를 걸 수 없습니다.");
			return 1;
		}
	}
	else
	{
		format(string, sizeof(string), "PHONE) "#C_WHITE"입력한 %d(은)는 없는 번호 입니다.", phoneNumber);
		SendClientMessage(playerid,COLOR_PURPLE,string);
		return 1;
	}
	return 0;
}
public SetCallUser(playerid, phoneNumber)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT phoneNum FROM information WHERE phoneNum = %d", phoneNumber);
	mysql_tquery(g_Sql, query, "CallUser", "iii", playerid, playerid, phoneNumber);
}
public GetPlayerAddPick()
{

	new index;
	for(new i = 1; i < MAX_PICK; i++)
	{
		if(ENTER_EXIT[i][ENTER_VIRTUAL_WORLD] == 0)
		{
			index = i;
			break;
		}
	}
	return index;
}
public CheckAccPlayer(playerid, index, modelid, price)
{
	new boneid = index !=3 ? 2 : 5;
	new query[128];
	if(cache_num_rows() > 0)
	{
		return SendClientMessage(playerid, COLOR_PURPLE, "INFO) "#C_WHITE"이미 해당 위치의 악세사리는 보유 중입니다.");
	}

	Player[playerid][ACC_INDEX][index] = index;
	Player[playerid][ACC_MODEL_ID][index] = modelid;
	
	SetPlayerAttachedObject(
	playerid, 
	Player[playerid][ACC_INDEX][index], 
	Player[playerid][ACC_MODEL_ID][index], 
	boneid); // 본 아이디는 알아서 정하면 됨.


	mysql_format(
	g_Sql, 
	query, 
	sizeof(query), 
	"INSERT INTO accessories (id, modelid, index_) VALUES ('%s', %d, %d);", 
	PlayerName(playerid),
	Player[playerid][ACC_MODEL_ID][index],
	Player[playerid][ACC_INDEX][index]);
	mysql_tquery(g_Sql, query);

	Player[playerid][MONEY] -= price;

	SaveUserData(playerid);

	EditAttachedObject(playerid, Player[playerid][ACC_INDEX][index]);
	return 1;
}
public ShowVehicleActive(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_VEHICLE_STATUS, DIALOG_STYLE_LIST, "상호작용", "Vehicle\n\t시동\n\t전조등\n\t트렁크\n\t본넷\n\t문\nRadio\n\t노래듣기", "선택", "닫기");
}
public ShowUserJobActive(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_PLAYER_JOB, DIALOG_STYLE_LIST, "상호작용", "JOB\n\t입사\n\t퇴사\n\t출근\n\t퇴근", "선택", "닫기");
}
public ShowInterActive(playerid)
{
	if(Player[playerid][ADMIN] > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_PLAYER_ADMIN_INTER_ACTIVE, DIALOG_STYLE_LIST, "상호작용", "Admin\n\tBuilding Construction\n\t\t입장 추가\n\t\t인테리어 이동\n\t\t퇴장 추가\n\t\t맵 아이콘\n\t\t구매 위치 추가\n\tBuilding Mangaement\n\t\t건물 관리\n\tNPC\n\t\t추가\n\t\t삭제\n\tJob Management\n\t\t목록 보기\n\t\t추가", "선택", "닫기");
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_PLAYER, DIALOG_STYLE_LIST, "상호작용", "My Info\n\t내 정보\n\t악세사리\nAction\n\t주기\nPhone\n\t통화\n\t통화 종료\n\t주소록\n\t메시지\n\t은행업무", "선택", "닫기");
	}
}
public ShowClothBuyDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_CLOTH, DIALOG_STYLE_LIST, "상호작용", "Cloth\n\t옷 구매하기\nAcessories\n\t모자\n\t안경\n\t마스크\n\t시계", "선택", "닫기");
}
public ShowBankDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK, DIALOG_STYLE_LIST, "상호작용", "Bank\n\t입금\n\t출금\n\t잔고확인", "선택", "닫기");
}
public ShowVehicleDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_VEHICLE, DIALOG_STYLE_LIST, "상호작용", "Vehicle\n\t구매", "선택", "닫기");
}
public DelaySpawnPlayer(playerid)
{
	GameTextForPlayer(playerid, "Load Player Information Successed", 2000, 4);
	SetPlayerSkin(playerid, Player[playerid][SKIN]);
	SetPlayerInterior(playerid, Player[playerid][INTERIOR]);
	SetPlayerVirtualWorld(playerid, Player[playerid][VIRTUALWORLD]);
	SetPlayerHealth(playerid, Player[playerid][HEALTH]);
	SetPlayerArmour(playerid, Player[playerid][ARMOUR]);
	Player[playerid][LOGIN]=true;
	for(new i = 0; i < 4; i++)
	{
		if(Player[playerid][ACC_INDEX][i]  >= 0)
		{
			new boneid = Player[playerid][ACC_INDEX][i] !=3 ? 2 : 5;
			SetPlayerAttachedObject(
				playerid, 
				Player[playerid][ACC_INDEX][i],
				Player[playerid][ACC_MODEL_ID][i],
				boneid,
				Player[playerid][ACC_POS][i][0],
				Player[playerid][ACC_POS][i][1],
				Player[playerid][ACC_POS][i][2],
				Player[playerid][ACC_POS][i][3],
				Player[playerid][ACC_POS][i][4],
				Player[playerid][ACC_POS][i][5],
				Player[playerid][ACC_POS][i][6],
				Player[playerid][ACC_POS][i][7],
				Player[playerid][ACC_POS][i][8]
			);
		}
	}
	SetPlayerPos(playerid, Player[playerid][POS][0], Player[playerid][POS][1], Player[playerid][POS][2]);
}
public PlayerStatus(playerid)
{
	Player[playerid][TIME][2]++;
	if(Player[playerid][TIME][2] > 59)
	{
		Player[playerid][TIME][2] = 0;
		Player[playerid][TIME][1]++;	
	} 
	if(Player[playerid][TIME][1] > 59)
	{
		Player[playerid][TIME][1] = 0;
		Player[playerid][TIME][0]++;
	}
}

public ServerStatus()
{
	new string[50];
	new randomNum = random(10)+1;
	if(randomNum % 2 == 0)
	{
		format(string, sizeof(string), "hostname %s", SERVER1);
		SendRconCommand(string);
	}
	else 
	{
		format(string, sizeof(string), "hostname %s", SERVER2);
		SendRconCommand(string);
	}
}
public SetEnviroment(hour)
{
	new string[64];
	new weather = random(10);
	SetWorldTime(hour++);
	if(hour > 23)
	{
	    hour = 0;
	}
	SetWeather(weather);

	format(string, sizeof(string),"SYSTEM)"#C_WHITE" 현재 게임시간은 "#C_GREEN"%d"#C_WHITE"시 입니다.",hour);
	SendClientMessageToAll(COLOR_RED, string);
}

public CheckAccount(playerid)
{
    new String[128];
	if(cache_num_rows() > 0)
	{
		format(String,sizeof(String),"계정\"%s\"의 회원 정보를 찾았습니다. 계정 비밀번호를 입력하세요.",PlayerName(playerid));
		ShowPlayerDialog(playerid, DIALOG_LOG, DIALOG_STYLE_PASSWORD,"LOGIN",String,"입력", "취소");
		cache_get_value_name(0, "password", Player[playerid][PWD], 60);
		
		InitializeUserData(playerid); // 한번 초기화 한 후 데이터 불러옴.
		SQL_CALL_LoadUserData(playerid);
		SQL_CALL_LoadUserLocationData(playerid);
		SQL_CALL_LoadUserStatusData(playerid);
		SQL_CALL_LoadUserAccData(playerid);
		SQL_CALL_LoadUserBankData(playerid);
		return 1;
	}
	ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_PASSWORD, "LOGIN_ERROR", "계정 정보가 확인 되지 않습니다. 회원 가입을 위해 비밀번호를 입력하세요.","예","아니오");
	return 1;
}
public DelayedKick(playerid)
{
    Kick(playerid);
    return 1;
}
public CheckPassword(playerid, password[])
{
	if(strcmp(password, Player[playerid][PWD]) == 0)
	{
	    return 0;
	}
	return -1;
}
public ComparePassword(playerid, password[], flag)
{
	if(flag == 0)
	{
		strcpy(Player[playerid][PWD], password, 64);
		return 1;
	}
	if(strcmp(password, Player[playerid][PWD]) == 0)
	{
		return 0;
	}
	return -1;
}
public AddUser(playerid, name[], password[])
{
    new query[128];
    mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM account WHERE id = '%s'", PlayerName(playerid));
	RegisterUserData(playerid);
    mysql_tquery(g_Sql, query, "CheckAccount", "i", playerid);
}
public RegisterUserData(playerid)
{
	new query[512];
	new randPhone = 10000000 + random(89999999); //중복 체크는 반드시 해야 할 거같은데.


	/* USER INITIALIZE CODE */
	Player[playerid][SEX] = 0;
	Player[playerid][SKIN] = 26;
	Player[playerid][TUTORIAL] = 0;
	Player[playerid][YEAR] = 1988;

	
	Player[playerid][INTERIOR] = 0;
	Player[playerid][VIRTUALWORLD] = 0;
	Player[playerid][POS][0] = 1685.5864;
	Player[playerid][POS][1] = -2333.1328;
	Player[playerid][POS][2] = 13.5469;

	Player[playerid][TIME][0] = 0;
	Player[playerid][TIME][1] = 0;
	Player[playerid][TIME][2] = 0;

	Player[playerid][PHONE] = randPhone;
	Player[playerid][MONEY] = 0;
	Player[playerid][HEALTH] = 100.0;
	Player[playerid][ARMOUR] = 0.0;
	Player[playerid][JOB] = 0;
	Player[playerid][ADMIN] = 0;
	Player[playerid][RFREQ] = -1;
	Player[playerid][RFREQ_SOUND] = -1;

	mysql_format(
		g_Sql, 
		query, 
		sizeof(query), 
		"INSERT INTO status (id, health, armour) VALUES ('%s', %f, %f);", 
		PlayerName(playerid),
		Player[playerid][HEALTH],
		Player[playerid][ARMOUR]
	);
	mysql_tquery(g_Sql, query);


	mysql_format(
		g_Sql, 
		query, 
		sizeof(query), 
		"INSERT INTO information (id, sex, skin, tutorial, age, phoneNum, job, frequency, freqSound) VALUES ('%s', %d, %d, %d, %d, %d, %d, %d, %d);", 
		PlayerName(playerid),
		Player[playerid][SEX],
		Player[playerid][SKIN],
		Player[playerid][TUTORIAL],
		Player[playerid][YEAR],
		Player[playerid][PHONE],
		Player[playerid][JOB],
		Player[playerid][RFREQ],
		Player[playerid][RFREQ_SOUND]
	);
	mysql_tquery(g_Sql, query);


	mysql_format(
		g_Sql, 
		query, 
		sizeof(query), 
		"INSERT INTO locationtime (id, interior, virtualworld, posX, posY, posZ, hour, minute, second) VALUES ('%s', %d, %d, %f, %f, %f, %d, %d, %d);", 
		PlayerName(playerid),
		Player[playerid][INTERIOR],
		Player[playerid][VIRTUALWORLD],
		Player[playerid][POS][0],
		Player[playerid][POS][1],
		Player[playerid][POS][2],
		Player[playerid][TIME][0],
		Player[playerid][TIME][1],
		Player[playerid][TIME][2]
	);
	mysql_tquery(g_Sql, query);

	mysql_format(
		g_Sql, 
		query, 
		sizeof(query), 
		"INSERT INTO bank (id, phoneNum, money, account, interest) VALUES ('%s', %d, %d, %d, %d);", 
		PlayerName(playerid),
		Player[playerid][PHONE],
		Player[playerid][MONEY],
		0,
		0
	);
	mysql_tquery(g_Sql, query);
}
public SQL_CALL_LoadUserAccData(playerid)
{
	new query[256];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM `accessories` WHERE id = '%s'AND posX > 0.00001 AND (index_ = 0 OR index_ = 1 OR index_ = 2 OR index_ = 3) IS NOT NULL ORDER BY index_ ASC;"
	,PlayerName(playerid));
	mysql_tquery(g_Sql, query, "LoadUserAccData","i", playerid);
}
public LoadUserAccData(playerid)
{
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "modelid", Player[playerid][ACC_MODEL_ID][i]);
		cache_get_value_name_int(i, "index_", Player[playerid][ACC_INDEX][i]);
		cache_get_value_name_float(i, "posX", Player[playerid][ACC_POS][i][0]);
		cache_get_value_name_float(i, "posY", Player[playerid][ACC_POS][i][1]);
		cache_get_value_name_float(i, "posZ", Player[playerid][ACC_POS][i][2]);
		cache_get_value_name_float(i, "posrX", Player[playerid][ACC_POS][i][3]);
		cache_get_value_name_float(i, "posrY", Player[playerid][ACC_POS][i][4]);
		cache_get_value_name_float(i, "posrZ", Player[playerid][ACC_POS][i][5]);
		cache_get_value_name_float(i, "possX", Player[playerid][ACC_POS][i][6]);
		cache_get_value_name_float(i, "possY", Player[playerid][ACC_POS][i][7]);
		cache_get_value_name_float(i, "possZ", Player[playerid][ACC_POS][i][8]);
	}
	return printf("LoadUserAccData Done!!!!");
}
public SQL_CALL_LoadBuyData()
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM buy;");
	mysql_tquery(g_Sql, query, "LoadBuyData");
}
public SQL_CALL_LoadVehicleData()
{
	new query[128]
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM vehicle;");
	mysql_tquery(g_Sql, query, "LoadVehicleData");
}
public LoadVehicleData()
{
	new name[MAX_PLAYER_NAME];
	new vehicleModel, vehicleColor,vehicleColor2, fuel, vJOB;
	new Float:vehicleX,Float:vehicleY,Float:vehicleZ, Float:vehicleAngle, Float:Health;
	if(cache_num_rows() > 0)
	{
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name(i, "id", name);
			cache_get_value_name_int(i, "vModel", vehicleModel);
			cache_get_value_name_float(i, "vHealth", Health);  
			cache_get_value_name_float(i, "X", vehicleX);  
			cache_get_value_name_float(i, "Y", vehicleY);
			cache_get_value_name_float(i, "Z", vehicleZ);
			cache_get_value_name_float(i, "vAngle", vehicleAngle);
			cache_get_value_name_int(i, "vColor1", vehicleColor);
			cache_get_value_name_int(i, "vColor2", vehicleColor2);
			cache_get_value_name_int(i, "vFuel", fuel);
			cache_get_value_name_int(i, "vJob", vJOB);
			CreateVehicleEx(vehicleModel, Health, vehicleX, vehicleY, vehicleZ, vehicleAngle, fuel, vJOB, vehicleColor, vehicleColor2, name);
		}
	}
	return printf("LoadVehicleData Done!!!!");
}
public LoadBuyData()
{
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "virtualWorld", BUY_PICK[i][BUY_VIRTUAL_WORLD]); 
		cache_get_value_name_float(i, "buyX", BUY_PICK[i][BUY][0]);
		cache_get_value_name_float(i, "buyY", BUY_PICK[i][BUY][1]);
		cache_get_value_name_float(i, "buyZ", BUY_PICK[i][BUY][2]);
		cache_get_value_name_int(i, "buyInt", BUY_PICK[i][BUY_INT]);
		cache_get_value_name_int(i, "feature", BUY_PICK[i][FEATURE]);

		TextPickup("상호 작용을 하려면 ["#C_RED"F"#C_WHITE"]키를 누르세요.", COLOR_WHITE, 1239, 1, BUY_PICK[i][BUY][0], BUY_PICK[i][BUY][1], BUY_PICK[i][BUY][2]+0.2, 5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BUY_PICK[i][BUY_VIRTUAL_WORLD], BUY_PICK[i][BUY_INT]);
	}
	return printf("LoadBuyData Done!!!!");
} 
public SQL_CALL_LoadEnterExitData()
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM `enter/exit`;");
	mysql_tquery(g_Sql, query, "LoadEnterExitData");
}
public LoadEnterExitData()
{
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "enterInt", ENTER_EXIT[i][ENTER_INT]);
		cache_get_value_name_int(i, "virtualWorld", ENTER_EXIT[i][ENTER_VIRTUAL_WORLD]);
		cache_get_value_name_float(i, "enterX", ENTER_EXIT[i][ENTER][0]);
		cache_get_value_name_float(i, "enterY", ENTER_EXIT[i][ENTER][1]);
		cache_get_value_name_float(i, "enterZ", ENTER_EXIT[i][ENTER][2]);

		cache_get_value_name_int(i, "exitInt", ENTER_EXIT[i][EXIT_INT]);
		cache_get_value_name_int(i, "exitVirtual", ENTER_EXIT[i][EXIT_VIRTUAL_WORLD]);
		cache_get_value_name_float(i, "exitX", ENTER_EXIT[i][EXIT][0]);
		cache_get_value_name_float(i, "exitY", ENTER_EXIT[i][EXIT][1]);
		cache_get_value_name_float(i, "exitZ", ENTER_EXIT[i][EXIT][2]);
		cache_get_value_name(i, "comment", ENTER_EXIT[i][COMMENT]);

		TextPickup("퇴장 하려면 ["#C_RED"F"#C_WHITE"]키를 누르세요.", COLOR_WHITE, 1239, 1, ENTER_EXIT[i][ENTER][0], ENTER_EXIT[i][ENTER][1], ENTER_EXIT[i][ENTER][2]+0.3, 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,ENTER_EXIT[i][ENTER_VIRTUAL_WORLD], ENTER_EXIT[i][ENTER_INT]);
		TextPickup("입장 하려면 ["#C_RED"F"#C_WHITE"]키를 누르세요.", COLOR_WHITE, 1239, 1, ENTER_EXIT[i][EXIT][0], ENTER_EXIT[i][EXIT][1], ENTER_EXIT[i][EXIT][2]+0.3, 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ENTER_EXIT[i][EXIT_VIRTUAL_WORLD], ENTER_EXIT[i][EXIT_INT]);
	}
	return printf("LoadEnterExitData Done!!!!");
}
public SQL_CALL_LoadUserStatusData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM status WHERE EXISTS (SELECT * FROM account WHERE status.id = '%s');", PlayerName(playerid));
	if(mysql_tquery(g_Sql, query, "LoadUserStatusData", "d", playerid) == 1)
	{
		return 1;
	}
	return 0;
}
public LoadUserStatusData(playerid)
{
	if(cache_num_rows() > 0){
		cache_get_value_name_float(0, "health", Player[playerid][HEALTH]);
		cache_get_value_name_float(0, "armour", Player[playerid][ARMOUR]);
	}
	return printf("LoadUserStatusData Done!!!!");
}
public SQL_CALL_LoadUserLocationData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM locationtime WHERE EXISTS (SELECT * FROM account WHERE locationtime.id = '%s');", PlayerName(playerid));
	if(mysql_tquery(g_Sql, query, "LoadUserLocationData", "d", playerid) == 1)
	{
		return 1;
	}
	return 0;
}
public LoadUserLocationData(playerid)
{
	if(cache_num_rows() > 0){
		cache_get_value_name_int(0, "interior", Player[playerid][INTERIOR]);
		cache_get_value_name_int(0, "virtualworld", Player[playerid][VIRTUALWORLD]);
		cache_get_value_name_float(0, "posX", Player[playerid][POS][0]);
		cache_get_value_name_float(0, "posY", Player[playerid][POS][1]);
		cache_get_value_name_float(0, "posZ", Player[playerid][POS][2]);
		cache_get_value_name_int(0, "hour", Player[playerid][TIME][0]);
		cache_get_value_name_int(0, "minute", Player[playerid][TIME][1]);
		cache_get_value_name_int(0, "second", Player[playerid][TIME][2]);
	}
	return printf("LoadUserLocationData Done!!!!");
}
public SQL_CALL_LoadUserData(playerid)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM information WHERE EXISTS (SELECT * FROM account WHERE information.id = '%s');", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "LoadUserData", "d", playerid);
}
public LoadUserData(playerid)
{
	if(cache_num_rows() > 0){
		cache_get_value_name_int(0, "tutorial", Player[playerid][TUTORIAL]);
		cache_get_value_name_int(0, "skin", Player[playerid][SKIN]);
		cache_get_value_name_int(0, "sex", Player[playerid][SEX]);
		cache_get_value_name_int(0, "age", Player[playerid][YEAR]);
		cache_get_value_name_int(0, "phoneNum", Player[playerid][PHONE]);
		cache_get_value_name_int(0, "job", Player[playerid][JOB]);
		cache_get_value_name_int(0, "frequency", Player[playerid][RFREQ]);
		cache_get_value_name_int(0, "freqSound", Player[playerid][RFREQ_SOUND]);
		SQL_CALL_LoadPlayerItem(playerid);
	}
	
	return printf("LoadUserData Done!!!!");
}
public SaveUserData(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
		if(Player[playerid][LOGIN] == true)
		{
			new query[256]; // 스킨 같은거 이런거는 딱 한번 바꾸면 되니까 여기서 하지말자.
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			Player[playerid][INTERIOR] = GetPlayerInterior(playerid);
			Player[playerid][VIRTUALWORLD] = GetPlayerVirtualWorld(playerid);
			GetPlayerHealth(playerid, Player[playerid][HEALTH]);
			GetPlayerArmour(playerid, Player[playerid][ARMOUR]);

			Player[playerid][POS][0] = X;
			Player[playerid][POS][1] = Y;
			Player[playerid][POS][2] = Z;

			mysql_format(
				g_Sql, 
				query, 
				sizeof(query), 
				"UPDATE status SET health = %f, armour = %f WHERE id = '%s';",
				Player[playerid][HEALTH],
				Player[playerid][ARMOUR],
				PlayerName(playerid)
			);
			mysql_tquery(g_Sql, query);


			mysql_format(
				g_Sql, 
				query, 
				sizeof(query), 
				"UPDATE bank SET money = %d WHERE id = '%s';",
				Player[playerid][MONEY],
				PlayerName(playerid)
			);
			mysql_tquery(g_Sql, query);

			mysql_format(g_Sql, query, sizeof(query), 
			"UPDATE locationtime SET interior = %d, virtualworld = %d, posX = %f, posY = %f, posZ = %f, hour = %d, minute = %d, second = %d  WHERE id = '%s';",
			Player[playerid][INTERIOR],
			Player[playerid][VIRTUALWORLD],
			Player[playerid][POS][0],
			Player[playerid][POS][1],
			Player[playerid][POS][2], 
			Player[playerid][TIME][0],
			Player[playerid][TIME][1], 
			Player[playerid][TIME][2], 
			PlayerName(playerid));
			mysql_tquery(g_Sql, query);

			if(IsPlayerInAnyVehicle(playerid))
			{
				SaveUserVehicle(playerid, GetPlayerVehicleID(playerid));
				/*KillTimer(GetPVarInt(playerid, "FuelTimer"));
				DeletePVar(playerid, "FuelTimer");*/
			}
			SavePlayerItem(playerid);
		}
	}
}
public LoadActorData()
{
	if(cache_num_rows() > 0)
	{
		new skinNum, Float:X, Float:Y, Float:Z, Float:Angle, attack, vWorld;
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name_int(i, "actorskin", skinNum);
			cache_get_value_name_float(i, "x", X);  
			cache_get_value_name_float(i, "y", Y);  
			cache_get_value_name_float(i, "z", Z);
			cache_get_value_name_float(i, "angle", Angle);
			cache_get_value_name_int(i, "attack", attack);
			cache_get_value_name_int(i, "vworld", vWorld);
			PlayerAddActor(skinNum, X, Y, Z, Angle, vWorld, attack, 0);
		}
	}
	return printf("LoadActorData Done!!!!");
}
public SQL_CALL_LoadActorData()
{
	new query[128]
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM actor;");
	mysql_tquery(g_Sql, query, "LoadActorData");
}        
public SQL_CALL_LoadJobList()
{
	new query[128]
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM joblist ORDER BY joblist.number ASC;");
	mysql_tquery(g_Sql, query, "LoadJobList");
}
public SQL_CALL_LoadUserBankData(playerid)
{
	new query[128]
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM bank where id = '%s';", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "LoadUserBankData", "i", playerid);
}
public LoadUserBankData(playerid)
{
	if(cache_num_rows() > 0)
	{
		cache_get_value_int(0, "money", Player[playerid][MONEY]);
		cache_get_value_int(0, "account", Player[playerid][BANK]);
	}
	PlayerUpdateMoney(playerid);
}
public LoadJobList()
{
	if(cache_num_rows() > 0)
	{
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name(i, "jobname", PlayerJobName[i]);
		}
	}
	return printf("LoadJobList Done!!!!");
}                                                      
public LoadMapIcon()
{
	if(cache_num_rows() > 0)
	{
		new iconNum, Float:X, Float:Y, Float:Z;
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name_int(i, "iconNum", iconNum);
			cache_get_value_name_float(i, "X", X);  
			cache_get_value_name_float(i, "Y", Y);  
			cache_get_value_name_float(i, "Z", Z);
			CreateDynamicMapIcon(X, Y, Z, iconNum, 0, MAPICON_LOCAL);
		}
	}
	return printf("LoadMapIcon Done!!!!");
}
public SaveMapIcon(Float:X, Float:Y, Float:Z, iconNum)
{
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), 
	"INSERT INTO mapicon(iconNum, X, Y, Z) VALUES (%d, %f, %f, %f)", iconNum, X, Y, Z);
	mysql_tquery(g_Sql, query);
	CreateDynamicMapIcon(X, Y, Z, iconNum, 0, MAPICON_LOCAL);
}
public SQL_CALL_LoadMapIcon()
{
	new query[128]
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM mapIcon;");
	mysql_tquery(g_Sql, query, "LoadMapIcon");
}                                            
public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                GetPlayerPos(i, posx, posy, posz);
                tempposx = (oldposx -posx);
                tempposy = (oldposy -posy);
                tempposz = (oldposz -posz);
                if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
                {
                    if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
                    {
                        SendClientMessage(i, col1, string);
                    }
                    else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
                    {
                        SendClientMessage(i, col2, string);
                    }
                    else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
                    {
                        SendClientMessage(i, col3, string);
                    }
                    else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
                    {
                        SendClientMessage(i, col4, string);
                    }
                    else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
                    {
                        SendClientMessage(i, col5, string);
                    }
                }
            }
        }
    }
    return 1;
}
public LoadUserMessage(playerid)
{
	new string[256];
	new tmp[256];
	new index = 0;
	format(tmp, sizeof(tmp), "전화번호       \t\n");
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "sender", Player[playerid][SAVE_NUM][index]);
		if(Player[playerid][SAVE_NUM][index] == Player[playerid][PHONE]) //내가 보낸거면
		{
			cache_get_value_name_int(i, "phoneNum", Player[playerid][SAVE_NUM][index]); // 그때는 받는 애 번호로 바꿔야함.
		}
		for(new j = 0; j < cache_num_rows(); j++)
		{
			if((index !=0) && (Player[playerid][SAVE_NUM][j] == Player[playerid][SAVE_NUM][index]))//이미 중복되는 값이면 건너 뛰어야 함.
			{
				break;
			}
			else 
			{
				format(string, sizeof(string), "%d\n", Player[playerid][SAVE_NUM][index]);
				strcat(tmp, string);
				index = index + 1;
				break;
			}
		}
	}
	ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_MESSAGE_SHOW, DIALOG_STYLE_TABLIST_HEADERS, "메시지 함", tmp, "보기", "나가기");
}
public LoadUserAddress(playerid)
{
	new name[30];
	new string[256];
	new tmp[256];
	format(tmp, sizeof(tmp), "전화번호       \t이름\n");
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "address", Player[playerid][SAVE_NUM][i]); 
		cache_get_value_name(i, "name", name);
		format(string, sizeof(string), "%d\t%s\n",Player[playerid][SAVE_NUM][i], name);
		strcat(tmp, string);
	}
	ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_ADDRESS_SHOW, DIALOG_STYLE_TABLIST_HEADERS, "주소록", tmp, "선택", "나가기");
}
public LoadUserMessageContents(playerid)
{
	new sender[10], phoneNum[10], message[255];
	new string[256];
	new tmp[256];
	format(tmp, sizeof(tmp), "발신자        \t수신자        \t내용\n");
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "sender", sender[i]); 
		cache_get_value_name_int(i, "phoneNum", phoneNum[i]);
		cache_get_value_name(i, "message",message);
		format(string, sizeof(string), "%d\t%d\t%s\n",sender[i],phoneNum[i],message);
		strcat(tmp, string);
	}
	ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_MESSAGE_SHOW_CONTENT, DIALOG_STYLE_TABLIST_HEADERS, "메시지 함", tmp, "보내기", "나가기");
}
public SendMessageUserDialog(playerid)
{	
	new query[128];
	mysql_format(g_Sql, query, sizeof(query), "SELECT phoneNum FROM information WHERE phoneNum = %d", Player[playerid][SAVE_PHONE]);
	mysql_tquery(g_Sql, query, "SendMessageCheckNumber", "i", playerid); // 유저한테 메시지 보내기.
	return 1;
}
public SendMessageCheckNumber(playerid)
{
	if(cache_num_rows() > 0) // 해당하는 번호 찾았으면 
	{
		ShowPlayerDialog(playerid, DIALOG_PLAYER_PHONE_MESSAGE_SEND, DIALOG_STYLE_INPUT, "메시지 전송", "보낼 내용을 입력하세요", "전송", "취소");
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"해당 번호는 없는 번호 이거나 가입하지 않은 번호 입니다.");
		return 0;
	}
}
public SetCreateBuyPick(playerid, feature)
{
	new index;
	new query[256];

	for(new i = 1; i < MAX_PICK; i++)
	{
		if(BUY_PICK[i][BUY_VIRTUAL_WORLD] == 0)
		{
			index = i;
			break;
		}
	}
	BUY_PICK[index][BUY_VIRTUAL_WORLD] = GetPlayerVirtualWorld(playerid);
	BUY_PICK[index][BUY_INT] = GetPlayerInterior(playerid);
	BUY_PICK[index][FEATURE] = feature;
	GetPlayerPos(playerid, BUY_PICK[index][BUY][0], BUY_PICK[index][BUY][1], BUY_PICK[index][BUY][2]);			

	mysql_format(
		g_Sql, 
		query, 
		sizeof(query), 
		"INSERT INTO `buy` (virtualWorld, buyX, buyY, buyZ, feature, buyInt) VALUES (%d, %f, %f, %f, %d, %d);", 
		BUY_PICK[index][BUY_VIRTUAL_WORLD],
		BUY_PICK[index][BUY][0],
		BUY_PICK[index][BUY][1],
		BUY_PICK[index][BUY][2],
		BUY_PICK[index][FEATURE],
		BUY_PICK[index][BUY_INT]);
	mysql_tquery(g_Sql, query);	
	TextPickup("상호 작용을 하려면 ["#C_RED"F"#C_WHITE"]키를 누르세요.", COLOR_WHITE, 1239, 1, BUY_PICK[index][BUY][0], BUY_PICK[index][BUY][1], BUY_PICK[index][BUY][2]+0.2, 5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BUY_PICK[index][BUY_VIRTUAL_WORLD], BUY_PICK[index][BUY_INT]);
	SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"구매 좌표 설정을 완료 하였습니다.");
	
}
public SendPlayerCash(playerid, phoneNumber)
{
	new string[256];
	new userName;
	if(cache_num_rows() > 0) // 해당 번호를 찾을 경우 
	{
		cache_get_value_name_int(0, "phoneNum", Player[playerid][SAVE_PHONE]); 
		cache_get_value_name_int(0, "id", userName);
		format(string, sizeof(string), "SYSTEM) 계좌번호:☏%d, 받는 이:%s에게 얼마를 보내시겠습니까?\n본인에게 입금 할 경우 가지고 있는 현금만 입금 가능합니다.", phoneNumber, userName);
		ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_BANK_INSERT_ACCOUNT, DIALOG_STYLE_INPUT, "bank", string, "입금", "취소");
	}
	else
	{
		format(string, sizeof(string), "SYSTEM) "#C_WHITE"계좌번호:☏%d는 없는 계좌 입니다. 다시 시도 해 주세요.");
		SendClientMessage(playerid, COLOR_RED, string);
	}
}

// Functions

// Create personalized textdraws
//
//  playerid: Player ID
CreatePersonalizedTextdraws(playerid)
{
    if (!(g_playerSpeedometer[playerid][EPSInfo_enabled]))
    {
        for (new i; i < sizeof g_playerTextdraws; i++)
        {
            g_playerSpeedometer[playerid][EPSInfo_textdraws][i] = CreatePlayerTextDraw(playerid, g_playerTextdraws[i][EPTDInfo_x], g_playerTextdraws[i][EPTDInfo_y], g_playerTextdraws[i][EPTDInfo_text]);
            PlayerTextDrawLetterSize(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_letterSizeX], g_playerTextdraws[i][EPTDInfo_letterSizeY]);
            if ((g_playerTextdraws[i][EPTDInfo_textSizeX] != 0.0) || (g_playerTextdraws[i][EPTDInfo_textSizeY] != 0.0))
            {
                PlayerTextDrawTextSize(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_textSizeX], g_playerTextdraws[i][EPTDInfo_textSizeY]);
            }
            PlayerTextDrawAlignment(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_alignment]);
            PlayerTextDrawColor(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_color]);
            PlayerTextDrawSetShadow(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_shadow]);
            PlayerTextDrawSetOutline(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_outline]);
            PlayerTextDrawBackgroundColor(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_backgroundColor]);
            PlayerTextDrawFont(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_font]);
            PlayerTextDrawSetProportional(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_proportional]);
            PlayerTextDrawSetShadow(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i], g_playerTextdraws[i][EPTDInfo_shadow]);
        }
        g_playerSpeedometer[playerid][EPSInfo_enabled] = true;
    }
}

// Destroy personalized textdraws
//
// playerid: Player ID
DestroyPersonalizedTextdraws(playerid)
{
    if (g_playerSpeedometer[playerid][EPSInfo_enabled])
    {
        for (new i; i < sizeof g_playerTextdraws; i++)
        {
            PlayerTextDrawDestroy(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i]);
        }
        g_playerSpeedometer[playerid][EPSInfo_enabled] = false;
    }
}

// Show speedometer
//
//  playerid: Player ID
ShowSpeedometer(playerid)
{
    for (new i; i < sizeof g_playerTextdraws; i++)
    {
        PlayerTextDrawShow(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i]);
    }
    for (new i; i < sizeof g_Speedometer; i++)
    {
        TextDrawShowForPlayer(playerid, g_Speedometer[i]);
    }
}

// Hide speedometer
//
//  playerid: Player ID
HideSpeedometer(playerid)
{
    for (new i; i < sizeof g_playerTextdraws; i++)
    {
        PlayerTextDrawHide(playerid, g_playerSpeedometer[playerid][EPSInfo_textdraws][i]);
    }
    for (new i; i < sizeof g_Speedometer; i++)
    {
        TextDrawHideForPlayer(playerid, g_Speedometer[i]);
    }
}

// Wrap value
//
//  x: Value
//  min: Minimum
//  max: Maximum
//
// Returns wrapped value
Float:Wrap(Float:x, Float:min, Float:max)
{
    new
        Float:ret = x,
        Float:delta = max - min;
    if (delta > 0.0)
    {
        while (ret < min)
        {
            ret += delta;
        }
        while (ret > max)
        {
            ret -= delta;
        }
    }
    else if (delta <= 0.0)
    {
        ret = min;
    }
    return x;
}

// Rotation to forward vector
//
//  angle: Angle in degrees (GTA rotation)
//  x: X (out)
//  y: Y (out)
RotationToForwardVector(Float:angle, &Float:x, &Float:y)
{
    // GTA rotation to radians
    //new Float:phi = ((360.0 - Wrap(angle, 0.0, 360.0)) * 3.14159265) / 180.0;
    new Float:phi = (Wrap(angle, 0.0, 360.0) * 3.14159265) / 180.0;
    x = floatcos(phi) - floatsin(phi);
    y = floatsin(phi) + floatcos(phi);
}

// Normalize vector (2D)
//
//  x: X
//  y: Y
//  resultX: Result X (out)
//  resultY: Result Y (out)
NormalizeVector2(Float:x, Float:y, &Float:resultX, &Float:resultY)
{
    if (IsNullVector2(x, y))
    {
        resultX = 0.0;
        resultY = 0.0;
    }
    else
    {
        new Float:mag = floatsqroot((x * x) + (y * y));
        resultX = x / mag;
        resultY = y / mag;
    }
}

// Is vehicle driving backwards
//
//  vehicleid: Vehicle ID
//
// Returns result
IsVehicleDrivingBackwards(vehicleid)
{
    new ret = false;
    if (IsValidVehicle(vehicleid))
    {
        new v1[EVector3], v2[EVector2], v3[EVector2], Float:rot;
        GetVehicleVelocity(vehicleid, v1[EVector3_x], v1[EVector3_y], v1[EVector3_z]);
        NormalizeVector2(v1[EVector3_x], v1[EVector3_y], v1[EVector3_x], v1[EVector3_y]);
        GetVehicleZAngle(vehicleid, rot);
        RotationToForwardVector(rot, v2[EVector2_x], v2[EVector2_y]);
        v3[EVector2_x] = v1[EVector3_x] + v2[EVector2_x];
        v3[EVector2_y] = v1[EVector3_y] + v2[EVector2_y];
        ret = (((v3[EVector2_x] * v3[EVector2_x]) + (v3[EVector2_y] * v3[EVector2_y])) < 2.0);
    }
    return ret;
}

// Get player any velocity magnitude
//
//  playerid: Player ID
//
// Returns velocity magnitude
Float:GetPlayerAnyVelocityMagnitude(playerid)
{
    new Float:ret = 0.0;
    if (IsPlayerConnected(playerid))
    {
        new v[EVector3];
        if (IsPlayerInAnyVehicle(playerid))
        {
            GetVehicleVelocity(GetPlayerVehicleID(playerid), v[EVector3_x], v[EVector3_y], v[EVector3_z]);
        }
        else
        {
            GetPlayerVelocity(playerid, v[EVector3_x], v[EVector3_y], v[EVector3_z]);
        }
        ret = floatsqroot((v[EVector3_x] * v[EVector3_x]) + (v[EVector3_y] * v[EVector3_y]) + (v[EVector3_z] + v[EVector3_z]));
    }
    return ret;
}
public PlayerKeyEnter(playerid)
{
	for(new i = 0; i < MAX_PICK; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, ENTER_EXIT[i][EXIT][0], ENTER_EXIT[i][EXIT][1], ENTER_EXIT[i][EXIT][2])) // 들어가기
		{
			SetPlayerInterior(playerid, ENTER_EXIT[i][ENTER_INT]);
			SetPlayerVirtualWorld(playerid, ENTER_EXIT[i][ENTER_VIRTUAL_WORLD]);
			
			SetPlayerPos(playerid, ENTER_EXIT[i][ENTER][0], ENTER_EXIT[i][ENTER][1], ENTER_EXIT[i][ENTER][2]);
			SetCameraBehindPlayer(playerid);
			break;
		}
		if(IsPlayerInRangeOfPoint(playerid, 3.0, ENTER_EXIT[i][ENTER][0], ENTER_EXIT[i][ENTER][1], ENTER_EXIT[i][ENTER][2])) //나가기
		{
			SetPlayerInterior(playerid, ENTER_EXIT[i][EXIT_INT]);
			SetPlayerVirtualWorld(playerid, ENTER_EXIT[i][EXIT_VIRTUAL_WORLD]);
			SetPlayerPos(playerid, ENTER_EXIT[i][EXIT][0], ENTER_EXIT[i][EXIT][1], ENTER_EXIT[i][EXIT][2]);
			SetCameraBehindPlayer(playerid);
			break;	
		}
		if(IsPlayerInRangeOfPoint(playerid, 3.0, BUY_PICK[i][BUY][0], BUY_PICK[i][BUY][1], BUY_PICK[i][BUY][2]))
		{
			if(BUY_PICK[i][FEATURE] == 0) // 옷
			{
				ShowClothBuyDialog(playerid);
			}
			if(BUY_PICK[i][FEATURE] == 1) // 은행
			{
				ShowBankDialog(playerid);
			}
			if(BUY_PICK[i][FEATURE] == 2) // 병원
			{
			}
			if(BUY_PICK[i][FEATURE] == 3) // 편의점
			{
				ShowConvDialog(playerid);
			}
			if(BUY_PICK[i][FEATURE] == 4) // 차량 구매/판매
			{
				ShowVehicleDialog(playerid);
			}
			if(BUY_PICK[i][FEATURE] >= 5) // 트럭
			{
				new jobid = BUY_PICK[i][FEATURE] - 4;
				SetPVarInt(playerid, "jobid", jobid);
				ShowUserJobActive(playerid);
			}
			break;
		}
	}
	return 1;
}
public ShowConvDialog(playerid)
{

	new subString[64];
	new string[sizeof(CONV_LIST) * sizeof(subString)];

	format(subString, sizeof(subString), "물건       \t가격\n");
	strcat(string, subString);
	for (new i = 0; i < sizeof(CONV_LIST); i++)
	{
		format(subString, sizeof(subString), "%s\t"#C_GREEN"($%i)\n", 
		CONV_LIST[i][NAME], CONV_LIST[i][PRICE]);
		strcat(string, subString);
	}
	ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOW_CONV, DIALOG_STYLE_TABLIST_HEADERS, "상호작용", string, "구매", "취소");
}
public ShowJobDialog(playerid)
{

	new subString[64];
	new string[sizeof(PlayerJobName) * sizeof(subString)];

	format(subString, sizeof(subString), "직업이름       \t직업번호\n");
	strcat(string, subString);
	for (new i = 0; i < sizeof(PlayerJobName); i++)
	{
		if(strcmp(PlayerJobName[i], "0") == 0)
		{
			break;
		}
		format(subString, sizeof(subString), "%s\t%d\n", PlayerJobName[i], i);
		strcat(string, subString);
	}
	ShowPlayerDialog(playerid, DIALOG_ADMIN_SHOW_JOB_LIST, DIALOG_STYLE_TABLIST_HEADERS, "상호작용", string, "구매", "취소");
}
public TextPickup(string[], color, model, type, Float:X, Float:Y, Float:Z, distance, attachedplayer, attachedvehicle, testlos, vWorld, vInt)
{
	AddStaticPickup(model, type, X, Y, Z, -1);
	CreateDynamic3DTextLabel(string, color, X, Y, Z, distance, attachedplayer, attachedvehicle, testlos,  vWorld, vInt);
	return 1;
}
public PlayerJobStart(playerid)
{
	switch(Player[playerid][JOB])
	{
		case 1:// 트럭기사
		{
			PlayerStartTruckJob(playerid);
		}
		case 6:// 경찰
		{
			PlayerStartPoliceJob(playerid);
		}
		default:
		{
			return 0;
		}
	}
	return 1;
}
public PlayerStartPoliceJob(playerid) // 경찰과 비인가 조직들은 약 30분 마다 한번 씩 일 관련한 문제가 날라와야지 ㅇㅇ
{
	new policeTimer = 0;

	//policeTimer = SetTimerEx(funcname[], interval, repeating, const format[], ...)
	return 0;
}

public PlayerStartTruckJob(playerid)
{
	PlayerPlaySound(playerid, 6401, 0.0,0.0,0.0);
	new vehicleid = random(3);
	new userTrailerid;
	new query[256];
	new truckcheckpoint = 0;
	switch(vehicleid)
	{
		case 0: vehicleid = 403;
		case 1: vehicleid = 514;
		case 2: vehicleid = 515;
	}
	SendClientMessage(playerid, COLOR_YELLOW, "JOB) "#C_WHITE"해당 체크포인트로 이동하여 차량에 탑승 하십시오.");
	SetPlayerCheckpoint(playerid, 2347.7102, -1999.6301, 13.3735, 10);	
	mysql_format(g_Sql, query, sizeof(query), 
	"INSERT INTO vehicle(id, vModel, vHealth, X, Y, Z, vAngle, vFuel, vJob, vColor1, vColor2) VALUES ('%s', %d, 1000, %f,%f,%f,%f, 3600, %d, 0, 0)", 
		CreateVehicleEx(vehicleid, 1000, 2347.7102, -1999.6301, 13.3735, 180.0, 3600, Player[playerid][JOB], 0, 0, PlayerName(playerid)),
		vehicleid, 
		2347.7102, 
		-1999.6301, 
		13.3735, 
		180.0,
		Player[playerid][JOB]
	);
	mysql_tquery(g_Sql, query);
	vehicleid = random(3);
	switch(vehicleid)
	{
		case 0: vehicleid = 435;
		case 1: vehicleid = 450;
		case 2: vehicleid = 584;
	}
	mysql_format(g_Sql, query, sizeof(query), 
	"INSERT INTO vehicle(id, vModel, vHealth, X, Y, Z, vAngle, vFuel, vJob, vColor1, vColor2) VALUES ('%s', %d, 1000, %f,%f,%f,%f, 3600, %d, 0, 0)", 
		CreateVehicleEx(vehicleid, 1000, 1701.8938,998.7264,11.4054, 180.0, 3600, Player[playerid][JOB], 0, 0, PlayerName(playerid)),
		vehicleid, 
		1701.8938, 
		998.7264, 
		11.4054, 
		180.0,
		Player[playerid][JOB]
	);
	mysql_tquery(g_Sql, query);
	userTrailerid = vehicleid;
	SetPVarInt(playerid, "trailerid", userTrailerid);
	SetPVarInt(playerid, "truckcheckpoint", truckcheckpoint);
}

public SetPlayerObjective(playerid, checkpoint)
{
	DisablePlayerCheckpoint(playerid);
	if(Player[playerid][JOB] == 1)
	{
		new userTrailerid = GetPVarInt(playerid, "trailerid");
		if(checkpoint == 0) //직업 할당 받고 일 시작 했다는 뜻이니까
		{
			SendClientMessage(playerid, COLOR_YELLOW, "JOB) "#C_WHITE"해당 체크포인트로 이동하여 물건을 적재 하세요.");
			checkpoint = 1;
			SetPVarInt(playerid, "truckcheckpoint", checkpoint);
			SetPlayerCheckpoint(playerid, 1701.8938,998.7264,11.4054, 10);
			return 1;
		}	
		if(checkpoint == 1) 
		{
			new objective = random(8);
			switch(objective)
			{
				case 0: SetPlayerCheckpoint(playerid, 815.6085,842.8511,10.8846,10);//
				case 1: SetPlayerCheckpoint(playerid, 2866.8516,2573.5354,11.4058,10);//
				case 2:	SetPlayerCheckpoint(playerid, 2353.8301,2778.8669,11.4054,10);//
				case 3: SetPlayerCheckpoint(playerid, -2262.4338,2293.9431,4.5738,10);//
				case 4: SetPlayerCheckpoint(playerid, -1648.7488,1298.8707,6.7774,10);//
				case 5: SetPlayerCheckpoint(playerid, -2054.0454,-861.6914,31.9148,10);//
				case 6: SetPlayerCheckpoint(playerid, -1887.1563,-1717.6616,21.3074,10);//
				case 7: SetPlayerCheckpoint(playerid, -2106.5657,-2416.4255,30.1973,10);//
			}
			//AttachTrailerToVehicle(userTrailerid, GetPlayerVehicleID(playerid));
			SendClientMessage(playerid, COLOR_YELLOW, "JOB) "#C_WHITE"해당 목적지에 배달을 완료 하십시오.");
			checkpoint = 2;
			SetPVarInt(playerid, "truckcheckpoint", checkpoint);
			return 1;
		}
		if(checkpoint == 2)
		{
			
			DestroyVehicleEx(userTrailerid, GetVehicleTrailer(GetPlayerVehicleID(playerid)));
			DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
			DeletePVar(playerid, "trailerid");
			SendClientMessage(playerid, COLOR_YELLOW, "JOB) "#C_WHITE"배달 완료! 해당 체크포인트로 이동하여 차량을 반납하세요.");
			SetPlayerCheckpoint(playerid, 2347.7102, -1999.6301, 13.3735, 10);
			checkpoint = 3;
			SetPVarInt(playerid, "truckcheckpoint", checkpoint);
			return 1;
		}
		if(checkpoint == 3)
		{
			SendClientMessage(playerid, COLOR_YELLOW, "JOB) "#C_WHITE"일을 완료 하였습니다!.");
			DestroyVehicleEx(GetVehicleModel(GetPlayerVehicleID(playerid)), GetPlayerVehicleID(playerid));
			DeletePVar(playerid, "truckcheckpoint");
			return 1;
		}
	}
	return 1;
}
public PlayerAddActor(skinNum, Float:X, Float:Y, Float:Z, Float:Angle, vWorld, attack, flag) //flag == 0 Exists, == 1 new add
{
	new slot = GetActorSlot();
	if(slot == -1)
	{
		return 0;
	}
	slot = CreateActor(skinNum, X, Y, Z, Angle);
	SetActorInvulnerable(slot, attack);
	SetActorVirtualWorld(slot, vWorld);


	ACTOR_DATA[slot][ACTOR_SLOT_USED] = true;
	ACTOR_DATA[slot][ACTOR_VIRTUAL_WORLD] = vWorld;
	ACTOR_DATA[slot][ACTOR_INVULNERABLE] = attack;
	ACTOR_DATA[slot][ACTOR_POS][0] = X;
	ACTOR_DATA[slot][ACTOR_POS][1] = Y;
	ACTOR_DATA[slot][ACTOR_POS][2] = Z;
	ACTOR_DATA[slot][ACTOR_POS][3] = Angle;

	if(flag == 1)
	{
		new query[256];
		mysql_format(g_Sql, query, sizeof(query), 
		"INSERT INTO actor(actorskin, x, y, z, angle, attack, vworld) VALUES (%d, %f, %f, %f, %f, %d, %d)", skinNum, X,Y,Z, Angle, attack, vWorld);
		mysql_tquery(g_Sql, query);
	}
	return 1;
}
public OnPlayerUseItem(playerid,item[])
{

	if(strcmp(item, "무전기") == 0)
	{
		SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" /(r)radio [소리/주파수/할말] (0 ~ 999) 또는 /무전 [소리/주파수/할말] (0 ~ 999)");
		SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" frequency < 0 = Device OFF");
		SendClientMessage(playerid, COLOR_PURPLE, "INFO)"#C_WHITE" sound < 0 = Earphone");
		return 1;
	}
	if(strcmp(item, "담배") == 0)
	{
		new smokeTimer;
		OnPlayerCommandText(playerid, "/me 주머니에서 담배와 라이터를 꺼내 불을 붙힌다.");
		SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"마우스 좌측 클릭을 통해 행동을 진행 합니다. 행동을 종료 하고 싶은 경우 \"F\"키를 누르십시오.");
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_SMOKE_CIGGY);
		smokeTimer = SetTimerEx("PlayerAnimEnd", 30*1000, false, "i", playerid);
		SetPVarInt(playerid, "PlayerSmokeTimer", smokeTimer);
		GivePlayerItem(playerid, item, -1);
		return 1;
	}
	if(strcmp(item, "상점 가판대") == 0) // 프리미엄으로 쓸지 말지 결정.
	{
		
		return 1;
	}
	if(strcmp(item, "술") == 0)
	{
		new drunkTimer;
		OnPlayerCommandText(playerid, "/me 주머니에서 술을 꺼냅니다.");
		SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"마우스 좌측 클릭을 통해 행동을 진행 합니다. 행동을 종료 하고 싶은 경우 \"F\"키를 누르십시오.");
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_BEER);
		drunkTimer = SetTimerEx("PlayerAnimEnd", 30*1000, false, "i", playerid);
		SetPVarInt(playerid, "PlayerDrunkTimer", drunkTimer);
		GivePlayerItem(playerid, item, -1);
		return 1;
	}
	if(strcmp(item, "붐박스/오디오") == 0)
	{
		
		SQL_CALL_LoadUserAudioData(playerid);
		return 1;
	}
	if(strcmp(item, "음료수") == 0)
	{
		new drinkTimer;
		OnPlayerCommandText(playerid, "/me 주머니에서 음료수를 꺼냅니다.");
		SendClientMessage(playerid, COLOR_YELLOW, "SYSTEM) "#C_WHITE"마우스 좌측 클릭을 통해 행동을 진행 합니다. 행동을 종료 하고 싶은 경우 \"F\"키를 누르십시오.");
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
		drinkTimer = SetTimerEx("PlayerAnimEnd", 30*1000, false, "i", playerid);
		SetPVarInt(playerid, "PlayerDrinkTimer", drinkTimer);
		SetPlayerHealth(playerid, Player[playerid][HEALTH]+30);
		GivePlayerItem(playerid, item, -1);
		return 1;
	}
	if(strcmp(item, "주사위") == 0)
	{
		new randomNum = random(6)+1;
		new string[128];
		OnPlayerCommandText(playerid, "/me 주머니에서 주사위를 꺼내 움켜쥐고 흔듭니다.");

		format(string, sizeof(string), "/me 움켜쥔 손을 펴 주사위 값을 가리킵니다. [%d]", randomNum);
		OnPlayerCommandText(playerid, string);
		return 1;
	}
	if(strcmp(item, "초코바") == 0)
	{
		OnPlayerCommandText(playerid, "/me 주머니에서 초코바를 꺼내 먹습니다.");
		SetPlayerHealth(playerid, Player[playerid][HEALTH]+10);
		ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1,0,1,1,1,1 );
		ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1,0,1,1,1,1 );
		GivePlayerItem(playerid, item, -1);
		return 1;
	}
	if(strcmp(item, "포커 카드") == 0)
	{
		new randomNum = random(52)+1;
		new poker[10];
		new str[5];
		new string[128];
		new rand;

		switch(randomNum / 13)
		{
			case 0:
			{
				strcat(poker, "♠ ", sizeof(poker));
			}
			case 1:
			{
				strcat(poker, "♥ ", sizeof(poker));
			}
			case 2:
			{
				strcat(poker, "◆ ", sizeof(poker));
			}
			case 3:
			{
				strcat(poker, "♣ ", sizeof(poker));
			}
		}
		switch(randomNum % 13)
		{
			case 0:
			{
				strcat(poker, "A", sizeof(poker));
			}
			case 1..9:
			{
				valstr(str, rand);
				strcat(poker, str, sizeof(poker));
			}
			case 10:
			{
				strcat(poker, "J", sizeof(poker));
			}
			case 11:
			{
				strcat(poker, "Q", sizeof(poker));
			}
			case 12:
			{
				strcat(poker, "K", sizeof(poker));
			}
		}
		OnPlayerCommandText(playerid, "/me 주머니에서 포커 카드를 꺼내 요란하게 섞습니다.");

		format(string, sizeof(string), "/me 카드를 하나 꺼내 그 값을 가리킵니다. [%s]", poker);
		OnPlayerCommandText(playerid, string);
		return 1;
	}
	return SendClientMessage(playerid, COLOR_RED, "SYSTEM) "#C_WHITE"그런 아이템은 없습니다.");
}
public SendRadioMessage(playerid, color, text[], frequency)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(i == playerid)
			continue;
		if(!IsPlayerConnected(i))
			continue;
		if(frequency != Player[i][RFREQ])
			continue;
		ProxDetector(Player[i][RFREQ_SOUND],i,text,color,color,color,COLOR_FADE4,COLOR_FADE5);
	}
}
public PlayerAnimEnd(playerid)
{
	new smokeTimer = GetPVarInt(playerid, "PlayerSmokeTimer");
	new drunkTimer = GetPVarInt(playerid, "PlayerDrunkTimer");
	new drinkTimer = GetPVarInt(playerid, "PlayerDrinkTimer");
	if(smokeTimer > 0)
	{
		OnPlayerCommandText(playerid, "/me 담배를 바닥에 버린 후 꽁초를 밟는다.");
		ApplyAnimation(playerid,"PED","DAM_LegR_frmBK",4.1,0,1,1,1,1);
		KillTimer(smokeTimer);
		DeletePVar(playerid, "PlayerSmokeTimer");
		return 1;
	}
	if(drunkTimer > 0)
	{
		OnPlayerCommandText(playerid, "/me 술병을 바닥에 버린다.");
		ApplyAnimation(playerid,"PED","DAM_LegR_frmBK",4.1,0,1,1,1,1);
		KillTimer(drunkTimer);
		DeletePVar(playerid, "PlayerDrunkTimer");
		return 1;
	}
	if(drinkTimer > 0)
	{
		OnPlayerCommandText(playerid, "/me 음료수 캔을 바닥에 버린다.");
		ApplyAnimation(playerid,"PED","DAM_LegR_frmBK",4.1,0,1,1,1,1);
		KillTimer(drinkTimer);
		DeletePVar(playerid, "PlayerDrinkTimer");
		return 1;
	}
	return 0;
}
public SQL_CALL_LoadUserAudioData(playerid)
{
	new query[256];
	mysql_format(g_Sql, query, sizeof(query), "SELECT * FROM boombox WHERE id = '%s';", PlayerName(playerid));
	mysql_tquery(g_Sql, query, "LoadAudioInfo");
}
public LoadAudioInfo(playerid)
{
	new tmp[2048];
	new audioString[2048];
	format(audioString, sizeof(audioString), "노래 추가하기\n");
	//strcat(audioString, audioString);
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name(i, "list", tmp);
		format(tmp, sizeof(tmp), "%s\n",tmp);
		strcat(audioString, tmp);
	}
	ShowPlayerDialog(playerid, DIALOG_SHOW_BOOMBOX_LIST, DIALOG_STYLE_LIST, "붐박스", audioString, "듣기", "취소");
}