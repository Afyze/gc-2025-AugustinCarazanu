/*
Augustin Carazanu
FAF-243
Variant 1
*/
PImage bg;
Attractor attractor;
Liquid liquid;
ArrayList<Creature> creatures;

int NUM_CREATURES = 18;

void setup() {
  size(900, 700); 
  smooth();
  bg = loadImage("background.jpg");
  if (bg != null) {
    bg.resize(width, height);
  }
  
  // Atractorul localizat aproximativ unde va fi desenata litera A in buzunarul de sus
  PVector aLoc = new PVector(width/2, height*0.28); // centrul buzunarului de sus
  float aMass = 700; // cat de puternic este atractorul
  attractor = new Attractor(aLoc, aMass);
  
  // lichidul in dreptunghiul buzunarului de jos y mai mare sau egal cu jumatatea inaltimii
  liquid = new Liquid(0.6, height/2, height); // coeficient de rezistenta y sus y jos
  
  // creeaza creaturi un amestec de tipuri TRIANGLE_FAN si QUAD_STRIP
  creatures = new ArrayList<Creature>();
  for (int i = 0; i < NUM_CREATURES; i++) {
    float x = random(width);
    float y = random(height/2 - 20); // apar mai ales in jumatatea de sus pentru a vedea atractia
    float m = random(3, 12);
    if (i % 2 == 0) {
      creatures.add(new CreatureFan(new PVector(x,y), m));
    } else {
      creatures.add(new CreatureStrip(new PVector(x,y), m));
    }
  }
}

void draw() {
  // deseneaza fundalul
  if (bg != null) {
    image(bg, 0, 0);
  } else {
    for (int y=0; y<height; y++) {
      float t = map(y, 0, height, 0, 1);
      int c = lerpColor(color(30, 60, 120), color(200, 230, 255), t);
      stroke(c);
      line(0, y, width, y);
    }
  }
  
  // deseneaza separatorul buzunarelor
  noStroke();
  fill(0, 30);
  rect(0, height/2 - 2, width, 4);
  
  // deseneaza litera A in buzunarul de sus folosind beginShape si vertex
  pushMatrix();
  drawLetterA(width/2, height*0.28, min(width*0.4f, 350), min(height*0.35f, 250));
  popMatrix();
  
  // deseneaza zona lichida a buzunaruluiefect de apa
  pushStyle();
  noStroke();
  fill(10, 60, 120, 120);
  rect(0, height/2, width, height/2);
  popStyle();
  
  // actualizeaza si afiseaza creaturile
  for (Creature c : creatures) {
    // Daca creatura este in buzunarul de sus unde este litera aplica forta de atractie
    if (c.position.y < height/2) {
      PVector force = attractor.attract(c); // forta calculata
      c.applyForce(force);
    }
    
    // Daca creatura este in buzunarul cu lichid aplica forta de rezistenta si o usoara flotabilitate
    if (liquid.contains(c.position)) {
      PVector drag = liquid.calculateDrag(c);
      c.applyForce(drag);
      // mica flotabilitate ascendenta proportionala cu masa astfel incat cele grele se scufunda mai repede
      PVector buoy = new PVector(0, -0.12f * c.mass);
      c.applyForce(buoy);
    } else {
      // gravitatie cand nu este in lichid
      PVector g = new PVector(0, 0.25f * c.mass);
      c.applyForce(g);
    }
    
    c.update();
    c.edges();
    c.display();
  }
  
  // vizualizare atractor optional
  attractor.display();
}


// aici deja deseneaza litera A folosind beginShape plus vertex poligon personalizat
void drawLetterA(float cx, float cy, float wA, float hA) {
  // calculeaza un poligon de forma A centrat la cx cy
  float halfW = wA/2;
  float halfH = hA/2;
  // coordonate cam relative la centru
  PVector top = new PVector(cx, cy - halfH);
  PVector left = new PVector(cx - halfW + wA*0.12f, cy + halfH);
  PVector right = new PVector(cx + halfW - wA*0.12f, cy + halfH);
  PVector crossL = new PVector(cx - wA*0.12f, cy + hA*0.05f);
  PVector crossR = new PVector(cx + wA*0.12f, cy + hA*0.05f);
  
  stroke(255, 220);
  strokeWeight(4);
  fill(255, 120);
  
  // forma exterioara a literei A ca un poligon folosind beginShape
  beginShape();
  vertex(top.x, top.y);
  vertex(left.x, left.y);
  vertex(left.x + wA*0.08f, left.y);
  vertex(cx - wA*0.06f, cy + halfH*0.1f);
  vertex(crossL.x, crossL.y);
  vertex(cx - wA*0.02f, cy + halfH*0.05f);
  vertex(cx + wA*0.02f, cy + halfH*0.05f);
  vertex(crossR.x, crossR.y);
  vertex(cx + wA*0.06f, cy + halfH*0.1f);
  vertex(right.x - wA*0.08f, right.y);
  vertex(right.x, right.y);
  endShape(CLOSE);
  
  // taietura inauntru la gaura din A deseneaza poligon inversat pentru a fi distinct vizual
  noStroke();
  fill(0, 40);
  beginShape();
  vertex(cx - wA*0.12f, cy + hA*0.02f);
  vertex(cx - wA*0.02f, cy + halfH*0.08f);
  vertex(cx + wA*0.02f, cy + halfH*0.08f);
  vertex(cx + wA*0.12f, cy + hA*0.02f);
  vertex(cx, cy - hA*0.02f);
  endShape(CLOSE);
}


