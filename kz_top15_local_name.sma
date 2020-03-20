/*==================================================================================================

				==================================
				=     Kz-Arg Mod By ReymonARG    =
				==================================
				

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
				Copyright © 2008, ReymonARG
			   This file is provided as is (no warranties)

	Kz-Arg Mod is free software;
	you can redistribute it and/or modify it under the terms of the
	GNU General Public License as published by the Free Software Foundation.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Kz-Arg Mod; if not, write to the
	Free Software Foundation, Inc., 59 Temple Place - Suite 330,
	Boston, MA 02111-1307, USA.
	
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
	
	// Creadits
	* Teame06
	* Kz-Arg Server
	* KzM Servers that I get the Model of de PHP for Top15:D
	* Xtreme-Jumps.eu
	* All persons that help in  AMX Mod X > Scripting
		arkshine, Emp`, danielkza, anakin_cstrike, Exolent[jNr], connorr,
		|PJ| Shorty, stupok, SchlumPF, etc..

	
	// Friends :D
	* Ckx 			( Argentina )		Kz Player
	* ChaosAD 		( Argentina ) 		Kz Player
	* Kunqui 		( Argentina ) 		Kz Player
	* RTK 			( Argentina )		Kz Player
	* BLT 			( Argentina ) 		Kz Player
	* Juann			( Argentina ) 		Scripter
	* Juanchox 		    ( ? ) 		Kz Player
	* Pajaro^		( Argentina )		Kz Player
	* Limado 		( Argentina )		Kz Player
	* Pepo 			( Argentina )		Kz Player
	* Kuliaa		( Argentina )		Kz Player
	* Mucholote		 ( Ecuador )		Kz Player
	* Creative SXJ 		  ( Spain )		Request me the Plugin, So I did :D												 
===============================================================================R=E=Y=M=O=N==A=R=G=*/
#include <amxmodx>
#include <geoip>
#include <kzarg>

#define TOP_VERSION "1.0"

new const KZ_TOP15_DIR[] = "addons/amxmodx/configs/kz/top15"

new g_saytext
new g_maxplayers
new g_item

new Float:Pro_Tiempos[24]
new Pro_AuthIDS[24][32]
new Pro_Names[24][32]
new Pro_Weapons[24][32]
new Pro_Date[24][32]
new Pro_Country[24][3]

new Float:Nub_Tiempos[24]
new Nub_AuthIDS[24][32]
new Nub_Names[24][32]
new Nub_Weapons[24][32]
new Nub_Date[24][32]
new Nub_Country[24][3]
new Nub_GoChecks[24]

//==================================================================================================

new const g_weaponsnames[][] =
{
	"", // NULL
	"p228", "shield", "scout", "hegrenade", "xm1014", "c4",
	"mac10", "aug", "smokegrenade", "elite", "fiveseven",
	"ump45", "sg550", "galil", "famas", "usp", "glock18",
	"awp", "mp5navy", "m249", "m3", "m4a1", "tmp", "g3sg1",
	"flashbang", "deagle", "sg552", "ak47", "knife", "p90"
};

//==================================================================================================

public plugin_init() 
{
	register_plugin("Kz-Arg Local Top15", TOP_VERSION, "ReymonARG");
	
	kz_register_saycmd("top15", "top15menu", -1, "")
	kz_register_saycmd("pro15", "showpro15", -1, "")
	kz_register_saycmd("nub15", "shownub15", -1, "")
	
	g_item = kz_mainmenu_item_register("Top15", "")
	
	g_saytext = get_user_msgid("SayText")
	g_maxplayers = get_maxplayers()
}

//==================================================================================================

public plugin_precache()
{
	if( !dir_exists(KZ_TOP15_DIR) )
		mkdir(KZ_TOP15_DIR);
		
}

public plugin_cfg()
{
	for (new i = 0 ; i < 15; ++i)
	{
		Pro_Tiempos[i] = 999999999.00000;
		Nub_Tiempos[i] = 999999999.00000;
	}
	read_pro15()
	read_nub15()
}

