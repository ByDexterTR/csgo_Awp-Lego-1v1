// include //
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <multicolors>

// pragma //
#pragma semicolon 1
#pragma newdecls required

// int //
int Sayi;
int m_flNextSecondaryAttack = -1;
int g_Offset_CollisionGroup = -1;

// Handle //
Handle bCvarPluginEnabled;

// define //
#define DEBUG
#define PLUGIN_AUTHOR "ByDexter"
#define PLUGIN_VERSION "1.0"

// myinfo //
public Plugin myinfo = 
{
	name = "Awp özel 1v1",
	author = PLUGIN_AUTHOR,
	description = "awp_lego_2021 haritasına özel 1v1 modu.",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnPluginStart()
{
	g_Offset_CollisionGroup = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
	HookConVarChange(bCvarPluginEnabled = CreateConVar("spy_bunny1v1", "0", "Bunny enabled", FCVAR_DONTRECORD, true, 0.0, true, 1.0), OnConVarChanged);
	HookEvent("player_spawn", Control_Spawn, EventHookMode_PostNoCopy);
	HookEvent("player_death", Control_Dead, EventHookMode_PostNoCopy);
	HookEvent("round_end", Control_REnd, EventHookMode_PostNoCopy);
	HookEvent("round_start", Control_RStart, EventHookMode_PostNoCopy);
}

public void OnAutoConfigsBuffered()
{
    CreateTimer(3.0, awpcontrol);
}

public void OnConVarChanged(Handle hConvar, const char[] chOldValue, const char[] chNewValue)
{
	UpdateConVars();
}

public void UpdateConVars()
{
	if (GetConVarBool(bCvarPluginEnabled))
	{
		SetConVarInt(FindConVar("sv_enablebunnyhopping"), 1);
		SetConVarInt(FindConVar("sv_autobunnyhopping"), 1);
		SetConVarInt(FindConVar("sv_airaccelerate"), 2000);
		SetConVarInt(FindConVar("sv_staminajumpcost"), 0);
		SetConVarInt(FindConVar("sv_staminalandcost"), 0);
		SetConVarInt(FindConVar("sv_staminamax"), 0);
	}
	else
	{
		SetConVarInt(FindConVar("sv_enablebunnyhopping"), 0);
		SetConVarInt(FindConVar("sv_autobunnyhopping"), 0);
		SetConVarInt(FindConVar("sv_airaccelerate"), 12);
		SetConVarFloat(FindConVar("sv_staminajumpcost"), 0.080);
		SetConVarFloat(FindConVar("sv_staminalandcost"), 0.050);
		SetConVarInt(FindConVar("sv_staminamax"), 80);
	}
}

public void OnEntityCreated(int entity, const char[] classname) 
{
	if(StrEqual(classname, "game_player_equip", false))
	{
		SDKHook(entity, SDKHook_Spawn, Hook_OnEntitySpawn);
	}
}

public Action Hook_OnEntitySpawn(int entity) 
{
	if(!(GetEntProp(entity, Prop_Data, "m_spawnflags")&1)) 
	{
		SetEntProp(entity, Prop_Data, "m_spawnflags", GetEntProp(entity, Prop_Data, "m_spawnflags")|2);
	}
	return Plugin_Continue;
}

public Action OnPreThink(int client)
{
	SetNoScope(GetPlayerWeaponSlot(client, 0));
}

void SetNoScope(int weapon)
{
	if (IsValidEdict(weapon))
	{
		char classname[MAX_NAME_LENGTH];
		if (GetEdictClassname(weapon, classname, sizeof(classname))
			 || StrEqual(classname[7], "ssg08") || StrEqual(classname[7], "aug")
			 || StrEqual(classname[7], "sg550") || StrEqual(classname[7], "sg552")
			 || StrEqual(classname[7], "sg556") || StrEqual(classname[7], "awp")
			 || StrEqual(classname[7], "scar20") || StrEqual(classname[7], "g3sg1"))
		{
			SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 1.0);
		}
	}
}

void SilahlariSil(int client)
{
	for(int j = 0; j < 5; j++)
	{
		int weapon = GetPlayerWeaponSlot(client, j);
		if(weapon != -1)
		{
			RemovePlayerItem(client, weapon);
			RemoveEdict(weapon);						
		}
	}
}

void SetCvar(char cvarName[64], int value)
{
	Handle IntCvar = FindConVar(cvarName);
	if (IntCvar)
	{
		int flags = GetConVarFlags(IntCvar);
		flags &= ~FCVAR_NOTIFY;
		SetConVarFlags(IntCvar, flags);
		SetConVarInt(IntCvar, value, false, false);
		flags |= FCVAR_NOTIFY;
		SetConVarFlags(IntCvar, flags);
	}
}

stock void UnblockEntity(int client, int cachedOffset)
{
	SetEntData(client, cachedOffset, 2, 4, true);
}

public Action Control_Spawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	UnblockEntity(client, g_Offset_CollisionGroup);
}

