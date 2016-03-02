//
//  JDFormSection.m
//  CoursesManager
//
//  Created by jsd on 19.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDFormSection.h"

@implementation JDFormSection

- (instancetype)initWithTitle: (NSString*) title
{
    self = [super init];
    if (self)
    {
        self.title = title;
    }
    return self;
}

- (instancetype)initWithItems: (NSArray*) items
{
    self = [super init];
    if (self)
    {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithTitle: (NSString*) title andItems: (NSArray*) items
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.items = items;
    }
    return self;
}

@end
