#include "sensor_FZ0430.h"

const float FZ0430::_ADC_RES = 1023;



FZ0430::FZ0430(uint8_t pin, float vmax) : _PIN(pin), _VMAX(vmax), _FACTOR(_VMAX / _ADC_RES), voltage(0.0) {}


void FZ0430::init() {
  pinMode(_PIN, INPUT);

  Serial.println(F("FZ0430 correct initialization"));
  delay(20);
}


String FZ0430::processData() {
  voltage = analogRead(_PIN) * _FACTOR;

  String data = String(voltage) + ",";
  return data;
}