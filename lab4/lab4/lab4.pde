import java.util.Iterator;

// --- global variables ---
ArrayList<Creature> population;
ArrayList<Food> foodSource;
ArrayList<ParticleSystem> systems;

void setup() {
  size(1000, 800); // (1000 width, 800 height for the window size)
  
  population = new ArrayList<Creature>();
  foodSource = new ArrayList<Food>();
  systems = new ArrayList<ParticleSystem>();
  
  // spawn initial prey 
  for (int i = 0; i < 15; i++) { // (15 is the starting number of seeker bugs)
    population.add(new Seeker(random(width), random(height)));
  }
  
  // spawn initial predators
  for (int i = 0; i < 2; i++) { // (2 is the starting number of hunters)
    population.add(new Hunter(random(width), random(height)));
  }
  
  // spawn initial food
  for (int i = 0; i < 30; i++) { // (30 is the amount of food pellets to start with)
    foodSource.add(new Food());
  }
}

void draw() {
  background(30); // (30 is a dark grey color for the background)
  
  // 1. manage food
  // randomly spawn new food occasionally
  if (random(1) < 0.05) { // (0.05 is a 5% chance every frame to spawn a new food item)
    foodSource.add(new Food());
  }
  for (Food f : foodSource) {
    f.display();
  }
  
  // 2. manage particle systems (visual fx)
  Iterator<ParticleSystem> psIt = systems.iterator();
  while (psIt.hasNext()) {
    ParticleSystem ps = psIt.next();
    ps.run();
    if (ps.isDead()) {
      psIt.remove(); // (removes the system from the list if all particles are gone)
    }
  }

  // temporary list to hold new babies born this frame
  // this prevents concurrentmodificationexception
  ArrayList<Creature> born = new ArrayList<Creature>();

  // 3. manage creatures (polymorphism in action)
  Iterator<Creature> it = population.iterator();
  while (it.hasNext()) {
    Creature c = it.next();
    
    // --- behaviors ---
    c.behave(foodSource, population);
    c.update();
    c.display();
    
    // --- reproduction ---
    // if healthy enough, small chance to reproduce
    // (200 is the health threshold needed to have a baby)
    // (0.005 is a 0.5% chance per frame to reproduce if healthy enough)
    if (c.health > 200 && random(1) < 0.005) {
      // create a copy and add to the temp 'born' list
      born.add(c.cloneCreature()); 
      c.health -= 50; // (50 is the energy cost to the parent for having a baby)
    }
    
    // --- death ---
    if (c.isDead()) {
      it.remove(); // safe removal via iterator
      // add a death particle effect
      // (100 is a grey color for the death cloud)
      systems.add(new ParticleSystem(c.location, color(100))); 
    }
  }
  
  // add all the babies to the main population now that the loop is done
  population.addAll(born);
}

// ==========================================
// class hierarchy
// ==========================================

// --- base class: creature ---
abstract class Creature {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxForce;
  float maxSpeed;
  float r; // radius size of the creature
  float health;
  
  Creature(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    health = 100; // (100 is the starting health for all creatures)
  }
  
  // standard euler integration
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed); // (caps the velocity so they dont move too fast)
    location.add(velocity);
    acceleration.mult(0); // reset accel for the next frame
    
    // health decays over time (metabolism)
    health -= 0.2; // (0.2 is the amount of health lost every single frame just by existing)
    
    borders();
  }
  
  void applyForce(PVector force) {
    // f = m * a (assuming mass = 1 for simplicity)
    acceleration.add(force);
  }
  
  // wraparound borders
  void borders() {
    // (checks if x is less than negative radius to wrap to the right side)
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
  
  // reynolds steering formula: steer = desired - velocity
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce); // (limits how sharp the turn can be)
    return steer;
  }
  
  boolean isDead() {
    return (health <= 0); // (returns true if health drops to zero or below)
  }
  
  // abstract methods forcing subclasses to implement specific logic
  abstract void display();
  abstract void behave(ArrayList<Food> food, ArrayList<Creature> others);
  abstract Creature cloneCreature();
}

// --- subclass 1: seeker (the "bug" with oscillating wings) ---
class Seeker extends Creature {
  float wingAngle = 0;
  
  Seeker(float x, float y) {
    super(x, y);
    maxSpeed = 4; // (4 pixels per frame is the top speed)
    maxForce = 0.1; // (0.1 is the turning ability/agility)
    r = 6; // (6 pixels is the radius of the body)
    health = 100;
  }
  
