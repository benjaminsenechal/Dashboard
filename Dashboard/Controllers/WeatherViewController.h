//
//  WeatherViewController.h
//  Dashboard
//
//  Created by Benjamin SENECHAL on 14/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
@interface WeatherViewController : UIViewController<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@end
