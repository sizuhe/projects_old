/* ----- CURRENT PROBLEMS -----
- String concatenation can affect the code speed as there are many concatenations 
on different functions.
- BMP and IMU functions delay the code a little bit, this affects the GPS.
clock so it resets when the offset gets bigger. This is why delays shouldnt 
be used before or after the GPS function.
- LoRa also delays the code but it's harder to make it faster.

----- SOLUTIONS -----
- Use char instead of String to create the dataPacket.
- Change IMU function to use Wire library therefore making it faster.
- Sending data every second (as GPS updates).
- Not using GPS data. */

#include <LoRa.h>
#include <SPI.h>
#include "sensor_ACS712.h"
#include "sensor_BMP180.h"
#include "sensor_FZ0430.h"
#include "sensor_MPU6050.h"
#include "sensor_NEO6M.h"

#define LORA_FREQ 433E6
#define PIN_LED_GREEN 8
#define PIN_LED_RED 7

int time;
String dataCurrent, dataBMP, dataVoltage, dataAccel, dataGPS, dataPacket;

ACS712 sensorCurrent(A1, 100, 5.0);
BMP180 sensorBMP;
FZ0430 sensorVoltage(A0, 25.0); 
MPU6050_Custom sensorIMU;
NEO6M sensorGPS(4, 3, 9600);



void setup() {
  Serial.begin(115200);

  pinMode(PIN_LED_GREEN, OUTPUT);
  pinMode(PIN_LED_RED, OUTPUT);

  sensorCurrent.init();
  sensorBMP.init();
  sensorVoltage.init();
  sensorIMU.init();
  sensorGPS.init();

  // Loop for GPS triangulation before sending data
  while (1) {
    digitalWrite(PIN_LED_RED, HIGH);

    sensorGPS.processData();
    if (sensorGPS.data.length() > 20) {
      digitalWrite(PIN_LED_RED, LOW);
      break;
    }
  }

  ledLoopGREEN(1000);

  // if (!LoRa.begin(LORA_FREQ)) {
  //   ledLoopRED(500);
  //   while(1);
  // } else {
  //   LoRa.setSpreadingFactor(7);
  //   LoRa.setSignalBandwidth(500E3);
  // }

  if (!sensorIMU.isInit) {
    ledLoopRED(500);
    ledLoopRED(500);
    while(1);
  }

  ledLoopGREEN(250);
  ledLoopGREEN(250);
  ledLoopGREEN(250);

  // Data type size optimization
  dataCurrent.reserve(7);
  dataBMP.reserve(7);
  dataVoltage.reserve(6);
  dataAccel.reserve(16);
  dataGPS.reserve(30);
  dataPacket.reserve(66);
}

void ledLoopRED(int speed) {
  digitalWrite(PIN_LED_RED, HIGH);
  delay(speed);
  digitalWrite(PIN_LED_RED, LOW);
  delay(speed);
}

void ledLoopGREEN(int speed) {
  digitalWrite(PIN_LED_GREEN, HIGH);
  delay(speed);
  digitalWrite(PIN_LED_GREEN, LOW);
  delay(speed);
}

/* -------------------------------------------------- */

void loop() {
  /* ----- TIMES FOR EVERY CODE [min - max] -----
  - processData / readData / allFunctions / globalVariables: 8 ms - 80 ms
  - processData / readData / -BMP / -IMU / globalVariables: 7 ms - 54 ms
  - processData / allFunctions / localVariables: 8 ms - 83 ms
  - processData / globalVariables: 9 ms - 66 ms

  - String dataPacket: 6 ms
  - Serial.println(dataGPS): 5 ms
  - dataPacket to Serial.println(dataGPS): 9 ms
  - dataPacket to Serial.println(dataPacket): 12 ms

  - dataPacket memory reserved: 5 ms
  - dataPacket memory not reserved: 6 ms

  - All process data funcions: 73 ms
  - All process data funcions / -GPS: 48 ms -- LoRa works great with this config --
  - All process data funcions / -BMP: 39 ms
  - All process data funcions / -IMU: 39 ms
  - All process data funcions / -IMU / -BMP: 31 ms
  
  Its not recommeded to use delays before or after the GPS code because it slows the
  GPS clock and forces it to reset.*/

  // long time0 = millis();

  dataCurrent = sensorCurrent.processData();    // Max time taken: 5 ms
  dataBMP = sensorBMP.processData();    // Max time taken: 21 ms
  dataVoltage = sensorVoltage.processData();    // Max time taken: 5 ms
  dataAccel = sensorIMU.processData();    // Max time taken: 21 ms
  sensorGPS.processData();    // Max time taken: 26 ms

  dataGPS = sensorGPS.isNew ? sensorGPS.data : dataGPS;   // Max time taken: 1 ms

  dataPacket = dataCurrent + dataVoltage + dataBMP + dataAccel + dataGPS;    // Max time taken: 5 ms (reserved) - 6 ms (not reserved)

  // LoRa.beginPacket();
  // LoRa.print(dataPacket);
  // LoRa.endPacket();

  Serial.println(dataPacket);
  /* -----DEBUGGING ----- */
  // int time1 = millis() - time0;
  // time = time1 > time ? time1 : time;
  // Serial.println(time);
}