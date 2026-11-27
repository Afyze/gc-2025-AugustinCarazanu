// setup function to initialize window
void setup() {
  fullScreen(); // full screen mode
}

// main drawing loop
void draw() {
  // background color with alpha
  background(100, 100, 200, 255);
  
  // calling custom function
  drawmygeometry();
}

// custom function for shapes
void drawmygeometry() {
  // center coordinates
  float cx = width / 2;
  float cy = height / 2;
  
  // dimensions based on rx=120 ry=195
  // multiplied by 2 for full width/height
  float w = 240; 
  float h = 390;
  float rx = 120;
  float ry = 195;

  // set rect to center mode
  rectMode(CENTER);
  
  // draw main rectangle
  strokeWeight(4); // thick line
  stroke(255, 255, 255); // white border
  noFill(); // no fill for rect
  rect(cx, cy, w, h);
  
  // draw diagonals
  strokeWeight(2);
  stroke(200, 200, 200); // grey lines
  line(cx - rx, cy - ry, cx + rx, cy + ry); // diag 1
  line(cx + rx, cy - ry, cx - rx, cy + ry); // diag 2
  
  // draw cross lines
  line(cx, cy - ry, cx, cy + ry); // vertical
  line(cx - rx, cy, cx + rx, cy); // horizontal

  // task a: arc with lines
  // mid q1 (315 deg) to end q2 (180 deg)
  // drawing counter-clockwise visually (top part)
  noFill();
  strokeWeight(5);
  stroke(255, 255, 0); // yellow
  // angles in radians
  arc(cx, cy, w, h, PI, 7 * PI / 4);

  // task c: pie inside rectangle
  // overlapping adjustment width - 10
  // start q2 to end q3 (left side)
  fill(0, 0, 255); // blue fill
  stroke(0); // black outline
  strokeWeight(2);
  // drawing left side (90 to 270 degrees)
  arc(cx, cy, w - 10, h - 10, HALF_PI, 3 * HALF_PI, PIE);

  // task b: chord inside rectangle
  // overlapping adjustment width - 20
  // start q3 to end q4 (bottom part)
  fill(255, 0, 0); // red fill
  stroke(0, 255, 0); // green outline
  strokeWeight(3);
  // drawing bottom half (0 to 180 degrees)
  arc(cx, cy, w - 20, h - 20, 0, PI, CHORD);
  
  // extra task: circle and isosceles triangle
  // positioned on the left side
  float leftx = width / 5;
  stroke(255);
  fill(0, 255, 255); // cyan
  ellipse(leftx, cy, 100, 100); // circle
  
  // triangle inside circle
  fill(255, 0, 255); // magenta
  // points calculated for isosceles
  triangle(leftx, cy - 40, leftx - 30, cy + 30, leftx + 30, cy + 30);
}
