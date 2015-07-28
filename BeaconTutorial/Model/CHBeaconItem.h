//
//  CHBeaconItem.h
//  BeaconTutorial
//
//  Created by Igor Ferreira on 7/28/15.
//  Copyright © 2015 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CHBeaconItem : NSObject

@property (readonly, copy) NSString *name;
@property (readonly, copy) NSUUID *uuId;
@property (readonly, assign) CLBeaconMajorValue majorValue;
@property (readonly, assign) CLBeaconMinorValue minorValue;

- (instancetype) initWithName:(NSString *)name
						 uuId:(NSUUID *)uuid
						major:(CLBeaconMajorValue)major
					 andMinor:(CLBeaconMinorValue)minor;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
