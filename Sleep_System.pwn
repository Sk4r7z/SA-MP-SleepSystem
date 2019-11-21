/*					###########################################
					#										  #
					#  Sleep System - FILTERSCRIPT BY GoKkuU  #
				 	#                       aka Frederico     #
					#                 			              #
					# !Steal my work and you will die virgin! #
					#                                         #
					###########################################
					
//______________________________________________________________________________
* Informations about this Script:

	- 12 in 12 minutes will be increased by 1 point in 'exhaustion' to the player, and at 60 minutes (1 Hour)
	the state of 'exhaustion' of the player will be at his maximum, which will cause the player a need to sleep;
	
	- When the player reach 4 points of weariness the screen blinks as if the eyes want to close;
	
	- When the player makes the sleep command, will stop at a place with a bed and will appear on the same lying.
	
					!!SORRY FOR MY BAD ENGLISH!!
//____________________________________________________________________________*/
#define FILTERSCRIPT
#include <a_samp>
#include <progress>

/*------------------------------[NEW VARIABLES]-------------------------------*/
new SleepLevel[MAX_PLAYERS];
new Bar:SleepBar[MAX_PLAYERS];
new Text:SleepTD;
new Text:SleepScreanTD;
new Sleeping[MAX_PLAYERS];
/*--------------------------------[FORWARDS]----------------------------------*/
forward SleepTimer(playerid);
forward Sleep2(playerid);
forward SleepOutSide(playerid);
forward SleepT3(playerid);
forward SleepTime4(playerid);

//____________________________________________________________________________*/

public OnFilterScriptInit()
{
	print("\n--------------------------------------------");
	print("! Using Sleep System by GoKkuU aka Frederico !");
	print("--------------------------------------------\n");
	
	SetTimer("SleepTimer", 720000, true);//720000 = 12 Minuts
	/*------------------------------------------------------------------------*/
	SleepTD = TextDrawCreate(64.187408, 314.416717, "SLEEP");
	TextDrawLetterSize(SleepTD, 0.336149, 1.279165);
	TextDrawAlignment(SleepTD, 1);
	TextDrawColor(SleepTD, -1);
	TextDrawSetShadow(SleepTD, 0);
	TextDrawSetOutline(SleepTD, 1);
	TextDrawBackgroundColor(SleepTD, 51);
	TextDrawFont(SleepTD, 2);
	TextDrawSetProportional(SleepTD, 1);

	SleepScreanTD = TextDrawCreate(641.531494, 1.500000, "usebox");
	TextDrawLetterSize(SleepScreanTD, 0.000000, 49.396297);
	TextDrawTextSize(SleepScreanTD, -2.000000, 0.000000);
	TextDrawAlignment(SleepScreanTD, 1);
	TextDrawColor(SleepScreanTD, 0);
	TextDrawUseBox(SleepScreanTD, true);
	TextDrawBoxColor(SleepScreanTD, 144);
	TextDrawSetShadow(SleepScreanTD, 0);
	TextDrawSetOutline(SleepScreanTD, 0);
	TextDrawFont(SleepScreanTD, 0);
	return 1;
}

public OnPlayerConnect(playerid)
{
	SleepLevel[playerid] = 0;
    TextDrawShowForPlayer(playerid, SleepTD);
    SleepBar[playerid] = CreateProgressBar(60.000000, 329.000000, 52.500000, 6.199999, 16755455, 5);
    SetProgressBarValue(SleepBar[playerid], SleepLevel[playerid]);
   	ShowProgressBarForPlayer(playerid, SleepBar[playerid]);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(SleepTimer(playerid));
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/sleep", cmdtext, true, 10) == 0)
	{
		if(SleepLevel[playerid] != 0)
		{
			TogglePlayerControllable(playerid, 0);
		    TextDrawShowForPlayer(playerid, SleepScreanTD);
			SetPlayerInterior(playerid, 15);
			SetPlayerPos(playerid,2229.4648,-1161.7744,1030.4410);
			SetPlayerFacingAngle(playerid, -90.0);
			ApplyAnimation(playerid,"CRACK","crckdeth2",4.0, 1, 0, 0, 0, 0);
			SetPlayerCameraPos(playerid, 2231.8608,-1161.0271,1031.3776);
	   		SetPlayerCameraLookAt(playerid,2228.0371,-1161.6714,1029.1803);
	   		GameTextForPlayer(playerid, "~w~Sleeping....", 5000, 1);
	   		Sleeping[playerid] = 1;
	   		SetTimerEx("Sleep2", 12000, false, "i", playerid);
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFFFF, "{FF0000}[{FFFFFF}SleepSystem{FF0000}]{808080} You have no desire to sleep!");
		    return 1;
  		}
		return 1;
	}
	return 0;
}

