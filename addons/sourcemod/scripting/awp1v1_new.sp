#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Awp özel 1v1", 
	author = "ByDexter", 
	description = "awp_lego_2021 haritasına özel 1v1 modu.", 
	version = "1.1", 
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

bool noscope = false;

public void OnPluginStart()
{
	HookEvent("round_start", OnRoundStart);
	HookEvent("player_death", OnClientDead);
}

public Action OnRoundStart(Event event, const char[] name, bool db)
{
	noscope = false;
	BunnyAyarla(false);
	SetCvar("mp_damage_headshot_only", 0);
	return Plugin_Continue;
}

public void OnMapStart()
{
	char filename[256];
	GetPluginFilename(INVALID_HANDLE, filename, sizeof(filename));
	char mapname[32];
	GetCurrentMap(mapname, sizeof(mapname));
	if (strcmp(mapname, "awp_lego_2021", false) != 0)
	{
		ServerCommand("sm plugins unload %s", filename);
	}
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (strcmp(classname, "game_player_equip", false) == 0)
	{
		SDKHook(entity, SDKHook_Spawn, Hook_OnEntitySpawn);
	}
}

public Action Hook_OnEntitySpawn(int entity)
{
	if (!(GetEntProp(entity, Prop_Data, "m_spawnflags") & 1))
	{
		SetEntProp(entity, Prop_Data, "m_spawnflags", GetEntProp(entity, Prop_Data, "m_spawnflags") | 2);
	}
	return Plugin_Continue;
}

public Action OnClientDead(Handle event, const char[] name, bool dontBroadcast)
{
	int Ts = 0, CTs = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i))
		{
			if (GetClientTeam(i) == 2)
				Ts++;
			
			if (GetClientTeam(i) == 3)
				CTs++;
			
			if (Ts >= 2 || CTs >= 2)
				break;
		}
	}
	if (Ts == 1 && CTs == 1)
	{
		PrintToChatAll("[SM] 1v1 \x10başlıyor...");
		CreateTimer(1.0, onevsone, 3, TIMER_FLAG_NO_MAPCHANGE);
		int Sayi = GetRandomInt(1, 6);
		switch (Sayi)
		{
			case 1:
			{
				float BolgeKz[3];
				BolgeKz[0] = StringToFloat("-1664");
				BolgeKz[1] = StringToFloat("128");
				BolgeKz[2] = StringToFloat("-73");
				
				BunnyAyarla(true);
				PrintToChatAll("[SM] \x06Kz 1v1'i \x01başlıyor!");
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsValidClient(i) && IsPlayerAlive(i))
					{
						ClearWeaponEx(i);
						SetClientGod(i, true);
						SetEntitySpeed(i, 0.0);
						BlockEntity(i, false);
						TeleportEntity(i, BolgeKz, NULL_VECTOR, NULL_VECTOR);
					}
				}
			}
			case 2:
			{
				float BolgeBhop[3];
				BolgeBhop[0] = StringToFloat("1924");
				BolgeBhop[1] = StringToFloat("-1076");
				BolgeBhop[2] = StringToFloat("-127");
				
				BunnyAyarla(true);
				PrintToChatAll("[SM] \x06Bhop 1v1'i \x01başlıyor!");
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsValidClient(i) && IsPlayerAlive(i))
					{
						ClearWeaponEx(i);
						SetClientGod(i, true);
						SetEntitySpeed(i, 0.0);
						BlockEntity(i, false);
						TeleportEntity(i, BolgeBhop, NULL_VECTOR, NULL_VECTOR);
					}
				}
			}
			case 3:
			{
				float BolgeCT[3];
				BolgeCT[0] = StringToFloat("30");
				BolgeCT[1] = StringToFloat("-1839");
				BolgeCT[2] = StringToFloat("-95");
				float BolgeT[3];
				BolgeT[0] = StringToFloat("30");
				BolgeT[1] = StringToFloat("-2747");
				BolgeT[2] = StringToFloat("-95");
				
				PrintToChatAll("[SM] \x06Ak47 1v1'i \x01başlıyor!");
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsValidClient(i) && IsPlayerAlive(i))
					{
						ClearWeaponEx(i);
						GivePlayerItem(i, "weapon_ak47");
						GivePlayerItem(i, "weapon_knife");
						SetClientGod(i, true);
						SetEntitySpeed(i, 0.0);
						BlockEntity(i, false);
						if (GetClientTeam(i) == 2)
						{
							TeleportEntity(i, BolgeT, NULL_VECTOR, NULL_VECTOR);
						}
						if (GetClientTeam(i) == 3)
						{
							TeleportEntity(i, BolgeCT, NULL_VECTOR, NULL_VECTOR);
						}
					}
				}
				
			}
			case 4:
			{
				float BolgeCT[3];
				BolgeCT[0] = StringToFloat("30");
				BolgeCT[1] = StringToFloat("-1839");
				BolgeCT[2] = StringToFloat("-95");
				float BolgeT[3];
				BolgeT[0] = StringToFloat("30");
				BolgeT[1] = StringToFloat("-2747");
				BolgeT[2] = StringToFloat("-95");
				
				noscope = true;
				PrintToChatAll("[SM] \x06NoScope 1v1'i \x01başlıyor!");
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsValidClient(i) && IsPlayerAlive(i))
					{
						ClearWeaponEx(i);
						GivePlayerItem(i, "weapon_awp");
						SetClientGod(i, true);
						SetEntitySpeed(i, 0.0);
						BlockEntity(i, false);
						if (GetClientTeam(i) == 2)
						{
							TeleportEntity(i, BolgeT, NULL_VECTOR, NULL_VECTOR);
						}
						if (GetClientTeam(i) == 3)
						{
							TeleportEntity(i, BolgeCT, NULL_VECTOR, NULL_VECTOR);
						}
					}
				}
				
			}
			case 5:
			{
				float BolgeCT[3];
				BolgeCT[0] = StringToFloat("30");
				BolgeCT[1] = StringToFloat("-1839");
				BolgeCT[2] = StringToFloat("-95");
				float BolgeT[3];
				BolgeT[0] = StringToFloat("30");
				BolgeT[1] = StringToFloat("-2747");
				BolgeT[2] = StringToFloat("-95");
				
				PrintToChatAll("[SM] \x06Deagle HS 1v1'i \x01başlıyor!");
				SetCvar("mp_damage_headshot_only", 1);
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsValidClient(i) && IsPlayerAlive(i))
					{
						ClearWeaponEx(i);
						GivePlayerItem(i, "weapon_deagle");
						SetClientGod(i, true);
						SetEntitySpeed(i, 0.0);
						BlockEntity(i, false);
						if (GetClientTeam(i) == 2)
						{
							TeleportEntity(i, BolgeT, NULL_VECTOR, NULL_VECTOR);
						}
						if (GetClientTeam(i) == 3)
						{
							TeleportEntity(i, BolgeCT, NULL_VECTOR, NULL_VECTOR);
						}
					}
				}
				
			}
			case 6:
			{
				float BolgeSurf[3];
				BolgeSurf[0] = StringToFloat("-1249");
				BolgeSurf[1] = StringToFloat("1899");
				BolgeSurf[2] = StringToFloat("254");
				
				BunnyAyarla(true);
				PrintToChatAll("[SM] \x06Surf 1v1'i \x01başlıyor!");
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsValidClient(i) && IsPlayerAlive(i))
					{
						ClearWeaponEx(i);
						SetClientGod(i, true);
						SetEntitySpeed(i, 0.0);
						BlockEntity(i, false);
						TeleportEntity(i, BolgeSurf, NULL_VECTOR, NULL_VECTOR);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action onevsone(Handle timer, int time)
{
	if (time <= 0)
	{
		PrintToChatAll("[SM] 1v1 \x0Fbaşladı.");
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsPlayerAlive(i))
			{
				SetClientGod(i, false);
				SetEntitySpeed(i, 1.0);
				BlockEntity(i, false);
			}
		}
	}
	else
	{
		time--;
		CreateTimer(1.0, onevsone, time, TIMER_FLAG_NO_MAPCHANGE);
		PrintToChatAll("[SM] 1v1'nin başlamasına \x06%d saniye\x01 kaldı.", time);
	}
	return Plugin_Stop;
}

