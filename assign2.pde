final int GAME_START=4, GAME_LOSE=5, GAME_RUN=6; //<>// //<>// //<>//
final int LIFE_START=2, LIFE_MISS=1, LIFE_ADD=3;
final int GROUNDHOG_IDLE=0, GROUNDHOG_UP=7, GROUNDHOG_DOWN=8, GROUNDHOG_LEFT=9, GROUNDHOG_RIGHT=10;

float groundhogX, groundhogY, groundhogSpeed;

int t;
int soldierX, soldierY;
int cabbageX, cabbageY;
int gameState, LifeState;
int groundhogState = GROUNDHOG_IDLE;

PImage groundhogImg, downgroundhogImg, leftgroundhogImg, rightgroundhogImg;
PImage titleImg, bgImg, lifeImg, soldierImg, soilImg, cabbageImg, gameoverImg;
PImage startImg, restartImg, starthoverImg, restarthoverImg;

void setup() {
  size(640, 480, P2D);
  frameRate(60);

  //loadimg
  bgImg = loadImage("img/bg.jpg");
  groundhogImg = loadImage("img/groundhogIdle.png");
  downgroundhogImg = loadImage("img/groundhogDown.png");
  leftgroundhogImg = loadImage("img/groundhogLeft.png");
  rightgroundhogImg = loadImage("img/groundhogRight.png");
  lifeImg = loadImage("img/life.png");
  soldierImg = loadImage("img/soldier.png");
  soilImg = loadImage("img/soil.png");
  cabbageImg = loadImage("img/cabbage.png");
  startImg = loadImage("img/startNormal.png");
  restartImg = loadImage("img/restartNormal.png");
  starthoverImg = loadImage("img/startHovered.png");
  restarthoverImg = loadImage("img/restartHovered.png");
  titleImg = loadImage("img/title.jpg");
  gameoverImg = loadImage("img/gameover.jpg");

  //int variables
  groundhogSpeed = 80;
  gameState = GAME_START;
  LifeState = LIFE_START;//=2

  //soldier start
  soldierX = -80;
  soldierY = 160 + floor(random(160, 400))%4*80;

  //cabbage start
  cabbageX = floor(random(0, 560))%8*80;
  cabbageY = 160 + floor(random(160, 400))%4*80;

  //groundhog
  groundhogX = width/2+keyCode;
  groundhogY = 80-keyCode;
}

