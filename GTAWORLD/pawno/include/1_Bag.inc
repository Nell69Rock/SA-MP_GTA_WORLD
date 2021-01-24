
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
	new filepath[32],
		ItemCount=_GetSlotCount(playerid);
		
	GetPlayerName(playerid,filepath,24);
	format(filepath,sizeof filepath,"%s.bag",filepath);
	new File:fhnd=fopen(filepath,io_write);
	
	for(new i=0; i<ItemCount; i++)
	{
	    new sz_item[MAX_ITEM_LENGTH+10],
			amount;
		
	    GetSlotItemName(playerid,sz_item,i);
	    amount=GetPlayerItem(playerid,sz_item);
	    
	    format(sz_item,sizeof sz_item,"%s\r\n",sz_item);
		for(new j=0,l=strlen(sz_item); j<l; j++)
		{
			fputchar(fhnd,sz_item[j],false);
		}
		format(sz_item,sizeof sz_item,"%d\r\n",amount);
		fwrite(fhnd,sz_item);
	}
	fclose(fhnd);
	return 1;
}
stock LoadPlayerItem(playerid)
{
	new filepath[32],
		sz_tmp[60],
		sz_tmp2[20];
	GetPlayerName(playerid,filepath,24);
	format(filepath,sizeof filepath,"%s.bag",filepath);
	
	if(fexist(filepath))
	{
	    ResetPlayerItem(playerid);
		new File:fhnd=fopen(filepath,io_read);
		while(fread(fhnd,sz_tmp))
		{
		    sz_tmp[strfind(sz_tmp,"\r")==-1?strlen(sz_tmp):strfind(sz_tmp,"\r")]=EOS;
			(fread(fhnd,sz_tmp2)!=-1)&&
			GivePlayerItem(playerid,sz_tmp,strval(sz_tmp2));
		}
		fclose(fhnd);
	}
	
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
stock GetSlotItemName(playerid,dest[],slot)
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
	ShowPlayerDialog(playerid,DIALOG_INVENTORY_ID,DIALOG_STYLE_LIST,"가방",szString,"사용","취소");
	return ;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid==DIALOG_INVENTORY_ID)
	{
	    if(!response)
		{
	        _GetPage(MAX_ITEM,ViewPage[playerid]-1,PAGE_ITEM)&&ShowPlayerBag(playerid,ViewPage[playerid]-1);
	    }
	    else if(listitem>=1)
	    {
			strdel(inputtext,0,1);
			new itemname[32];
			strmid(itemname,inputtext,0,strfind(inputtext,"\t"),32);
			if(GetPlayerItem(playerid,itemname))
			{
				f_strpack(SelectItem[playerid],itemname);
				ShowPlayerDialog(playerid,DIALOG_INVENTORY_USE_ID,DIALOG_STYLE_LIST,"선택",""#USE_BUTTON_NAME"\n버리기","확인","");
				//return (funcidx("OnPlayerUseItem")!=-1)?CallLocalFunction("OnPlayerUseItem","is",playerid, itemname):1;
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
		    if(strcmp(inputtext,#USE_BUTTON_NAME,false,strlen(#USE_BUTTON_NAME)) ==0)
                (funcidx("OnPlayerUseItem")!=-1)&&CallLocalFunction("OnPlayerUseItem","is",playerid, f_strunpack(SelectItem[playerid])),
				ShowPlayerBag(playerid,ViewPage[playerid]);
			else GivePlayerItem(playerid,f_strunpack(SelectItem[playerid]),-1),
				 ShowPlayerBag(playerid,ViewPage[playerid]);

		}
	}
 	if(!strlen(inputtext)) return (funcidx("Item_OnDialogResponse")!=-1)?CallLocalFunction("Item_OnDialogResponse","iiiis",playerid, dialogid, response, listitem,inputtext[0] = ' ') :1;
	else return (funcidx("Item_OnDialogResponse")!=-1)?CallLocalFunction("Item_OnDialogResponse","iiiis",playerid, dialogid, response, listitem,inputtext) :1;
}

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Item_OnDialogResponse
forward Item_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
forward OnPlayerUseItem(playerid,item[]);

