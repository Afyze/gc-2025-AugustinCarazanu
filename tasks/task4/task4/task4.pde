import peasy.*;

// ==================== global variables ====================
PeasyCam cam;
int mode = 1;  // 1 = part i, 2 = part ii (obj), 3 = part iii (custom 3d)

// part i variables
float rotX = 0, rotY = 0;
PImage boxTexture;

// part ii variables
PShape objModel;
float objAngle = 0;

// part iii variables
float part3Angle = 0;

// ==================== setup ====================
void setup() {
  size(900, 700, P3D); // canvas size (width: 900, height: 700, renderer: 3d)
  
  // initialize peasycam
  cam = new PeasyCam(this, 400); // create camera (look at distance: 400)
  cam.setMinimumDistance(100);   // set minimum zoom limit (100)
  cam.setMaximumDistance(1000);  // set maximum zoom limit (1000)
  
  // load textures (place these in your 'data' folder if you want)
  // boxTexture = loadImage("texture.jpg");
  
  // part ii: load obj model (place your .obj file in 'data' folder)
  // objModel = loadShape("model.obj");
  
  textureMode(NORMAL);
}

// ==================== main draw loop ====================
void draw() {
  background(30, 30, 45); // dark blue background color (red: 30, green: 30, blue: 45)
  
  // setup lighting for all modes
  setupLighting();
  
  // draw based on current mode
  switch (mode) {
    case 1:
      drawPartI();
      break;
    case 2:
      drawPartII();
      break;
    case 3:
      drawPartIII();
      break;
  }
  
  // draw hud (disable camera for 2d overlay)
  cam.beginHUD();
  drawHUD();
  cam.endHUD();
}

// ==================== lighting setup ====================
void setupLighting() {
  ambientLight(60, 60, 60); // soft general light (red: 60, green: 60, blue: 60)
  pointLight(255, 255, 255, 200, -200, 200); // bright white light (color: 255, 255, 255) at position (x: 200, y: -200, z: 200)
  pointLight(150, 150, 200, -200, 200, -200); // dimmer blue light (color: 150, 150, 200) at position (x: -200, y: 200, z: -200)
  
  // material properties
  ambient(100, 100, 100);   // material interaction with ambient light (rgb: 100)
  specular(255, 255, 255);  // highlight color (white: 255)
  shininess(30);            // surface glossiness (value: 30)
}

// ==================== part i: box, sphere & custom shapes ====================
void drawPartI() {
  // update rotation with framecount for animation
  rotX += 0.01;  // increase x rotation speed (value: 0.01)
  rotY += 0.015; // increase y rotation speed (value: 0.015)
  
  // ----- box -----
  pushMatrix();
  translate(-150, 0, 0); // move left on x axis (distance: -150)
  rotateX(rotX);
  rotateY(rotY);
  fill(255, 100, 100);   // red color (r: 255, g: 100, b: 100)
  stroke(0);             // black outline (color: 0)
  strokeWeight(1);       // line thickness (width: 1)
  box(80);               // draw cube (size: 80)
  popMatrix();
  
  // ----- sphere -----
  pushMatrix();
  translate(150, 0, 0);      // move right on x axis (distance: 150)
  rotateX(rotX * 0.8);       // rotate x slower (multiplier: 0.8)
  rotateY(rotY * 1.2);       // rotate y faster (multiplier: 1.2)
  fill(100, 150, 255);       // blue color (r: 100, g: 150, b: 255)
  noStroke();
  sphereDetail(30);          // set sphere smoothness (resolution: 30)
  sphere(50);                // draw sphere (radius: 50)
  popMatrix();
  
  // ----- custom shape: pyramid using beginshape() -----
  pushMatrix();
  translate(0, 0, 0);        // center position
  rotateX(rotX);
  rotateY(rotY);
  rotateZ(rotX * 0.5);       // rotate z (multiplier: 0.5)
  drawPyramid(70);           // call custom function (size: 70)
  popMatrix();
  
  // ----- custom shape: star using triangle_fan -----
  pushMatrix();
  translate(0, -150, 0);     // move up on y axis (distance: -150)
  rotateY(rotY * 2);         // spin fast (multiplier: 2)
  drawStar3D(40, 20, 30);    // call star function (outer radius: 40, inner radius: 20, depth: 30)
  popMatrix();
  
  // ----- custom shape: prism using quad_strip -----
  pushMatrix();
  translate(0, 150, 0);      // move down on y axis (distance: 150)
  rotateX(rotX);
  rotateY(rotY);
  drawPrism(40, 80);         // call prism function (radius: 40, height: 80)
  popMatrix();
}

