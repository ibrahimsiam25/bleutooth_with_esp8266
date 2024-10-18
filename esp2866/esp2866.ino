#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // عنوان I2C هو 0x3F، حجم الشاشة 16x2

void setup() {
  Serial.begin(9600);  // بدء الاتصال التسلسلي بسرعة 9600
  lcd.init();           // بدء الاتصال مع شاشة I2C
  lcd.backlight();     // تشغيل الإضاءة الخلفية لشاشة LCD
  lcd.clear();         // مسح الشاشة

  // عرض رسالة الترحيب على شاشة LCD
  lcd.setCursor(0, 0); // تعيين المؤشر عند بداية السطر الأول
  lcd.print("Welcome!"); // عرض رسالة الترحيب
  delay(2000);          // الانتظار لمدة 2 ثانية (2000 ملي ثانية) لرؤية الرسالة
  lcd.clear();         // مسح الشاشة بعد عرض رسالة الترحيب
}

void loop() {
  // فحص ما إذا كانت هناك بيانات واردة من البلوتوث
  if (Serial.available()) {
    String receivedData = Serial.readString(); // قراءة النص المرسل من البلوتوث
    
    // طباعة البيانات المستلمة على الـ Serial Monitor
    Serial.println("Received: " + receivedData);
    
    // عرض الرسالة المستلمة على شاشة الـ LCD
    lcd.clear(); // مسح الشاشة قبل عرض الرسالة الجديدة
    lcd.setCursor(0, 0); // تعيين المؤشر عند بداية السطر الأول
    lcd.print("Message:");
    lcd.setCursor(0, 1); // تعيين المؤشر عند بداية السطر الثاني
    lcd.print(receivedData);
  }
}
