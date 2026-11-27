Creature[] school = new Creature[9];

void setup() {
  size(800, 600);
  
  for (int i = 0; i < school.length; i++) {
    school[i] = new Creature(random(width), random(height));
  }
}

void draw() {
  background(220, 245, 255);
  
  fill(0); 
  textSize(16);
  textAlign(LEFT, TOP);
  text("Variant 3, Augustin Carazanu, FAF-243", 10, 10);
  
  // Update and display creatures
  for (int i = 0; i < school.length; i++) {
    school[i].updatePosition();
    school[i].checkEdges();
    school[i].display();
  }
}

class Creature {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float creatureWidth = 130;
  float creatureHeight = 50;
  float maxSpeed;
  
  float noiseOffsetX;
  float noiseOffsetY;

  Creature(float startX, float startY) {
    location = new PVector(startX, startY);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    
    maxSpeed = random(2.0, 3.5);
    
    noiseOffsetX = random(0, 1000);
    noiseOffsetY = random(10000, 11000);
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);

    fill(80, 150, 255);
    stroke(50, 100, 200);
    strokeWeight(2);
    rect(0, 0, 100, 50, 0, 25, 0, 25);

    fill(255, 165, 0);
    noStroke();
    quad(0, 0, -30, -15, -30, 65, 0, 50);

    fill(255);
    stroke(0);
    circle(75, 15, 15);
    fill(0);
    circle(78, 15, 5);

    fill(255, 100, 100);
    stroke(150, 50, 50);
    arc(85, 35, 15, 15, 0.2, PI - 0.2, CHORD);
    
    fill(255, 200, 0, 150);
    noStroke();
    for (int i = 0; i < 3; i++) {
      float scaleX = 20 + i * 20;
      circle(scaleX, 15, 12);
      circle(scaleX + 10, 35, 12);
    }

    popMatrix();
  }
  
  void updatePosition() {
    float ax = map(noise(noiseOffsetX), 0, 1, -0.1, 0.1);
    float ay = map(noise(noiseOffsetY), 0, 1, -0.1, 0.1);
    acceleration = new PVector(ax, ay);
    
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    
    noiseOffsetX += 0.01;
    noiseOffsetY += 0.01;
  }
  
  void checkEdges() {
    if (location.x > width) {
      location.x = -creatureWidth;
    } else if (location.x < -creatureWidth) {
      location.x = width;
    }
    
    if (location.y > height) {
      location.y = -creatureHeight;
    } else if (location.y < -creatureHeight) {
      location.y = height;
    }
  }
}
