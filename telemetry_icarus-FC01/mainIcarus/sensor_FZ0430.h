#ifndef FZ0430_H
#define FZ0430_H

#include <Arduino.h>



// Instance receives analog pin input and sensor max input voltage [V].
class FZ0430 {
  public:
    FZ0430(uint8_t pin, float vmax);

    void init();
    String processData();


  private:
    static const float _ADC_RES;
    const uint8_t _PIN;
    const float _VMAX, _FACTOR;
    float voltage;
};

#endif