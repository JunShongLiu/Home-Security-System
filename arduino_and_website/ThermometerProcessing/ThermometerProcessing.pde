/*******************************
* Thermometer
**********************************/

import processing.serial.* ;

Serial myport ;
float inByte ;

PFont f;

void setup(){
  size(200, 400) ;
  
  f=createFont("Arial", 20) ;
}

void draw(){
  fill(277,277,277) ;
  background(211, 211, 211) ;
  
  smooth() ;
  
  // thermometer shape
  rectMode(CORNER) ;
  rect (50, 50, 20 , 200) ;
  ellipse(60, 270, 40, 40) ;
  
  // build reservoir
  fill(255, 0, 0) ;
  ellipse(60, 270, 20, 20) ;
  
  // quicksilver
  float thermometer_value = map(inByte,0,50,200,0);
  rect(57, 57 + thermometer_value, 6, (200 - thermometer_value));
  
  // define stroke
  stroke(255, 0, 0) ;
  strokeWeight(2) ;
  
  displayText() ;
}

/****************************************************************
* This function takes in temperature readings in voltage readings
* from the Serial Monitor, and converts them into positions on our
* screen
******************************************************************/
void serialEvent(Serial myPort){
  String inString = myPort.readStringUntil('\n') ;
  
  if(inString != null && inString.contains("Temp")){
    String[] list = split(inString, ':') ;
    String splitString = trim(list[1]) ;
    inByte = float(splitString) ;
  }
}

void displayText(){
  textFont(f, 20) ;
  text("Temperature", 35, 330) ;
  text("("+ inByte +")", 35, 360) ;
  
}