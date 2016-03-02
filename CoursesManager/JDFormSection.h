//
//  JDFormSection.h
//  CoursesManager
//
//  Created by jsd on 19.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDFormSection : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSArray* items;

- (instancetype)initWithTitle: (NSString*) title;
- (instancetype)initWithItems: (NSArray*) items;
- (instancetype)initWithTitle: (NSString*) title andItems: (NSArray*) items;

@end
