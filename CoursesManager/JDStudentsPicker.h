//
//  JDStudentsPicker.h
//  CoursesManager
//
//  Created by jsd on 25.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDCoreDataTableViewController.h"
#import "JDCourse.h"

@interface JDStudentsPicker : JDCoreDataTableViewController

@property (strong, nonatomic) JDCourse* course;

@end
