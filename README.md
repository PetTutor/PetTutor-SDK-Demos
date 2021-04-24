# PetTutor-SDK-Demos
This document contains protocols and demo applications to help programmers,engineers and hobbiests jump start development for the Smart Training Feeder by Pet Tutor(R). The Pet Tutor technology has improved over the years and there are now 2 generations of Bluetooth Low Energy(BLE) that use different open protocols to trigger the feeder. We would love to hear from you if you have questions or if you would like to share what you build.  Contact us at email: Support@PetTutor.Biz    website: PetTutor.Biz

1. BLE 4.0 Gen 2 Pet Tutor. The "Light Blue Bean" by Punch Through Design(the "Bean" device is no longer made and was only used in Gen 2 Pet Tutors).
2. BLE 4.2 Gen 3 Pet Tutor. BLE integrated in hardware by Smart Animal Training Systems, LLC (maker of Pet Tutor Gen 3)

In both generations the method to trigger the feeder from your application is to use a BLE library for your device to the send wireless BLE commands to the feeder.  This means you will need access to a BLE library and some knowledge of how to discover, connect and pass messages over BLE. Applications have been written for the following devices but not all are covered in this document: Arduino, Raspberry Pi, Android, iOS, Windows MacOS etc.

# Gen 3 Pet Tutor Smart Training Feeder
see details ---> [Gen3 and Gen2 BLE protocols](https://docs.google.com/document/d/1PxKD6AsvxdNHz8d7aNg2p_5EXLo3YyCsrwHvg-yw6h0/edit?usp=sharing)

# Gen 3 feeder Example using Raspbery Pi and openHab
blog by Paul Lambert ---> [Raspberry Pi and openHab] (https://technpol.wordpress.com/2021/04/25/pet-tutor-controlled-from-raspberry-pi-and-openhab/)

# Gen 2 Pet Tutor Smart Training Feeder
The following are examples in this document are from the older Gen 2 Pet Tutor. For any feeder sold in 2018 or later it is Gen 3(see link above)

# Prerequisites To Accessory Development:
The to allow of an open  solution to developing for the device. To learn more about the Bean and how to setup their software (required before development) go to:

A. The newer BLE 4.2 interface:

B. The Bean BLE 4.0 (older Gen 2 feeders):
https://punchthrough.com/bean/getting-started-osx/ (OSX Development Install Guide)
https://punchthrough.com/bean/getting-started-windows/ (Windows Development Install Guide)
https://punchthrough.com/bean/ (general info)

# Accessory Development
Accessories are easily developed by programming the Light Blue Beans. These accessories can interface with the Pet Tutor feeder through the free Pet Tutor Blu mobile app. https://itunes.apple.com/us/app/pettutor-blu/id934260904?mt=8 Unfortunately there is no way to achieve direct bean to bean communicaton so an intermediate communication system has been built into our application.

The process is simple: 1) Build an accessory, 2) Include the code to trigger the feeder, 3) Use the Pet Tutor app to connect your accessory to the Feeder device. 

You can also submt your .hex file to us at: tech [at] smartanimaltraining  com and we will post it on our mini-app store for free. This allows other Makers to use your ardunio apps.

# Triggering a Feed Cycle from the Arduino:

```c
Serial.write("CMD-ACCESSORY-FEED");
```

You can also trigger the feed command through the scratch banks with:

```c
Bean.setScratchNumber(5, 1);
```

# iOS/OSX Applicaiton Development
Currently you can build iOS and OSX applications to trigger feed cycles directly to the feeder. This allows for a mobile phone or BLE supported laptop to communicate with the feeder. 

You must first include the Punch Through Design Bean SDK in your app:
https://github.com/PunchThrough/Bean-iOS-OSX-SDK

Then setup and detect the Bean devices (please review our iOS code for a jump start on this!)

Then to trigger a feed via iOS/OSX:
```objective-c
[bean sendSerialString:@"CMD-FEED"];
```
When the feeder receives the command it will issue an ACK! message back to the sender.


You can also trigger a feed command via the scratch bank registers on the device. We reserved Scratch Bank 5 on feeder for feed commands. If you set Scratch Bank 5 to a value of 1 the feeder will cycle. You can then read scratch bank 5 to see if the feeder acknowledged the command. A value of 2 is the same as receiving a ACK! serial message from the feeder.

```objective-c
int feedValue = 1;
[selectedBean setScratchBank:5 data:[NSData dataWithBytes:&feedValue length:sizeof(feedValue)]];
```

Windows requires 8.1+ and currently can only be used for developing accessories and not windows applications.

# Questions? Concerns? Contact us today!

http://pettutor.biz




