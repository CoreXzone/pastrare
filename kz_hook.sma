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
	* Nv-Arg Community
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
	* Creative & Yeans	  ( Spain )		Request me the Plugin, So I did :D
												 
===============================================================================R=E=Y=M=O=N==A=R=G=*/
#include <amxmodx>
#include <fakemeta>
#include <kzarg>

#define PLUGIN "Kz Hook Test"
#define VERSION "1.1"
#define AUTHOR "ReymonARG"

new Float:g_hook_speed[33];
new g_changethinks[33][32];
new g_canchenge[33];
new g_hook_color[33];
new g_naturalcolor[33][3];
new bool:hook[33];
new hook_to[33][3];
new hashook[33];
new beamsprite;
new g_item

new darhook[33][32]

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_clcmd("kz_stuffchange", "kz_stuffchange")
	register_clcmd("say /hookmenu", "hook_principal")
	
	register_concmd("+hook","hook_on");
	register_concmd("-hook","hook_off");
	
	g_item = kz_rewards_item_register("Hook", "")
	
	register_clcmd("say /givehook", "set_hook")
}

public plugin_precache()
{
	beamsprite = precache_model("sprites/plasma.spr")
}

public set_hook(id)
{
	kz_adminhook(id, 0)
	
	return PLUGIN_HANDLED
}


stock kz_adminhook(id, page)
{
	if( !kz_get_user_vip(id) )
	{
		kz_set_hud_overtime(id, "Solo Vips Pueden tener Hook")
		return PLUGIN_HANDLED;
	}
	
	new menu = menu_create("\[Kz-Arg] \yGive Hook", "darmenuu")
	new contador = 0	
	darhook[id][0] = 0

	for(new i = 1; i <= 32 ; i++)
	{
		if( is_user_connected(i) )
		{
			contador++
			new mostrarmsg[64], name[32], contadorr[4]
			get_user_name(i, name, 31)
			formatex(mostrarmsg, 63, "\w %s - %s", name, !hashook[i] && !kz_get_user_vip(i) ? "\dOFF" : "\yON")
			num_to_str(contador, contadorr, 3)
			menu_additem(menu, mostrarmsg, contadorr, 0)
			darhook[id][contador] = i
		}
	}
	
	menu_display(id, menu, page)
	
	return PLUGIN_HANDLED;
}
	
public darmenuu(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		return PLUGIN_HANDLED
	}
	
	new data[6], iName[64]
	new access, callback
	
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)
	
	new key = str_to_num(data)
	new LALA = floatround(str_to_float(data)/7.0001, floatround_floor)
	
	new i = darhook[id][key]
	
	hashook[i] = !hashook[i]

	kz_adminhook(id, LALA)
	return PLUGIN_HANDLED
}

public kz_prestartclimb(id)
{
	hashook[id] = false
}

public kz_itemrewardsmenu(id, item ,page)
{
	if( g_item == item )
	{
		hashook[id] = true
		kz_set_hud_overtime(id, "Type /Hookmenu for more Info")
	}
}
	
public client_connect(id)
{
	g_hook_speed[id] = 600.0;
	g_changethinks[id][0] = 0;
	g_canchenge[id] = 0;
	g_hook_color[id] = 0;
	hashook[id] = false;
}

public hook_on(id)
{
	if( !kz_get_user_vip(id) && !hashook[id])
	{
		kz_set_hud_overtime(id, "Solo Vips Pueden tener Hook")
		return PLUGIN_HANDLED;
	}
		
	if( hook[id] )
	{
		return PLUGIN_HANDLED;
	}
	
	set_pev(id, pev_gravity, 0.0);
	set_task(0.1,"hook_prethink",id+10000,"",0,"b");
	hook[id]=true;
	hook_to[id][0]=999999;
	hook_prethink(id+10000);
	return PLUGIN_HANDLED;
}

