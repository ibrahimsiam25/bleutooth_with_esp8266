#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif

#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <ArduinoJson.h>

/* WiFi credentials */
#define WIFI_SSID "flutter"         // WiFi SSID
#define WIFI_PASSWORD "flutter123"  // WiFi password

/* Firebase configuration */
#define API_KEY "AIzaSyA40kf45kSfEkb41qnj9GfPVkoCyLQlW8o"
#define FIREBASE_PROJECT_ID "iot-and-flutter-e5b97"
#define USER_EMAIL "siam@gmail.com"
#define USER_PASSWORD "123456789"

/* LED pin definitions */
#define FAN_PIN D0
#define LED_GREEN_PIN D1
#define LED_RED_PIN D2
#define POTENTIOMETER A0

// Firebase data, authentication, and configuration objects
FirebaseData fbdo;      
FirebaseAuth auth;      
FirebaseConfig config;  

void setup() {
  Serial.begin(115200);    
  connectToWiFi();         
  configureFirebase();    
  initializeLEDsAndFan();  
}

void loop() {
  readPotentiometer();
  fetchAndUpdateLEDsAndFan();
  delay(100);
}

void connectToWiFi() {
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD); 
  Serial.print("Connecting to Wi-Fi");   

  // Wait for Wi-Fi connection
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");  
    delay(300);         
  }

  // Print local IP address upon successful connection
  Serial.println("\nConnected with IP: ");
  Serial.println(WiFi.localIP());  // Display local IP address
}

void configureFirebase() {
  Serial.printf("Firebase Client v%s\n", FIREBASE_CLIENT_VERSION);  

  config.api_key = API_KEY;                           
  auth.user.email = USER_EMAIL;                       
  auth.user.password = USER_PASSWORD;                  
  config.token_status_callback = tokenStatusCallback;  

  Firebase.begin(&config, &auth);  
  Firebase.reconnectWiFi(true);   
}

void initializeLEDsAndFan() {
  pinMode(FAN_PIN, OUTPUT);
  pinMode(LED_GREEN_PIN, OUTPUT);
  pinMode(LED_RED_PIN, OUTPUT);
  pinMode(POTENTIOMETER, INPUT);
}

void fetchAndUpdateLEDsAndFan() {
  String path = "iot_control";  // Path to Firestore document
  if (Firebase.Firestore.getDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(), "")) {
    Serial.println("ok");

    StaticJsonDocument<1024> doc;
    DeserializationError error = deserializeJson(doc, fbdo.payload().c_str());

    if (!error) {
      // Iterate over each document in the array
      for (JsonObject document : doc["documents"].as<JsonArray>()) {
        const char *document_name = document["name"];
        Serial.print(document_name);

        // Check the document name to determine the correct control
        if (strstr(document_name, "fan") != nullptr) {
          // Get the boolean value for fan control
          bool stateValue = document["fields"]["value"]["booleanValue"];
          digitalWrite(FAN_PIN, stateValue);
          stateValue ? Serial.println("Fan On") : Serial.println("Fan Off");

        } else if (strstr(document_name, "greenLed") != nullptr) {
          // Get the boolean value for green LED control
          bool stateValue = document["fields"]["value"]["booleanValue"];
          digitalWrite(LED_GREEN_PIN, stateValue);
          stateValue ? Serial.println("Green LED On") : Serial.println("Green LED Off");

        } else if (strstr(document_name, "redLed") != nullptr) {
          // Get the boolean value for red LED control
          bool stateValue = document["fields"]["value"]["booleanValue"];
          digitalWrite(LED_RED_PIN, stateValue);
          stateValue ? Serial.println("Red LED On") : Serial.println("Red LED Off");
        }
      }
    } else {
      Serial.print("Failed to deserialize JSON: ");
      Serial.println(error.c_str());
    }
  } else {
    Serial.println("Failed to fetch data from Firebase");
    Serial.println(fbdo.errorReason());
  }
}



void readPotentiometer() {
  int analogValue = analogRead(POTENTIOMETER);
  int mappedValue = map(analogValue, 150, 1000, 0, 100);
  if (mappedValue < 0) {
    mappedValue = 0;
  } else if (mappedValue > 100) {
    mappedValue = 100;
  }

  String documentPath = "iot_control/potentiometer";

  // Update potentiometer value in Firestore
  updateFirestorePotentiometer(documentPath, mappedValue);
  Serial.print("Analog Value: ");
  Serial.println();
}
void updateFirestorePotentiometer(const String &documentPath, int newValue) {
  FirebaseJson updateData;

  // Update the JSON structure with the new potentiometer value
  updateData.set("fields/potentiometer/integerValue", String(newValue));

  // Convert FirebaseJson to String
  String jsonStr;
  updateData.toString(jsonStr, true);

  // Update the document in Firestore
  if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), jsonStr.c_str(), "")) {

    Serial.println("Potentiometer value updated successfully.");
  } else {
    Serial.println("Failed to update potentiometer value:");
  }
}
