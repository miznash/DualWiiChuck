import processing.serial.*;
Serial myPort;                // The serial port

float xmag, ymag = 0;
float newXmag, newYmag = 0; 
int sensorCount = 6;                        // number of values to expect
float[] sensorValues = new float[sensorCount];  // array to hold the incoming values
int BAUDRATE = 115200; 
char DELIM = ','; // the delimeter for parsing incoming data

int idxWiiChuck = 0;  // 0...Right WiiChuck, 1...Left WiiChuck

// WiiChuckData range: -180 --- +180 -> 0 -- 360
int[] scales = new int[2];

/////////////////////////////////////////////////////////////////////////
//  Setup
/////////////////////////////////////////////////////////////////////////
void setup() 
{ 
  size(200, 200, P3D); 
  noStroke(); 
  colorMode(RGB, 1); 
  myPort = new Serial(this, Serial.list()[0], BAUDRATE);
  // clear the serial buffer:
  myPort.clear();
} 

/////////////////////////////////////////////////////////////////////////
//  Main draw function
/////////////////////////////////////////////////////////////////////////
void draw() 
{ 
  background(0.5, 0.5, 0.45);

  scales[idxWiiChuck] = int(abs(60 - abs(sensorValues[1])) / 2);
  println(sensorValues[1]);

  // Draw left square
  pushMatrix(); 
  translate(width/2 - 40, height/2, 0); 
  scale(scales[0]);

  beginShape(QUADS);
  fill(0, 1, 1); 
  vertex(-1,  1,  1);
  fill(1, 1, 1); 
  vertex( 1,  1,  1);
  fill(1, 0, 1); 
  vertex( 1, -1,  1);
  fill(0, 0, 1); 
  vertex(-1, -1,  1);
  endShape();
  popMatrix(); 

  // Draw right square
  pushMatrix(); 
  translate(width/2 + 40, height/2, 0); 
  scale(scales[1]);

  beginShape(QUADS);
  fill(1, 1, 1); 
  vertex(-1,  1,  1);
  fill(1, 1, 0); 
  vertex( 1,  1,  1);
  fill(1, 0, 0); 
  vertex( 1, -1,  1);
  fill(1, 0, 1); 
  vertex(-1, -1,  1);
  endShape();
  popMatrix();
}

/////////////////////////////////////////////////////////////////////////
//  Get serial data (from WiiChuck)
//
//  * Data Format (each line has 6 values)*
//  [0|1], RollVal, PitchVal, AccelX, AccelY, AccelZ
//
//  first data: 0...Right WiiChuck Data, 1...Left WiiChuck Data
//
/////////////////////////////////////////////////////////////////////////
void serialEvent(Serial myPort) {
  // read incoming data until you get a newline:
  String serialString = myPort.readStringUntil('\n');
  // if the read data is a real string, parse it:

  if (serialString != null) {
    //println(serialString);
    //println(serialString.charAt(serialString.length()-3));
    // println(serialString.charAt(serialString.length()-2));
    // split it into substrings on the DELIM character:
    String[] numbers = split(serialString, DELIM);
    // convert each substring into an int
    if (numbers.length == sensorCount) {
      idxWiiChuck = int(trim(numbers[0]));
      for (int i = 0; i < numbers.length; i++) {
        // make sure you're only reading as many numbers as
        // you can fit in the array:
        if (i <= sensorCount) {
          // trim off any whitespace from the substring:
          numbers[i] = trim(numbers[i]);
          sensorValues[i] =  float(numbers[i]);
        }
        // Things we don't handle in particular can get output to the text window
        //print(serialString);
      }
    }
  }
}

