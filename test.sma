#include <amxmodx>
#include <amxmisc>
#include <sqlx>

new Handle:g_SqlTuple
new g_Cache[512]

public plugin_init()
{
    register_plugin("SQLx Demonstration","1.0","Hawk552")
   
    new Host[64],User[64],Pass[64],Db[64]
    // let's fetch the cvars we will use to connect
    // no pcvars because we're only fetching them once
    get_cvar_string("amx_sql_host",Host,63)
    get_cvar_string("amx_sql_user",User,63)
    get_cvar_string("amx_sql_pass",Pass,63)
    get_cvar_string("amx_sql_db",Db,63)
   
    // we tell the API that this is the information we want to connect to,
    // just not yet. basically it's like storing it in global variables
    g_SqlTuple = SQL_MakeDbTuple(Host,User,Pass,Db)
   
    copy(g_Cache,511,"CREATE TABLE IF NOT EXISTS zomg (you INT(11),are INT(11),a INT(11),noob INT(11))")
    SQL_ThreadQuery(g_SqlTuple,"TableHandle",g_Cache)
}

public TableHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
    // lots of error checking
    if(FailState == TQUERY_CONNECT_FAILED)
        return set_fail_state("Could not connect to SQL database.")
    else if(FailState == TQUERY_QUERY_FAILED)
        return set_fail_state("Query failed.")
   
    if(Errcode)
        return log_amx("Error on query: %s",Error)
       
    SQL_ThreadQuery(g_SqlTuple,"QueryHandle","INSERT INTO zomg VALUES('1','2','3','4')")
    SQL_ThreadQuery(g_SqlTuple,"QueryHandle","INSERT INTO zomg VALUES('4','3','2','1')")
   
    // notice that we didn't free the query - you don't have to
   
    return PLUGIN_CONTINUE
}

public QueryHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
    // lots of error checking
    if(FailState == TQUERY_CONNECT_FAILED)
        return set_fail_state("Could not connect to SQL database.")
    else if(FailState == TQUERY_QUERY_FAILED)
        return set_fail_state("Query failed.")
   
    if(Errcode)
        return log_amx("Error on query: %s",Error)
   
    return PLUGIN_CONTINUE
}

public client_disconnect(id)
    SQL_ThreadQuery(g_SqlTuple,"SelectHandle","SELECT * FROM zomg WHERE you='1' OR you='4'")

public SelectHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
    if(FailState == TQUERY_CONNECT_FAILED)
        return set_fail_state("Could not connect to SQL database.")
    else if(FailState == TQUERY_QUERY_FAILED)
        return set_fail_state("Query failed.")
   
    if(Errcode)
        return log_amx("Error on query: %s",Error)
   
    new DataNum
    while(SQL_MoreResults(Query))
    {
        DataNum = SQL_ReadResult(Query,0)
       
        server_print("zomg, some data: %d",DataNum)
    
        SQL_NextRow(Query)
    }
   
    return PLUGIN_CONTINUE
}

public plugin_end()
    // free the tuple - note that this does not close the connection,
    // since it wasn't connected in the first place
    SQL_FreeHandle(g_SqlTuple)