//
//  JDTeacherPicker.h
//  CoursesManager
//
//  Created by jsd on 24.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDCoreDataTableViewController.h"
#import "JDUser.h"

@protocol JDTeacherPickerDelegate;

@interface JDTeacherPicker : JDCoreDataTableViewController

@property (strong, nonatomic) JDUser* selectedUser;
@property (weak, nonatomic) id <JDTeacherPickerDelegate> delegate;

@end

@protocol JDTeacherPickerDelegate <NSObject>

- (void) selectedUser: (JDUser*) user;

@end
