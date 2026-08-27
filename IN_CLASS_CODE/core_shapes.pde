size(600,400);
background(255);

strokeWeight(40);
strokeCap(ROUND);
//point(200,100);
line(0,0, 600,400);
stroke(color(255,0,0));
line(600,0, 0,400);

strokeCap(ROUND);
line(200,100, 400,100);
strokeCap(SQUARE);
line(200,200, 400,200);
strokeCap(PROJECT);
line(200,300, 400,300);

background(0);
strokeCap(ROUND);
strokeJoin(BEVEL);
fill(color(0,0,255));

ellipseMode(RADIUS);

noFill();
noStroke();
ellipse(150,100, 300,200);
//background(0);
textSize(64);
fill(255,0,0);
text("Hello", 300,200);