// ==================== custom shape: pyramid (triangles) ====================
void drawPyramid(float size) {
  float s = size / 2; // half size offset
  float h = size;     // full height
  
  fill(100, 255, 150); // green color (r: 100, g: 255, b: 150)
  stroke(0);
  strokeWeight(1);
  
  // base using quads
  beginShape(QUADS);
  vertex(-s, 0, -s);
  vertex(s, 0, -s);
  vertex(s, 0, s);
  vertex(-s, 0, s);
  endShape();
  
  // sides using triangles
  beginShape(TRIANGLES);
  
  // front
  fill(100, 255, 150);
  vertex(0, -h, 0);
  vertex(-s, 0, s);
  vertex(s, 0, s);
  
  // right
  fill(80, 220, 130);
  vertex(0, -h, 0);
  vertex(s, 0, s);
  vertex(s, 0, -s);
  
  // back
  fill(60, 200, 110);
  vertex(0, -h, 0);
  vertex(s, 0, -s);
  vertex(-s, 0, -s);
  
  // left
  fill(80, 220, 130);
  vertex(0, -h, 0);
  vertex(-s, 0, -s);
  vertex(-s, 0, s);
  
  endShape();
}

// ==================== custom shape: 3d star (triangle_fan) ====================
void drawStar3D(float outerR, float innerR, float depth) {
  fill(255, 220, 100); // yellow color (r: 255, g: 220, b: 100)
  stroke(0);
  strokeWeight(1);
  
  int points = 5; // number of star points (5)
  float angleStep = TWO_PI / points;
  
  // top point
  beginShape(TRIANGLE_FAN);
  vertex(0, -depth, 0);
  for (int i = 0; i <= points * 2; i++) {
    float angle = i * angleStep / 2 - HALF_PI;
    float r = (i % 2 == 0) ? outerR : innerR; // alternate radius for star shape
    vertex(cos(angle) * r, 0, sin(angle) * r);
  }
  endShape();
  
  // bottom point
  beginShape(TRIANGLE_FAN);
  vertex(0, depth, 0);
  for (int i = points * 2; i >= 0; i--) {
    float angle = i * angleStep / 2 - HALF_PI;
    float r = (i % 2 == 0) ? outerR : innerR;
    vertex(cos(angle) * r, 0, sin(angle) * r);
  }
  endShape();
}

// ==================== custom shape: prism (quad_strip) ====================
void drawPrism(float radius, float height) {
  int sides = 6; // hexagon (sides: 6)
  float angleStep = TWO_PI / sides;
  
  fill(255, 150, 200); // pink color (r: 255, g: 150, b: 200)
  stroke(0);
  strokeWeight(1);
  
  // side faces using quad_strip
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= sides; i++) {
    float angle = i * angleStep;
    float x = cos(angle) * radius;
    float z = sin(angle) * radius;
    vertex(x, -height/2, z);
    vertex(x, height/2, z);
  }
  endShape();
  
  // top face using triangle_fan
  beginShape(TRIANGLE_FAN);
  vertex(0, -height/2, 0);
  for (int i = 0; i <= sides; i++) {
    float angle = i * angleStep;
    vertex(cos(angle) * radius, -height/2, sin(angle) * radius);
  }
  endShape();
  
  // bottom face using triangle_fan
  beginShape(TRIANGLE_FAN);
  vertex(0, height/2, 0);
  for (int i = sides; i >= 0; i--) {
    float angle = i * angleStep;
    vertex(cos(angle) * radius, height/2, sin(angle) * radius);
  }
  endShape();
}

