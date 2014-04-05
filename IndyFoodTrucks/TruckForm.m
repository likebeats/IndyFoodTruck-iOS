//
//  TruckForm.m
//  IndyFoodTrucks
//
//  Created by Manny on 4/4/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "TruckForm.h"

@implementation TruckForm

- (NSArray *)fields
{
    return @[@"truckName",
             @"truckInfo",
             @"truckMenuURL",
             @"truckWebsite",
             @"truckPhone"];
}


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_truckName forKey:@"_truckName"];
    [aCoder encodeObject:_truckInfo forKey:@"_truckInfo"];
    [aCoder encodeObject:_truckMenuURL forKey:@"_truckMenuURL"];
    [aCoder encodeObject:_truckWebsite forKey:@"_truckWebsite"];
    [aCoder encodeObject:_truckPhone forKey:@"_truckPhone"];
    [aCoder encodeObject:_truckAvatarURL forKey:@"_truckAvatarURL"];
    
    [aCoder encodeObject:_truckTwitter forKey:@"_truckTwitter"];
    [aCoder encodeObject:_truckTwitterId forKey:@"_truckTwitterId"];
    [aCoder encodeObject:_truckId forKey:@"_truckId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _truckName = [aDecoder decodeObjectForKey:@"_truckName"];
        _truckInfo = [aDecoder decodeObjectForKey:@"_truckInfo"];
        _truckMenuURL = [aDecoder decodeObjectForKey:@"_truckMenuURL"];
        _truckWebsite = [aDecoder decodeObjectForKey:@"_truckWebsite"];
        _truckPhone = [aDecoder decodeObjectForKey:@"_truckPhone"];
        _truckAvatarURL = [aDecoder decodeObjectForKey:@"_truckAvatarURL"];
        
        _truckTwitterId = [aDecoder decodeObjectForKey:@"_truckTwitterId"];
        _truckTwitter = [aDecoder decodeObjectForKey:@"_truckTwitter"];
        _truckId = [aDecoder decodeObjectForKey:@"_truckId"];
        
    }
    return self;
}

@end
