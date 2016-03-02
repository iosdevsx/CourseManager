//
//  JDCourseInfoCell.m
//  CoursesManager
//
//  Created by jsd on 19.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDLabelAndFieldCell.h"

@interface JDLabelAndFieldCell()

@end

@implementation JDLabelAndFieldCell

- (nullable instancetype)initWithStyle: (UITableViewCellStyle) style
              reuseIdentifier: (nullable NSString *) identifier
                  andCellType: (NSInteger) type
{
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self)
    {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 150, 30)];
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 10, 150, 30)];
        self.formType = type;
        
        [self addSubview:self.label];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.textField.delegate = delegate;
}

@end
