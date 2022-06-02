#include <stdio.h>
#include "../header/DB_connector.h"

int main() {
    MYSQL *con = DB_connect("localhost", "root", "root", "datadistributeur");
    DB_sendQuery(con, "INSERT INTO Annimaux (nom) VALUES ('test');");
    MYSQL_RES *res = DB_sendQuery(con, "SELECT * FROM Annimaux;");

    int num_fields = mysql_num_fields(res);

    MYSQL_ROW row;
    while ((row = mysql_fetch_row(res)))
    {
        for(int i = 0; i < num_fields; i++)
        {
            printf("%s ", row[i] ? row[i] : "NULL");
        }
        printf("\n");
    }
    mysql_free_result(res);
    DB_close(con);
}
