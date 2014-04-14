//
//  WeatherViewController.m
//  Dashboard
//
//  Created by Benjamin SENECHAL on 14/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@property (strong, nonatomic) Weather *Weather;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation WeatherViewController
/*
- (Weather*)Wheater
{
    if(!_Weather) _Weather = [[Weather alloc]init];
    return _Weather;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations firstObject];
    [self.locationManager stopUpdatingLocation];
    [self retrieveData];
}

- (void)retrieveData
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude];
    NSLog(@"%@", url);
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error)
        {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
            
            if(httpResp.statusCode == 200)
            {
                NSError *jsonError;
                NSDictionary *weatherJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                
                if(!jsonError)
                {
                    NSArray *contentOfRootDirectory = weatherJSON[@"weather"];
                    for(NSDictionary *data in contentOfRootDirectory)
                    {
                        _Weather = [[Weather alloc]initWithData:data];
                        NSLog(@"%@", _Weather.conditionDescription);
                        NSLog(@"%@", [_Weather imageName]);
                    }
                }else
                {
                    NSLog(@"Error");
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                
            }else{
                NSLog(@"Http error");
            }
        }else{
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
