#include <Wire.h>
#include <math.h>
#include "WiiChuck.h"
//#include "nunchuck_funcs.h"

#define MAXANGLE 90
#define MINANGLE -90

int PinWiiChuckLSW = 12;  // D12 - CONT1
int PinWiiChuckRSW = 13;  // D13 - CONT4

WiiChuck chuck = WiiChuck();
int angleStart, currentAngle;
int tillerStart = 0;
double angle;

void setup() {
  // Activate both WiiChuck
  pinMode(PinWiiChuckLSW, OUTPUT);
  pinMode(PinWiiChuckRSW, OUTPUT);
  digitalWrite(PinWiiChuckLSW, HIGH);
  digitalWrite(PinWiiChuckRSW, HIGH);
  
//  DDRC |= _BV(PC3) | _BV(PC2);  // set ANALOG IN 2, 3 -- OUTPUT
//  PORTC &=~ _BV(PC2);           // set ANALOG IN 2:GND
//  PORTC |=  _BV(PC3);           // set ANALOG IN 3:Vcc
  delay(100);  // wait for things to stabilize
  //nunchuck_init();
  Serial.begin(115200);
  Serial.println("chuck.begin() start");
  chuck.begin();
  Serial.println("chuck.begin() OK");

  // Deactivate left WiiChuck
  digitalWrite(PinWiiChuckLSW, LOW);

  chuck.update();
  Serial.println("chuck.update() OK");
  //chuck.calibrateJoy();
}


void switchWiiChuck(bool sw)
{
  if (sw != false) {
    digitalWrite(PinWiiChuckRSW, LOW);    
    digitalWrite(PinWiiChuckLSW, HIGH);
  }
  else {
    digitalWrite(PinWiiChuckLSW, LOW);
    digitalWrite(PinWiiChuckRSW, HIGH);
  }
}

int counter = 0;
int sw = 0;

void loop() {

  delay(20);
  chuck.update(); 

  // output WiiChuck index
  Serial.print(sw);
  Serial.print(", ");
  
  // output WiiChuck data
  Serial.print(chuck.readRoll());
  Serial.print(", ");  
  Serial.print(chuck.readPitch());
  Serial.print(", ");  

  Serial.print((int)chuck.readAccelX()); 
  Serial.print(", ");  
  Serial.print((int)chuck.readAccelY()); 
  Serial.print(", ");  

  Serial.print((int)chuck.readAccelZ()); 
  Serial.println();

  counter++;
  counter = counter % 5;
  if (counter == 0) {
    sw = (sw == 0) ? 1 : 0;
    switchWiiChuck(sw); 
  }
}
