#include <amxmodx>
#include <amxmisc>
#include <deathrun_stats>
#define PLUGIN "Rozne dzwieki podczas pobicia czasu"
#define VERSION "1.0"
#define AUTHOR "R3X/nTiger"
new const gszSound[][] = {
		"sound/sr/rekord1.mp3",
		"sound/sr/rekord2.mp3",
		"sound/sr/rekord3.mp3"
}
public plugin_precache() {
		register_plugin(PLUGIN, VERSION, AUTHOR);
		for(new i=0; i<sizeof(gszSound); i++)
				precache_generic(gszSound[i]);
}
public fwPlayerFinished(id, iTime, bool:newrecord){
		if(newrecord) {
				client_cmd(0, "mp3 play %s", gszSound[random(sizeof(gszSound))]);
		}
}