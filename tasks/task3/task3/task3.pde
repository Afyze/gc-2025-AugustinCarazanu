/*
Augustin Carazanu
FAF-243
*/

PImage img;
ArrayList<CoverShape> shapes;

void setup() {
  size(800, 600);
  
  // 1. load the image
  img = loadImage("house.jpg");
  
  // face resize la imagine ca sa incapa pe ecran
  if (img != null) {
    img.resize(width, height);
  } else {
    println("error: house.jpg not found. trebuie sa fie in folderul fisierului.");
  }
  
  // 2. initialize the list of shapes
  shapes = new ArrayList<CoverShape>();
  
  // 3. create the shapes based on the specific coordinates
  createHouseShapes();
  
  textSize(24);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(255);
  
  // 1. draw the background image first
  if (img != null) {
    imageMode(CORNER);
    image(img, 0, 0);
  }
  
  // 2. draw the cover shapes (windows, door, roof) on top
  for (CoverShape s : shapes) {
    s.display();
  }
  
  // 3. draw decorative elements (grass)
  drawDecorativeGrass();
  
  // 4. draw the flying kite
  drawKite();
}

void mousePressed() {
  // check if any shape was clicked to reveal it
  for (CoverShape s : shapes) {
    if (s.isClicked(mouseX, mouseY)) {
      s.reveal();
    }
  }
}

// ==========================================
//        helper functions for shapes
// ==========================================

void createHouseShapes() {
  // we use helper functions to convert center/width/height into vertex points
  // this satisfies the "vertex" requirement while keeping your coordinates.

  // shape 1: roof (triangle)

  addTriangleShape(width/2, 150, 300, 150, 1);

  // shape 2: top left window
  addRectShape(200, 280, 80, 50, 2);
  
  // shape 3: top middle window
  addRectShape(400, 280, 80, 50, 3);
  
  // shape 4: top right window
  addRectShape(600, 280, 80, 50, 4);
  
  // shape 5: bottom left window
  addRectShape(200, 450, 100, 60, 5);
  
  // shape 6: bottom right window
  addRectShape(600, 450, 100, 60, 6);
  
  // shape 7: door
  addRectShape(400, 500, 60, 100, 7);
}

// helper to create a rectangle using vertices (for the kite code style)
void addRectShape(float x, float y, float w, float h, int id) {
  CoverShape s = new CoverShape(id, color(100, 150, 200)); // blue-ish
  // calculate corners based on center x/y
  float left = x - w/2;
  float right = x + w/2;
  float top = y - h/2;
  float bottom = y + h/2;
  
  s.addPoint(left, top);
  s.addPoint(right, top);
  s.addPoint(right, bottom);
  s.addPoint(left, bottom);
  shapes.add(s);
}

// helper to create a triangle using vertices
void addTriangleShape(float x, float y, float w, float h, int id) {
  CoverShape s = new CoverShape(id, color(200, 100, 100)); // red-ish
  // calculate corners
  s.addPoint(x, y - h);          // top
  s.addPoint(x + w/2, y + h/2);  // bottom right
  s.addPoint(x - w/2, y + h/2);  // bottom left
  shapes.add(s);
}

// ==========================================
//        decoration and kite logic
// ==========================================

void drawKite() {
  pushMatrix();
  translate(650, 100); 
  
  // rotate based on time (wind effect)
  float angle = sin(millis() / 500.0) * 0.2; 
  rotate(angle);
  
  stroke(0);
  strokeWeight(2);
  fill(255, 255, 0); // yellow kite
  
  // drawing the kite (stylized shape)
  beginShape(); 
  vertex(0, -40);   
  vertex(30, 40);   
  vertex(10, 10);   
  vertex(-10, 10);  
  vertex(-30, 40);  
  endShape(CLOSE);  
  
  // kite tail
  stroke(100);
  noFill();
  bezier(0, 40, 10, 80, -20, 100, 0, 140);
  
  popMatrix();
}

void drawDecorativeGrass() {
  noStroke();
  fill(50, 180, 50, 150); // semi-transparent green
  
  beginShape(TRIANGLE_STRIP);
  for (int x = 0; x <= width; x += 40) {
    vertex(x, height);           // base
    vertex(x + 20, height - 30); // tip of grass
  }
  endShape();
}

// ==========================================
//            class definition
// ==========================================

class CoverShape {
  int id;
  color col;
  boolean revealed = false;
  ArrayList<PVector> vertices;
  
  // bounding box for accurate clicking
  float minX = 10000, maxX = -10000, minY = 10000, maxY = -10000;
  
  CoverShape(int id, color col) {
    this.id = id;
    this.col = col;
    this.vertices = new ArrayList<PVector>();
  }
  
  void addPoint(float x, float y) {
    vertices.add(new PVector(x, y));
    // update bounding box for collision detection
    if(x < minX) minX = x;
    if(x > maxX) maxX = x;
    if(y < minY) minY = y;
    if(y > maxY) maxY = y;
  }
  
  void display() {
    if (!revealed) {
      fill(col);
      stroke(0);
      strokeWeight(2);
      
      // draw using vertices (requirement)
      beginShape();
      float centerX = 0;
      float centerY = 0;
      
      for (PVector v : vertices) {
        vertex(v.x, v.y);
        centerX += v.x;
        centerY += v.y;
      }
      endShape(CLOSE);
      
      // draw number id
      if (vertices.size() > 0) {
        centerX /= vertices.size(); // average position for text center
        centerY /= vertices.size();
        
        fill(255);
        text(id, centerX, centerY);
      }
    }
  }
  
  void reveal() {
    revealed = true;
  }
  
  // accurate collision detection using bounding box
  boolean isClicked(float mx, float my) {
    if (revealed) return false;
    
    // check if mouse is inside the rectangular bounds of the shape
    if (mx > minX && mx < maxX && my > minY && my < maxY) {
      return true;
    }
    return false;
  }
}
