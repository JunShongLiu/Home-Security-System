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

String pythonOutput;

int Width = 640;
int Height = 480;
int count = 0;
int matchImg;

boolean [] faceMatches = new boolean [10];


public void setup() {
 
  size(640, 480);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  PythonCom = new Client(this, "127.0.0.1", 50007);
  opencv = new OpenCV(this, width/2, height/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
 
  for(int i = 0; i < 10; i++){
  faceMatches[i] = false;
  }

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
    
    outputImg = createImage(faces[i].width, faces[i].height, ALPHA);
    outputImg = get(2*faces[i].x - 30, 2*faces[i].y - 30 ,2*faces[i].width + 50, 2*faces[i].height + 100);
          outputImg.resize(92, 112);
    
    outputImg.save("../openCV/test_faces/OutputImage" + i + ".jpg");
  
  }
 //PythonCom.clear();
 
  if(PythonCom.available() > 0){
  pythonOutput = PythonCom.readString();
  
  String [] pythonMatches = split(pythonOutput, " ");
  if(pythonMatches[0].length() > 0 && faces.length > 0){
    myPort.write("y");
    for(int i = 0; i < pythonMatches.length; i++){
      matchImg = parseInt(pythonMatches[i]);
      if((faces.length - 1 - matchImg) >= 0){ 
        faceMatches[faces.length - 1 - matchImg] = true;
      }
    }
  }
  }
  for(int i = 0; i < faces.length; i++){
      
   if(faceMatches[i]){
     stroke(0, 255, 0);
     rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
   }else{
     stroke(255, 0, 0);
     rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
     }
  }
  
  for(int i = 0; i < faceMatches.length; i++){
  faceMatches[i] = false;
  
  }
 
 saveFrame("/stream/Stream.jpg");
}


 public void captureEvent(Capture c) {
  c.read();
}