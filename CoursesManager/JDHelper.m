//
//  JDHelper.m
//  CoursesManager
//
//  Created by jsd on 24.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDHelper.h"

@implementation JDHelper

+ (void) showAlert: (id) target withTitle: (NSString*) title andMessage: (NSString*) message
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [target presentViewController:alertController animated:YES completion:nil];
}

@end
