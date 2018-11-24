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
    //angle = a + 90;
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
    if (s<1) {s += 1;
    stroke(0,0,0,5);

    pushMatrix();
    translate(xpos,ypos);
  
    fill(red(c), green(c), blue(c), 255);

    angle -= 3;
    rotate((angle) * 0.0174532925);
    scale(s * scl);

    //image(myCamera, 0, 0, unitsize * 3, unitsize * 3);
    
    beginShape();
    textureMode(NORMALIZED);
    texture(myCamera);
    vertex(0,0,1,1);
    vertex(unitsize * 2.5,0,1,0);
    vertex(unitsize * 2.5, unitsize * 2.5,0,0);
    vertex(0, unitsize * 2.5,0,1);
    endShape();

    popMatrix();
    };
  };
};
