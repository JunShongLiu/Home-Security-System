import gab.opencv.*; 
import processing.video.*; 
import java.awt.*; 
import processing.serial.*; 

Serial myPort;
Capture video;
OpenCV opencv;

PImage outputImg;
PImage storeImg;

int Width = 640;
int Height = 480;
int count = 0;

boolean python = true;
boolean wait = true;
boolean [] faceMatches = new boolean [10];


public void setup() {
 
  
  size(640, 480);
  println(Serial.list());
 
  opencv = new OpenCV(this, width/2, height/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  
  for(int i = 0; i < 10; i++){
    faceMatches[i] = false;
  }
  //outputImg = createGraphics(640, 480, JAVA2D);


  //video.start();
}

public void draw() {
  
  scale(2);
  storeImg = loadImage("../data/test.jpg");
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
      outputImg = get(2*faces[0].x - 10, 2*faces[0].y - 20 ,2*faces[0].width + 20, 2*faces[0].height + 50);
    
      
      // outputImg.resize(92, 112);
      //if(count < 10){
      outputImg.save("../../openCV/att_faces/s97/Shavon" + count + ".jpg"); 
     // delay(500);
      count++;
      //}
       
    }
   
  for(int i = 0; i < faces.length; i++){
     //println(faces[i].x + "," + faces[i].y);
     if(faceMatches[i]){
       stroke(0, 255, 0);
       rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
     }else{
       stroke(255, 0, 0);
       rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
     }
  }
 // python = true;
  for(int i = 0; i < faceMatches.length; i++){
    faceMatches[i] = false;
    
  }
 // myPort.write("\n");
  //opencv.releaseROI();
}


public void captureEvent(Capture c) {
  c.read();
}
  