#ifndef MPU6050_CUSTOM_H
#define MPU6050_CUSTOM_H

#include <Arduino.h>
#include "MPU6050.h"
#include <Wire.h>

/*---------LAST CODE---------*/

class MPU6050_Custom {
  public:
    MPU6050_Custom();

    void init();
    String processData();

    bool isInit;

      
  private:
    int16_t axRead, ayRead, azRead;
    float ax, ay, az;
    MPU6050 mpu;
};

#endif

// #define MPU6050_ADDRESS 0x68
// #define MPU6050_ACCEL_XOUT_H 0x3B
// #define MPU6050_PWR_MGMT_1 0x6B

// class MPU6050_Custom {
//   public:
//   MPU6050_Custom();

//   void init();
//   void readAccel(int16_t &ax, int16_t &ay, int16_t &az);

//   private:
//   int16_t readRegister16(int reg);

// };

// #endif