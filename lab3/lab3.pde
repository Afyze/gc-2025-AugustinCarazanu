Creature[] population;
int populationSize = 20;

// configurare initiala si crearea tabloului de creaturi
void setup() {
  size(600, 600);
  smooth();
  
  population = new Creature[populationSize];
  
  // genereaza creaturi cu personalitati diferite in secventa
  for (int i = 0; i < population.length; i++) {
    int personalityType = i % 4; 
    population[i] = new Creature(random(width), random(height), personalityType);
  }
}

// bucla principala pentru fundal si actualizare fizica
void draw() {
  drawBackground();
  
  // ruleaza motorul fizic pentru fiecare creatura
  for (int i = 0; i < population.length; i++) {
    population[i].run();
  }
}

// deseneaza elementele statice cer stele si pamant
void drawBackground() {
  noStroke();
  fill(20, 24, 45, 100);
  rect(0, 0, width, height);

  stroke(255);
  strokeWeight(3);
  point(100, 50); point(450, 80); point(500, 200);
  point(50, 300); point(300, 40);
  
  fill(101, 67, 33);
  stroke(0);
  strokeWeight(2);
  rect(0, 550, 600, 50); 
}
