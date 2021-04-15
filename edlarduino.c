#include <Wire.h>
#include <LCD.h>
#include <LiquidCrystal_I2C.h>

#define I2C_ADDR          0x27
#define BACKLIGHT_PIN      3
#define En_pin             2
#define Rw_pin             1
#define Rs_pin             0
#define D4_pin             4
#define D5_pin             5
#define D6_pin             6
#define D7_pin             7

unsigned int RBias = 10000;
float VBias =  5.00;
unsigned int ADC_BITS = 1024;
float THRM_DIV_VDC = 0;
float THRM_RES = 0;
float THRM_TEMP = 0;

LiquidCrystal_I2C      lcd(I2C_ADDR, En_pin,Rw_pin,Rs_pin,D4_pin,D5_pin,D6_pin,D7_pin);
int inPin = 2;
int val;

float Thermistor(int raw_ADC)                          
{
    THRM_DIV_VDC = 0;
    THRM_RES = 0;
    THRM_ADC = raw_ADC
               
    float THRM_A0 = -2.734009E+02;
    float THRM_A1 = 5.319219E-02;
    float THRM_A2 = -3.534446E-06;
    float THRM_A3 = 1.426866E-10;
    float THRM_A4 = -2.351983E-15;

    THRM_DIV_VDC = (VBias/ADC_BITS) * THRM_ADC;
    THRM_RES = THRM_DIV_VDC/((VBias - THRM_DIV_VDC)/RBias);
    THRM_TEMP = (THRM_A4 * powf(THRM_RES,4)) + (THRM_A3 * powf(THRM_RES,3)) + (THRM_A2 * powf(THRM_RES,2)) + (THRM_A1 * THRM_RES) + THRM_A0; 
    return THRM_TEMP; 
}

void setup()
 {
    lcd.begin (16,2);
    lcd.setBacklightPin(BACKLIGHT_PIN,POSITIVE);
    lcd.setBacklight(HIGH);

    pinMode(inPin, INPUT);
 }

void main()
{
    setup();
    int converted;
    String tostr;
    while(1)
    {
        val = digitalRead(inPin);
        converted = Thermistor(val);
        tostr = String(converted);
        lcd.setCursor(5,0);
        lcd.print(tostr);
    }

}
