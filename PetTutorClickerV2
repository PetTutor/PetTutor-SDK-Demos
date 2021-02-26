/* this sketch triggers the Pet Tutor Feedeer after a button is pushed.
    it does only if it has been 1 secondsince the last button press

    Timing can be adjusted by changing the argument in the
    "Wait" command but should not occur more frequently than
    the feeder can cycle food through - or the Feedcycle command will negate
    the previous FeedCycle command.
    This works on the basis that the device stays connected.
    Initial Design John Clarke Feb 7 2021.
    Updated Feb 25 2021

    The circuit:
    Arduino Nano 33 BLE or equivalent (pins may differ)
    push-button (normally open) connected between Digital Pin 4 and 3.3v
    pulldown resistor (10000 ohm) connected between Digital Pin 4 and ground
    Power provided by USB or via 9V battery connected to GND and VIn

    Timing loop to check if putton is pressed is set with 1200ms delay
    any lower than this seems to send feed commands on top of each other
    thereby negating the first command.  Holding the button down cycles the
    feeder about every 1 second.

    This assumes the name of the feeder has remained "PTFeeder"

    This iteration is using the connection invterval feature of the BLE library
    with minimum connection time of 8 ms and maximum of 40ms.
    In addition there is a timing loop to test for connection and reestablish if 
    the link disconnects in less than 10 seconds.

    Will be rebuilding the trigger using a different arduino boaard because the 
    current board seems to have limited distance causing frequent disconnection

    
*/
#include <ArduinoBLE.h>
//these are the global constants used in this sketch

// the pin number of the button used to trigger the feeder
const  int Pin4 = 4;
const int pinLow = LOW;
//the pin number of the built-in LED - could also use BUILTIN_LED
const int ledPin =  13;
unsigned long previousMillis = 0;
unsigned long interval = 10000;
void setup() {
  //begin initialization

  Serial.begin(115200);
  //  while (!Serial); 
  /*uncomment previous line for debug purposes - prevents code from running if
   * arduino not connected to computer and serial monitor is not open
   * all Serial.print and Serial.println can be removed after debug complete
  */ 
  pinMode(ledPin, OUTPUT);   //set the built-in LED pin to output
  pinMode(Pin4, INPUT); //set the button to input

  if (!BLE.begin()) {
    //    Serial.println("starting BLE failed!");
    while (1);
  }
  //  Serial.println("BLE Central - PetTutor Feeder Remote trigger");
  // start scanning for peripheral
  BLE.setConnectionInterval(0x0008, 0x0C80); // 10 ms minimum, 4sec maximum
  // BLE.setTimeout(10000);//additional line to test if timeout made a difference
}
void loop() {

  BLE.scanForAddress("00:05:c6:1f:56:9c");// hard coded address of PT Feeder comment to code for name
  //uncomment the following line to scan for name instead of address
 //   BLE.scanForName("PTFeeder");
  BLEDevice pettutor = BLE.available();
  if (pettutor) {

    // Serial.println("Connecting ...");
    if (pettutor.connect()) {
      Serial.println("Connected");
      BLE.stopScan();
    }
    /*this else statement is used to maintain connection to the PTFeeder. 
     * the code sends a disconnect followed by connect to reestablish connection
     * after the designated interval - 10000 milliseconds 
     * 
     */
    else {
          unsigned long currentMillis = millis();
      if ((!pettutor.connect()) && (currentMillis - previousMillis >=interval)) {
        Serial.print(millis());
        Serial.println("Reconnecting...");
        pettutor.disconnect();
        pettutor.connect();
          BLEDevice pettutor = BLE.available();
        previousMillis = currentMillis;
      }
            Serial.println("Failed to connect!");
      return;
    }
    digitalWrite(ledPin, HIGH);
    Serial.println("Waiting for button press ...");
    pettutor.discoverAttributes();
    BLEService feedService = pettutor.service(2);
    BLECharacteristic feedCycle = feedService.characteristic(2);

    while (pettutor.connected()) {
      if (feedService) {
        int buttonPressed = digitalRead(Pin4); 
        
        /*if the button is pressed, the Feed Cycle characterisitic
        is writtn to 0x00 to trigger a treat 
*/
        if (buttonPressed) {  //discover pettutor attributes
          //use the service if it has the correct Characteristic UUID - Feed Cycle in the PT Feeder
                    if (feedService.hasCharacteristic("b0e6a4bf-cccc-ffff-330c-0000000000f1")) {
          feedCycle.writeValue((byte)0x00);
          Serial.println("feeder triggered");

                    }//if hasCharacteristic  // loop is used to confirm only Feed Cycle is written to

        }//if buttonPressed

      } //if feed service
      //} //if discover attributes
    }// while connected
    Serial.println("disconnected from feed service");

    digitalWrite(ledPin, LOW);//turn off the on-board LED if the PTFeeder is not connected
  } // if(pettutor)
  //  pettutor.disconnect();
} //void loop()
