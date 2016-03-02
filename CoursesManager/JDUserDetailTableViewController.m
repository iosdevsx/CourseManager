//
//  JDUserDetailTableViewController.m
//  CoursesManager
//
//  Created by jsd on 17.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDUserDetailTableViewController.h"
#import "JDCourseDetailTableViewController.h"
#import "JDDataManager.h"
#import "JDLabelAndFieldCell.h"
#import "JDFormSection.h"
#import "JDHelper.h"


typedef enum {
    JDUserDetailFirstName,
    JDUserDetailLastName,
    JDUserDetailEmail
}JDUserDetail;

typedef enum{
    SectionTypeInfo,
    SectionTypeTeach,
    SectionTypeStudy
}SectionType;

@interface JDUserDetailTableViewController ()

@property (strong, nonatomic) JDDataManager* dataManager;
@property (strong, nonatomic) UIBarButtonItem* saveButton;
@property (strong, nonatomic) NSMutableArray* sections;
@property (strong, nonatomic) NSMutableArray* textFields;

@end

@implementation JDUserDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataManager = [JDDataManager sharedManager];
    self.sections = [NSMutableArray array];
    self.textFields = [NSMutableArray array];
    
    JDFormSection* firstSection = [[JDFormSection alloc] initWithTitle:NSLocalizedString(@"info", nil)];
    firstSection.items = [self configuredFormSection];
    [self.sections addObject:firstSection];
    
    if ([[self.user.teach allObjects] count] > 0)
    {
        JDFormSection* secondSection = [[JDFormSection alloc] initWithTitle:NSLocalizedString(@"teach", nil)];
        secondSection.items = [self.user.teach allObjects];
        [self.sections addObject:secondSection];
    }
    
    if ([[self.user.study allObjects] count] > 0)
    {
        JDFormSection* thirdSection = [[JDFormSection alloc] initWithTitle:NSLocalizedString(@"study", nil)];
        thirdSection.items = [self.user.study allObjects];
        [self.sections addObject:thirdSection];
    }
    
    if (self.user)
    {
        self.navigationItem.title = NSLocalizedString(@"info", nil);
    } else
    {
        self.navigationItem.title = NSLocalizedString(@"create", nil);
    }
    
    self.saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Ok-50.png"] style:UIBarButtonItemStyleDone target:self action:@selector(actionSaveUser)];
    self.saveButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Actions

- (void) actionSaveUser
{
    JDUser* user;
    NSString* title = nil;
    NSString* message = nil;
    
    if (self.user)
    {
        user = self.user;
        title = NSLocalizedString(@"update_user", nil);
        message = NSLocalizedString(@"update_user_message", nil);
    } else
    {
        user = [self.dataManager addUser];
        title = NSLocalizedString(@"create_user", nil);
        message = NSLocalizedString(@"create_user_message", nil);
    }
    
    for (JDLabelAndFieldCell* cell in [[self.sections objectAtIndex:SectionTypeInfo] items])
    {
        [cell.textField resignFirstResponder];
        switch (cell.formType) {
            case JDUserDetailFirstName:
                user.firstName = cell.textField.text;
                break;
            case JDUserDetailLastName:
                user.lastName = cell.textField.text;
                break;
            case JDUserDetailEmail:
                user.email = cell.textField.text;
                break;
        }
    }
    
    [[JDDataManager sharedManager] saveContext];
    [JDHelper showAlert:self withTitle:title andMessage:message];
}

- (NSArray*) configuredFormSection
{
    JDLabelAndFieldCell* firstNameCell = [[JDLabelAndFieldCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                   reuseIdentifier:@"UserDetailCell"
                                                                       andCellType:JDUserDetailFirstName];
    firstNameCell.label.text = NSLocalizedString(@"user_name", nil);
    firstNameCell.textField.placeholder = NSLocalizedString(@"user_name_placeholder", nil);
    firstNameCell.delegate = self;
    
    JDLabelAndFieldCell* lastNameCell = [[JDLabelAndFieldCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                  reuseIdentifier:@"UserDetailCell"
                                                                      andCellType:JDUserDetailLastName];
    lastNameCell.label.text = NSLocalizedString(@"user_lastname", nil);
    lastNameCell.textField.placeholder = NSLocalizedString(@"user_lastname_placeholder", nil);
    lastNameCell.delegate = self;
    
    JDLabelAndFieldCell* emailCell = [[JDLabelAndFieldCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:@"UserDetailCell"
                                                                   andCellType:JDUserDetailEmail];
    emailCell.label.text = NSLocalizedString(@"user_email", nil);
    emailCell.textField.placeholder = NSLocalizedString(@"user_email_placeholder", nil);
    emailCell.delegate = self;
    
    if (self.user)
    {
        firstNameCell.textField.text = self.user.firstName;
        lastNameCell.textField.text = self.user.lastName;
        emailCell.textField.text = self.user.email;
    }
    return @[firstNameCell, lastNameCell, emailCell];
}

#pragma mark -UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    JDFormSection* currentSection = [self.sections objectAtIndex:section];
    return currentSection.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JDFormSection* currentSection = [self.sections objectAtIndex:section];
    return [currentSection.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDFormSection* section = [self.sections objectAtIndex:indexPath.section];
    
    if (indexPath.section == SectionTypeInfo)
    {
        JDLabelAndFieldCell *cell;
        if (!cell)
        {
            cell = [section.items objectAtIndex:indexPath.row];
        }
        return cell;
    }
    else
    {
        static NSString* identifier = @"TeachCourse";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (indexPath.section == SectionTypeTeach)
        {
            JDCourse* course = [section.items objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", course.name, course.subject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == SectionTypeStudy)
        {
            JDCourse* course = [section.items objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", course.name, course.subject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    return nil;
}

#pragma mark -UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == SectionTypeStudy || indexPath.section == SectionTypeTeach)
    {
        JDFormSection* section = [self.sections objectAtIndex:indexPath.section];
        JDCourse* course = [section.items objectAtIndex:indexPath.row];
        JDCourseDetailTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JDCourseDetailTableViewController"];
        vc.course = course;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (UITextField*) textFieldForIndexRow: (NSInteger) row andSection: (NSInteger) section
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:row inSection:section];
    JDLabelAndFieldCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL correctField = YES;
    NSString* resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([[self textFieldForIndexRow:JDUserDetailEmail andSection:SectionTypeInfo] isEqual:textField])
    {
        correctField = [self isEmailCorrectForString:resultString];
    }
    
    self.saveButton.enabled = correctField && [self saveButtonIsAvailable] && resultString.length > 0;
    return YES;
}

#pragma mark -Validate methods

- (BOOL) saveButtonIsAvailable
{
    JDFormSection* section = [self.sections objectAtIndex:SectionTypeInfo];
    for (JDLabelAndFieldCell* cell in section.items)
    {
        if ([cell.textField isFirstResponder])
        {
            continue;
        }
        if ([cell.textField.text length] <= 0)
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL) isEmailCorrectForString: (NSString*) string
{
    NSError* error = nil;
    NSString *pattern = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    if (numberOfMatches <= 0)
    {
        return NO;
    }
    return YES;
}

@end
