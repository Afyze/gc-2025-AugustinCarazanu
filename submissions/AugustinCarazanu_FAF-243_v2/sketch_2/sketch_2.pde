// Augustin Carazanu
// FAF-243 V2
// fractal Tree with flowers

ArrayList<FallingFlower> fallingFlowers;
float time = 0;
boolean[] treeTipsState; 
float[] dropTimes; // store random times here
int tipCounter = 0;

void setup() {
  size(800, 600);
  fallingFlowers = new ArrayList<FallingFlower>();
  
  treeTipsState = new boolean[200]; 
  dropTimes = new float[200];
  
  for(int i=0; i<treeTipsState.length; i++) {
    treeTipsState[i] = true; 
    // random delay between 1 and 15 seconds
    dropTimes[i] = 1000 + random(14000); 
  }
}

void draw() {
  background(135, 206, 235); // sky
  
  fill(34, 139, 34); // ground
  rect(0, 550, width, 50);
  
  tipCounter = 0; // reset for recursion
  
  // draw tree and attached flowers
  drawBranch(width/2, 550, -PI/2, 60, 0, 6);
  
  // wind and gravity
  float windStr = (noise(time * 0.3) * 2 - 1) * 0.15;
  PVector wind = new PVector(windStr, 0);
  PVector gravity = new PVector(0, 0.15); // slightly lighter gravity
  
  // update fallen flowers
  for (int i = fallingFlowers.size() - 1; i >= 0; i--) {
    FallingFlower f = fallingFlowers.get(i);
    f.applyForce(gravity);
    f.applyForce(wind);
    
    // turbulence
    float tx = (noise(f.pos.x * 0.01, time * 0.5) - 0.5) * 0.4;
    float ty = (noise(f.pos.y * 0.01 + 100, time * 0.5) - 0.5) * 0.2;
    f.applyForce(new PVector(tx, ty));
    
    f.update();
    f.display();
    
    if (f.isOffScreen()) fallingFlowers.remove(i);
  }
  
  time += 0.05;
}

void drawBranch(float x1, float y1, float angle, float length, int depth, int maxDepth) {
  if (depth > maxDepth) {
    // flower colors
    color[] colors = {
      color(255, 105, 180), color(255, 192, 203), 
      color(255, 182, 193), color(255, 20, 147), color(219, 112, 147) 
    };
    color c = colors[tipCounter % colors.length];
    
    if(treeTipsState[tipCounter]) {
      // check if its specific random time has passed
      if (millis() > dropTimes[tipCounter]) {
         treeTipsState[tipCounter] = false; // detach
         fallingFlowers.add(new FallingFlower(x1, y1, c));
      } else {
         drawAttachedFlower(x1, y1, c); // still attached
      }
    }
    tipCounter++;
    return;
  }
  
  // physics for swaying branches
  float nVal = noise(x1 * 0.01, y1 * 0.01 + time);
  float newLen = length * (0.75 + nVal * 0.3);
  float x2 = x1 + cos(angle) * newLen;
  float y2 = y1 + sin(angle) * newLen;
  
  stroke(101 + depth * 10, 67 + depth * 5, 33 + depth * 3);
  strokeWeight(max(1, (maxDepth - depth + 1) * 1.5));
  line(x1, y1, x2, y2);
  
  float an1 = noise(x2 * 0.01 + 100, y2 * 0.01 + time * 0.5) * 0.3;
  float an2 = noise(x2 * 0.01 + 200, y2 * 0.01 + time * 0.5) * 0.3;
  
  drawBranch(x2, y2, angle - PI/6 + an1, newLen, depth + 1, maxDepth);
  drawBranch(x2, y2, angle + PI/6 + an2, newLen, depth + 1, maxDepth);
}

void drawAttachedFlower(float x, float y, color c) {
    pushMatrix();
    translate(x, y);
    noStroke();
    for (int i = 0; i < 5; i++) {
      pushMatrix();
      rotate(TWO_PI * i / 5);
      fill(c);
      ellipse(3, 0, 4, 2.5);
      popMatrix();
    }
    fill(255, 215, 0); 
    ellipse(0, 0, 2.5, 2.5);
    popMatrix();
}

class FallingFlower {
  PVector pos, vel, acc;
  float size, rotation, rotSpd;
  color col;
  
  FallingFlower(float x, float y, color c) {
    pos = new PVector(x, y);
    // slight lateral drift on release
    vel = new PVector(random(-0.5, 0.5), random(0, 0.5));
    acc = new PVector(0, 0);
    size = random(6, 10);
    col = c;
    rotation = random(TWO_PI);
    rotSpd = random(-0.1, 0.1);
  }
  
  void applyForce(PVector f) { acc.add(f); }
  
  void update() {
    vel.add(acc);
    vel.limit(4); // slower fall speed
    pos.add(vel);
    rotation += rotSpd;
    acc.mult(0);
  }
  
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    noStroke();
    for (int i = 0; i < 5; i++) {
      pushMatrix();
      rotate(TWO_PI * i / 5);
      fill(col);
      ellipse(size * 0.4, 0, size * 0.5, size * 0.3);
      popMatrix();
    }
    fill(255, 215, 0); 
    ellipse(0, 0, size * 0.3, size * 0.3);
    popMatrix();
  }
  
  boolean isOffScreen() { return pos.y > height + 20; }
}
