//
//  ViewController.m
//  BeaconTutorial
//
//  Created by Igor Ferreira on 7/28/15.
//  Copyright © 2015 POGAmadores. All rights reserved.
//

#import "ViewController.h"
#import "CHBeaconController.h"
#import "CHBeaconItem.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *monitoringButton;
@property (strong) CHBeaconItem *beaconItem;
@property (strong) CHBeaconController *beaconController;
@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
	self.beaconController = [[CHBeaconController alloc] init];
	[self.statusLabel setText:@"Hello Beacon"];
	[self.monitoringButton setTitle:@"Start" forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitoringError:) name:CHErrorOnMonitoringRegion object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconRanged:) name:CHBeaconRanged object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedMonitoringRegion:) name:CHStartedMonitoringRegion object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(determinatedRegionState:) name:CHDeterminatedStateForRegion object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredRegion:) name:CHEnterRegion object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitRegion:) name:CHExitRegion object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void) monitoringError:(NSNotification *)notification
{
	[self.statusLabel setText:@"Error on monitoring"];
}
- (void) beaconRanged:(NSNotification *)notification
{
	CLBeacon *beacon;
	
	id object = notification.object;
	if ([object isKindOfClass:[NSArray class]]) {
		id temp = [((NSArray*)object) firstObject];
		if ([temp isKindOfClass:[CLBeacon class]]) {
			beacon = (CLBeacon *)temp;
		}
	}
	
	if (beacon) {
		[self.statusLabel setText:[NSString stringWithFormat:@"Beacon: %@ / %ld", beacon.proximityUUID.UUIDString, (long)beacon.rssi]];
	} else {
		[self.statusLabel setText:@"Beacon Ranged"];
	}
}
- (void) startedMonitoringRegion:(NSNotification *)notification
{
	[self.statusLabel setText:@"Start monitoring"];
}
- (void) determinatedRegionState:(NSNotification *)notification
{
	[self.statusLabel setText:[NSString stringWithFormat:@"Determined State: %d", [notification.userInfo[@"state"] integerValue]]];
}
- (void) enteredRegion:(NSNotification *)notification
{
	[self.statusLabel setText:@"Entered Region"];
}
- (void) exitRegion:(NSNotification *)notification
{
	[self.statusLabel setText:@"Exited Region"];
}

#pragma mark - Getters

- (CHBeaconItem *)getBeaconItem
{
	if (self.beaconItem == nil) {
		self.beaconItem = [[CHBeaconItem alloc] initWithName:@"Estimote"
														uuId:[[NSUUID alloc] initWithUUIDString:@"b9407f30-f5f8-466e-aff9-25556b57fe6d"]
													   major:1
													andMinor:2];
	}
	return self.beaconItem;
}

#pragma mark - IBActions

- (IBAction)doToggleMonitorState:(id)sender
{
	CHBeaconItem *item = [self getBeaconItem];
	if ([self.beaconController isMonitoringItem:item]) {
		[self.beaconController stopMonitoringItem:item];
		[self.monitoringButton setTitle:@"Start" forState:UIControlStateNormal];
		[self.statusLabel setText:@"Hello Beacon"];
	} else {
		[self.beaconController startMonitoringItem:item];
		[self.monitoringButton setTitle:@"Stop" forState:UIControlStateNormal];
	}
}

@end