// ==================== part ii: obj file ====================
void drawPartII() {
  objAngle += 0.01; // increase rotation speed (0.01)
  
  pushMatrix();
  rotateY(objAngle);
  rotateX(PI/6); // tilt model (30 degrees)
  
  if (objModel != null) {
    // scale and display the loaded obj model
    scale(2); // double size (factor: 2)
    shape(objModel);
  } else {
    // placeholder if no obj loaded
    fill(255, 200, 100);
    noStroke();
    
    rotateX(objAngle * 0.5);
    box(100, 60, 80); // placeholder box (w: 100, h: 60, d: 80)
    
    // extra sphere just for visual interest
    pushMatrix();
    translate(0, 100, 0); // move down (distance: 100)
    sphere(30);           // small sphere (radius: 30)
    popMatrix();
  }
  popMatrix();
}

// ==================== part iii: custom "advanced" 3d shapes ====================
void drawPartIII() {
  part3Angle += 0.01; // increment angle (0.01)
  
  // ----- ellipsoid (scaled sphere) -----
  pushMatrix();
  translate(-150, -50, 0); // position (x: -150, y: -50)
  rotateY(part3Angle * 1.2);
  fill(180, 220, 255);
  noStroke();
  scale(1.2, 0.8, 1.0);  // scale differently on each axis (x: 1.2, y: 0.8, z: 1.0)
  sphere(50);            // draw sphere (base radius: 50)
  popMatrix();
  
  // ----- cone (manually built) -----
  pushMatrix();
  translate(150, -50, 0); // position (x: 150, y: -50)
  rotateX(-HALF_PI);      // rotate to stand upright
  rotateZ(part3Angle);
  drawCone(40, 90, 40);   // custom cone (radius: 40, height: 90, segments: 40)
  popMatrix();
  
  // ----- tube (cylinder with hole) -----
  pushMatrix();
  translate(-150, 120, 0); // position (x: -150, y: 120)
  rotateX(-HALF_PI);
  rotateZ(part3Angle * 1.5);
  drawTube(20, 35, 80, 40); // custom tube (inner r: 20, outer r: 35, height: 80, segments: 40)
  popMatrix();
  
  // ----- extrusion-like shape (prism extruded from a 2d footprint) -----
  pushMatrix();
  translate(150, 120, 0); // position (x: 150, y: 120)
  rotateY(part3Angle * 0.8);
  drawExtrudedBuilding(60, 80); // custom extrusion (radius: 60, height: 80)
  popMatrix();
}

// ========== custom: cone ==========
// cone with base at y=0, tip at y=-h
void drawCone(float r, float h, int segments) {
  fill(255, 200, 120);
  stroke(0);
  strokeWeight(1);
  
  float angleStep = TWO_PI / segments;
  
  // side faces (triangle fan)
  beginShape(TRIANGLE_FAN);
  // tip
  vertex(0, -h, 0);
  for (int i = 0; i <= segments; i++) {
    float a = i * angleStep;
    float x = cos(a) * r;
    float z = sin(a) * r;
    vertex(x, 0, z);
  }
  endShape();
  
  // base (circle)
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, 0);
  for (int i = 0; i <= segments; i++) {
    float a = i * angleStep;
    float x = cos(a) * r;
    float z = sin(a) * r;
    vertex(x, 0, z);
  }
  endShape();
}

