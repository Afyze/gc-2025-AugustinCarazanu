// Augustin Carazanu
// FAF-243 V2
// bat thats chasing flies

Bat bat;
ArrayList<Fly> flies;

void setup() {
  size(800, 600);
  bat = new Bat(width/2, height/2);
  flies = new ArrayList<Fly>();
  
  // create initial flies
  for (int i = 0; i < 5; i++) {
    flies.add(new Fly(random(width), random(height)));
  }
}

void draw() {
  background(30, 30, 50);
  
  // update and display flies
  for (int i = flies.size() - 1; i >= 0; i--) {
    Fly f = flies.get(i);
    f.update();
    f.display();
    
    // check if bat caught the fly
    if (PVector.dist(bat.location, f.location) < 15) {
      flies.remove(i);
    }
  }
  
  // add new fly at mouse position occasionally
  if (frameCount % 60 == 0) {
    flies.add(new Fly(mouseX, mouseY));
  }
  
  // find nearest fly for bat to chase
  if (flies.size() > 0) {
    Fly nearest = flies.get(0);
    float minDist = PVector.dist(bat.location, nearest.location);
    
    for (Fly f : flies) {
      float d = PVector.dist(bat.location, f.location);
      if (d < minDist) {
        minDist = d;
        nearest = f;
      }
    }
    
    bat.seek(nearest.location);
  }
  
  bat.update();
  bat.display();
  
  // info text
  fill(200);
  text("Flies: " + flies.size(), 10, 20);
  text("Move mouse to spawn flies", 10, 40);
}

// fly class using geometric shapes
class Fly {
  PVector location;
  PVector velocity;
  float angle;
  
  Fly(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(random(-2, 2), random(-2, 2));
    angle = 0;
  }
  
  void update() {
    // move toward mouse slowly
    PVector mouse = new PVector(mouseX, mouseY);
    PVector dir = PVector.sub(mouse, location);
    dir.limit(0.5);
    velocity.add(dir);
    velocity.limit(3);
    
    location.add(velocity);
    angle += 0.2;
    
    // wrap around edges
    if (location.x < 0) location.x = width;
    if (location.x > width) location.x = 0;
    if (location.y < 0) location.y = height;
    if (location.y > height) location.y = 0;
  }
  
  void display() {
    pushMatrix();
    translate(location.x, location.y);
    
    // body - ellipse
    fill(100, 100, 150);
    stroke(80, 80, 120);
    ellipse(0, 0, 8, 12);
    
    // wings - lines
    stroke(120, 120, 180, 150);
    strokeWeight(1);
    float wing = sin(angle) * 5;
    line(-4, 0, -4 - wing, -3);
    line(4, 0, 4 + wing, -3);
    
    // head - small ellipse
    fill(80, 80, 100);
    noStroke();
    ellipse(0, -5, 5, 5);
    
    // tail - triangle
    fill(90, 90, 130);
    triangle(-2, 6, 0, 10, 2, 6);
    
    popMatrix();
  }
}

// bat class - predator using vehicle behavior
class Bat {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce;
  
  Bat(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxSpeed = 4;
    maxForce = 0.1;
  }
  
  // apply force to acceleration
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  // seek behavior - pursue target
  void seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxSpeed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    
    applyForce(steer);
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
    
    // wrap edges
    if (location.x < -20) location.x = width + 20;
    if (location.x > width + 20) location.x = -20;
    if (location.y < -20) location.y = height + 20;
    if (location.y > height + 20) location.y = -20;
  }
  
  void display() {
    float theta = velocity.heading() + PI/2;
    
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    
    // bat shape using vertices
    fill(40, 40, 60);
    stroke(20, 20, 40);
    strokeWeight(1);
    
    // body
    beginShape();
    vertex(0, -15);
    vertex(-5, -5);
    vertex(-4, 5);
    vertex(0, 10);
    vertex(4, 5);
    vertex(5, -5);
    endShape(CLOSE);
    
    // left wing
    beginShape();
    vertex(-5, -5);
    vertex(-15, -8);
    vertex(-18, 0);
    vertex(-12, 3);
    vertex(-4, 5);
    endShape(CLOSE);
    
    // right wing
    beginShape();
    vertex(5, -5);
    vertex(15, -8);
    vertex(18, 0);
    vertex(12, 3);
    vertex(4, 5);
    endShape(CLOSE);
    
    // head
    fill(50, 50, 70);
    beginShape();
    vertex(-3, -15);
    vertex(-4, -18);
    vertex(-2, -20);
    vertex(0, -19);
    vertex(2, -20);
    vertex(4, -18);
    vertex(3, -15);
    endShape(CLOSE);
    
    // ears
    fill(60, 60, 80);
    beginShape();
    vertex(-3, -20);
    vertex(-5, -24);
    vertex(-2, -21);
    endShape(CLOSE);
    
    beginShape();
    vertex(3, -20);
    vertex(5, -24);
    vertex(2, -21);
    endShape(CLOSE);
    
    // eyes
    fill(200, 50, 50);
    noStroke();
    ellipse(-2, -17, 2, 2);
    ellipse(2, -17, 2, 2);
    
    popMatrix();
  }
}
