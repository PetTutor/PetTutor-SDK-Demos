//
//  FeedViewController.m

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

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize beanNameLabel, selectedBean;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // We set this beans delegate to this view so we recieve any callbacks here
    selectedBean.delegate = self;
    
    // setup the bean name so we know what we're working with
    if (selectedBean != nil)
        [beanNameLabel setText:[NSString stringWithFormat:@"Bean Name: %@", selectedBean.name]];
    else
        [beanNameLabel setText:@"Bean Name: Bean not available."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The feed button simply sends a Serial String of CMD-FEED. The upper case is required
// and no extra spaces should come before or after the command
- (IBAction)feedButtonPressed:(id)sender
{
    // log to the console that we are sending a feed command
    NSLog(@"Feed pressed. Sending command: CMD-FEED");
    
    ////////////////////////////////////////////
    // actually send the feed command
    [selectedBean sendSerialString:@"CMD-FEED"];
    ////////////////////////////////////////////
}

- (IBAction)scratchFeedPressed:(id)sender
{
    // log to the console that we are sending a feed command
    NSLog(@"Feed pressed. Setting Scrach Bank 5 to a value of 1.");

    // set scratch bank 5 to 1 and the device will feed
    int feedValue = 1;
    [selectedBean setScratchBank:5 data:[NSData dataWithBytes:&feedValue length:sizeof(feedValue)]];
    
    // you can also read scrach bank 5 to see if a value of 2 exists. The 2 in scratch bank 5 of a feeder is
    // equal to an ACK! message.
    //[selectedBean readScratchBank:5];
}

#pragma Mark - Bean delegate functions

// the feeder will return an ACK message after receiving the command. If you would like to
// receive this message you must include PTDBeanDelegate in your .h file and include this function
-(void) bean:(PTDBean *)bean serialDataReceived:(NSData *)data
{
    // messages are sent as data objects so convert it to a string and post to console
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received Serial Data: %@", string);
}

@end