// Clasa Atractor locatie masa gravitatie forta calcul distanta
class Attractor {
  PVector loc;
  float mass;
  float G = 1.0f; // ajustare constanta gravitationala
  
  Attractor(PVector loc_, float mass_) {
    loc = loc_.copy();
    mass = mass_;
  }
  
  // calculeaza forta de atractie de tip gravitational catre acest atractor asupra unei creaturi
  PVector attract(Creature m) {
    PVector force = PVector.sub(loc, m.position);
    float distance = constrain(force.mag(), 5, 300);
    force.normalize();
    // magnitudinea gravitationala G inmultit cu m1 m2 impartit la d patrat
    float strength = (G * mass * m.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }
  
  void display() {
    // deseneaza un cerc slab in jurul atractorului
    pushStyle();
    noFill();
    stroke(255, 60);
    strokeWeight(1.5f);
    ellipse(loc.x, loc.y, 220, 220);
    // centru
    fill(255, 100);
    noStroke();
    ellipse(loc.x, loc.y, 8, 8);
    popStyle();
  }
}
// Clasa Lichid regiune cu gravitatie si rezistenta la inaintare
class Liquid {
  float c; // coeficient de rezistenta
  float topY, bottomY;
  
  Liquid(float coeff, float topY_, float bottomY_) {
    c = coeff;
    topY = topY_;
    bottomY = bottomY_;
  }
  
  boolean contains(PVector p) {
    return p.y >= topY && p.y <= bottomY;
  }
  
  // calculeaza forta de rezistenta simplificata bazata pe viteza inversa si coeficient
  PVector calculateDrag(Creature m) {
    PVector v = m.velocity.copy();
    float speed = v.mag();
    if (speed == 0) return new PVector(0, 0);
    PVector drag = v.copy();
    drag.normalize();
    drag.mult(-1);
    float dragMagnitude = c * speed * speed * (m.mass * 0.01f);
    drag.mult(dragMagnitude);
    return drag;
  }
}
// Clasa parinte Creatura
abstract class Creature {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r; // factor de marime vizuala
  int baseColor;
  float phase; // pentru oscilatie
  
  Creature(PVector pos, float m) {
    position = pos.copy();
    mass = m;
    r = mass * 2;
    velocity = new PVector(random(-1,1), random(-1,1));
    acceleration = new PVector();
    baseColor = color(random(60, 255), random(60,255), random(60,255), 200);
    phase = random(TWO_PI);
  }
  
  void applyForce(PVector f) {
    // Formula Forta egal cu masa inmultit cu acceleratia deci acceleratia egal cu Forta impartit la masa
    PVector a = PVector.div(f, mass);
    acceleration.add(a);
  }
  
  void update() {
    // fizica simpla
    velocity.add(acceleration);
    position.add(velocity);
    // amortizare pentru a reduce viteza excesiva
    velocity.mult(0.995f);
    acceleration.mult(0);
    // mica oscilatie plutire
    phase += 0.02f + 0.002f * mass;
  }
  
  void edges() {
    // infasoara orizontal ricosaza usor in buzunarele de sus si jos
    if (position.x > width + r) position.x = -r;
    if (position.x < -r) position.x = width + r;
    if (position.y < 0) {
      position.y = 0;
      velocity.y *= -0.6;
    }
    if (position.y > height) {
      position.y = height;
      velocity.y *= -0.6;
    }
  }
  
  abstract void display();
}

// ----------------------------
// Copil Creatura deseneaza folosind TRIANGLE_FAN
// ----------------------------
class CreatureFan extends Creature {
  CreatureFan(PVector pos, float m) {
    super(pos, m);
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    float wob = sin(phase*1.5f) * (r*0.4f);
    float size = r + wob;
    noStroke();
    // varianta de culoare aleatorie
    fill(red(baseColor)+sin(phase)*20, green(baseColor)+cos(phase)*20, blue(baseColor)+sin(phase*0.5f)*20, 210);
    
    beginShape(TRIANGLE_FAN);
    vertex(0, 0); // centru
    int pts = 12;
    for (int i = 0; i <= pts; i++) {
      float ang = map(i, 0, pts, 0, TWO_PI);
      float rad = size * (0.6f + 0.4f * noise(i*0.1f + phase));
      float vx = cos(ang) * rad;
      float vy = sin(ang) * rad * (0.8f + 0.2f * sin(phase*0.8f + i));
      vertex(vx, vy);
    }
    endShape();
    
    // ochi sau reflexie
    fill(255, 200);
    ellipse(size*0.2f, -size*0.1f, max(2, r*0.25f), max(2, r*0.25f));
    popMatrix();
  }
}

// Copil Creatura deseneaza folosind QUAD_STRIP
class CreatureStrip extends Creature {
  CreatureStrip(PVector pos, float m) {
    super(pos, m);
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    float length = r * 2.8f;
    float baseWidth = r*0.8f;
    
    // schimbarea culorii
    fill(red(baseColor)-20, green(baseColor)+10, blue(baseColor)+40, 200);
    noStroke();
    
    int segments = 14;
    float freq = 0.7f;
    beginShape(QUAD_STRIP);
    for (int i = 0; i <= segments; i++) {
      float t = (float)i/segments;
      float x = t * length;
      float wave = sin(t*PI*2*freq + phase*1.4f) * (r*0.5f) * (1 - t);
      float w = baseWidth * (1 - t*0.7f);
      // doua varfuri pe pas pentru quad strip
      vertex(x, -w + wave);
      vertex(x, w + wave*0.7f);
    }
    endShape();
    
    // cap mic
    fill(255, 230);
    ellipse(0, 0, r*0.9f, r*0.9f);
    popMatrix();
  }
}
