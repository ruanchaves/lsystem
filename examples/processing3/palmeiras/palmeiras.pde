ArrayList<Tree> trees = new ArrayList<Tree>();
int numTrees = 3;

Boolean wind = false;

void setup() {
  size(1300, 700, P2D);
  
  for(int i=0; i<numTrees; i++) {
    trees.add(new Tree(random(width)));
  }
}

void draw() {
  background(0);
  
  for(Tree t : trees) {
    t.display();
  }
}

void mousePressed() {
  wind = !wind;
}

class Tree {
  
  ArrayList<Leaf> bush = new ArrayList<Leaf>();
  int maxSize = 65;
  float xPos;
  
  Tree(float x) {  
    xPos = x;
    for (int i = 0; i < maxSize; i++) {
      bush.add(new Leaf(random(40, 180), maxSize));
    }
  }
  
  void display() {
    stroke(255);
    fill(255);
    for(int i = 0; i < bush.size(); i++){
      Leaf b = (Leaf) bush.get(i);
      b.display(xPos); 
    }
  }

}

class Leaf {
  float segments, angle, num;
  int maxSize;
  float initAngle;

  Leaf(float segments, int _maxSize) {
    maxSize = _maxSize;
    this.segments = segments;
    angle = random(-20, 20);
    initAngle = angle;
  }

  void display(float x){
    pushMatrix();
    translate(x, height);
    branch(segments);
    popMatrix();
  }
  
  void branch(float len) {
    len *= 0.75;
    
    float t = map(len, 1, maxSize, 1, 5);
    
    if(wind) {
      if(angle > 0) angle += 0.01; 
      if(angle < 0) angle -= 0.01;
    }
    
    float c = angle+sin(len+num) * 5;
    strokeWeight(t);
    
    line(0, 0, 0, -len);
    
    translate(0, -len);
    if(len < 35) {
      strokeWeight(1);
      line(0,0, cos(PI/4) * 10+t, sin(PI/4) * 10+t);
      ellipse(cos(PI/4) * 10+t, sin(PI/4) * 10+t, 1+t, 1+t);
      line(0,0, cos(PI*0.75) * 10+t, sin(PI*0.75) * 10+t);
      ellipse(cos(PI*0.75) * 10+t, sin(PI*0.75) * 10+t, 1+t, 1+t);
    }
    if (len > 5) {
      pushMatrix();
      rotate(radians(c));
      strokeWeight(t);
      branch(len);
      popMatrix();
    }
    num+=0.001;
  }
}
