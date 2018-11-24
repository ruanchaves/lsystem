float transparency = 150;
color leafColor = color(5,113,3,transparency);
color veinColor = color(5,113,3,transparency/2);
color branchColor = color(30);
color skyColor = color(211,211,255);

int width = 900;
int height = 500;

//branch controls
int nTrees = 1; //the number of trees
int nSegments;
float totalBranchLength;
float maxBranchThickness;
float minBranchThickness; 
float minSpawnDistance; //this controls how far the branch will grow before splitting
float branchSpawnOdds;   //the odds of a branch growing there
float branchSpawnOddsOfSecond; //odds of a second branch growing from the same node
float mindThetaSplit;
float maxdThetaSplit;
float maxdThetaWander;
float dBranchSize; //the new branch may change by 1.0+/- this amount

//leaf controls
float minLength; //leaf length
float maxLength; //leaf length
float minWidth;  //leaf width as a factor of length
float maxWidth;  //leaf width as a factor of length
float maxBranchSizeForLeaves;
float leafSpawnOdds;

branch[] branches;

boolean pauseWind = false;
boolean drawWind = false;
boolean drawVeins = false;
boolean blackLeaves = false;
boolean drawLeaves = true;

//int width = 1680;
//int height = 1050;

void settings(){
  size(width,height);
}

void setup(){
  frameRate(30);
  smooth();
  noStroke();

  initializeTreeValues();
  
  windDirection = 0;
  windVelocity = 0;
  defineLeafOutline();
  defineVeins();
  
  generateBranches();
  
  redrawTrees();
}


void draw(){
  if(!pauseWind){
    updateWind();
    
    //move in the wind!
    for(int i = 0; i<nTrees; i++)
      branches[i].rotateDueToWind();
     
    redrawTrees();
    
    //draw the wind line
    if(drawWind)
      drawWindLine();
  }
}

void redrawTrees(){
  background(skyColor);
  drawBranches();
  if(drawLeaves)
    drawLeavesFn();
}

void drawBranches(){
  stroke(branchColor);
  for(int i = 0; i<nTrees; i++)
    branches[i].drawBranch(new float[]{(1+i)*(width/(1+nTrees)), height});
}

void drawLeavesFn(){
  noStroke();
  if(blackLeaves)
    fill(0,0,0,transparency);
  else
    fill(leafColor);
  //draw leaves
  for(int i = 0; i<nTrees; i++)
    branches[i].drawLeaves(new float[]{(1+i)*(width/(1+nTrees)), height});
}

void drawWindLine(){
  stroke(0);
  int dx= 100;
  int dy = 100;
  line(dx,dy,dx+50*windVelocity*cos(windDirection),dy+50*windVelocity*sin(windDirection));
  noStroke();
  fill(0);
  ellipse(dx,dy,3,3);
}

void initializeTreeValues(){
  pauseWind = false;
  drawWind = false;
  drawVeins = false;
  blackLeaves = false;
  drawLeaves = true;
  //branch
  nSegments = 15;
  totalBranchLength = 400;
  maxBranchThickness = 10;
  maxBranchSizeForLeaves = 4;
  minBranchThickness = 2; 
  minSpawnDistance = .2;
  branchSpawnOdds = .8; 
  branchSpawnOddsOfSecond = 0;
  mindThetaSplit = PI*.1;
  maxdThetaSplit = PI*.3;
  maxdThetaWander = PI/20;
  dBranchSize = .2;
  //leaves
  minLength = 10;
  maxLength = 30;
  minWidth = .4;
  maxWidth = .5;
  maxBranchSizeForLeaves = 4;
  leafSpawnOdds = .7;
  generateBranches(); 
}
