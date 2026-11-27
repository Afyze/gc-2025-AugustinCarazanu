class Creature {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float maxSpeed;
  float maxForce;
  float scaleFactor;
  int personality;
  float xOff;
  color owlColor; // variabila pentru a stoca culoarea principala a bufniței
  
  // initializeaza vectorii si seteaza atribute specifice in functie de tipul de personalitate
  Creature(float x, float y, int type) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    personality = type;
    
    // seteaza viteza, forta si culoarea in functie de comportamentul ales (familia de bufnițe)
    if (personality == 0) { // Bufnița "perlin noise" - Albastru
      maxSpeed = 2;
      maxForce = 0.1;
      xOff = random(1000);
      owlColor = color(70, 130, 180); // Albastru
    } else if (personality == 1) { // Bufnița "random force" - Verde
      maxSpeed = 4;
      maxForce = 0.5;
      owlColor = color(100, 180, 100); // Verde
    } else if (personality == 2) { // Bufnița "mouse follower" - Roșu/Portocaliu
      maxSpeed = 5;
      maxForce = 0.2;
      owlColor = color(220, 100, 80); // Roșu/Portocaliu
    } else { // Bufnița "constant wave" - Galben/Maro
      maxSpeed = 1.5;
      maxForce = 0.05;
      owlColor = color(180, 140, 70); // Galben/Maro
    }
    
    scaleFactor = random(0.15, 0.25);
  }

  // functie centrala ce gestioneaza logica miscarii si desenarea
  void run() {
    applyPersonality();
    update();
    checkEdges();
    display();
  }

  // calculeaza fortele in functie de comportament precum zgomot aleator sau urmarire mouse
  void applyPersonality() {
    
    // miscare fluida bazata pe zgomot perlin
    if (personality == 0) {
      float theta = map(noise(xOff), 0, 1, 0, TWO_PI);
      PVector noiseForce = PVector.fromAngle(theta);
      noiseForce.mult(maxForce);
      applyForce(noiseForce);
      xOff += 0.01;
    }
    
    // miscare haotica total aleatorie
    else if (personality == 1) {
      PVector randomForce = PVector.random2D();
      randomForce.mult(random(maxForce));
      applyForce(randomForce);
    }
    
    // comportament de urmarire a cursorului mouseului
    else if (personality == 2) {
      PVector mouse = new PVector(mouseX, mouseY);
      PVector dir = PVector.sub(mouse, location);
      dir.normalize();
      dir.mult(maxForce);
      applyForce(dir);
    }
    
    // miscare constanta cu ondulare sinusoidala
    else if (personality == 3) {
      PVector constantForce = new PVector(0.02, 0);
      applyForce(constantForce);
      
      PVector wave = new PVector(0, sin(frameCount * 0.05) * 0.05);
      applyForce(wave);
    }
  }

  // actualizeaza pozitia si viteza pe baza acceleratiei
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  // adauga un vector de forta la acceleratie
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  // verifica marginile ecranului si muta pozitia pe partea opusa
  void checkEdges() {
    if (location.x > width + 50) location.x = -50;
    else if (location.x < -50) location.x = width + 50;
    
    if (location.y > height + 50) location.y = -50;
    else if (location.y < -50) location.y = height + 50;
  }

  // deseneaza creatura cu transformari pentru pozitie scara si directie
  void display() {
    pushMatrix();
    translate(location.x, location.y);
    
    // intoarce imaginea orizontal daca viteza este negativa
    if (velocity.x < 0) {
      scale(-1, 1);
    }
    
    scale(scaleFactor);
    
    // ajusteaza originea desenului
    translate(-300, -300);

    // codul de desenare pentru bufnita
    // Picioare (culoare constantă)
    stroke(255, 165, 0);
    strokeWeight(6);
    line(270, 450, 260, 470);
    line(270, 450, 270, 470);
    line(270, 450, 280, 470);
    line(330, 450, 320, 470);
    line(330, 450, 330, 470);
    line(330, 450, 340, 470);

    // Corpul Bufniței (folosind culoarea setată)
    stroke(0);
    strokeWeight(3);
    fill(owlColor); // Culoarea principală a corpului
    ellipse(300, 300, 200, 320);

    // Burta/Penajul inferior (culoare deschisă, bazată pe culoarea setată)
    // Atenție: Folosim `red()`, `green()`, `blue()` doar dacă sunt definite în clasa principală
    // Aici le definim direct:
    int r = (int)red(owlColor);
    int g = (int)green(owlColor);
    int b = (int)blue(owlColor);
    fill(r + 40, g + 40, b + 40, 200); // O nuanță mai deschisă
    noStroke();
    arc(300, 350, 140, 160, 0, PI, CHORD);

    // Contur/Aripioare laterale (o nuanță mai închisă)
    noFill();
    stroke(r - 40, g - 40, b - 40); // O nuanță mai închisă/mai închisă la culoare
    strokeWeight(4);
    arc(220, 300, 40, 100, HALF_PI, PI+HALF_PI, OPEN);
    arc(380, 300, 40, 100, -HALF_PI, HALF_PI, OPEN);

    // Urechile/Smocurile de penaj (folosind culoarea setată)
    fill(owlColor);
    stroke(0);
    strokeWeight(3);
    triangle(220, 200, 200, 130, 260, 180);
    triangle(380, 200, 400, 130, 340, 180);

    // Ochii (Albi)
    fill(255);
    strokeWeight(2);
    circle(260, 250, 70);
    circle(340, 250, 70);
    
    // Pupilele (Negre)
    fill(0);
    square(250, 240, 20);
    square(330, 240, 20);

    // Ciocul (Portocaliu)
    fill(255, 140, 0);
    strokeWeight(2);
    quad(300, 270, 315, 285, 300, 310, 285, 285);
              
    popMatrix();
  }
}