void draw() {
  //game title
  switch(gameState) {
  case GAME_START:
    //reset
    image(titleImg, 0, 0);
    image(startImg, 248, 360);
    //mouse action
    if (mouseX >248 && mouseX <392 && mouseY >360 && mouseY <420) {
      image(starthoverImg, 248, 360);
      if (mousePressed) {
        //click
        gameState = GAME_RUN;
        LifeState = LIFE_START;
      } else {
        //hover
        image(starthoverImg, 248, 360);
      }
    }
    break;

  case GAME_RUN:
    //sky
    image(bgImg, 0, 0);
    //grass
    noStroke();
    fill(124, 204, 25);
    rectMode(CORNER);
    rect(0, 145, width, 15);
    //sun
    fill(255, 255, 0);
    ellipse(590, 50, 130, 130);
    noStroke();
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);
    noStroke();
    //soil
    image(soilImg, 0, 160);
    //cabbage
    image(cabbageImg, cabbageX, cabbageY);

    //soldier walk
    image(soldierImg, soldierX, soldierY);
    soldierX += 3;
    if (soldierX >= floor(640)) {
      soldierX *=-1;
      soldierX %= 640-80;
    }

    //groundhog framerate
    if (t<15) {
      t++;
      switch(groundhogState) {
      case GROUNDHOG_DOWN:
        groundhogY += groundhogSpeed/15.0;
        break;
      case GROUNDHOG_LEFT:
        groundhogX -= groundhogSpeed/15.0;
        break;
      case GROUNDHOG_RIGHT:
        groundhogX += groundhogSpeed/15.0;
        break;
      }
    } else {
      groundhogState = GROUNDHOG_IDLE;
    }

    //groundhog in edge
    if (groundhogX <=0) {
      groundhogX = 0;
    }
    if (groundhogX >=640) {
      groundhogX = 640-80;
    }
    if (groundhogY >=480) {
      groundhogY = 480-80;
    }

    //groundhog display
    switch(groundhogState) {
    case GROUNDHOG_IDLE:
      image(groundhogImg, groundhogX, groundhogY);
      break;
    case GROUNDHOG_UP:
      image(groundhogImg, groundhogX, groundhogY);
      break;
    case GROUNDHOG_DOWN:
      image(downgroundhogImg, groundhogX, groundhogY);
      break;
    case GROUNDHOG_LEFT:
      image(leftgroundhogImg, groundhogX, groundhogY);
      break;
    case GROUNDHOG_RIGHT:
      image(rightgroundhogImg, groundhogX, groundhogY);
      break;
    }

    switch(LifeState) {
      //start 2 lifes
    case LIFE_START:
      image(lifeImg, 10, 10);
      image(lifeImg, 80, 10);

      //touch the soldier
      if (groundhogX+80 >soldierX && groundhogX <soldierX+80) {
        if (groundhogY+80 >soldierY && groundhogY <soldierY+80) {
          groundhogX = 320;
          groundhogY = 80;
          t=15;
          groundhogState = GROUNDHOG_IDLE;
          LifeState -= LIFE_MISS\\;//1
          break;
        } else {
          LifeState = LIFE_START;//2
        }
      }
      //eaten cabbage
      if (groundhogX+80 >cabbageX && groundhogX <cabbageX+80
        && groundhogY+80 >cabbageY && groundhogY <cabbageY+80) {
        cabbageX = -80;
        LifeState = LIFE_ADD;//3
        break;
      } else {
        LifeState = LIFE_START;//2
      }
      break;

      //3lifes
    case LIFE_ADD:
      image(lifeImg, 10, 10);
      image(lifeImg, 80, 10);
      image(lifeImg, 150, 10);
      //touch the soldier
      if (groundhogX+80 >soldierX && groundhogX <soldierX+80) {
        if (groundhogY+80 >soldierY && groundhogY <soldierY+80) {
          groundhogX = 320;
          groundhogY = 80;
          t=15;
          groundhogState = GROUNDHOG_IDLE;
          LifeState = LIFE_START;//2
          break;
        }
      }
      break;

      //1lifes
    case LIFE_MISS:
      image(lifeImg, 10, 10);

      //touch the soldier
      if (groundhogX+80 >soldierX && groundhogX <soldierX+80) {
        if (groundhogY+80 >soldierY && groundhogY <soldierY+80) {
          groundhogX = 320;
          groundhogY = 80;
          t=15;
          groundhogState = GROUNDHOG_IDLE;
          gameState = GAME_LOSE;//0
          break;
        } else {
          LifeState = LIFE_MISS;//1
        }
      }
      //eaten cabbage
      if (groundhogX+80 >cabbageX && groundhogX <cabbageX+80
        && groundhogY+80 >cabbageY && groundhogY <cabbageY+80) {
        cabbageX = -80;
        LifeState = LIFE_START;//2
        break;
      } else {
        LifeState = LIFE_MISS;//1
      }
    }
    break;

    //gameover
  case GAME_LOSE:
    //gameover
    image(gameoverImg, 0, 0);
    image(restartImg, 248, 360);
    //restart mouse action
    if (mouseX >248 && mouseX <392 && mouseY >360 && mouseY <420) {
      image(restarthoverImg, 248, 360);
      if (mousePressed) {
        //int variables
        groundhogSpeed = 80;
        gameState = GAME_START;
        LifeState = LIFE_START;//=2
        groundhogX = 320;
        groundhogY = 80;
        t=15;
        
        //soldier start
        soldierX = -80;
        soldierY = 160 + floor(random(160, 400))%4*80;

        //cabbage start
        cabbageX = floor(random(0, 560))%8*80;
        cabbageY = 160 + floor(random(160, 400))%4*80;
      } else {
        //hover
        image(restarthoverImg, 248, 360);
      }
    }
    break;
  }
}

void keyPressed() {
  if (groundhogState == GROUNDHOG_IDLE) {
    t=0;
    println(123);
    switch(keyCode) {
    case UP:
      groundhogState = GROUNDHOG_UP;
      break;
    case DOWN:
      groundhogState = GROUNDHOG_DOWN;
      break;
    case LEFT:
      groundhogState = GROUNDHOG_LEFT;
      break;
    case RIGHT:
      groundhogState = GROUNDHOG_RIGHT;
      break;
    }
  }
}
