void setup() {
  size(800, 600);
  noLoop();
}

void draw() {
  background(220, 245, 255);
  
  fill(0);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Variant 3, Augustin Carazanu, FAF-243", 10, 10);
  
  drawCreature(width / 2, height / 2);
}

void drawCreature(float x, float y) {
  
  pushMatrix();
  translate(x - 50, y - 25); 

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
