//
//  SearchViewController.m
//  Dashboard
//
//  Created by Benjamin SENECHAL on 23/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "SearchViewController.h"
#import "WebViewController.h"

@interface SearchViewController ()

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) Search *searchToWebView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    UIImage *background = [UIImage imageNamed:@"bg_2"];
    self.backgroundImageView = [[UIImageView alloc]initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    self.searchDisplayController.searchBar.backgroundColor = [UIColor clearColor];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    [self.view addSubview:self.searchBar];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)retrieveDataWithKeyword:(NSString *)keyword
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *url = [NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=8&q=%@",keyword];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error)
        {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
            
            if(httpResp.statusCode == 200)
            {
                NSError *jsonError;
                NSDictionary *searchesJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSMutableArray *searchesFound = [[NSMutableArray alloc]init];
                
                if(!jsonError)
                {
                    NSArray *contentOfRootDirectory = searchesJSON[@"responseData"][@"results"];
                    for(NSMutableDictionary *data in contentOfRootDirectory)
                    {
                        Search *search = [[Search alloc]initWithData:data];
                        [searchesFound addObject:search];
                    }
                }else{
                    NSLog(@"json error");
                }
                self.searchResults = [[NSArray alloc]initWithArray:searchesFound];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchDisplayController.searchResultsTableView reloadData];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
            }else{
                NSLog(@"http error");
            }
        }else{
            NSLog(@"error");
        }
    }];
    [dataTask resume];
}

- (IBAction)swipeRight:(UIGestureRecognizer *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    SearchViewController *second = [storyboard instantiateViewControllerWithIdentifier:@"weatherView"];
    second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:second animated:YES completion:nil];
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
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIView *customSelection = [[UIView alloc] initWithFrame:cell.frame];
    customSelection.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = customSelection;
    Search *s = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = [[NSString alloc]initWithCString:[s.title cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchToWebView = [self.searchResults objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"webView" sender:self];
}

#pragma mark Search Bar Configuration

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchString
{
    // TODO: Instant search
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self retrieveDataWithKeyword:searchBar.text];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"webView"])
    {
        WebViewController *next = segue.destinationViewController;
        next.searchFromSearchView = self.searchToWebView;
    }
}

@end