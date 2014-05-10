//
//  Nameday.m
//  Dashboard
//
//  Created by Benjamin SENECHAL on 09/05/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "Nameday.h"

@implementation Nameday

- (id)initWithData:(NSDictionary *)content
{
    self = [super init];
    if (self) {
        self.date = content[@"date"];
        self.gender = content[@"gender"];
        self.name = content[@"name"];
    }
    return self;
}

@end
