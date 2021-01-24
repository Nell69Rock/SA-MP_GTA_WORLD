// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <1_Bag>

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" SquarePants Bag Include example script");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
public OnPlayerConnect(playerid)
{
	LoadPlayerItem(playerid);//플레이어가 접속했을때 저장된 가방을 불러옵니다.
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	SavePlayerItem(playerid);//플레이어가 접속을 끊엇을떄 저장을합니다.
	return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp(cmdtext, "/가방", true) == 0)
	{
        ShowPlayerBag(playerid);//가방 다이어로그를 엽니다.
		return 1;
	}
	if (strcmp(cmdtext,"/알약구매",true) == 0)
	{
		if(GetPlayerMoney(playerid)<=5000)
		{
		    SendClientMessage(playerid,-1,"당신은 돈이 없습니다. 5000원이에요.");
			return 1;
		}
		GivePlayerItem(playerid, "알약",3);//알약 3개를 줌.
		SendClientMessage(playerid,-1,"당신은 알약 3개를 얻었습니다 [/가방]");
	    return 1;
	}
	return 0;
}
public OnPlayerUseItem(playerid,item[])
{
	if(strcmp(item,"알약",true) == 0)
	{
	    new Float:Hp;
	    GetPlayerHealth(playerid,Hp);
	    
	    GivePlayerItem(playerid,"알약",-1);
		SendClientMessage(playerid,-1,"당신은 알약을 사용하였습니다.");

		SetPlayerHealth(playerid,Hp+20);
		return 1;
	}
	return 0;
}







