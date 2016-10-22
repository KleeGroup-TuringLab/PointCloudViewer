#include "FS.h"
#include <rgb_lcd.h>

#define DO_CONFIG false
#define DO_FORMAT false

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
    File f = SPIFFS.open("/wifi.cfg", "w");
    f.println("SID");
    f.println("Password");
    f.close();
  }
}

// Boucle principale
void loop() {
  lcd.setColor(GREEN);

  // Lecture du fichier de configuration
  File f = SPIFFS.open("/wifi.cfg", "r");
  String sid = f.readStringUntil('\n');
  String password = f.readStringUntil('\n');

  // Affichage du SID
  lcd.home();
  lcd.print(sid);

  delay(3000);
}
