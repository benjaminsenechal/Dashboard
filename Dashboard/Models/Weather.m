//
//  Weather.m
//  Dashboard
//
//  Created by Benjamin SENECHAL on 14/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "Weather.h"
@interface Weather()

@property (strong, nonatomic) NSMutableArray *MutableArray;

@end

@implementation Weather

- (NSMutableArray*)MutableArray
{
    if(!_MutableArray) _MutableArray = [[NSMutableArray alloc]init];
    return _MutableArray;
}

- (id)initWithData:(NSDictionary*)content
{
    self = [super init];
    if (self) {
        self.temperature = content[@"temp"][@"day"];
        self.tempLow = content[@"temp"][@"min"];
        self.tempHigh = content[@"temp"][@"max"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:((NSString*)(content[@"dt"])).floatValue];
        
        if(date){
            self.date=date;
        }

        for(NSDictionary *weather in content[@"weather"])
        {
            self.icon = weather[@"icon"];
            self.conditionDescription = weather[@"description"];
        }
    }
    return self;
}

+ (NSDictionary *)imageMap {
    
    static NSDictionary *_imageMap = nil;
    if (! _imageMap){
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

- (NSString *)imageName
{
    return [Weather imageMap][self.icon];
}


@end
