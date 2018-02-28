/*-----------
 Dual Brains Data Viz - R2
 This sketch should
 1. initialized necessary Graph objects & a UDP object
 2. Parse data read via UDP object and pipe the correct data into the Graph objects
 ------------- */
boolean handsTouching;
boolean DEBUG = true;

LineGraph g, g2;
Spectrogram s, s2;
float[][] data_list;
PImage backgroundImg;
ArrayList <Point> leftPoints;
ArrayList <Point> rightPoints;

float[] subj1_eeg;
float[] subj1_heart;
float[] subj1_fft;

float[] subj2_eeg;
float[] subj2_fft;
float[] subj2_heart;

void setup() {
  //size(1080, 768);
  frameRate(20);
  //fullScreen(P3D);
  size(640, 480, P3D);
  background(0);
  backgroundImg = loadImage("GradientBackground-640.jpg");

  handsTouching = false;
  //Setting up array list for Points
  leftPoints = new ArrayList<Point>();
  rightPoints = new ArrayList<Point>();


  //Test Graph
  //Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, int ORIGIN_X, int ORIGIN_Y){
  //LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y,  boolean IS_ON_LEFT){
  g = new LineGraph(6, 250, -250, 20, 9, width*0.003, width*0 - 20, height*1.05, true);
  g2 = new LineGraph(6, 250, -250, 20, 9, width*0.003, width*0.5 - 20, height*1.05, false);

  //Spectrogram graph
  // Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
  s = new Spectrogram(32, 10, 0, 9, 4, width*0.0125, width*0-(width*0.035), -20, true);
  s2 = new Spectrogram(32, 10, 0, 9, 4, width*0.0125, width*0.5-(width*0.035), -20, false);

  //Set DeBug to False for Gabe FrameRate Test
  g.debugMode = DEBUG;
  s.debugMode = DEBUG;
  g2.debugMode = DEBUG;
  s2.debugMode = DEBUG;

  //***********************************
  //NETWORKING
  //THIS MUST BE INCLUDED IN YOUR SETUP
  udp= new UDP(this,PORT_RX,HOST_IP);
  udp.log(true);
  udp.listen(true);
  super.start();
  //***********************************

}

void draw() {
  pushStyle();
    tint(255,5);
    image(backgroundImg, 0, 0, width, height);
  popStyle();

  if(g.debugMode == false){
    //background(#210e25);
    colorMode(RGB,100);
    if(handsTouching){
      fill(color(red(#000606),green(#000606),blue(#000606),15));
    } else {
      fill(color(red(#210e25),green(#210e25),blue(#210e25),35));
    }
    noStroke();
    rect(0,0,width,height);
  } else {
    //background(0);
    colorMode(RGB,100);
    fill(0,0,0,70);
    noStroke();
    rect(0,0,width,height);
  }


  float [] newData2 = new float[s.dataPoints];
  float [] newData3 = {random(-250,250)};
  //POPULATE RANDOM DATA
  float[] newData = {random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250)};
  // float[] newData = subj1_eeg;
  
  for (int i = 0; i < s.dataPoints; i++) {
    //newData2[i] = random(0, 11);
    newData2[i] = random(0.0, 10.0);
  }
  

  if(handsTouching && frameCount % 10 == 0){
    //spawnLeft(newData3, -250, 250);
    //spawnRight(newData3, -250, 250);
    spawnLeft(newData3, -250, 250);
    spawnRight(newData3, -250, 250);
  }

  // If data is pulled from UDP, pass it to the drawing board
  if (subj1_eeg != null) {
    g.update(subj1_eeg);
  } else {
    g.update(newData);
  }
  
  if (subj2_eeg != null) {
    g2.update(subj2_eeg);
  } else {
    g2.update(newData);
  }
  
  if (subj1_fft != null) {
    s.update(subj1_fft);
  } else {
    s.update(newData2);
  }
  
  if (subj2_fft != null) {
    s.update(subj2_fft);
  } else {
    s2.update(newData2);
  }

  g.render();
  g2.render();
  s.render();
  s2.render();


  for(Point pt : leftPoints){
    pt.render();
  }
  for(Point pt : rightPoints){
    pt.render();
  }

  if(handsTouching){
    pushStyle();

      noFill();
      strokeWeight(0.5);
      stroke(color(255,0,255,10));
      for(int i = 0; i < width; i += (width*0.1)){
        beginShape(TRIANGLE_STRIP);
        for(int j = 0; j <= height; j += (height*0.1)){
          vertex(i - (height*0.05) * sin(millis()*0.001) ,j + (height*0.05) * cos(millis()*0.001));
          vertex(i + (width*0.1) + (height*0.05) * cos(millis()*0.001), j);
        }
        endShape();
      }
    popStyle();
  }



  prune();

  // fill(color(#FFFFFF));
  // text(frameRate, 20, 20);

}

void mousePressed(){
  g.debugMode = !g.debugMode;
  s.debugMode = !s.debugMode;
  g2.debugMode = !g2.debugMode;
  s2.debugMode = !s2.debugMode;
}

void keyPressed(){
  handsTouching = !handsTouching;
}


void spawnLeft(float[] heart, float lowerLim, float upperLim){
  int interval = floor(map(heart[0],lowerLim, upperLim,40,5));
  for(int i = 0; i < height; i += interval){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(width*0.52, i, sizeX, sizeX, random(0.01, 0.02), true);
    leftPoints.add(pt);
  }
}

void spawnRight(float[] heart, float lowerLim, float upperLim){
  int interval = floor(map(heart[0],lowerLim, upperLim,40,5));
  for(int i = 0; i < height; i += interval){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(width*0.48, i, sizeX, sizeX, random(0.01, 0.02), false);
    rightPoints.add(pt);
  }
}


void prune(){
  for(int i = leftPoints.size()-1; i > 0; i--){
    Point pt = leftPoints.get(i);
    if(pt.alive == false){
      leftPoints.remove(pt);
    }
  }
  for(int i = rightPoints.size()-1; i > 0; i--){
    Point pt = rightPoints.get(i);
    if(pt.alive == false){
      rightPoints.remove(pt);
    }
  }
}


// **********************************************************
// NETWORKING
import hypermedia.net.*;
import java.util.Scanner;
int PORT_RX=6100; //port
String HOST_IP="127.0.0.1"; //
UDP udp;
String receivedFromUDP = "";

void receive(byte[] received_data) {
  receivedFromUDP ="";
  String data = new String(received_data);
  String[] items = data.replaceAll("\\[","").replaceAll("\\]","").split(",");
  data_list = new float[12][items.length/12];
  subj1_eeg = new float[6];
  subj1_heart = new float[1];
  subj2_eeg = new float[6];
  subj2_heart = new float[1];
  subj1_fft = new float[32];
  subj2_fft = new float[32];

  for (int i = 0; i<6;i++){
    subj1_eeg[i] = Float.parseFloat(items[i]);
    //println(items[i], subj1_eeg[i]);
  }
  subj1_heart[0] = Float.parseFloat(items[7]);
  for (int i =0;i<6;i++){
    subj2_eeg[i] = Float.parseFloat(items[i+7]);
  }
  subj2_heart[0] = Float.parseFloat(items[14]);
  for (int i=0;i<32;i++){
    subj1_fft[i] = Float.parseFloat(items[i+15]);
  }
  for (int i=0;i<32;i++){
    subj2_fft[i] = Float.parseFloat(items[i+48]);
  }
}