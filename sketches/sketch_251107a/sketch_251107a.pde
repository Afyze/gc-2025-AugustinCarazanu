import processing.core.PApplet;
import processing.core.PVector;

// Create an array to hold 9 creature objects
Creature[] school = new Creature[9];

public void settings() {
  size(800, 600);
}

public void setup() {
  // Initialize the array with 9 creatures
  for (int i = 0; i < school.length; i++) {
    school[i] = new Creature(i);
  }
}

public void draw() {
  background(220, 245, 255);
  
  // Loop through the entire array
  for (int i = 0; i < school.length; i++) {
    school[i].updatePosition(); // Update physics (accel, vel, loc)
    school[i].checkEdges();     // Check if it's off-screen
    school[i].display();        // Draw the creature
  }
}

// ======================================================
// Creature Class
// ======================================================
class Creature {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float creatureWidth = 130;
  float creatureHeight = 50;
  float maxSpeed;
  
  float noiseOffsetX;
  float noiseOffsetY;

  // --- Constructor ---
  Creature(int index) {
    float startX = width - creatureWidth;
    float startY = height - creatureHeight - 20 - (index * (creatureHeight + 10));
    
    location = new PVector(startX, startY);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    
    maxSpeed = random(2.0, 3.5);
    
    noiseOffsetX = random(0, 1000);
    noiseOffsetY = random(10000, 11000);
  }

  /**
   * Draw the creature at its location.
   */
  void display() {
    pushMatrix();
    translate(location.x, location.y);

    // 1. Body: rectangle with equal rounded opposite corners
    fill(80, 150, 255);
    stroke(50, 100, 200);
    strokeWeight(2);
    rect(0, 0, 100, 50, 0, 25, 0, 25);

    // 2. Tail: quad
    fill(255, 165, 0);
    noStroke();
    quad(0, 0, -30, -15, -30, 65, 0, 50);

    // 3. Eye: circle
    fill(255);
    stroke(0);
    circle(75, 15, 15);
    fill(0);
    circle(78, 15, 5);

    // 4. Mouth: arc (using CHORD mode)
    fill(255, 100, 100);
    stroke(150, 50, 50);
    arc(85, 35, 15, 15, 0.2, PI - 0.2, CHORD);
    
    // Decoration (Scales): for loop with circles
    fill(255, 200, 0, 150);
    noStroke();
    for (int i = 0; i < 3; i++) {
      float scaleX = 20 + i * 20;
      circle(scaleX, 15, 12);
      circle(scaleX + 10, 35, 12);
    }

    popMatrix();
  }

  /**
   * Update position using Perlin noise acceleration.
   */
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
