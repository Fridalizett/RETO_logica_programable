
//Libreria para musica
import processing.sound.*;
//Libreria para puerto serial
import processing.serial.*; 

Serial port;  // Create object from Serial class
int val;      // Data received from the serial port 


final int WIDTH = 34;
final int HEIGHT = 32;
int[][] level = new int[HEIGHT][WIDTH];



Player p1;

//Variables para el sonido de fondo
SoundFile file;

String audioName = "song.mp3";
String path;
 
//booleans for key presses to get a simple yes or no press and
//to not have to worry about the a,aaaaaaaaaaaaa thing
boolean right = false, left = false, up = false;
 
 
 //SETUP/////////////////////////////
void setup() {
  size(900,600);
  p1 = new Player(WIDTH*10,HEIGHT*10);
 
  //Musica de fondo
  path = sketchPath(audioName);
  file = new SoundFile(this, path);
  file.play();
  //serial
  frameRate(10);  // Run 10 frames per second
  // Open the port that the board is connected to and use the same speed (9600 bps) 
  port = new Serial(this, "COM14", 9600);
  //serVal();
}//END SETUP//////////////////////////
 //DRAW///////////////////////////////
 
 
void draw() {
  if (0 < port.available()) {  // If data is available to read,
    val = port.read();            // read it and store it in val
  } 
  println(val);
  //PImage es un tipo de dato que almacena imagenes
  PImage bck;
  //Cargamos a una variable la imagen
  bck = loadImage("fondo7.jpg");
  serVal();
  
  //Asignamos esa variable al fondo
  background(bck);
  p1.update();
  p1.display();

  //imprime valores del puerto
  println(val);
  
}//END DRAW///////////////////////////
 
 boolean place_free(int xx,int yy) {
   xx = int(floor(xx));
   yy = int(floor(yy));
  if (yy < height-height/8) {
      return true;
  }
  return false;
}
 
void keyPressed() {
  switch(key) {
    case 'd': right = true; left=false; up=false; break;
    case 'a': left = true; right=false; up=false; break;
    case 'w': up = true; left=false; right=false; break;
  }
}

void serVal() {
  switch(val) {
    
    case 255: right = true; left=false; up=false; break;
    case 254: left = true; right=false; up=false; break;
    case 0: up = true; left=false; right=false; break;
  }
}
void keyReleased() {
  switch(key) {
    case RIGHT: right = false; break;
    case LEFT: left = false; break;
    case UP: up = false; break;
  }
}
