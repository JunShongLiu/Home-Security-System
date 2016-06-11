#include <Servo.h>
#include "DHT.h"

/***********************************
* Global Variables
************************************/

int incomingByte;
int disable_flag = 1;

int temperatureSensor;

int sirens = 0;
int Alarm=0;

int Intruder = 0;

//Motion Sensor
int calibrationTime = 30;
int motionSensor = 3;
int Motion_flag = 1;


/*************************************
* Pin Declaration
************************************/

// pins for led pins
int ledPin = 13;
int redLed = 10;
int blueLed = 12;
int greenLed = 11;

int buzzpin = 5;


//Temperature Sensor
#define DHTPIN 9
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// Servo
int position = 90;
#define SERVO 6
#define LEFT 5
#define RIGHT 5
#define FORWARD 90
Servo myservo ; //create servo object

void setup() {
  Serial.begin(9600);

  pinMode(buzzpin, OUTPUT) ;
  pinMode(motionSensor, INPUT);
  pinMode(ledPin, OUTPUT);

  pinMode(redLed, OUTPUT);
  pinMode(blueLed, OUTPUT);
  pinMode(greenLed, OUTPUT);

  //have leds display red to indicate still calibrating
  digitalWrite(greenLed, HIGH);
  digitalWrite(blueLed, HIGH);
  digitalWrite(redLed, LOW);

  //Initialize Temp Sensor:
  dht.begin();

  //initialize Servo
  myservo.attach(SERVO) ;
  myservo.write(FORWARD);         //turn the servo to face in the forward direction

  //Allow Motion Sensor Calibrate
  for(int i=0;i<calibrationTime;i++){
    delay(1000);
  }
  //Signal that Motion sensor is ready
  GreenLights();
}

void loop(){

  float t = dht.readTemperature();
  
  int MotionDetected = MotionSensor();

  if(MotionDetected==1){      // if motion detected, alarm should go off
    Alarm=1;
  }
  alarm(Alarm) ;
  SerialRead();
  delay(250);
}

/***********************************************************************************
 * Used the MotionSensor hardware to detect motion. Returns 1 if motion is detected.
 * Returns 0 if motion was not or if the alarm is already off
 **********************************************************************************/
int MotionSensor(){

  //If motion was detected, then there is no need to set alarm to 1 as the alarm is going off. Therefore we set a disable flag to zero when motion is detected and we set the disable flag
  //back to 1 when the alarm is turned off.
  if(disable_flag){
    return 0;
  }
  //If motionSensor was triggered, then returns 1
  if(digitalRead(motionSensor)==HIGH){
      return 1;
  }
  //If motionSensor was not triggered, then returns 0
  if(digitalRead(motionSensor)==LOW){
    return 0;
  }
  delay(50);
}

/**********************************************
* This function triggers the alarm and turns on the
* LEDs when motion is detected
************************************************/
void alarm(int motion){
  if(motion == 1){
      analogWrite(buzzpin, 10); // buzzer goes off
      digitalWrite(blueLed, LOW);
      digitalWrite(redLed, HIGH);
      digitalWrite(greenLed, HIGH);
      delay(500);
      analogWrite(buzzpin,0);
      digitalWrite(blueLed,HIGH);
      digitalWrite(redLed, LOW);
      digitalWrite(greenLed, HIGH);
      delay(500);
      if(Motion_flag == 1){
        Serial.println("S");        // write to serial monitor to send notification to web
        Motion_flag = 0;            // set Motion_flag to zero so that even though motion may be detected, it doesn't send another "s" to the web
        disable_flag = 0;
      }
  }
  else {
      analogWrite(buzzpin,0);
      digitalWrite(blueLed, HIGH);
      digitalWrite(greenLed, HIGH);
      digitalWrite(redLed, HIGH);
  }
}

/***************************************************
* This function takes in instructions from the Serial
* Monitor
*****************************************************/
void SerialRead(){

   if (Serial.available() > 0){
    incomingByte = Serial.read();

       switch(incomingByte){
        
         /*
         Code to control the servo, unfortuntely, we decided to not use the servo in our project
         
           case 'R':
           if(position > 0){
             position -= RIGHT;
           }
           myservo.write(position);
           break;
         case 'L':
           if(position < 180){
             position += LEFT;
           }
           myservo.write(position);
           break;
         case 'F':
           myservo.write(FORWARD);
           break;
           */
    
         //If C is read from the webpage, the set the alarm system to be on
         case 'C':
           delay(5000);
           Alarm = 0;
           disable_flag = 0;
           Motion_flag = 1;
           //myservo.write(FORWARD);
           break;
         //If X is read from the webpage, then turn off the alarm system
         case 'X':
           GreenLights(); //Indicates alarm if off
           Alarm=0;
           delay(500);
           if(disable_flag == 0){
             Serial.println("D"); //Stops a text message from being sent
           }
           disable_flag = 1 ;
           break;
         default:
           break;
       }
   }
}

/***************************************************************************************
*This function signals that the alarm is off and when the motion sensor is ready
***************************************************************************************/

void GreenLights(){
  for(int x=0;x<3;x++){
    digitalWrite(greenLed, LOW);
    digitalWrite(redLed, HIGH);
    digitalWrite(blueLed, HIGH);
    delay(500);
    digitalWrite(greenLed, HIGH);
    delay(500);
  }
}


