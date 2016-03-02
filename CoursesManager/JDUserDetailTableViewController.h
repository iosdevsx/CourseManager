//
//  JDUserDetailTableViewController.h
//  CoursesManager
//
//  Created by jsd on 17.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDUser.h"

@interface JDUserDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) JDUser* user;

@end
