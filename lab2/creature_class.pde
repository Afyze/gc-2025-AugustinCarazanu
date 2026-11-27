class Creature {

  // variabile pentru pozitie si viteza
  float x;
  float y;
  float speedX;

  // constructor pentru initializare pozitie si viteza
  Creature(float startX, float startY) {
    x = startX;
    y = startY;
    speedX = 3;
  }

  // functie pentru actualizare miscare
  void move() {
    // schimba pozitia pe axa x
    x = x + speedX;

    // verifica coliziunea cu marginile si intoarce directia
    if (x > width - 100 || x < 100) {
      speedX = speedX * -1;
    }
  }

  // functie pentru desenarea elementelor grafice
  void display() {
    // izoleaza transformarile de coordonate
    pushMatrix();
    // muta punctul de origine la pozitia creaturii
    translate(x, y);

    // deseneaza ghearele
    stroke(255, 165, 0);
    strokeWeight(6);

    for (int i = -10; i <= 10; i += 10) {
      line(-30, 150, -30 + i, 170);
      line(30, 150, 30 + i, 170);
    }

    // deseneaza corpul si aripile
    stroke(0);
    strokeWeight(3);
    fill(70, 130, 180);
    ellipse(0, 0, 200, 320);

    fill(176, 224, 230);
    noStroke();
    arc(0, 50, 140, 160, 0, PI, CHORD);

    noFill();
    stroke(30, 80, 130);
    strokeWeight(4);
    arc(-80, 0, 40, 100, HALF_PI, PI+HALF_PI, OPEN);
    arc(80, 0, 40, 100, -HALF_PI, HALF_PI, OPEN);

    // deseneaza capul ochii si ciocul
    fill(70, 130, 180);
    stroke(0);
    strokeWeight(3);
    triangle(-80, -100, -100, -170, -40, -120);
    triangle(80, -100, 100, -170, 40, -120);

    fill(255);
    strokeWeight(2);
    circle(-40, -50, 70);
    circle(40, -50, 70);

    fill(0);
    square(-50, -60, 20);
    square(30, -60, 20);

    fill(255, 140, 0);
    strokeWeight(2);
    quad(0, -30,
         15, -15,
         0, 10,
         -15, -15);

    // restaureaza sistemul de coordonate original
    popMatrix();
  }
}
