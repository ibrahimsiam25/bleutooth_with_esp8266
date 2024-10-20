#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // Initialize I2C LCD, address 0x27, size 16x2

void setup() {
  Serial.begin(9600);  // Start serial communication at 9600 baud rate
  lcd.init();           // Initialize the LCD
  lcd.backlight();     // Turn on the backlight of the LCD
  lcd.clear();         // Clear the LCD screen

  // Display a welcome message on the LCD
  lcd.setCursor(0, 0); // Set cursor to the beginning of the first line
  lcd.print("Welcome!"); // Show welcome message
  delay(2000);          // Wait for 2 seconds to see the message
  lcd.clear();         // Clear the screen after displaying the welcome message
}

void loop() {
  // Check if there is data available from Bluetooth
  if (Serial.available()) {
    String receivedData = Serial.readString(); // Read the incoming data as a string
    
    // Print the received data to the Serial Monitor for debugging
    Serial.println("Received: " + receivedData);
    
    // Split the received data into WiFi name and password
    int separatorIndex = receivedData.indexOf(','); // Find the index of the comma
    if (separatorIndex != -1) {
      String wifiName = receivedData.substring(0, separatorIndex); // Extract WiFi name
      String wifiPassword = receivedData.substring(separatorIndex + 1); // Extract WiFi password
      
      // Display the WiFi name and password on the LCD
      lcd.clear(); // Clear the LCD before displaying new messages
      lcd.setCursor(0, 0); // Set cursor to the first line
      lcd.print("WiFi Name:"); // Show label for WiFi name
      lcd.setCursor(0, 1); // Move to the second line
      lcd.print(wifiName); // Display the WiFi name
      
      delay(3000); // Wait for a few seconds to display the WiFi name
      
      lcd.clear(); // Clear the LCD before displaying the password
      lcd.setCursor(0, 0); // Set cursor to the first line
      lcd.print("Password:"); // Show label for password
      lcd.setCursor(0, 1); // Move to the second line
      lcd.print(wifiPassword); // Display the WiFi password
    }
  }
}
