//
//  MainViewController.m

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

#import "DevicesTableViewController.h"
#import "FeedViewController.h"

@implementation DevicesTableViewController

@synthesize mBeanManager, mPTDevices, selectedBean;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup our manager (which will start looking for devices)
    mBeanManager = [[PTDBeanManager alloc] initWithDelegate:self];

    // initialize our array to store devices
    mPTDevices = [NSMutableArray array];
}


#pragma mark UITableViewDataSource

// our ptDevices will represent all available devices and a table view will list each one
// with is cooresponding state. When a user selects one it will try and connect and go to the
// next screen with a feed button on it
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mPTDevices count];
}

// this is a UI element for the table view describing whats in the list below:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Available Devices:";
}

// draw the table view cells with the bean name and its status
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTDBean *bean = [mPTDevices objectAtIndex:indexPath.row];
    
    NSLog(@"Bean name is: %@", bean.name);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = bean.name;

    NSString* state;
    switch ( bean.state)
    {
        case BeanState_Unknown:
            state = @"Unknown";
            break;
        case BeanState_Discovered:
            state = @"Disconnected";
            break;
        case BeanState_AttemptingConnection:
            state = @"Connecting...";
            break;
        case BeanState_AttemptingValidation:
            state = @"Connecting...";
            break;
        case BeanState_ConnectedAndValidated:
            state = @"Connected";
            break;
        case BeanState_AttemptingDisconnection:
            state = @"Disconnecting...";
            break;
        default:
            state = @"Invalid";
            break;
    }
    
    // set status of this bean
    [cell.detailTextLabel setText:state];
    
    return cell;
}

// when selecting a cell we call beanManager's connectToBean function if it's state is not "Connected"
// otherwise we attempt to disconnect the bean
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTDBean *bean = [mPTDevices objectAtIndex:indexPath.row];
    self.selectedBean = bean;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSError *error;
    
    // its connected to disconnect the bean
    if ([cell.detailTextLabel.text isEqualToString:@"Connected"])
    {
        [mBeanManager disconnectBean:bean error:nil];
    }
    else // it's not connected to try and connect
    {
        [cell.detailTextLabel.text isEqualToString:@"Connecting..."];
        
        [mBeanManager connectToBean:bean error:&error];
        if (error)
            NSLog(@"Error connecting to bean: %@", [error description]);
    }
}


// bean manager callbacks are events that are called when things happen (i.e. a bean is discovered)
#pragma mark - BeanManagerDelegate Callbacks

// this is called when the device starts up/or is intiialized and starts
- (void)beanManagerDidUpdateState:(PTDBeanManager *)manager
{
    if(manager.state == BeanManagerState_PoweredOn)
    {
        // if we're on, scan for advertisting beans
        NSError* scanError;
        [manager startScanningForBeans_error:&scanError];
        if (scanError)
        {
            NSLog(@"Scan Error: %@", [scanError localizedDescription]);
        }
    }
    else if (manager.state == BeanManagerState_PoweredOff)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Turn on bluetooth to continue" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
}

// Each time the bean manager discovers a new bean we add it to our list and refresh the table view
- (void)BeanManager:(PTDBeanManager*)beanManager didDiscoverBean:(PTDBean*)bean error:(NSError*)error
{
    NSLog(@"Discovered a bean: %@ id: %@", bean.name, bean.identifier.UUIDString);
    
    if (error)
    {
        NSLog(@"Error discovering bean: %@", [error description]);
        return;
    }
    
    // New bean, add it to our device listing and refresh the table view
    NSLog(@"BeanManager found bean: %@", bean);
    [mPTDevices addObject:bean];
    
    [self.tableView reloadData];
}

// When we call "connect to bean" this is returned when the connecting completes (or fails)
-(void) beanManager:(PTDBeanManager *)beanManager didConnectBean:(PTDBean *)bean error:(NSError *)error
{
    // refresh the table so it now says "connected" next to this bean
    [self.tableView reloadData];
    
    NSLog(@"Connected, now headed to feed view");

    // we connected so head over to view the bean info
    [self performSegueWithIdentifier:@"feedViewSeg" sender:nil];
}

// we disconnect from the bean manager and refresh the table view so we can see the change
-(void) beanManager:(PTDBeanManager *)beanManager didDisconnectBean:(PTDBean *)bean error:(NSError *)error
{
    [self.tableView reloadData];
}


// UI feature declaring what this app is for and how to contact us
- (IBAction)helpPressed:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Smart Animal Training Systems, LLC" message:@"This demo is provided to you through the MIT open source license. This app demonstrates how to conntect to a Pet Tutor (http://pettutor.biz) device. For more information, please contact us at http://pettutor.biz" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}



#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"feedViewSeg"])
    {
        FeedViewController *feedVC = [segue destinationViewController];
        feedVC.selectedBean = self.selectedBean;
    }
}

@end