public hook_principal(id)
{
	new msgspeed[64];
	formatex(msgspeed, 63, "\r[Kz-Arg] \yHook \w- %s", !hashook[id] && !kz_get_user_vip(id) ? "\dOFF" : "\yON");
	new menuhook = menu_create(msgspeed, "principal_hook", 0);
	new msglala[2][64], msgcolor[32];
	formatex(msglala[0], 63, "\wSpeed \yActual Speed: %.1f", g_hook_speed[id]);
	formatex(msgcolor, 31, "%i %i %i", g_naturalcolor[id][0], g_naturalcolor[id][1], g_naturalcolor[id][2]);
	formatex(msglala[1], 63, "\wColor's \yActual Colors: %s", g_hook_color[id] == 0 ? "Random" : msgcolor );
	
	menu_additem(menuhook, msglala[0], "1", 0);
	menu_additem(menuhook, msglala[1], "2", 0);
	
	menu_display(id, menuhook, 0);
	
	return PLUGIN_HANDLED
}

public principal_hook(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new access, callback;
	
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1:
		{
			hook_menu(id);
		}
		case 2:
		{
			hook_menu2(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public hook_menu(id)
{
	new msgspeed[64];
	formatex(msgspeed, 63, "\r[Kz-Arg] Hook \yActual Speed: %.1f", g_hook_speed[id]);
	new menuhook = menu_create(msgspeed, "menu_hook", 0);
	menu_additem(menuhook, "\wManual Edit^n^n\yDefaul's Speed:", "1", 0);
	
	new cuentahook = 1;
	
	for( new i=1; i <= 6; i++ )
	{
		new Float:new_speed = i * 300.0;
		
		new post[5], msg[64];
		cuentahook++;
		formatex(post, 4, "%i", cuentahook);
		
		if( g_hook_speed[id] != new_speed )
		{
			formatex(msg, 63, "\w%.1f", new_speed);
		}
		else
		{
			formatex(msg, 63, "\d%.1f \y(Actual)", new_speed);
		}
			
		menu_additem(menuhook, msg, post, 0);
			
	}
	menu_setprop(menuhook, MPROP_EXITNAME, "\wHook Menu");
	
	menu_display(id, menuhook, 0);
	
}

public menu_hook(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		hook_principal(id);
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new access, callback;
	
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1:
		{
			g_canchenge[id] = 1;
			copy(g_changethinks[id],sizeof(g_changethinks[])-1,"kz_speed_hook");
			client_cmd(id,"messagemode kz_stuffchange");
			hook_menu(id);
		}
		default:
		{
			new Float:change_speed = (key - 1) * 300.0;
			g_hook_speed[id] = change_speed;
			hook_menu(id);
		}
	}
	
	return PLUGIN_HANDLED
}

public hook_menu2(id)
{
	new msgspeed[64];
	new msgcolor[32];
	formatex(msgcolor, 31, "%i %i %i", g_naturalcolor[id][0], g_naturalcolor[id][1], g_naturalcolor[id][2]);
	formatex(msgspeed, 63, "\r[Kz-Arg] Hook \yColors: %s", g_hook_color[id] == 0 ? "Random" : msgcolor );
	new menuhook = menu_create(msgspeed, "menu_hook2", 0);
	
	menu_additem(menuhook, "\wManual Edit^n^n\yDefaul's Colors:", "1", 0);
	menu_additem(menuhook, "\wRandom's Colors", "2", 0);
	menu_additem(menuhook, "\wRed", "3", 0);
	menu_additem(menuhook, "\wBlue", "4", 0);
	menu_additem(menuhook, "\wGreen", "5", 0);
	menu_additem(menuhook, "\wWhite", "6", 0);
	menu_setprop(menuhook, MPROP_EXITNAME, "\wHook Menu");
	
	menu_display(id, menuhook, 0);
	
}

public menu_hook2(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		hook_principal(id);
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new access, callback;
	
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1:
		{
			g_canchenge[id] = 1;
			copy(g_changethinks[id],sizeof(g_changethinks[])-1,"kz_color_hook");
			client_cmd(id,"messagemode kz_stuffchange");
			hook_menu2(id);
		}
		case 2:
		{
			g_hook_color[id] = 0;
			hook_menu2(id);
		}
		case 3:
		{
			g_hook_color[id] = 1;
			g_naturalcolor[id][0] = 255;
			g_naturalcolor[id][1] = 0;
			g_naturalcolor[id][2] = 0;
			hook_menu2(id);
		}
		case 4:
		{
			g_hook_color[id] = 1;
			g_naturalcolor[id][0] = 0;
			g_naturalcolor[id][1] = 0;
			g_naturalcolor[id][2] = 255;
			hook_menu2(id);
		}
		case 5:
		{
			g_hook_color[id] = 1;
			g_naturalcolor[id][0] = 0;
			g_naturalcolor[id][1] = 255;
			g_naturalcolor[id][2] = 0;
			hook_menu2(id);
		}
		case 6:
		{
			g_hook_color[id] = 1;
			g_naturalcolor[id][0] = 255;
			g_naturalcolor[id][1] = 255;
			g_naturalcolor[id][2] = 255;
			hook_menu2(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

/*------------------------------------------------------------------------------------------------*/

public hook_off(id)
{
	set_pev(id, pev_gravity, 1.0);
	hook[id] = false;
	return PLUGIN_HANDLED;
}

public hook_prethink(id)
{
	id -= 10000;
	
	kz_cheat_detection(id, "HooK");
	
	if(!is_user_alive(id))
	{
		hook[id]=false;
	}
	
	if(!hook[id])
	{
		remove_task(id+10000);
		return PLUGIN_HANDLED;
	}


	static origin1[3];
	new Float:origin[3];
	get_user_origin(id,origin1);
	pev(id, pev_origin, origin);

	if(hook_to[id][0]==999999)
	{
		static origin2[3];
		get_user_origin(id,origin2,3);
		hook_to[id][0]=origin2[0];
		hook_to[id][1]=origin2[1];
		hook_to[id][2]=origin2[2];
	}

	//Create blue beam
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY);
	write_byte(1);
	write_short(id);
	write_coord(hook_to[id][0]);
	write_coord(hook_to[id][1]);
	write_coord(hook_to[id][2]);
	write_short(beamsprite);
	write_byte(1);
	write_byte(1);
	write_byte(5);
	write_byte(18);
	write_byte(0);
	if( g_hook_color[id] == 0 )
	{
		write_byte(random(256));
		write_byte(random(256));
		write_byte(random(256));
	}
	else if( g_hook_color[id] == 1 )
	{
		write_byte(g_naturalcolor[id][0]);
		write_byte(g_naturalcolor[id][1]);
		write_byte(g_naturalcolor[id][2]);
	}
	write_byte(200);
	write_byte(0);
	message_end();

	//Calculate Velocity
	static Float:velocity[3];
	velocity[0] = (float(hook_to[id][0]) - float(origin1[0])) * 3.0;
	velocity[1] = (float(hook_to[id][1]) - float(origin1[1])) * 3.0;
	velocity[2] = (float(hook_to[id][2]) - float(origin1[2])) * 3.0;

	static Float:y;
	y = velocity[0]*velocity[0] + velocity[1]*velocity[1] + velocity[2]*velocity[2];

	static Float:x;
	x = (g_hook_speed[id]) / floatsqroot(y);

	velocity[0] *= x;
	velocity[1] *= x;
	velocity[2] *= x;

	set_velo(id,velocity);

	return PLUGIN_CONTINUE;
}

public set_velo(id,Float:velocity[3])
{
	return set_pev(id,pev_velocity,velocity);
}

public kz_stuffchange(id)
{
	if(g_canchenge[id]==0)
	{
		return PLUGIN_CONTINUE;
	}
	
	new Args[256];
	
	read_args(Args,sizeof(Args)-1);
	
	remove_quotes(Args);
	
	if (equali(Args,"!cancel",7) || equali(Args,"",0) )
	{
		//
	}
	else
	{
		if( equali(g_changethinks[id] , "kz_speed_hook", 13) )
		{
			g_hook_speed[id] = str_to_float(Args);
			g_canchenge[id] = 0;
			hook_menu(id);
		}
		
		if( equali(g_changethinks[id] , "kz_color_hook", 13) )
		{
			new colormierda[3][6];
			parse(Args, colormierda[0], 5, colormierda[1], 5, colormierda[2], 5);
			g_naturalcolor[id][0] = str_to_num(colormierda[0]);
			g_naturalcolor[id][1] = str_to_num(colormierda[1]);
			g_naturalcolor[id][2] = str_to_num(colormierda[2]);
			g_canchenge[id] = 0;
			g_hook_color[id] = 1;
			hook_menu2(id);
		}
	}
	
	return PLUGIN_HANDLED;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n{\\ colortbl ;\\ red0\\ green0\\ blue0;}\n\\ viewkind4\\ uc1\\ pard\\ cf1\\ lang3082\\ f0\\ fs16 \n\\ par }
*/
