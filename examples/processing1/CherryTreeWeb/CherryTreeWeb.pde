/*

L-System Cherry Tree
September, 2005
blprnt@blprnt.com

*/


Lsystem ls = new Lsystem("FF");
RuleSet rs = new RuleSet();
Engine e = new Engine(300, 600, -29.5, -20);

int value = 0; 
boolean playing = false;
int count = 0;
Leaf[] leaves = new Leaf[50000];
int leafcount;
int [] leafcolors = new int[1000000];
int [] branchcolors = new int[1000000];
int branchcount;
float startw;
;



void setup() {

   
  size(600,600,P3D);
  framerate(60);
    
    
   branchcount = 0;
   startw = 15;

  PImage b;
  b = loadImage("cherry2.gif");
  image(b,0,0);
  loadPixels();
  for(int i=0; i<pixels.length; i++) {
    leafcolors[i] = pixels[i];
  };
  background(255);
  
  PImage b2;
  b2 = loadImage("bark2.gif");
  image(b2,0,0);
  loadPixels();
  for(int i=0; i<pixels.length; i++) {
    branchcolors[i] = pixels[i];
  };
  
  leafcount = 0;
  
   rs.init();
  
  String[] rax = {"FF-[-F+F+F-]+[+F-F-F+]:90", "++:5", "--:5"};
  Rule r1 = new Rule("F", rax);  
   
  rs.addRule(r1);
  ls.registerRuleSet(rs);
  ls.registerEngine(e); 
  ls.recurse(5); 

   background(255);
};

void draw() {
  
  count ++;
  if (!playing) {
    ls.render(0);
  };
  
  for (int i=0; i<leafcount; i++) {
    leaves[i].render();
  };
};

void mousePressed() {
  //setup();
};


