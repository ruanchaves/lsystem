class Leaf {

  float xpos;
  float ypos;
  float angle;
  float rot;
  float unitsize;
  float s;
  int id;
  color c;
  float scl;
  
  Leaf(float x, float y, float a, float u, color col) {
    s = 0;
    angle = a;
    xpos = x;
    ypos = y;
    rot = 0;
    unitsize = u/2;
    c = col;
    scl = random(2);
    render();
  };
  
  void render() {
    if (s<1) {s += 0.2;
    stroke(0,0,0,5);

    pushMatrix();
    translate(xpos,ypos);
   
    fill(red(c), green(c), blue(c), 60);
    
    angle -= 3;
    rotate((angle) * 0.0174532925);
    scale(s * scl);

    ellipseMode(CORNER);
    ellipse(0,0, unitsize, -6);
    
    popMatrix();
    };
  };
};
