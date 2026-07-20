#ifndef ACS712_H
#define ACS712_H

#include <Arduino.h>
#include <stdlib.h>



// Instance receives analog pin used in the MCU, sensitivity [mA] depending on the reference of the ACS used (ACS712-20A) and reference voltage for sensor [V].
class ACS712 {
  public:
    ACS712(uint8_t pin, float sensitivity, float vref);

    void init();
    String processData();


  private:
    static const float _ADC_RES;
    const uint8_t _PIN;
    const float _VREF, _VMID, _SENSITIVITY, _FACTOR;
    int rawValue;
    float current, voltage;
};

#endif