//==================================================================================================

public kz_finishclimb(id, Float:tiempo, checkpoints, gochecks, weapon)
{
	if( gochecks == 0 && (weapon == CSW_USP || weapon == CSW_KNIFE) )
	{
		set_sql_pro15(id, tiempo, weapon)
	}
	else if( weapon == CSW_USP || weapon == CSW_KNIFE || weapon == CSW_SCOUT )
	{
		set_sql_nub15(id, tiempo, gochecks, weapon)
	}
	else
	{
		//Others Weapons Tops
	}
}

public set_sql_pro15(id, Float:tiempo, weapon) 
{
	new authid[32], name[32], nombrearma[32], ip[32], pais[3], horario[32];
	get_user_name(id, name, 31);
	get_user_authid(id, authid, 31);
	get_time(" %m/%d/%Y ", horario, 31);
	get_user_ip(id, ip, 31);
	geoip_code2(ip, pais);
	formatex(nombrearma, 31, g_weaponsnames[weapon])
	new bool:Is_in_pro15
	Is_in_pro15 = false
	
	for(new i = 0; i < 15; i++)
	{
		if( equali(Pro_Names[i], name) )
		{
			Is_in_pro15 = true
		}
	}
	
	for (new i = 0; i < 15; i++)
	{
		new Float:mejorar = tiempo - Pro_Tiempos[i];
		new Float:mejoro = Pro_Tiempos[i] - tiempo;
		new Float:protiempo = Pro_Tiempos[i]
		
		if( tiempo < Pro_Tiempos[i])
		{
			new pos = i
			
			while( !equal(Pro_Names[pos], name) && pos < 15 )
			{
				pos++;
			}
			
			for (new j = pos; j > i; j--)
			{
				formatex(Pro_AuthIDS[j], 31, Pro_AuthIDS[j-1]);
				formatex(Pro_Names[j], 31, Pro_Names[j-1]);
				formatex(Pro_Weapons[j], 31, Pro_Weapons[j-1])
				formatex(Pro_Date[j], 31, Pro_Date[j-1])
				formatex(Pro_Country[j], 3, Pro_Country[j-1])
				Pro_Tiempos[j] = Pro_Tiempos[j-1];
			}
			
			formatex(Pro_AuthIDS[i], 31, authid);
			formatex(Pro_Names[i], 31, name);
			formatex(Pro_Weapons[i], 31, nombrearma)
			formatex(Pro_Date[i], 31, horario)
			formatex(Pro_Country[i], 3, pais)
			Pro_Tiempos[i] = tiempo
			
			//No olvidarse !! Aca poner para que lo Grabe :D
			save_pro15()
			
			if( Is_in_pro15 )
			{

				if( tiempo < protiempo )
				{
					new minutos, Float:segundos;
					minutos = floatround(mejoro, floatround_floor)/60;
					segundos = mejoro - (60*minutos);
					kz_reymon_print(0, "^x03%s^x04 improved his time %02d:%s%.4f", name, minutos, segundos < 10 ? "0" : "", segundos);
					
					if( (i + 1) == 1)
					{
						client_cmd(0, "spk woop");
						kz_reymon_print(0, "CONGRATULATIONS^x03 %s^x04 is the new Leet in Pro15", name);
					}
					else
					{
						kz_reymon_print(0, "^x03%s^x04 new rank in Pro15 is [%i]", name, (i+1));
					}
				}	
			}
			else
			{
				if( (i + 1) == 1)
				{
					client_cmd(0, "spk woop");
					kz_reymon_print(0, "CONGRATULATIONS^x03 %s^x04 is the new Leet in Pro15", name);
				}
				else
				{
					kz_reymon_print(0, "^x03%s^x04 new rank in Pro15 is [%i]", name, (i+1));
				}
			}
			
			return;
		}
		
		if( equali(Pro_Names[i], name) )
		{
			if( tiempo > protiempo )
			{
				new minutos, Float:segundos;
				minutos = floatround(mejorar, floatround_floor)/60; 
				segundos = mejorar - (60*minutos);
				kz_reymon_print(0, "^x03%s^x04 fail his better time by %02d:%s%.5f", name, minutos, segundos < 10 ? "0" : "", segundos);
				return;
			}
		}
	}
}

