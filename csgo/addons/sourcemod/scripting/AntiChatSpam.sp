#include <sourcemod>

ConVar chatCooldown;
ConVar adminsImmune;

int lastUsedCommand[MAXPLAYERS + 1];

public Plugin myinfo =
{
	name = "Anti Chat Spam",
	author = "Diam0ndz",
	description = "Prevents players from spamming chat",
	version = "1.0",
	url = ""
};

public void OnPluginStart()
{
	chatCooldown = CreateConVar("sm_chatcooldown", "3", "The chat cooldown in seconds");
	adminsImmune = CreateConVar("sm_chatcooldownadminsimmune", "1", "Set if admins are immune to the chat cooldown");
	HookEvent("player_chat", Event_OnPlayerChat, EventHookMode_Pre);
}

public Action Event_OnPlayerChat(Event event, const char[] name, bool dontBroadcast)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);

	if(GetConVarBool(adminsImmune))
	{
		if(GetUserAdmin(client) != INVALID_ADMIN_ID)
		{
			return Plugin_Continue;
		}
	}

	char message[250];
	event.GetString("text", message, sizeof(message));

	int time = GetTime();
	if(time - lastUsedCommand[client] < chatCooldown.IntValue)
	{
		PrintToChat(client, " \x04You are sending messages too fast! Please wait \x02%i \x04second(s) before sending another message.", chatCooldown.IntValue - (time - lastUsedCommand[client]));
		return Plugin_Handled;
	}else
	{
		lastUsedCommand[client] = time;
		return Plugin_Continue;
	}
}
