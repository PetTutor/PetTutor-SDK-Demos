/*
Smart Animal Training Systems
Pet Tutor Arduino SDK Demo
Coder: David Nelson
Contact: tech@smartanimaltraining.com
Modified Date: 7/1/2015

Description:
This is a very basic example on how to trigger a feed command to the Pet Tutor feeder.
A simple loop counts to 100,000 and then calls the feed comand.

NOTE: App 'Print' commands must be disabled when interacting with the feeder. Print should
only be used when interacting with the virtual terminal and not he physical device.

License:
This software is provided to you through the The MIT License (MIT)

Copyright (c) 2015 Smart Animal Training Systems

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

//***** WARNING: Remove battery after testing this app or it WILL kill your 
//               2032 battery very quickly!

int counter = 0;

void setup() 
{
  // this is important to allow the virtual terminal to recieve responses during development
  Serial.begin(57600);
  Serial.setTimeout(25);

  // start with the onboard LED off
  Bean.setLed(0,0,0);
}
 
void loop() 
{ 
  counter++;
  //Serial.println(counter);
  
  if (counter == 20)
  {
    Bean.setLed(0, 0, 255); // turn on the blue light
    counter = 0;
    
    // Below is the command to trigger a feed cycle on the Pet Tutor device
    // Commands ARE case sensitive
    ///////////////////////////////////
    Serial.write("CMD-ACCESSORY-FEED");
    ///////////////////////////////////    
  }

  // it's important to sleep the Bean. If you don't they can become unresponsive
  // and impossible to connect to without a hard reset. If this happens to you go here:
  // http://beantalk.punchthrough.com/t/cant-connect-cant-reprogram-solution/166
  Bean.sleep( 250 );
  
  Bean.setLed(0, 0, 0); // turn off the blue light
}

