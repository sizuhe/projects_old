/*
BMP180 I2C Address: 0x77 
*/

#ifndef BMP180_H
#define BMP180_H

#include <Arduino.h>
#include <Wire.h>



class BMP180 {
  public:
    BMP180();

    void init();
    String processData();
      

  private:
    int16_t read16(uint8_t reg);

    uint32_t AC5, AC6;
    int32_t MC, MD;
    float temperature;
};

#endif