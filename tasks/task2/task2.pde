void setup() {
  // setup canvas size
  size(400, 400);
  
  // set background to light grey
  background(240);
  
  // set common style
  stroke(0);          // black outline
  strokeWeight(6);    // thick lines
  strokeJoin(ROUND);  // smooth corners
  rectMode(CENTER);   // draw from center
  
  // draw horns using triangle
  fill(235, 215, 190); // beige color
  triangle(135, 130, 150, 95, 165, 130); // left horn
  triangle(235, 130, 250, 95, 265, 130); // right horn
  
  // draw ears using ellipse
  fill(255); // white
  ellipse(90, 180, 45, 45);  // left ear
  ellipse(310, 180, 45, 45); // right ear
  
  // draw head using rect with rounded corners
  fill(255);
  rect(200, 200, 220, 200, 50);
  
  // draw spot using ellipse without outline
  noStroke();
  fill(200); // grey
  ellipse(155, 190, 70, 60);
  
  // draw eyes using circle
  stroke(0); // restore outline
  fill(0);   // black
  circle(150, 200, 25);
  circle(250, 200, 25);
  
  // draw eye reflections
  noStroke();
  fill(255);
  circle(154, 196, 8);
  circle(254, 196, 8);
  
  // draw snout using rect
  stroke(0);
  fill(255, 205, 220); // pink
  rect(200, 260, 180, 80, 35);
  
  // draw nostrils using ellipse
  noStroke();
  fill(230, 150, 160); // darker pink
  ellipse(180, 245, 10, 6);
  ellipse(220, 245, 10, 6);
  
  // draw mouth using arc
  noFill();
  stroke(0);
  strokeWeight(4);
  arc(200, 260, 30, 20, 0, PI);
}

void draw() {
  // static scene, nothing here
}
