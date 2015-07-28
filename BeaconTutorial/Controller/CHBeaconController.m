//
//  CHBeaconController.m
//  BeaconTutorial
//
//  Created by Igor Ferreira on 7/28/15.
//  Copyright © 2015 POGAmadores. All rights reserved.
//

#import "CHBeaconController.h"
#import <CoreLocation/CoreLocation.h>
#import "CHBeaconItem.h"

NSString * const CHBeaconRanged = @"CHBeaconRanged";
NSString * const CHStartedMonitoringRegion = @"CHStartedMonitoringRegion";
NSString * const CHDeterminatedStateForRegion = @"CHDeterminatedStateForRegion";
NSString * const CHEnterRegion = @"CHEnterRegion";
NSString * const CHExitRegion = @"CHExitRegion";
NSString * const CHErrorOnMonitoringRegion = @"CHErrorOnMonitoringRegion";

@interface CHBeaconController() <CLLocationManagerDelegate>

@property (strong) CLLocationManager *locationManager;
@property (strong) NSMutableArray *itens;

@end

@implementation CHBeaconController

#pragma mark - Life cicle

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		[self.locationManager requestWhenInUseAuthorization];
		self.itens = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark - Helpers

+ (CLBeaconRegion *)regionFromNotification:(NSNotification *)notification
{
	id object = notification.object;
	if ([object isKindOfClass:[CLBeaconRegion class]]) {
		return object;
	}
	return nil;
}

- (CLBeaconRegion *)beaconRegionWithItem:(CHBeaconItem *)beaconItem
{
	CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconItem.uuId
																		   major:beaconItem.majorValue
																		   minor:beaconItem.minorValue
																	  identifier:beaconItem.name];
	
	return beaconRegion;
}

- (BOOL) isMonitoringItem: (CHBeaconItem *)item
{
	return [self hasItem:item];
}

- (BOOL)hasItem:(CHBeaconItem *)item
{
	for (CHBeaconItem *storagedItem in self.itens) {
		if ([storagedItem isEqual:item]) {
			return YES;
		}
	}
	return NO;
}

#pragma mark - Start/Stop monitoring

- (void)startMonitoringItem:(CHBeaconItem *)beaconItem
{
	if ([self hasItem:beaconItem]) {
		return;
	}
	CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:beaconItem];
	[self.locationManager startMonitoringForRegion:beaconRegion];
	[self.locationManager startRangingBeaconsInRegion:beaconRegion];
	[self.itens addObject:beaconItem];
}

- (void)stopMonitoringItem:(CHBeaconItem *)beaconItem
{
	if ([self hasItem:beaconItem]) {
		CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:beaconItem];
		[self.locationManager stopMonitoringForRegion:beaconRegion];
		[self.locationManager stopRangingBeaconsInRegion:beaconRegion];
		[self.itens removeObject:beaconItem];
	}
}

#pragma mark - CLLocationManager Error State

-(void)locationManager:(nonnull CLLocationManager *)manager
monitoringDidFailForRegion:(nullable CLRegion *)region
			 withError:(nonnull NSError *)error
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CHErrorOnMonitoringRegion object:error];
}

-(void)locationManager:(nonnull CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(nonnull CLBeaconRegion *)region
			 withError:(nonnull NSError *)error
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CHErrorOnMonitoringRegion object:error];
}

#pragma mark - CLLocationManager Success State

-(void)locationManager:(nonnull CLLocationManager *)manager didEnterRegion:(nonnull CLRegion *)region
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CHEnterRegion object:region];
}

-(void)locationManager:(nonnull CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CHExitRegion object:region];
}

- (void)locationManager:(nonnull CLLocationManager *)manager
		didRangeBeacons:(nonnull NSArray<CLBeacon *> *)beacons
			   inRegion:(nonnull CLBeaconRegion *)region
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CHBeaconRanged object:beacons];
}

- (void)locationManager:(nonnull CLLocationManager *)manager
didStartMonitoringForRegion:(nonnull CLRegion *)region
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CHStartedMonitoringRegion object:region];
}

-(void)locationManager:(nonnull CLLocationManager *)manager
	 didDetermineState:(CLRegionState)state
			 forRegion:(nonnull CLRegion *)region
{
	NSDictionary *userInfo = @{@"state":[NSNumber numberWithUnsignedInteger:state]};
	[[NSNotificationCenter defaultCenter] postNotificationName:CHDeterminatedStateForRegion
														object:region
													  userInfo:userInfo];
}

@end