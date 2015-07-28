//
//  CHBeaconItem.m
//  BeaconTutorial
//
//  Created by Igor Ferreira on 7/28/15.
//  Copyright © 2015 POGAmadores. All rights reserved.
//

#import "CHBeaconItem.h"

@implementation CHBeaconItem

- (instancetype) initWithName:(NSString *)name
						 uuId:(NSUUID *)uuid
						major:(CLBeaconMajorValue)major
					 andMinor:(CLBeaconMinorValue)minor
{
	self = [super init];
	if (self) {
		_name = name;
		_uuId = uuid;
		_majorValue = major;
		_minorValue = minor;
	}
	return self;
}

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon {
	return [[beacon.proximityUUID UUIDString] isEqualToString:[self.uuId UUIDString]] &&
	[beacon.major isEqual: @(self.majorValue)] &&
	[beacon.minor isEqual: @(self.minorValue)];
}

-(BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[self class]]) {
		return [super isEqual:object];
	}
	CHBeaconItem *item = (CHBeaconItem *)object;
	
	return [[item.uuId UUIDString] isEqualToString:self.uuId.UUIDString] &&
	item.majorValue == self.majorValue &&
	item.minorValue == self.minorValue;
}

@end
