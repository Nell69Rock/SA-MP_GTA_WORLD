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
	LoadPlayerItem(playerid);//�÷��̾ ���������� ����� ������ �ҷ��ɴϴ�.
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	SavePlayerItem(playerid);//�÷��̾ ������ �������� �������մϴ�.
	return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp(cmdtext, "/����", true) == 0)
	{
        ShowPlayerBag(playerid);//���� ���̾�α׸� ���ϴ�.
		return 1;
	}
	if (strcmp(cmdtext,"/�˾౸��",true) == 0)
	{
		if(GetPlayerMoney(playerid)<=5000)
		{
		    SendClientMessage(playerid,-1,"����� ���� �����ϴ�. 5000���̿���.");
			return 1;
		}
		GivePlayerItem(playerid, "�˾�",3);//�˾� 3���� ��.
		SendClientMessage(playerid,-1,"����� �˾� 3���� ������ϴ� [/����]");
	    return 1;
	}
	return 0;
}
public OnPlayerUseItem(playerid,item[])
{
	if(strcmp(item,"�˾�",true) == 0)
	{
	    new Float:Hp;
	    GetPlayerHealth(playerid,Hp);
	    
	    GivePlayerItem(playerid,"�˾�",-1);
		SendClientMessage(playerid,-1,"����� �˾��� ����Ͽ����ϴ�.");

		SetPlayerHealth(playerid,Hp+20);
		return 1;
	}
	return 0;
}







