//
//  YLLocalSearch.m
//  yelp-ios-api-v2
//
//  Created by Fabian Canas on 6/13/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import "YLLocalSearch.h"
#import "YLClient.h"
#import "YLLocalSearchResponse.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "YLBusiness.h"

@interface YLLocalSearchResponse ()
- (instancetype)initWithV2Dictionary:(NSDictionary *)yelp;
@end

@implementation YLLocalSearch

- (instancetype)initWithMap:(MKMapView *)mapView
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _mapView = mapView;
    
    return self;
}

- (void)localSearchWithTerm:(NSString *)searchTerm
                     offset:(NSNumber *)offset
                    success:(void(^)(NSMutableArray* response)) success
                    failure:(void(^)(NSError* error)) failure
{
    YLClient *client = [YLClient new];
    
    NSDictionary *paramDictionary = @{@"location": @"indianapolis", @"term": searchTerm, @"limit": @20, @"offset": offset};

    [client getPath:@"search" parameters:paramDictionary
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSMutableArray *businesses = [NSMutableArray new];
                for (NSDictionary *bd in responseObject[@"businesses"]) {
                    YLBusiness *b = [[YLBusiness alloc] initWithDictionary:bd];
                    [businesses addObject:b];
                }
                
                success?success(businesses):0;
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure?failure(error):0;
            }];
}

- (NSDictionary *)boundingBoxFromMapRect
{
    MKMapRect mapRect = _mapView.visibleMapRect;
    CLLocationCoordinate2D nw = MKCoordinateForMapPoint(mapRect.origin);
    
    MKMapPoint southEastMapPoint = (MKMapPoint) { .x = mapRect.origin.x + mapRect.size.width, .y = mapRect.origin.y + mapRect.size.height };
    CLLocationCoordinate2D se = MKCoordinateForMapPoint(southEastMapPoint);
    
    return @{@"bounds": [NSString stringWithFormat:@"%f,%f|%f,%f",se.latitude,nw.longitude,nw.latitude,se.longitude]};
}

@end
