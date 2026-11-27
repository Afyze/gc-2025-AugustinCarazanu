Creature myOwl;

// configurare initiala si creare obiect
void setup() {
  size(600, 600);
  smooth();
  // initializeaza obiectul la coordonatele specificate
  myOwl = new Creature(300, 300);
}

// bucla principala de desenare
void draw() {
  // curata ecranul si deseneaza cerul
  noStroke();
  fill(20, 24, 45);
  rect(0, 0, width, height);

  // genereaza stele aleatorii la fiecare cadru
  stroke(255);
  int stars = 0;
  while (stars < 10) {
    float rX = random(width);
    float rY = random(height/2);

    if (random(1) > 0.5) {
      strokeWeight(3);
    } else {
      strokeWeight(2);
    }

    point(rX, rY);
    stars++;
  }

  // deseneaza pamantul la baza
  fill(101, 67, 33);
  stroke(0);
  strokeWeight(2);
  rect(0, 450, 600, 150);

  // actualizeaza si deseneaza obiectul
  myOwl.move();
  myOwl.display();
}
