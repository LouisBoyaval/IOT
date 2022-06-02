//
// Created by louis on 24/05/22.
//
#include "stdio.h"
#include "mysql/mysql.h"

#ifndef IOT_DB_CONNECTOR_H
#define IOT_DB_CONNECTOR_H
#endif //IOT_DB_CONNECTOR_H

MYSQL * DB_connect(char* addr, char* user, char* password, char* database){
    MYSQL *con = mysql_init(NULL);
    if (con == NULL)
    {
        fprintf(stderr, "%s\n", mysql_error(con));
        exit(1);
    }

    if (mysql_real_connect(con, addr, user, password, database, 0, NULL, 0) == NULL)
    {
        fprintf(stderr, "%s\n", mysql_error(con));
        mysql_close(con);
        exit(1);
    }
    return con;
}

MYSQL_RES * DB_sendQuery(MYSQL *con, char* query){
    mysql_query(con, query);
    return mysql_store_result(con);

}

void DB_close(MYSQL *con){
    mysql_close(con);
}



