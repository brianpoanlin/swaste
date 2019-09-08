#include <Servo.h>

Servo servo1;
Servo servo2;
Servo servo3;

void setup() {
  // put your setup code here, to run once:
  servo1.attach(2);
  servo1.write(0);
  servo2.attach(3);
  servo2.write(0);
  servo3.attach(4);
  servo3.write(0);
  Serial.begin(9600);
}

void loop() {
  while (Serial.available() > 0) {
    int input = Serial.parseInt();
    Serial.print(input);
    driveMotor(input);
     if (Serial.read() == '\n') {
     }
  }
 }

void driveMotor(int input) {
  switch (input) {
    case 1:
      servo1.write(180);
      break;
    case 2:
      servo2.write(180);
      break;
    case 3:
      servo3.write(180);
      break;
    case 4:
      servo1.write(0);
      break;
    case 5:
      servo2.write(0);
      break;
    case 6:
      servo3.write(0);
    break;
    default:
      break;
  }
}
