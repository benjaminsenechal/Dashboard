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
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *hiloLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *conditionsLabel;
@property (nonatomic, strong) NSArray *weather;

@end

@implementation WeatherViewController

#pragma mark Life cycle

- (Weather*)Wheater
{
    if(!_Weather) _Weather = [[Weather alloc]init];
    return _Weather;
}

- (id)init {
    if (self = [super init]) {
        _hourlyFormatter = [[NSDateFormatter alloc] init];
        _hourlyFormatter.dateFormat = @"h a";
        
        _dailyFormatter = [[NSDateFormatter alloc] init];
        _dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];

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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"Enable location"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

#pragma mark Networking

- (void)retrieveData
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/dayli?lat=%f&lon=%f&units=metric", self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude];
    NSLog(@"%@", url);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error)
        {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
            
            if(httpResp.statusCode == 200)
            {
                NSError *jsonError;
                NSDictionary *weatherJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSMutableArray *weatherFound = [[NSMutableArray alloc]init];

                if(!jsonError)
                {
                    NSString *city = weatherJSON[@"city"][@"name"];
                    
                    NSArray *contentOfRootDirectory = weatherJSON[@"list"];
                    for(NSMutableDictionary *data in contentOfRootDirectory)
                    {
                        _Weather = [[Weather alloc]initWithData:data];
                        _Weather.locationName = city;
                        [weatherFound addObject:_Weather];
                    }
                }else
                {
                    NSLog(@"Error");
                }
                
                _weather = weatherFound;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    Weather *w = [_weather firstObject];
                    _temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",[w.temperature floatValue]];
                    _hiloLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",[w.tempHigh floatValue], [w.tempLow floatValue]];
                    [_iconView setImage:[UIImage imageNamed:[w imageName]]];
                    _cityLabel.text = [w.locationName capitalizedString];
                    _conditionsLabel.text = [w.conditionDescription capitalizedString];
                    
                    [_tableView reloadData];
                    
                    [weatherFound enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                    }];
                });
            }else{
                NSLog(@"http Error %d",httpResp.statusCode);
            }
        }else{
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

#pragma mark UI

- (void)initUI
{
    NSLog(@"init ui / view did load");
    self.view.backgroundColor = [UIColor redColor];
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    self.backgroundImageView = [[UIImageView alloc]initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    CGRect hiloFrame = CGRectMake(inset,
                                  headerFrame.size.height - hiloHeight,
                                  headerFrame.size.width - (2 * inset),
                                  hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset,
                                         headerFrame.size.height - (temperatureHeight + hiloHeight),
                                         headerFrame.size.width - (2 * inset),
                                         temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset,
                                  temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight);
    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    _temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    _temperatureLabel.backgroundColor = [UIColor clearColor];
    _temperatureLabel.textColor = [UIColor whiteColor];
    _temperatureLabel.text = @"0°";
    _temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:_temperatureLabel];
    
    _hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    _hiloLabel.backgroundColor = [UIColor clearColor];
    _hiloLabel.textColor = [UIColor whiteColor];
    _hiloLabel.text = @"0° / 0°";
    _hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:_hiloLabel];
    
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    _cityLabel.backgroundColor = [UIColor clearColor];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.text = @"Loading...";
    _cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:_cityLabel];
    
    _conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    _conditionsLabel.backgroundColor = [UIColor clearColor];
    _conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    _conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:_conditionsLabel];
    
    _iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:_iconView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark Table View Configuration

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return MIN([_weather count], 6)+ 1;
    }
    return MIN([_weather count], 6)+ 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0){
        if (indexPath.row == 0)
        {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.textLabel.text = [@"Next days" capitalizedString];
            cell.detailTextLabel.text = @"";
            cell.imageView.image = nil;
        }else{
            Weather *w = [_weather objectAtIndex:indexPath.row];
            cell.textLabel.text = [self.dailyFormatter stringFromDate:w.date];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
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
