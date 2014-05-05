//
//  SearchViewController.h
//  Dashboard
//
//  Created by Benjamin SENECHAL on 23/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
