//
//  CHBeaconController.h
//  BeaconTutorial
//
//  Created by Igor Ferreira on 7/28/15.
//  Copyright © 2015 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CHBeaconRanged;
extern NSString * const CHStartedMonitoringRegion;
extern NSString * const CHDeterminatedStateForRegion;
extern NSString * const CHEnterRegion;
extern NSString * const CHExitRegion;
extern NSString * const CHErrorOnMonitoringRegion;

@class CLBeaconRegion;
@class CHBeaconItem;

@interface CHBeaconController : NSObject

+ (CLBeaconRegion *)regionFromNotification:(NSNotification *)notification;

- (void)startMonitoringItem:(CHBeaconItem *)beaconItem;
- (void)stopMonitoringItem:(CHBeaconItem *)beaconItem;
- (BOOL) isMonitoringItem: (CHBeaconItem *)item;

@end
