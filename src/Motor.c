#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>

int main (void)
{
  if (wiringPiSetup() == -1)
    exit (1) ;

  pinMode(1,PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS);
  pwmSetClock(1920);
  pwmSetRange(200);
  
  // SI TOURNE DANS LE MAUVAIS SENS, METTRE (1,10)
  pwmWrite(1,20); //tourne dans un sens
}




FICHIER STOP.C

#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>

int main (void)
{
  printf ("Raspberry Pi wiringPi test program\n") ;

  if (wiringPiSetup() == -1)
    exit (1) ;

  pinMode(1,PWM_OUTPUT);
  pwmWrite(1,0); //stop
}