public save_pro15()
{
	new mapname[33], profile[128]
	get_mapname(mapname, 32)
	formatex(profile, 127, "%s/pro_%s.cfg", KZ_TOP15_DIR, mapname)
	
	if( file_exists(profile) )
	{
		delete_file(profile)
	}
   
	new Data[256];
	new f = fopen(profile, "at")
	
	for(new i = 0; i < 15; i++)
	{
		formatex(Data, 255, "^"%.5f^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^"^n", Pro_Tiempos[i], Pro_AuthIDS[i], Pro_Names[i], Pro_Weapons[i], Pro_Date[i], Pro_Country[i])
		fputs(f, Data)
	}
	fclose(f);
}

public read_pro15()
{
	new mapname[33], profile[128], prodata[256]
	get_mapname(mapname, 32)
	formatex(profile, 127, "%s/pro_%s.cfg", KZ_TOP15_DIR, mapname)
	
	new f = fopen(profile, "rt" )
	new i = 0
	while( !feof(f) && i < 16)
	{
		fgets(f, prodata, 255)
		new totime[25]
		parse(prodata, totime, 24, Pro_AuthIDS[i], 31, Pro_Names[i], 31, Pro_Weapons[i], 31, Pro_Date[i], 31, Pro_Country[i], 3)
		Pro_Tiempos[i] = str_to_float(totime)
		i++;
	}
	fclose(f)
}

//==================================================================================================

public set_sql_nub15(id, Float:tiempo, gochecks, weapon) 
{
	new authid[32], name[32], nombrearma[32], ip[32], pais[3], horario[32];
	get_user_name(id, name, 31);
	get_user_authid(id, authid, 31);
	get_time(" %m/%d/%Y ", horario, 31);
	get_user_ip(id, ip, 31);
	geoip_code2(ip, pais);
	formatex(nombrearma, 31, g_weaponsnames[weapon])
	new bool:Is_in_pro15
	Is_in_pro15 = false
	
	for(new i = 0; i < 15; i++)
	{
		if( equali(Nub_Names[i], name) )
		{
			Is_in_pro15 = true
		}
	}
	
	for (new i = 0; i < 15; i++)
	{
		new Float:mejorar = tiempo - Nub_Tiempos[i];
		new Float:mejoro = Nub_Tiempos[i] - tiempo;
		new Float:protiempo = Nub_Tiempos[i]
		
		if( tiempo < Nub_Tiempos[i])
		{
			new pos = i
			
			while( !equal(Nub_Names[pos], name) && pos < 15 )
			{
				pos++;
			}
			
			for (new j = pos; j > i; j--)
			{
				formatex(Nub_AuthIDS[j], 31, Nub_AuthIDS[j-1]);
				formatex(Nub_Names[j], 31, Nub_Names[j-1]);
				formatex(Nub_Weapons[j], 31, Nub_Weapons[j-1])
				formatex(Nub_Date[j], 31, Nub_Date[j-1])
				formatex(Nub_Country[j], 3, Nub_Country[j-1])
				Nub_Tiempos[j] = Nub_Tiempos[j-1]
				Nub_GoChecks[j] = Nub_GoChecks[j-1]
			}
			
			formatex(Nub_AuthIDS[i], 31, authid);
			formatex(Nub_Names[i], 31, name);
			formatex(Nub_Weapons[i], 31, nombrearma)
			formatex(Nub_Date[i], 31, horario)
			formatex(Nub_Country[i], 3, pais)
			Nub_Tiempos[i] = tiempo
			Nub_GoChecks[i] = gochecks
			
			//No olvidarse !! Aca poner para que lo Grabe :D
			save_nub15()
			
			if( Is_in_pro15 )
			{

				if( tiempo < protiempo )
				{
					new minutos, Float:segundos;
					minutos = floatround(mejoro, floatround_floor)/60;
					segundos = mejoro - (60*minutos);
					kz_reymon_print(0, "^x03%s^x04 improved his time %02d:%s%.4f", name, minutos, segundos < 10 ? "0" : "", segundos);
					
					if( (i + 1) == 1)
					{
						client_cmd(0, "spk woop");
						kz_reymon_print(0, "CONGRATULATIONS^x03 %s^x04 is the new Leet in Nub15", name);
					}
					else
					{
						kz_reymon_print(0, "^x03%s^x04 new rank in Nub15 is [%i]", name, (i+1));
					}
				}	
			}
			else
			{
				if( (i + 1) == 1)
				{
					client_cmd(0, "spk woop");
					kz_reymon_print(0, "CONGRATULATIONS^x03 %s^x04 is the new Leet in Nub15", name);
				}
				else
				{
					kz_reymon_print(0, "^x03%s^x04 new rank in Nub15 is [%i]", name, (i+1));
				}
			}
			
			return;
		}
		
		if( equali(Nub_Names[i], name) )
		{
			if( tiempo > protiempo )
			{
				new minutos, Float:segundos;
				minutos = floatround(mejorar, floatround_floor)/60; 
				segundos = mejorar - (60*minutos);
				kz_reymon_print(0, "^x03%s^x04 fail his better time by %02d:%s%.5f", name, minutos, segundos < 10 ? "0" : "", segundos);
				return;
			}
		}
	}
}

