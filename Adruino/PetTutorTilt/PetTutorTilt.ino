/*
Smart Animal Training Systems, LLC
Pet Tutor Arduino SDK Demo
Coder: David Nelson
Contact: tech@smartanimaltraining.com
Modified Date: 7/1/2015

Description:
This app uses the acceleration data to trigger a feed command on a Pet Tutor device.
After feed is called the device must wait a set period of time before it can feed again.

NOTE: App 'print' commands must be disabled when interacting with the feeder. Print should
only be used when interacting with the virtual terminal and not he physical device.

License:
This software is provided to you through the The MIT License (MIT)

Copyright (c) 2015 Smart Animal Training Systems, LLC

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

// setup some initial variables to store acceleration values
AccelerationReading lastAccel = {0, 0, 0};

// we'll use this to dampen our results
float sensitivity = 50.0;

// store the differences between the current and previous accel data
float xDiff = 0.0;
float yDiff = 0.0;
float zDiff = 0.0;

// decide if we can trigger the feeder
boolean canTrigger = false;

void setup() 
{
  // this is important to allow the virtual terminal to recieve responses during development
  Serial.begin(57600);
  Serial.setTimeout(25);

  // start with the onboard LED off
  Bean.setLed(0,0,0);
 
  // this helps with power management. The bean can be put to sleep until something connects
  // to the device and then it'll wake back up and start running.
  Bean.enableWakeOnConnect( true ); 
}
 
void loop() 
{ 
  // we'll check if we are connected and then if we are we'll process the acceleration data
  // to determine if we should feed. If we are not connected we turn off the LED and sleep.
  bool connected = Bean.getConnectionState();
 
  if ( connected )
  {
    // a green LED means it's ready to feed while red means it can't be triggered yet
    Bean.setLed( 0, 255, 0 );

    AccelerationReading accel = {0, 0, 0};
   
    // get the acceleration data and determine if we can feed based on how long its been
    // stable, and how great the movement is.
    accel = Bean.getAcceleration();  
    if (lastAccel.xAxis == 0 && lastAccel.yAxis == 0 && lastAccel.zAxis == 0)
      lastAccel = accel;
      
    xDiff = abs(lastAccel.xAxis - accel.xAxis);
    yDiff = abs(lastAccel.yAxis - accel.yAxis);
    zDiff = abs(lastAccel.zAxis - accel.zAxis);
    
    if (xDiff > sensitivity || yDiff > sensitivity || zDiff > sensitivity)
    {     
      if (canTrigger)
      { 
        //Serial.println("Feed!"); // this is used for virtual serial processing

        // Below is the command to trigger a feed cycle on the Pet Tutor device
        // Commands ARE case sensitive
        ///////////////////////////////////
        Serial.write("CMD-ACCESSORY-FEED");
        ///////////////////////////////////
        
        canTrigger = false;
        Bean.setLed(255, 0, 0);
      }
    }    
    
    // must be stable for 3 second
    for (int i = 0; i < 3; i++)
    {
      if (xDiff < sensitivity && yDiff < sensitivity && zDiff < sensitivity && canTrigger == false)
      { 
        canTrigger = true;
        xDiff = yDiff = zDiff = 0.0;
        lastAccel.xAxis = lastAccel.yAxis = lastAccel.zAxis = 0.0;
        //Serial.println("Can feed!");
        Bean.setLed(0, 255, 0);
      }
    }
    
    lastAccel = accel;
    
    Bean.sleep(250);
  }
  else
  {
    // we are not connected to any devices so sleep until we are
    Bean.setLed( 0, 0, 0 );
    // Sleep unless woken
    Bean.sleep( 0xFFFFFFFF );
  }
}