public Action Control_Dead(Handle event, const char[] name, bool dontBroadcast)
{
	Sayi = 0;
	Sayi = GetRandomInt(1, 6);
	int	T_Sayisi = 0;
	int CT_Sayisi = 0;
	for (int i = 1; i <= MaxClients; i++) 
	if(IsClientInGame(i) && IsPlayerAlive(i))
	{
		if(GetClientTeam(i) == CS_TEAM_T)
		{
			T_Sayisi++;
		}
		if(GetClientTeam(i) == CS_TEAM_CT)
		{
			CT_Sayisi++;		
		}
		if(IsPlayerAlive(i) && T_Sayisi == 1 && CT_Sayisi == 1)
		{
			CreateTimer(0.1, onevsone, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action Control_RStart(Handle event, const char[] name, bool dontBroadcast)
{
	int	T_Sayisi = 0;
	int CT_Sayisi = 0;
	for (int i = 1; i <= MaxClients; i++) 
	if(IsClientInGame(i) && IsPlayerAlive(i))
	{
		if(GetClientTeam(i) == CS_TEAM_T)
		{
			T_Sayisi++;
		}
		if(GetClientTeam(i) == CS_TEAM_CT)
		{
			CT_Sayisi++;		
		}
		if(IsPlayerAlive(i) && T_Sayisi == 1 && CT_Sayisi == 1)
		{
			CreateTimer(0.1, onevsone, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action onevsone(Handle Timer)
{
	for (int i = 1; i <= MaxClients; i++)
	if(IsPlayerAlive(i))
	{
	float BolgeCT[3];
	BolgeCT[0] = StringToFloat("30");
	BolgeCT[1] = StringToFloat("-1839");
	BolgeCT[2] = StringToFloat("-95");
	float BolgeT[3];
	BolgeT[0] = StringToFloat("30");
	BolgeT[1] = StringToFloat("-2747");
	BolgeT[2] = StringToFloat("-95");
	float BolgeKz[3];
	BolgeKz[0] = StringToFloat("-1664");
	BolgeKz[1] = StringToFloat("128");
	BolgeKz[2] = StringToFloat("-73");
	float BolgeBhop[3];
	BolgeBhop[0] = StringToFloat("1924");
	BolgeBhop[1] = StringToFloat("-1076");
	BolgeBhop[2] = StringToFloat("-127");
	float BolgeSurf[3];
	BolgeSurf[0] = StringToFloat("-1249");
	BolgeSurf[1] = StringToFloat("1899");
	BolgeSurf[2] = StringToFloat("254");
	SilahlariSil(i);
	if(Sayi == 1)
	{
		SetCvar("spy_bunny1v1", 1);
		CPrintToChatAll("{darkblue}> {green}Kz 1v1'i {default}başlıyor!");
		TeleportEntity(i, BolgeKz, NULL_VECTOR, NULL_VECTOR);
	}
	else
	if(Sayi == 2)
	{
		SetCvar("spy_bunny1v1", 1);
		CPrintToChatAll("{darkblue}> {green}Bhop 1v1'i {default}başlıyor!");
		TeleportEntity(i, BolgeBhop, NULL_VECTOR, NULL_VECTOR);
	}
	else
	if(Sayi == 3)
	{
		CPrintToChatAll("{darkblue}> {green}Aim 1v1'i {default}başlıyor!");
		GivePlayerItem(i, "weapon_ak47");
		GivePlayerItem(i, "weapon_knife");
		if (GetClientTeam(i) == CS_TEAM_T)
		{
			TeleportEntity(i, BolgeT, NULL_VECTOR, NULL_VECTOR);
		}
		if (GetClientTeam(i) == CS_TEAM_CT)
		{
			TeleportEntity(i, BolgeCT, NULL_VECTOR, NULL_VECTOR);
		}
	}
	else
	if(Sayi == 4)
	{
		CPrintToChatAll("{darkblue}> {green}NoScope 1v1'i {default}başlıyor!");
		SDKHook(i, SDKHook_PreThink, OnPreThink);
		GivePlayerItem(i, "weapon_awp");
		if(GetClientTeam(i) == CS_TEAM_T)
		{
			TeleportEntity(i, BolgeT, NULL_VECTOR, NULL_VECTOR);
		}
		if(GetClientTeam(i) == CS_TEAM_CT)
		{
			TeleportEntity(i, BolgeCT, NULL_VECTOR, NULL_VECTOR);
		}
	}
	else
	if(Sayi == 5)
	{
		CPrintToChatAll("{darkblue}> {green}Deagle HS 1v1'i {default}başlıyor!");
		SetCvar("mp_damage_headshot_only", 1);
		GivePlayerItem(i, "weapon_deagle");
		if(GetClientTeam(i) == CS_TEAM_T)
		{
			TeleportEntity(i, BolgeT, NULL_VECTOR, NULL_VECTOR);
		}
		if(GetClientTeam(i) == CS_TEAM_CT)
		{
			TeleportEntity(i, BolgeCT, NULL_VECTOR, NULL_VECTOR);
		}
	}
	else
	if(Sayi == 6)
	{
		SetCvar("spy_bunny1v1", 1);
		CPrintToChatAll("{darkblue}> {green}Surf 1v1'i {default}başlıyor!");
		TeleportEntity(i, BolgeSurf, NULL_VECTOR, NULL_VECTOR);
	}
	}
}

public Action Control_REnd(Handle event, const char[] name, bool dontBroadcast)
{
	SetCvar("spy_bunny1v1", 0);
	SetCvar("mp_damage_headshot_only", 0);
	for (int i = 1; i <= MaxClients; i++) 
	if(IsClientInGame(i) && IsPlayerAlive(i))
	{
		SDKUnhook(i, SDKHook_PreThink, OnPreThink);
	}
}

public Action awpcontrol(Handle timer)
{
    char filename[512];
    GetPluginFilename(INVALID_HANDLE, filename, sizeof(filename));
    char mapname[PLATFORM_MAX_PATH];
    GetCurrentMap(mapname, sizeof(mapname));
    if (StrContains(mapname, "awp_lego_2021", false) == -1)
    {
        ServerCommand("sm plugins unload %s", filename);
    }
    return Plugin_Stop;
}