public save_nub15()
{
	new mapname[33], profile[128]
	get_mapname(mapname, 32)
	formatex(profile, 127, "%s/nub_%s.cfg", KZ_TOP15_DIR, mapname)
	
	if( file_exists(profile) )
	{
		delete_file(profile)
	}
   
	new Data[256];
	new f = fopen(profile, "at")
	
	for(new i = 0; i < 15; i++)
	{
		formatex(Data, 255, "^"%.5f^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%i^"^n", Nub_Tiempos[i], Nub_AuthIDS[i], Nub_Names[i], Nub_Weapons[i], Nub_Date[i], Nub_Country[i], Nub_GoChecks[i])
		fputs(f, Data)
	}
	fclose(f);
}

public read_nub15()
{
	new mapname[33], profile[128], prodata[256]
	get_mapname(mapname, 32)
	formatex(profile, 127, "%s/nub_%s.cfg", KZ_TOP15_DIR, mapname)
	
	new f = fopen(profile, "rt" )
	new i = 0
	while( !feof(f) && i < 16)
	{
		fgets(f, prodata, 255)
		new totime[25], checks[5]
		parse(prodata, totime, 24, Nub_AuthIDS[i], 31, Nub_Names[i], 31, Nub_Weapons[i], 31, Nub_Date[i], 31, Nub_Country[i], 3, checks, 4)
		Nub_Tiempos[i] = str_to_float(totime)
		Nub_GoChecks[i] = str_to_num(checks)
		i++;
	}
	fclose(f)
}


//==================================================================================================

public kz_itemmainmenu(id, item, page)
{
	if( item == g_item )
		top15menu(id)
}

public top15menu(id)
{
	new menu = menu_create("\r[Kz-Arg] \yTop15 \w", "top15funccions");
	menu_additem(menu, "\wPro15", "1", 0);
	menu_additem(menu, "\wNub15", "2", 0);
	
	menu_display(id, menu, 0);
	
	return PLUGIN_HANDLED;
}

