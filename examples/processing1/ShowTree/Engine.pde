/*

Tree Engine

*/

class Engine {
  float xpos , startx;
  float ypos , starty;
  float angle, starta;
  float unitsize;
  float anglechange;
  float[] xpos_a;
  float[] ypos_a;
  float[] angle_a;
  float[] startw_a;
  int acount;
  
  Engine(float x, float y, float a, float u) {
    xpos = startx = x;
    ypos = starty = y;
    angle = starta = 0;
    anglechange = a;
    unitsize = u;
    
    xpos_a = new float[1000];
    ypos_a = new float[1000];
    angle_a = new float[1000];
    startw_a = new float[1000];
    
    acount = 0;
  };
  
  void reset() {
    xpos = startx;
    ypos = starty;
    angle = starta;
    
    xpos_a = new float[1000];
    ypos_a = new float[1000];
    angle_a = new float[1000];
    startw_a = new float[1000];
  };
  
  void init() {
  
  };
  
  void process(char c) {
    if (c == '+') {
      angle += anglechange;
    }
    else if (c == '-') {
      angle -= anglechange;
    }
    else if (c == 'F') {
       float us = unitsize * random(1);
       float tx = xpos + (sin(angle * 0.0174532925 * random(1)) * us);
       float ty = ypos + (cos(angle * 0.0174532925 * random(1)) * us);
       
       
      stroke(0,0,0,70);
      if (branchcount > 2) {
        line(xpos, ypos, tx, ty);
        //ai.ai_line(xpos, ypos, tx, ty);
       }
       else {
       Branch b = new Branch(xpos, ypos, tx, ty);
        };
       xpos = tx;
       ypos = ty;
       
       if (random(10) < (2 * branchcount)) {
         int lc = leafcount % leafcolors.length;
         Leaf l = new Leaf(tx,ty,angle + 90,us, leafcolors[lc]);
         // Leaf l = new Leaf(tx,ty,angle + 90,us, leafcolors[int(random(leafcolors.length - 2) + 1)]);
         leaves[leafcount] = l;
         leafcount ++;
         if (leafcount > 500) { leafcount = 0;};
       /*
         int lc2 = leafcount % leafcolors.length;
         Leaf l2 = new Leaf(tx,ty,angle + random(360),us, leafcolors[lc2]);
         leaves[leafcount] = l2;
         leafcount ++;
*/
       };
       
    }
    else if (c =='[') {
      branchcount ++;
      xpos_a = append(xpos_a, xpos);
      ypos_a = append(ypos_a, ypos);
      angle_a = append(angle_a, angle);
      startw_a = append(startw_a, startw);
    }
    else if (c ==']') {
      branchcount --;
      xpos = xpos_a[xpos_a.length - 1];
      ypos = ypos_a[ypos_a.length - 1];
      angle = angle_a[angle_a.length - 1];
      startw = startw_a[startw_a.length - 1];
      
      xpos_a = shorten(xpos_a);
      ypos_a = shorten(ypos_a);
      angle_a = shorten(angle_a);
      startw_a = shorten(startw_a);
      
      
    };
  // return(false);
  };
  
};
