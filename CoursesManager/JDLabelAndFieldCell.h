//
//  JDCourseInfoCell.h
//  CoursesManager
//
//  Created by jsd on 19.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDLabelAndFieldCell : UITableViewCell

@property (strong, nonatomic, nullable) UILabel *label;
@property (strong, nonatomic, nullable) UITextField *textField;

@property (strong, nonatomic, nullable) id delegate;
@property (assign, nonatomic) NSInteger formType;

- (nullable instancetype)initWithStyle: (UITableViewCellStyle) style
              reuseIdentifier: (nullable NSString *) identifier
                  andCellType: (NSInteger) type;

@end
