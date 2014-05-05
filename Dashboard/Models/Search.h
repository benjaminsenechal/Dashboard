//
//  Search.h
//  Dashboard
//
//  Created by Benjamin SENECHAL on 29/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

- (id)initWithData:(NSDictionary *)content;

@end
