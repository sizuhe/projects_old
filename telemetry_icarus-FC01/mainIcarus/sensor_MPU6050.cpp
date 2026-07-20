#include "sensor_MPU6050.h"

const float RANGE_G = 2.0;
const float FACTOR_CONVERSION = RANGE_G / (pow(2, 16) / 2.0);



MPU6050_Custom::MPU6050_Custom() : mpu() {}


void MPU6050_Custom::init() {
  mpu.initialize();
  if (!mpu.testConnection()){
    isInit = 0;
  } else {
    isInit = 1;
  }

/* ----- CALIBRATION VARIABLES ----- */
  mpu.setXAccelOffset(1317);
  mpu.setYAccelOffset(-81);
  mpu.setZAccelOffset(1147);

  delay(20);
}


/* Get read data from library functions */
String MPU6050_Custom::processData() {
  mpu.getAcceleration(&axRead, &ayRead, &azRead);

  ax = axRead * FACTOR_CONVERSION;
  ay = ayRead * FACTOR_CONVERSION;
  az = azRead * FACTOR_CONVERSION;

  String data = String(ax) + "," + String(ay) + "," + String(az) + ",";
  return data;
}


// MPU6050_Custom::MPU6050_Custom(){

// }

// void MPU6050_Custom::init(){
//   Wire.begin();
//   Wire.beginTransmission(MPU6050_ADDRESS);
//   Wire.write(MPU6050_PWR_MGMT_1);
//   Wire.write(0);
//   Wire.endTransmission();
// }

// void MPU6050_Custom::readAccel(int16_t &ax, int16_t &ay, int16_t &az){
//   ax = readRegister16(MPU6050_ACCEL_XOUT_H);
//   ay = readRegister16(MPU6050_ACCEL_XOUT_H + 2);
//   az = readRegister16(MPU6050_ACCEL_XOUT_H + 4);

// }
// int16_t MPU6050_Custom::readRegister16(int reg) {
//     Wire.beginTransmission(MPU6050_ADDRESS);  
//     Wire.write(reg); 
//     Wire.endTransmission(false);  
//     Wire.requestFrom(MPU6050_ADDRESS, 2, true); 

//     int16_t value = (Wire.read() << 8) | Wire.read();  
//     return value;
// }