// ========== custom: tube (cylinder with hole) ==========
void drawTube(float innerR, float outerR, float h, int segments) {
  float angleStep = TWO_PI / segments;
  
  fill(180, 100, 255);
  stroke(0);
  strokeWeight(1);
  
  // outer wall
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= segments; i++) {
    float a = i * angleStep;
    float x = cos(a);
    float z = sin(a);
    vertex(x * outerR, -h/2, z * outerR);
    vertex(x * outerR,  h/2, z * outerR);
  }
  endShape();
  
  // inner wall
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= segments; i++) {
    float a = i * angleStep;
    float x = cos(a);
    float z = sin(a);
    vertex(x * innerR,  h/2, z * innerR);
    vertex(x * innerR, -h/2, z * innerR);
  }
  endShape();
  
  // top ring
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= segments; i++) {
    float a = i * angleStep;
    float x = cos(a);
    float z = sin(a);
    vertex(x * innerR, -h/2, z * innerR);
    vertex(x * outerR, -h/2, z * outerR);
  }
  endShape();
  
  // bottom ring
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= segments; i++) {
    float a = i * angleStep;
    float x = cos(a);
    float z = sin(a);
    vertex(x * outerR, h/2, z * outerR);
    vertex(x * innerR, h/2, z * innerR);
  }
  endShape();
}

// ========== custom: extrusion-like building ==========
void drawExtrudedBuilding(float radius, float height) {
  // hexagon-like footprint extruded in y
  int sides = 6;
  float angleStep = TWO_PI / sides;
  
  fill(200, 200, 200);
  stroke(40);
  strokeWeight(1);
  
  // side faces
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= sides; i++) {
    float a = i * angleStep;
    float x = cos(a) * radius;
    float z = sin(a) * radius;
    vertex(x, -height/2, z);
    vertex(x,  height/2, z);
  }
  endShape();
  
  // top
  beginShape(TRIANGLE_FAN);
  vertex(0, -height/2, 0);
  for (int i = 0; i <= sides; i++) {
    float a = i * angleStep;
    vertex(cos(a) * radius, -height/2, sin(a) * radius);
  }
  endShape();
  
  // bottom
  beginShape(TRIANGLE_FAN);
  vertex(0, height/2, 0);
  for (int i = sides; i >= 0; i--) {
    float a = i * angleStep;
    vertex(cos(a) * radius, height/2, sin(a) * radius);
  }
  endShape();
}

// ==================== hud (heads-up display) ====================
void drawHUD() {
  fill(255);
  textSize(16); // set font size (16)
  textAlign(LEFT, TOP);
  
  String modeText = "";
  switch (mode) {
    case 1: modeText = "PART I: Box, Sphere & Custom Shapes (beginShape)"; break;
    case 2: modeText = "PART II: OBJ File Loading"; break;
    case 3: modeText = "PART III: Custom 3D Shapes (ellipsoid, cone, tube, extrusion)"; break;
  }
  
  // background panel
  fill(0, 0, 0, 150); // semi transparent black (alpha: 150)
  noStroke();
  rect(10, 10, 460, 130, 10); // rounded rectangle (x: 10, y: 10, w: 460, h: 130, radius: 10)
  
  // text
  fill(255, 255, 100);
  textSize(18); // set title size (18)
  text("3D SHAPES - TASK 4 (NO Shape3D)", 20, 20); // (x: 20, y: 20)
  
  fill(255);
  textSize(14); // set body text size (14)
  text("Current Mode: " + modeText, 20, 50); // (y: 50)
  text("Press 1, 2, 3 to switch modes", 20, 70); // (y: 70)
  text("Press R to reset rotation & camera", 20, 90); // (y: 90)
  text("Use mouse to orbit camera (PeasyCam)", 20, 110); // (y: 110)
}

// ==================== keyboard interaction ====================
void keyPressed() {
  // switch modes
  if (key == '1') mode = 1;
  if (key == '2') mode = 2;
  if (key == '3') mode = 3;
  
  // reset rotation
  if (key == 'r' || key == 'R') {
    rotX = 0;
    rotY = 0;
    objAngle = 0;
    part3Angle = 0;
    cam.reset();
  }
  
  // reset camera
  if (key == 'c' || key == 'C') {
    cam.reset();
  }
}

// ==================== mouse interaction ====================
void mousePressed() {
  if (mouseButton == CENTER) {
    cam.reset();
  }
}
