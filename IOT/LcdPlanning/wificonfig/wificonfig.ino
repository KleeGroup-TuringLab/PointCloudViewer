#include "FS.h"
#include <rgb_lcd.h>

#define DO_CONFIG false
#define DO_FORMAT false
#define WIFI_SSID "SSID"
#define WIFI_PASSWORD "PASSWORD"

const char* configFile = "/wifi.cfg";

rgb_lcd lcd;

// Initialisation
void setup() {
  // Initialisation de la taille de l'afficheur à 16x2 caractéres 
  lcd.begin(16, 2);
  SPIFFS.begin();

  if (DO_CONFIG) {
    if (DO_FORMAT) {
      // Initialisation de l'afficheur LCD
      lcd.setColor(RED);
      lcd.home();
      lcd.print("Formating ...");
      lcd.setCursor(0, 1);
      lcd.print("Wait 60 sec");
    
      // Ouverture du filesystem et formatage.
      SPIFFS.format();
    
      lcd.clear();
    }
  
    // Ecriture du fichier de configuration
    lcd.setColor(BLUE);
    File f = SPIFFS.open(configFile, "w");
    f.print(String(WIFI_SSID));
    f.print("\n");
    f.print(String(WIFI_PASSWORD));
    f.print("\n");
    f.close();
  }
}

// Boucle principale
void loop() {
  lcd.setColor(GREEN);

  // Lecture du fichier de configuration
  File f = SPIFFS.open(configFile, "r");
  String ssid = f.readStringUntil('\n');
  String password = f.readStringUntil('\n');
  f.close();

  // Affichage du SSID
  lcd.home();
  lcd.print(password);

  delay(3000);
}
