size(600,800);
background(255);

float x = 300;
float y = 400;
float w = 300;

ellipseMode(CORNER);

noStroke();
fill(0);
ellipse(150,150, 300,300);
ellipse(150,350, 300,300);
rect(150,300, 300,200);

fill(255);
arc(150,150, 300,300, 0,PI);
arc(150,225, 150,150, PI,2*PI);
arc(300,225, 150,150, PI,2*PI);

fill(0);
ellipse(200,275, 40,40);
ellipse(350,275, 40,40);

int sc = 20;
quad(300,300, 300+sc,300+sc, 300,300+sc*2, 300-sc,300+sc);

fill(255);
textAlign(CENTER);
textSize(32);
text("wat?", 300,500);
