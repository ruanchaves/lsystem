/*

Webcam Tree
September, 2005
blprnt@blprnt.com

*/

import processing.video.*;
Capture myCamera;

Lsystem ls = new Lsystem("FF");
RuleSet rs = new RuleSet();
Engine e = new Engine(500, 800, -22.5, -25);


int value = 0; 
boolean playing = false;
int count = 0;
Leaf[] leaves = new Leaf[50000];
int leafcount;
int [] leafcolors = new int[1000000];
int [] branchcolors = new int[1000000];
int branchcount;
float startw;
boolean stamped;
int adcount = 0;
boolean ad = false;
int timer = 18000;
PImage russel;
      


void mousePressed() {
  reset();
 };
 
void reset() {
println(adcount);
  save(hour() + "_" + minute() + ".tif");
  ls.reset("FF");
  ls.recurse(5);
  
  e.reset();
  e.anglechange = 10 + random(30);
  e.unitsize = -10 - random(30);
  
  leafcount = 0;
  branchcount = 0;
  
  leaves = new Leaf[50000];
  
  startw = 15;
  background(255);
  
  adcount ++;
  if (adcount == 5) {
    adcount = 0;
    ad = true;
    timer = 200;
  } else {
    ad = false;
    timer = 18000;
  };
};
 

void setup() {
  stamped = false;
  
  
  
  size(1000,800,P3D);
  myCamera = new Capture(this, 320, 240, 12);
  framerate(30);

   branchcount = 0;
   startw = 15;
  russel = loadImage("russell.jpg");
  
  PImage b;
  b = loadImage("leaf6.gif");
  image(b,0,0);
  loadPixels();
  for(int i=0; i<pixels.length; i++) {
    leafcolors[i] = pixels[i];
  };
  background(255);
  
  PImage b2;
  b2 = loadImage("bark4.gif");
  image(b2,0,0);
  loadPixels();
  for(int i=0; i<pixels.length; i++) {
    branchcolors[i] = pixels[i];
  };

  leafcount = 0;
  
  rs.init();
 // rs2.init();
  
  String[] rax = {"FF-[-F+F+F-]+[+F-F-F+]:90", "FFF+:10"};
  Rule r1 = new Rule("F", rax);  
   
  rs.addRule(r1);
  //rs2.addRule(r1);
  
  ls.registerRuleSet(rs);
  //ls2.registerRuleSet(rs2);
  
  ls.registerEngine(e);
  //ls2.registerEngine(e2);
  
  ls.recurse(5); 
  //ls2.recurse(4);
  
   background(255);
};

void captureEvent(Capture myCamera){
 myCamera.read();
}

void draw() {

  
  loadPixels();
  
  count ++;
  if (count > timer) {
    count = 0;
    reset();
  };
  if (!playing) {
    if (!ad) {
      ls.render(0);
    }
    else {
      image(russel,75,0);
    };
  };
  
  for (int i=0; i<leafcount; i++) {
    leaves[i].render();
  };
};




