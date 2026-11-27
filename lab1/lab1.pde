// configurare initiala a ferestrei
void setup() {
  size(600, 600);
  smooth();
}

// incepe desenarea elementelor grafice
void draw() {
  // deseneaza cerul noptii si stelele
  noStroke();
  fill(20, 24, 45);
  rect(0, 0, width, height);

  stroke(255);
  strokeWeight(3);
  point(100, 50);
  point(450, 80);
  point(500, 200);
  point(50, 300);
  point(300, 40);
   
  // deseneaza creanga de copac
  fill(101, 67, 33);
  stroke(0);
  strokeWeight(2);
  rect(0, 450, 600, 40);

  // adauga ghearele pasarii
  stroke(255, 165, 0);
  strokeWeight(6);
  line(270, 450, 260, 470);
  line(270, 450, 270, 470);
  line(270, 450, 280, 470);
  line(330, 450, 320, 470);
  line(330, 450, 330, 470);
  line(330, 450, 340, 470);

  // deseneaza corpul principal al bufnitei
  stroke(0);
  strokeWeight(3);
  fill(70, 130, 180);
  ellipse(300, 300, 200, 320);

  // adauga detaliile pentru burta
  fill(176, 224, 230);
  noStroke();
  arc(300, 350, 140, 160, 0, PI, CHORD); 

  // contureaza aripile laterale
  noFill();
  stroke(30, 80, 130);
  strokeWeight(4);
  arc(220, 300, 40, 100, HALF_PI, PI+HALF_PI, OPEN);
  arc(380, 300, 40, 100, -HALF_PI, HALF_PI, OPEN);

  // deseneaza urechile ascutite
  fill(70, 130, 180);
  stroke(0);
  strokeWeight(3);
  triangle(220, 200, 200, 130, 260, 180);
  triangle(380, 200, 400, 130, 340, 180);

  // creeaza ochii mari si pupilele
  fill(255);
  strokeWeight(2);
  circle(260, 250, 70);
  circle(340, 250, 70);
   
  fill(0);
  square(250, 240, 20);
  square(330, 240, 20);

  // deseneaza ciocul portocaliu
  fill(255, 140, 0);
  strokeWeight(2);
  quad(300, 270,
       315, 285,
       300, 310,
       285, 285);
       
  // opreste repetarea desenarii
  noLoop();
}