  void behave(ArrayList<Food> food, ArrayList<Creature> others) {
    // 1. find food
    PVector steer = new PVector(0,0);
    float closestDist = Float.MAX_VALUE;
    Food closestFood = null;
    
    // find closest food
    for (int i = food.size()-1; i >= 0; i--) {
      Food f = food.get(i);
      float d = PVector.dist(location, f.location);
      
      // eat if close enough
      if (d < r + f.r) { // (checks if the circles overlap)
        health += 40; // (40 is the health gained by eating one food pellet)
        // (color(0, 255, 0) is green for the particle burst)
        systems.add(new ParticleSystem(f.location, color(0, 255, 0))); 
        food.remove(i);
      } else if (d < closestDist) {
        closestDist = d;
        closestFood = f;
      }
    }
    
    // seek closest food
    if (closestFood != null) {
      steer = seek(closestFood.location);
      applyForce(steer);
    }
    
    // 2. avoid predators (separate logic)
    for (Creature c : others) {
      if (c instanceof Hunter) {
        float d = PVector.dist(location, c.location);
        if (d < 100) { // (100 pixels is the danger zone radius)
          PVector flee = PVector.sub(location, c.location);
          flee.setMag(maxSpeed * 2); // (multiplies speed by 2 to sprint away in panic)
          PVector fleeSteer = PVector.sub(flee, velocity);
          fleeSteer.limit(maxForce * 2);
          applyForce(fleeSteer);
        }
      }
    }
  }

  void display() {
    // oscillation logic: speed determines flapping rate
    // if moving fast, flap fast. if stopped, wings rest.
    float flapSpeed = velocity.mag() * 0.2; // (0.2 scales the flap speed relative to movement speed)
    wingAngle += flapSpeed; 
    
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading() + PI/2); // (rotate canvas to face the direction of movement)
    
    // (health * 2 controls the alpha transparency, so they fade out as they die)
    fill(200, 200, 255, health * 2); 
    stroke(255);
    
    // draw body
    ellipse(0, 0, r*2, r*3);
    
    // draw oscillating wings
    // we use sin(wingAngle) to make them flap in and out
    // (map converts the sine wave -1 to 1 into pixel wing extension values)
    float wingExt = map(sin(wingAngle), -1, 1, r, r*3);
    
    // left wing
    triangle(-r/2, 0, -wingExt, -r, -r/2, -r*1.5);
    // right wing
    triangle(r/2, 0, wingExt, -r, r/2, -r*1.5);
    
    popMatrix();
  }
  
  Creature cloneCreature() {
    return new Seeker(location.x, location.y);
  }
}

// --- subclass 2: hunter (the predator) ---
class Hunter extends Creature {
  
  Hunter(float x, float y) {
    super(x, y);
    maxSpeed = 5; // (5 pixels per frame, faster than the seeker prey)
    maxForce = 0.2; // (0.2 turning force, slightly more agile)
    r = 12; // (12 pixel radius, bigger than prey)
    health = 150; // (starts with 150 health, stronger than prey)
  }
  
  void behave(ArrayList<Food> food, ArrayList<Creature> others) {
    float closestDist = Float.MAX_VALUE;
    Creature target = null;
    
    // look for prey
    for (Creature c : others) {
      if (c instanceof Seeker) {
        float d = PVector.dist(location, c.location);
        
        // eat prey
        if (d < r + c.r) {
          health += 60; // (60 health gained for eating a bug)
          c.health = -1; // (sets prey health to -1 to kill it instantly)
          // (color(255, 0, 0) is red for the blood particle effect)
          systems.add(new ParticleSystem(c.location, color(255, 0, 0))); 
        } else if (d < 200 && d < closestDist) { // (200 pixels is the vision radius)
          closestDist = d;
          target = c;
        }
      }
    }
    
    if (target != null) {
      applyForce(seek(target.location));
    } else {
      // if no prey visible, wander randomly
      PVector wander = PVector.random2D(); 
      wander.mult(0.5); // (0.5 force for wandering gently)
      applyForce(wander);
    }
  }
  
  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading() + PI/2);
    
    fill(255, 50, 50, health); // (alpha is tied to health)
    noStroke();
    
    // triangle shape for predator
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r);
    vertex(r, r);
    endShape(CLOSE);
    
    popMatrix();
  }
  
  Creature cloneCreature() {
    return new Hunter(location.x, location.y);
  }
}

// --- environment: food ---
class Food {
  PVector location;
  float r;
  
  Food() {
    location = new PVector(random(width), random(height));
    r = 4; // (4 pixel radius for the food dot)
  }
  
  void display() {
    fill(100, 255, 100); // (bright green color)
    noStroke();
    ellipse(location.x, location.y, r*2, r*2);
  }
}

// --- particle system (for eating effects) ---
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  
  ParticleSystem(PVector location, int c) {
    origin = location.copy();
    particles = new ArrayList<Particle>();
    // spawn a burst
    for (int i = 0; i < 10; i++) { // (10 particles created per burst)
      particles.add(new Particle(origin, c));
    }
  }
  
  void run() {
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
  
  boolean isDead() {
    return particles.isEmpty();
  }
}

class Particle {
  PVector loc;
  PVector vel;
  float lifespan;
  int col;
  
  Particle(PVector l, int c) {
    loc = l.copy();
    vel = PVector.random2D();
    vel.mult(random(0.5, 2)); // (random speed between 0.5 and 2)
    lifespan = 255.0; // (255 is the starting opacity)
    col = c;
  }
  
  void run() {
    loc.add(vel);
    lifespan -= 5.0; // (5.0 is the fade out speed per frame)
    
    noStroke();
    fill(red(col), green(col), blue(col), lifespan);
    ellipse(loc.x, loc.y, 4, 4);
  }
  
  boolean isDead() {
    return lifespan < 0; // (checks if the particle has faded out completely)
  }
}
