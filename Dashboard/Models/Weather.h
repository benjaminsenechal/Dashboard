//
//  Weather.h
//  Dashboard
//
//  Created by Benjamin SENECHAL on 14/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface Weather : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSDate *sunrise;
@property (nonatomic, strong) NSDate *sunset;
@property (nonatomic, strong) NSString *conditionDescription;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSNumber *windBearing;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSString *icon;

- (id)initWithData:(NSDictionary*)content;
- (NSString *)imageName;

@end
