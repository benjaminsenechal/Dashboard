//
//  Nameday.h
//  Dashboard
//
//  Created by Benjamin SENECHAL on 09/05/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Nameday : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *name;

- (id)initWithData:(NSDictionary *)content;

@end
