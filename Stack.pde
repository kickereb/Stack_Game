Square square;
class pSquare {
  float x;
  float y;
  float wid;
  color colour;
  boolean perfect;
  void display() {
    fill(colour);
    rect(x, y, wid, 40);
    if (perfect){
      fill(0, 100);
     star(x + wid/2, y + 20, 7, 15, 5);  
    }
  }
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a + radians(45)) * radius2;
    float sy = y + sin(a + radians(45)) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle + radians(45)) * radius1;
    sy = y + sin(a+halfAngle + radians(45)) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
class Square {
  float x;
  float y;
  float wid;
  float velocity = 5;
  boolean direction;
  void display() {
    fill(colors[colorIndex]);
    rect(x, y, wid, 40);
  }
  void update() {
    if (x - velocity <= 0) {
      direction = true;
    }
    if (x + velocity + wid >= width) {
      direction = false;
    }
    if (direction) {
      x += velocity;
    } else {
      x -= velocity;
    }
  }
  void click(color colour) {
    boolean reset = false;
    pSquare newSquare = new pSquare();
    newSquare.colour = colour;
    if (pSquares.size() > 0) {
      pSquare prev = pSquares.get(pSquares.size() - 1);
      if (x > prev.x) {
        if (x > prev.x + prev.wid) {
          restart();
          reset = true;
        } else {
          newSquare.wid = dist(x, 0, prev.x + prev.wid, 0);
          wid = dist(x, 0, prev.x + prev.wid, 0);
          newSquare.x = x;
        }
      } else if (x < prev.x) {
        if (x + wid < prev.x) {
          restart();
          reset = true;
        } else {
          newSquare.wid = dist(prev.x, 0, x + wid, 0);
          wid = dist(prev.x, 0, x + wid, 0);
          newSquare.x = prev.x;
        }
      } else {
        newSquare.wid = wid + 30;
        newSquare.x = x - 15;
        wid += 30;
        velocity = 6.5;
        score += 4;
        newSquare.perfect = true;
      }
    } else {
      newSquare.wid = wid;
      newSquare.x = x;
    }
    if (!reset) {
      newSquare.y = y;
      pSquares.add(newSquare);
      if (pSquares.size() == 8) {
        pSquares.remove(pSquares.get(0));
      }
      if (y >= 250) {
        y -= 40;
      } else {
        for (pSquare p : pSquares) {
          p.y += 40;
        }
      }
    }
  }
}
ArrayList<pSquare> pSquares = new ArrayList<pSquare>();

color[] colors = {color(254, 212, 7), color(252, 221, 35), 
  color(247, 231, 73), color(245, 231, 111), 
  color(247, 198, 168), color(251, 160, 196), 
  color(254, 125, 220)};
int colorIndex;
boolean colorDir;
int score;
int highScore;

void setup() {
  background(10, 40, 40);
  size(500, 500);
  square = new Square();
  square.x = 0;
  square.y = width - 40;
  square.wid = 200;
  score = 0;
  highScore = 0;
  noStroke();
}

void draw() {
  backgrnd();
  for (pSquare p : pSquares) {
    p.display();
  }
  square.update();
  square.display();
  showScores();
}

void mousePressed() {
  if (square.velocity < 15) {
    square.velocity += 0.5;
  }
  color colorAux = colors[colorIndex];
  if (colorDir) {
    colorIndex++;
  } else {
    colorIndex--;
  }
  if (colorIndex == -1) {
    colorIndex = 1;
    colorDir = true;
  } else if (colorIndex == 7) {
    colorIndex = 5;
    colorDir = false;
  }
  square.click(colorAux);
  score++;
}

void restart() {
  pSquares = new ArrayList<pSquare>();
  square.x = 0;
  square.y = width - 40;
  square.wid = 200;
  square.velocity = 5;
  if (score > highScore) {
    highScore = score;
  }
  score = -1;
}

void backgrnd() {
  int[] c1 = {72, 132, 130};
  int[] c2 = {174, 211, 163};
  for (int i = 0; i < height; i++) {
    float t = 0.002 * i;
    float[] cIndex = new float[3];
    cIndex[0] = (1 - t) * c1[0] + t * c2[0];
    cIndex[1] = (1 - t) * c1[1] + t * c2[1];
    cIndex[2] = (1 - t) * c1[2] + t * c2[2];
    fill(cIndex[0] - 20, cIndex[1] - 20, cIndex[2] - 20);
    rect(0, i, width, 1);
  }
}

void showScores() {
  fill(255);
  textAlign(CENTER);
  
  textSize(45);
  text("Score: " + score, width/2, 70);
  textSize(20);
  text("Highscore: " + highScore, width/2, 100);
}
