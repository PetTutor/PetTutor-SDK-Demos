//
//  MainViewController.h

/*
 Smart Animal Training Systems, LLC
 Pet Tutor Demo for iOS
 Coder: David Nelson
 Contact: tech@smartanimaltraining.com
 Modified Date: 7/1/2015
 Copyright (c) 2015 Smart Animal Training Systems, LLC. All rights reserved.
 
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

#import <UIKit/UIKit.h>
#import <PTDBeanManager.h>

@interface DevicesTableViewController : UITableViewController <PTDBeanDelegate, PTDBeanManagerDelegate>

// we need a bean manager to manage connections to the devices
@property (nonatomic, retain) PTDBeanManager *mBeanManager;

// we use a mutable array to store all available devices
@property (nonatomic, retain) NSMutableArray *mPTDevices;

// we send our connected bean forward to the next view so we store it here
@property (nonatomic, retain) PTDBean *selectedBean;

@end
