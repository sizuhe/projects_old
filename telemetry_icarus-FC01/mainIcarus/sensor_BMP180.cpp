#include "sensor_BMP180.h"

/* ----- BMP180 REGISTERS ----- */
#define BMP180_ADDRESS 0x77

// Control and temperature data
#define BMP180_REG_CONTROL 0xF4
#define BMP180_REG_READTEMP 0x2E
#define BMP180_REG_TEMP 0xF6

// Calibration values
#define BMP180_CAL_AC5 0xB2
#define BMP180_CAL_AC6 0xB4
#define BMP180_CAL_MC 0xBC
#define BMP180_CAL_MD 0xBE



BMP180::BMP180() : temperature(0.0) {}


void BMP180::init() {
  Wire.begin();

  AC5 = read16(BMP180_CAL_AC5);
  AC6 = read16(BMP180_CAL_AC6);
  MC = read16(BMP180_CAL_MC);
  MD = read16(BMP180_CAL_MD);

  delay(500);
}


// Get read data from library functions
String BMP180::processData() {
  Wire.beginTransmission(BMP180_ADDRESS);
  Wire.write(BMP180_REG_CONTROL);
  Wire.write(BMP180_REG_READTEMP);
  Wire.endTransmission();
  delay(5);   // Temperature data needs 4.5 ms to make readings - Datasheet

  // True (calibrated) temperature calculation
  int32_t UT = read16(BMP180_REG_TEMP);    // Raw (uncalibrated) temperature data
  int32_t X1 = (UT - AC6) * AC5 >> 15;
  int32_t X2 = (MC << 11) / (X1 + MD);
  int32_t B5 = X1 + X2;
  temperature = (B5 + 8) >> 4;
  temperature /= 10.0;

  String data = String(temperature) + ",";
  return data;
}


int16_t BMP180::read16(uint8_t reg) {
  Wire.beginTransmission(BMP180_ADDRESS);
  Wire.write(reg);
  Wire.endTransmission();

  Wire.requestFrom(BMP180_ADDRESS, 2);

  if (Wire.available() >= 2) {
    int16_t value = (Wire.read() << 8) | Wire.read();
    return value;
  } else {
    return 0;
  }
}