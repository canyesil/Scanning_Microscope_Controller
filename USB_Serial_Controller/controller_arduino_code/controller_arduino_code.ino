
String inputString = "";
String str = "";

String Xdir = "";
String Xstep = "";

String Ydir = "";
String Ystep = "";

String laserON = "";
    
int stpX = 0;
int stpY = 0;
int laserPower = 0;

bool stringComplete = false;
bool enabled = false;

const int PulseX = 6;
const int dirX = 13;
const int enableX = 12;

const int PulseY = 5;
const int dirY = 8;
const int enableY = 7;

const int laser = 3;

void setup() {

  pinMode(dirX, OUTPUT);
  pinMode(enableX, OUTPUT);

  analogWrite(PulseX, 0);
  digitalWrite(dirX, LOW);
  digitalWrite(enableX, HIGH);
  
  analogWrite(PulseY, 0);
  pinMode(dirY, OUTPUT);
  pinMode(enableY, OUTPUT);

  digitalWrite(dirY, LOW);
  digitalWrite(enableY, HIGH);


  Serial.begin(115200);
  inputString.reserve(200);

}

void loop() {
  if (stringComplete) {
    int delim = inputString.indexOf("m2");
    
    laserON = inputString.substring(0,3);
    Xdir = inputString.substring(3,4);
    Xstep = inputString.substring(4,delim);
    Ydir = inputString.substring(delim + 2,delim + 3);
    Ystep = inputString.substring(delim + 3);

    stpX = Xstep.toInt();
    stpY = Ystep.toInt();
    laserPower = laserON.toInt();

    if (stpX != 0) {        
      analogWrite(PulseX, 0);
      delay(2);
      digitalWrite(enableX, LOW);
      delay(2);
      if (Ydir.equals("r")) {
        digitalWrite(dirX, LOW);
      }
      else if (Ydir.equals("l")){
        digitalWrite(dirX, HIGH);
      }
      delay(2);
      analogWrite(PulseX, 127);
      delay(stpX);
      analogWrite(PulseX, 0);
      delay(2);
      digitalWrite(enableX, HIGH);
    }

    if (stpY != 0) {        
      analogWrite(PulseY, 0);
      delay(2);
      digitalWrite(enableY, LOW);
      delay(2);
      if (Ydir.equals("r")) {
        digitalWrite(dirY, LOW);
      }
      else if (Ydir.equals("l")){
        digitalWrite(dirY, HIGH);
      }
      delay(2);
      analogWrite(PulseY, 127);
      delay(stpY);
      analogWrite(PulseY, 0);
      delay(2);
      digitalWrite(enableY, HIGH);
    }
   // Serial.print("ok\n");
    inputString = "";
    stringComplete = false;
  }
}


void serialEvent() 
{
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    inputString += inChar;
    if (inChar == '\n') {
      stringComplete = true;
    }
   }
}


