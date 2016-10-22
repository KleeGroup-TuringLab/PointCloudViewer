#include <rgb_lcd.h>

rgb_lcd lcd;

int colorR = 0;
int colorG = 0;
int colorB = 0; 

// Méthode d'initialisation
void setup() { 
    // Initialisation de la taille de l'afficheur à 16x2 caractéres 
    lcd.begin(16, 2);

     // Initialisation de la couleur
    lcd.setRGB(colorR, colorG, colorB);
} 

// Boucle principale
void loop() {
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
    lcd.setRGB(colorR, colorG, colorB); 

    int cycle = millis()/1000 % 20;
    if (cycle < 10) {
      lcd.setCursor(0, 0);
      lcd.print("Lundi 24   18h30");
      lcd.setCursor(0, 1);
      lcd.print("Complet         ");
    } else {
      lcd.setCursor(0, 0);
      lcd.print("Mardi 25   12h30");
      lcd.setCursor(0, 1);
      lcd.print("2 places dispos");
    }

    delay(100); 
}

