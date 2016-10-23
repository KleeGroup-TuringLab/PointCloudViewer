#include "FS.h"
#include <ESP8266WiFi.h>
#include <rgb_lcd.h>

const char* configFile = "/wifi.cfg";
const char* messageFile = "/message.txt";
const int LCD_WIDTH = 16;
const int MAX_MESSAGES = 10;
const int MESSAGE_ROWS = 3;

rgb_lcd lcd;

int colorR = 0;
int colorG = 0;
int colorB = 0;

char messages[(LCD_WIDTH + 1) * MESSAGE_ROWS * MAX_MESSAGES];
int messageCount;

// Méthode d'initialisation
void setup() { 
  SPIFFS.begin();

  // Lecture du fichier de configuration
  File f = SPIFFS.open(configFile, "r");
  String ssid = f.readStringUntil('\n');
  ssid.replace("\n", "");
  String password = f.readStringUntil('\n');
  password.replace("\n", "");
  f.close();

  // Passage String en char*
  char __ssid[ssid.length() + 1];
  char __password[password.length() + 1];
  ssid.toCharArray(__ssid, sizeof(__ssid));
  password.toCharArray(__password, sizeof(__password));

  // Initialisation du WIFI
  WiFi.begin(__ssid, __password);
  delay(1);

  // Initialisation de la taille de l'afficheur à 16x2 caractéres 
  lcd.begin(16, 2);
  lcd.setRGB(colorR, colorG, colorB);

  // Lecture des messages dans la configuration
  readMessages();
} 

// Loop backlight color
void changeColor() {
  colorR += 10;
  if (colorR > 255) {
    colorR = 0;
    colorG += 10;
    if (colorG > 255) {
      colorG = 0;
      colorB += 10;
      if (colorB > 255) {
        colorR += 10;
        colorB = 0;
      }
    }
  }
}

// Lit les messages dans le fichier de configuration.
void readMessages() {  
  File f = SPIFFS.open(messageFile, "r");
  String s = f.readStringUntil('\n');

  int i = 0;
  while (s.length() > 0 && i < MAX_MESSAGES * MESSAGE_ROWS) {
    // Suppression des retours éventuels chariots
    s.replace("\r", "");

    // Limitation de la taille du message
    if (s.length() > LCD_WIDTH) {
      s = s.substring(0, LCD_WIDTH);
    }

    // Padding avec des espaces pour assurer l'effacement de l'écran LCD
    while (s.length() < LCD_WIDTH) {
      s.concat(" ");
    }

    // Copie de la string à la bonne position dans le buffer des messages
    s.toCharArray(messages + (LCD_WIDTH + 1)  * i, s.length() + 1);

    // Lecture de la ligne suivante
    s = f.readStringUntil('\n');
    i++;
  }
  f.close();  

  messageCount = i / MESSAGE_ROWS;
}

// Boucle principale
void loop() {
    changeColor();
    if (WiFi.status() != WL_CONNECTED) {
      lcd.setRGB(colorR, colorG, colorB); 
    } else {
      lcd.setColor(GREEN);
    }
    
    int cycle = millis() / 1000 % (messageCount * 10);
    int cycle2 = (millis() % 5000) / 2500;
    cycle = cycle / 10;

    lcd.home();
    lcd.print(messages + (17 * cycle * 3));
    lcd.setCursor(0, 1);
    lcd.print(messages + (17 * (cycle * 3 + cycle2 + 1)));

    delay(100); 
}

