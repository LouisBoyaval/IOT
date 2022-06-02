#include <stdio.h>
#include <errno.h>
#include <string.h>

#include <wiringPi.h>
#include <softServo.h>
#include "../header/DB_connector.h"

int main ()
{
    int idAnimal;
    DB_sendQuery("SELECT quantite FROM Repas WHERE idAnimal =");
}