/*-----------
 Dual Brains Data Viz - R2
 This sketch should
 1. initialized necessary Graph objects & a UDP object
 2. Parse data read via UDP object and pipe the correct data into the Graph objects
 ------------- */

class DBvis {
  boolean handsTouching;
  boolean DEBUG = false;
  
  DBLineGraph g, g2;
  DBSpectrogram s, s2;
  //float[][] data_list;
  PImage backgroundImg;
  ArrayList <DBPoint> leftPoints;
  ArrayList <DBPoint> rightPoints;
  
  float[] newData;
  float[] newData2;
  float[] newData3;
  
  float[] subj1_eeg;
  float[] subj1_heart;
  float[] subj1_fft;
  
  float[] subj2_eeg;
  float[] subj2_fft;
  float[] subj2_heart;

  DBvis() {
    background(0);
    backgroundImg = loadImage("GradientBackground-640.jpg");
  
    handsTouching = false;
    //Setting up array list for Points
    leftPoints = new ArrayList<DBPoint>();
    rightPoints = new ArrayList<DBPoint>();
  
  
    // Test Graph
    // DBGraph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, int ORIGIN_X, int ORIGIN_Y){
    // DBLineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y,  boolean IS_ON_LEFT){
    g = new DBLineGraph(6, 250, -250, 20, 9, width*0.003, width*0 - 20, height*1.05, true);
    g2 = new DBLineGraph(6, 250, -250, 20, 9, width*0.003, width*0.5 - 20, height*1.05, false);
  
    // DBSpectrogram graph
    // DBSpectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
    s = new DBSpectrogram(32, 10, 0, 9, 4, width*0.0125, width*0-(width*0.035), -20, true);
    s2 = new DBSpectrogram(32, 10, 0, 9, 4, width*0.0125, width*0.5-(width*0.035), -20, false);
    
    newData = new float[6];
    newData2 = new float[s.dataPoints];
    newData3 = new float[1];
  
    //Set DeBug to False for Gabe FrameRate Test
    g.debugMode = DEBUG;
    s.debugMode = DEBUG;
    g2.debugMode = DEBUG;
    s2.debugMode = DEBUG;
  
  }
  
  void update() {
    //POPULATE RANDOM DATA
    for (int i = 0; i < newData.length; i++) {
      newData[i] = random(-250,250);
    }
     
    for (int i = 0; i < newData2.length; i++) {
      newData2[i] = random(0.0, 10.0);
    }
    newData3[0] = random(-250,250);
    
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
  }

  void draw() {
    pushStyle();
      tint(255,5);
      image(backgroundImg, 0, 0, width, height);
    popStyle();
  
    if(g.debugMode == false){
      //colorMode(RGB,100);
      if(handsTouching){
        //fill(color(red(#000606),green(#000606),blue(#000606),15));
        fill(637535750);
      } else {
        //fill(color(red(#210e25),green(#210e25),blue(#210e25),35));
        fill(1495338533);
      }
      noStroke();
      rect(0,0,width,height);
    } else {
      //background(0);
      colorMode(RGB,100);
      //fill(0,0,0,70);
      fill(-1308622848);
      noStroke();
      rect(0,0,width,height);
    }
    
  
    if(handsTouching && frameCount % 10 == 0){
      spawnLeft(newData3, -250, 250);
      spawnRight(newData3, -250, 250);
    }
  
    g.render();
    g2.render();
    s.render();
    s2.render();
  
  
    for(DBPoint pt : leftPoints){
      pt.render();
    }
    for(DBPoint pt : rightPoints){
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
  }

  //void mousePressed(){
  //  g.debugMode = !g.debugMode;
  //  s.debugMode = !s.debugMode;
  //  g2.debugMode = !g2.debugMode;
  //  s2.debugMode = !s2.debugMode;
  //}

  //void keyPressed(){
  //  handsTouching = !handsTouching;
  //}


  void spawnLeft(float[] heart, float lowerLim, float upperLim){
    int interval = floor(map(heart[0],lowerLim, upperLim,40,5));
    for(int i = 0; i < height; i += interval){
      //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
      float sizeX = random(20,120);
      DBPoint pt = new DBPoint(width*0.52, i, sizeX, sizeX, random(0.01, 0.02), true);
      leftPoints.add(pt);
    }
  }

  void spawnRight(float[] heart, float lowerLim, float upperLim){
    int interval = floor(map(heart[0],lowerLim, upperLim,40,5));
    for(int i = 0; i < height; i += interval){
      //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
      float sizeX = random(20,120);
      DBPoint pt = new DBPoint(width*0.48, i, sizeX, sizeX, random(0.01, 0.02), false);
      rightPoints.add(pt);
    }
  }


  void prune(){
    for(int i = leftPoints.size()-1; i > 0; i--){
      DBPoint pt = leftPoints.get(i);
      if(pt.alive == false){
        leftPoints.remove(pt);
      }
    }
    for(int i = rightPoints.size()-1; i > 0; i--){
      DBPoint pt = rightPoints.get(i);
      if(pt.alive == false){
        rightPoints.remove(pt);
      }
    }
  }
}