public Action OnPlayerRunCmd(int client, int &buttons)
{
	if (IsValidClient(client) && noscope && buttons & IN_ATTACK2)
	{
		buttons &= ~IN_ATTACK2;
		buttons &= ~IN_ATTACK;
	}
	return Plugin_Continue;
}

void SetEntitySpeed(int entity, float speed = 1.0)
{
	SetEntPropFloat(entity, Prop_Data, "m_flLaggedMovementValue", speed);
}

void BlockEntity(int client, bool solid = true)
{
	if (solid)
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 5);
	else
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 2);
}

void SetClientGod(int client, bool god)
{
	if (god)
		SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
	else
		SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
}

void ClearWeaponEx(int client)
{
	int wepIdx;
	for (int i; i < 13; i++)
	{
		while ((wepIdx = GetPlayerWeaponSlot(client, i)) != -1)
		{
			RemovePlayerItem(client, wepIdx);
			RemoveEntity(wepIdx);
		}
	}
}

void BunnyAyarla(bool Durum)
{
	if (Durum)
	{
		SetCvar("sv_enablebunnyhopping", 1);
		SetCvar("sv_autobunnyhopping", 1);
		SetCvar("sv_airaccelerate", 2000);
		SetCvar("sv_staminajumpcost", 0);
		SetCvar("sv_staminalandcost", 0);
		SetCvar("sv_staminamax", 0);
		SetCvar("sv_staminarecoveryrate", 60);
	}
	else
	{
		SetCvar("sv_enablebunnyhopping", 0);
		SetCvar("sv_autobunnyhopping", 0);
		SetCvar("sv_airaccelerate", 101);
		SetCvarFloat("sv_staminajumpcost", 0.080);
		SetCvarFloat("sv_staminalandcost", 0.050);
		SetCvar("sv_staminamax", 80);
		SetCvar("sv_staminarecoveryrate", 60);
	}
}

void SetCvar(char[] cvarName, int value)
{
	ConVar IntCvar = FindConVar(cvarName);
	if (IntCvar == null)return;
	int flags = IntCvar.Flags;
	flags &= ~FCVAR_NOTIFY;
	IntCvar.Flags = flags;
	IntCvar.IntValue = value;
	flags |= FCVAR_NOTIFY;
	IntCvar.Flags = flags;
}

void SetCvarFloat(char[] cvarName, float value)
{
	ConVar FloatCvar = FindConVar(cvarName);
	if (FloatCvar == null)return;
	int flags = FloatCvar.Flags;
	flags &= ~FCVAR_NOTIFY;
	FloatCvar.Flags = flags;
	FloatCvar.FloatValue = value;
	flags |= FCVAR_NOTIFY;
	FloatCvar.Flags = flags;
}

bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
} 