public SleepTimer(playerid)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	if(IsPlayerConnected(i))
	{
		if(SleepLevel[i] == 5)
		{
		    SendClientMessage(i, 0xFFFFFF, "{00FF00}[{FFFFFF}SleepSystem{00FF00}]{808080} You end up falling asleep because you're too tired!");
    		TogglePlayerControllable(i, 0);
			ApplyAnimation(i,"CRACK","crckdeth2",4.0, 1, 0, 0, 0, 0);
			GameTextForPlayer(i, "~w~Sleeping....", 5000, 1);
	   		SetTimerEx("SleepOutSide", 12000, false, "i", i);
	   		Sleeping[playerid] = 1;
		    return 1;
  		}
  		if(SleepLevel[i] == 4)
		{
			SendClientMessage(i, 0xFFFFFF, "{00FF00}[{FFFFFF}SleepSystem{00FF00}]{808080} You're getting sleepy, go to sleep!");
  		    SleepLevel[i] = 5;
  			SetTimerEx("SleepT3", 600, false, "i", i);
  		    SetProgressBarValue(SleepBar[i], SleepLevel[i]);
  		    UpdateProgressBar(SleepBar[i], i);
  		}
  		else
  		{
  		    SleepLevel[i] += 1;
  		    SetProgressBarValue(SleepBar[i], SleepLevel[i]);
  		    UpdateProgressBar(SleepBar[i], i);
  		    }
		}
	}
	return 1;
}

public Sleep2(playerid)
{
	TextDrawHideForPlayer(playerid, SleepScreanTD);
	SleepLevel[playerid] = 0;
	SetProgressBarValue(SleepBar[playerid], SleepLevel[playerid]);
	UpdateProgressBar(SleepBar[playerid], playerid);
	TogglePlayerControllable(playerid, 1);
	Sleeping[playerid] = 0;
	SpawnPlayer(playerid);
	SendClientMessage(playerid, 0xFFFFFF, "{00FF00}[{FFFFFF}SleepSystem{00FF00}]{808080} You just woke up, Is like you are born again!");
	return 1;
}

public SleepOutSide(playerid)
{
	TextDrawHideForPlayer(playerid, SleepScreanTD);
	SleepLevel[playerid] = 3;
	SetProgressBarValue(SleepBar[playerid], SleepLevel[playerid]);
	UpdateProgressBar(SleepBar[playerid], playerid);
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	ClearAnimations(playerid);
	Sleeping[playerid] = 0;
	SendClientMessage(playerid, 0xFFFFFF, "{00FF00}[{FFFFFF}SleepSystem{00FF00}]{808080} You just woke up, but you still feel very tired!");
	return 1;
}

public SleepT3(playerid)
{
	if(SleepLevel[playerid] >= 4)
	{
		if(Sleeping[playerid] == 0)
		{
			TextDrawShowForPlayer(playerid, SleepScreanTD);
		 	SetTimerEx("SleepTime4", 1000, false, "i", playerid);
	 	}
 	}
 	return 1;
}

public SleepTime4(playerid)
{
	if(Sleeping[playerid] == 0)
	{
	    TextDrawHideForPlayer(playerid, SleepScreanTD);
	    SetTimerEx("SleepT3", 1000, false, "i", playerid);
    }
    return 1;
}
