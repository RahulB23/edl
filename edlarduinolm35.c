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



LiquidCrystal_I2C      lcd(I2C_ADDR, En_pin,Rw_pin,Rs_pin,D4_pin,D5_pin,D6_pin,D7_pin);
int inPin = 2;
int val;

float Thermistor(int raw_ADC)
{
    return ((90/19) + raw_ADC)/0.19;
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