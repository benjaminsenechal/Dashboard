//
//  Search.m
//  Dashboard
//
//  Created by Benjamin SENECHAL on 29/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "Search.h"

@implementation Search

- (id)initWithData:(NSDictionary *)content
{
    self = [super init];
    if (self) {
        self.title = content[@"titleNoFormatting"];
        self.url = content[@"url"];
        self.content = content[@"content"];
    }
    return self;
}

@end