public top15funccions(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64]
	new iaccess, callback;
	
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback);
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1:
		{
			showpro15(id);
		}
		case 2:
		{
			shownub15(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showpro15(id)
{		
	new buffer[2048], name[32]

	new len = formatex(buffer, 2047, "<body bgcolor=#94AEC6><table width=100%% cellpadding=2 cellspacing=0 border=0>")
	len += formatex(buffer[len], 2047-len, "<tr  align=center bgcolor=#52697B><th width=5%%> # <th width=30%% align=left> Player <th  width=25%%> Time <th width=20%%> Weapon ")
		
	for (new i = 0; i < 15; i++) 
	{	
		name = Pro_Names[i]
		
		if( Pro_Tiempos[i] > 9999999.0 ) 
		{
			len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td align=left> %s <td> %s <td> %s", ((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), "", "", "")
		}
		else
		{
			new minutos, Float:segundos
			minutos = floatround(Pro_Tiempos[i], floatround_floor)/60
			segundos = Pro_Tiempos[i] - (60*minutos)
			
			while (containi(name, "<") != -1)
				replace(name, 63, "<", "&lt;")
			while (containi(name, ">") != -1)
				replace(name, 63, ">", "&gt;")
			len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td align=left> %s <td> %02d:%s%.5f <td> %s", ((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), Pro_Names[i], minutos, segundos < 10 ? "0" : "", segundos, Pro_Weapons[i])
		}
	}
	
	len += formatex(buffer[len], 2047-len, "</table></body>")
		
	show_motd(id, buffer, "Pro15 Climbers")

	return PLUGIN_HANDLED
}

public shownub15(id)
{
	new buffer[2048], name[32]

	new len = formatex(buffer, 2047, "<body bgcolor=#94AEC6><table width=100%% cellpadding=2 cellspacing=0 border=0>")
	len += formatex(buffer[len], 2047-len, "<tr  align=center bgcolor=#52697B><th width=5%%> # <th width=30%% align=left> Player <th  width=25%%> Time <th width=20%%> GoChecks <th width=20%%> Weapon ")
		
	for (new i = 0; i < 15; i++) 
	{		
		if( Nub_Tiempos[i] > 9999999.0 ) 
		{
			len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td align=left> %s <td> %s <td> %s <td> %s", ((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), "", "", "", "")
		}
		else 
		{
			name = Nub_Names[i]
			new minutos, Float:segundos
			minutos = floatround(Nub_Tiempos[i], floatround_floor)/60
			segundos = Nub_Tiempos[i] - (60*minutos)
			
			while (containi(name, "<") != -1)
				replace(name, 63, "<", "&lt;")
			while (containi(name, ">") != -1)
				replace(name, 63, ">", "&gt;")
			len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td align=left> %s <td> %02d:%s%.5f <td> %d <td> %s", ((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), Nub_Names[i], minutos, segundos < 10 ? "0" : "", segundos, Nub_GoChecks[i], Nub_Weapons[i])
		}
	}
	
	len += formatex(buffer[len], 2047-len, "</table></body>")
		
	show_motd(id, buffer, "Nub15 Climbers")

	return PLUGIN_HANDLED
}

//==================================================================================================

stock kz_reymon_print(id, const msg[], {Float,Sql,Result,_}:...)
{
	new message[160], final[192];
	final[0] = 0x04;
	vformat(message, 159, msg, 3);
	formatex(final[1], 188, "[Kz-Arg] %s", message);
	
	if(id)
	{
		kz_print_config(id, final);
	} 
	else 
	{
		for( new i = 1; i <= g_maxplayers; i++)
			if( is_user_connected(i) )
				kz_print_config(i, final)
	}
}

stock kz_print_config(id, const msg[])
{
	message_begin(MSG_ONE_UNRELIABLE, g_saytext, _, id);
	write_byte(id);
	write_string(msg);
	message_end();
}

stock kz_register_saycmd(const saycommand[], const function[], flags, const info[])
{
	new temp[64];
	formatex(temp, 63, "say /%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, "say .%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, "say_team /%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, ".%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, "/%s", saycommand);
	register_clcmd(temp, function, flags, info);
}
