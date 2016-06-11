import processing.net.*;

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;

Serial myPort;
Capture video;
OpenCV opencv;
Client PythonCom;

PImage outputImg;
PImage storeImg;

int imgSize = 0;

String pythonOutput;

int Width = 640;
int Height = 480;
int count = 0;
int matchImg;

boolean faceMatch = false;


public void setup() {
 
  size(640, 480);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  PythonCom = new Client(this, "127.0.0.1", 50007);
  opencv = new OpenCV(this, width/2, height/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  
 

}

public void draw() {
 
 
  scale(2);
  storeImg = loadImage("test.jpg");
  storeImg.resize(width/2, height/2);
  image(storeImg,0,0);
  opencv.loadImage(storeImg);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
 
  println(faces.length);
  for (int i = 0; i < faces.length; i++) {
    if((faces[i].width + faces[i].height) > imgSize){
      faces[0] = faces[i];
      imgSize = faces[i].width + faces[i].height;
     }
   }
    imgSize = 0;
    
    if(faces.length > 0){
    outputImg = createImage(faces[0].width, faces[0].height, ALPHA);
    outputImg = get(2*faces[0].x - 10, 2*faces[0].y - 20 ,2*faces[0].width + 20, 2*faces[0].height + 50);
    
    outputImg.resize(92, 112);
    
    
    
    outputImg.save("../openCV/test_faces/OutputImage" + 0 + ".jpg");
    }
  
 //PythonCom.clear();
 
  if(PythonCom.available() > 0){
  pythonOutput = PythonCom.readString();
  
  String [] pythonMatches = split(pythonOutput, " ");
  if(pythonMatches[0].length() > 0 && faces.length > 0){
    myPort.write("X");
    faceMatch = true;
   }
  }
  //for(int i = 0; i < faces.length; i++){
  if(faces.length > 0){     
     if(faceMatch){
       stroke(0, 255, 0);
       rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
     }else{
       stroke(255, 0, 0);
       rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
     }
  }
  
  faceMatch = false;
 
 saveFrame("Stream.jpg");
 
}


 public void captureEvent(Capture c) {
  c.read();
}