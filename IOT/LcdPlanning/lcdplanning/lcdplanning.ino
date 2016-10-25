#include "FS.h"
#include <ESP8266WiFi.h>
#include <rgb_lcd.h>

//#define DEBUG

const char* configFile = "/wifi.cfg";
const char* messageFile = "/message.txt";
const char* downloadFile = "/download.txt";
const int LCD_WIDTH = 16;
const int MAX_MESSAGES = 10;
const int MESSAGE_ROWS = 3;

rgb_lcd lcd;
WiFiClientSecure client;
unsigned long lastSync = 0;
const unsigned long syncInterval = 60000 * 10;

int colorR = 0;
int colorG = 0;
int colorB = 0;

char messages[(LCD_WIDTH + 1) * MESSAGE_ROWS * MAX_MESSAGES];
int messageCount;
bool messageLoaded = false;

// Méthode d'initialisation
void setup() {
  SPIFFS.begin();

#ifdef DEBUG
  Serial.begin(9600);
  Serial.println();
  Serial.println("Setup");
#endif

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
  messageLoaded = true;
}

// Lit les données téléchargées et écrit le fichier message.
void parseDownload() {  
  File fm = SPIFFS.open(messageFile, "w");
  File fd = SPIFFS.open(downloadFile, "r");

  // Lecture jusqu'à la fin de l'entête
  String s = fd.readStringUntil('\n');
  s.trim();
  while (s.length() > 0) {
#ifdef DEBUG
    Serial.print("Header (");
    Serial.print(s.length());
    Serial.print(") : ");
    Serial.println(s);
#endif
    
    s = fd.readStringUntil('\n');
    s.trim();
  }

  // Lecture des données
  s = fd.readStringUntil('\n');
  while (s.length() > 0) {
    // Ecriture sur le fichier de sortie
    fm.println(s);

#ifdef DEBUG
    Serial.println(s);
#endif
    
    // Lecture de la ligne suivante
    s = fd.readStringUntil('\n');
  }
  fd.close();
  fm.close();  
}

// Récupére le plannig sur GitHub
bool retrievePlanning() {
#ifdef DEBUG  
  Serial.println("Start HTTPS connection");
#endif

  // Ouverture de la connexion HTTPS
  if ( !client.connect("raw.githubusercontent.com", 443) ) {
#ifdef DEBUG  
    Serial.println("HTTPS connection failed");
#endif
    return false;
  }

#ifdef DEBUG  
  Serial.println("HTTPS connection succeded");
#endif

  // Ecriture de la request sur le stream
  client.println("GET /KleeGroup/turinglab/master/IOT/LcdPlanning/planning.txt HTTP/1.1");
  client.print("Host: ");
  client.println("raw.githubusercontent.com");
  client.println("Connection: close");
  client.println();

  delay(1);

  // Ouverture du fichier
  File f = SPIFFS.open(downloadFile, "w");

  // Ecoute jusqu'à la fermeture de la connexion par le serveur
  // Lecture des données
  while (client.connected()) {
    if (client.available()) {
      char c = client.read();
      f.print(c);

#ifdef DEBUG  
      Serial.print(c);
#endif
    }

    // Delay pour rendre la main à l'ESP9266 pour les traitements Wifi
    delay(1);
  }

  // Lecture de la fin du flux
  while (client.available()) {
    char c = client.read();
    f.print(c);

#ifdef DEBUG  
    Serial.print(c);
#endif
  }

  // Fermeture de la socket et du fichier
  client.stop();
  f.close();

  return true;
}

// Boucle principale
void loop() {
    changeColor();
    if (WiFi.status() != WL_CONNECTED) {
      lcd.setRGB(colorR, colorG, colorB); 
    } else {
      if ((millis() - lastSync > syncInterval) || (lastSync == 0)) {
        lcd.setColor(GREEN);
        if (retrievePlanning()) {
          lastSync = millis();

          // Traite le téléchargement
          parseDownload();

          // Met à jour les messages.
          readMessages();
        }
      } else {
        lcd.setColor(BLUE);
      }
    }

    if (messageCount > 0) {
      int cycle = millis() / 1000 % (messageCount * 10);
      int cycle2 = (millis() % 5000) / 2500;
      cycle = cycle / 10;
  
      lcd.home();
      lcd.print(messages + (17 * cycle * 3));
      lcd.setCursor(0, 1);
      lcd.print(messages + (17 * (cycle * 3 + cycle2 + 1)));
    }

    delay(100); 
}

