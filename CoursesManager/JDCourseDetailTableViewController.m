//
//  JDCourseDetailTableViewController.m
//  CoursesManager
//
//  Created by jsd on 18.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDCourseDetailTableViewController.h"
#import "JDUserDetailTableViewController.h"
#import "JDUser.h"
#import "JDLabelAndFieldCell.h"
#import "JDFormSection.h"
#import "JDCourse.h"
#import "JDDataManager.h"
#import "JDTeacherPicker.h"
#import "JDStudentsPicker.h"
#import "JDHelper.h"

typedef enum {
    JDCourseDetailName,
    JDCourseDetailSubject,
    JDCourseDetailSector,
    JDCourseDetailTeacher
}JDCourseDetail;

typedef enum{
    SectionTypeInfo,
    SectionTypeStudents
}SectionType;

@interface JDCourseDetailTableViewController () <UITextFieldDelegate, JDTeacherPickerDelegate>

@property (strong, nonatomic) UIBarButtonItem* saveButton;
@property (strong, nonatomic) NSArray* sections;
@property (strong, nonatomic) JDDataManager* dataManager;
@property (strong, nonatomic) JDUser* teacher;
@property (assign, nonatomic) BOOL addUserEnable;
@property (strong, nonatomic) JDFormSection* firstSection;
@property (strong, nonatomic) JDFormSection* secondSection;

@end

@implementation JDCourseDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addUserEnable = NO;
    
    self.dataManager = [JDDataManager sharedManager];
    
    self.firstSection = [[JDFormSection alloc] init];
    self.firstSection.items = [self configuredFormCells];
    self.firstSection.title = NSLocalizedString(@"info", nil);
    
    self.secondSection = [[JDFormSection alloc] init];
    self.secondSection.items = [self.course.students allObjects];
    self.secondSection.title = NSLocalizedString(@"students", nil);
    
    self.sections = @[self.firstSection, self.secondSection];
    
    self.saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Ok-50.png"] style:UIBarButtonItemStyleDone target:self action:@selector(actionSaveCourse)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.secondSection.items = [self.course.students allObjects];
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex: SectionTypeStudents];
    [self.tableView reloadSections: indexSet withRowAnimation: UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITextField*) textFieldForIndexRow: (NSInteger) row andSection: (NSInteger) section
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:row inSection:section];
    JDLabelAndFieldCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.textField;
}

- (void) actionSaveCourse
{
    JDCourse* course;
    NSString *title;
    NSString *message;
    
    if (self.course)
    {
        course = self.course;
        title = NSLocalizedString(@"update_course", nil);
        message = NSLocalizedString(@"update_course_message", nil);
    } else
    {
        course = [self.dataManager addCourse];
        title = NSLocalizedString(@"create_course", nil);
        message = NSLocalizedString(@"create_course_message", nil);
    }
    
    for (JDLabelAndFieldCell* courseCell in [[self.sections objectAtIndex:SectionTypeInfo] items])
    {
        switch (courseCell.formType)
        {
            case JDCourseDetailName:
                course.name = courseCell.textField.text;
                break;
            case JDCourseDetailSubject:
                course.subject = courseCell.textField.text;
                break;
            case JDCourseDetailSector:
                course.sector = courseCell.textField.text;
                break;
            case JDCourseDetailTeacher:
                if (self.teacher)
                {
                    course.teacher = self.teacher;
                }
                break;
        }
    }
    [self.teacher addTeachObject:course];
    [self.dataManager saveContext];
    [JDHelper showAlert:self withTitle:title andMessage:message];
    self.addUserEnable = YES;
    self.course = course;
    [self.tableView reloadData];
}

- (NSArray*) configuredFormCells
{
    JDLabelAndFieldCell* name = [[JDLabelAndFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetail" andCellType:JDCourseDetailName];
    name.label.text = NSLocalizedString(@"course_name", nil);
    name.textField.placeholder = NSLocalizedString(@"course_name_placeholder", nil);
    name.textField.delegate = self;
    
    JDLabelAndFieldCell* subject = [[JDLabelAndFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetail" andCellType:JDCourseDetailSubject];
    subject.label.text = NSLocalizedString(@"course_subject", nil);
    subject.textField.placeholder = NSLocalizedString(@"course_subject_placeholder", nil);
    subject.textField.delegate = self;
    
    JDLabelAndFieldCell* sector = [[JDLabelAndFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetail" andCellType:JDCourseDetailSector];
    sector.label.text = NSLocalizedString(@"course_sector", nil);
    sector.textField.placeholder = NSLocalizedString(@"course_sector_placeholder", nil);
    sector.textField.delegate = self;
    
    JDLabelAndFieldCell* teacher = [[JDLabelAndFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetail" andCellType:JDCourseDetailTeacher];
    teacher.label.text = NSLocalizedString(@"course_teacher", nil);
    teacher.textField.placeholder = NSLocalizedString(@"course_teacher_placeholder", nil);
    teacher.textField.delegate = self;
    
    if (self.course)
    {
        name.textField.text = self.course.name;
        subject.textField.text = self.course.subject;
        sector.textField.text = self.course.sector;
        if (self.course.teacher)
        {
            teacher.textField.text = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstName, self.course.teacher.lastName];
        }
        self.addUserEnable = YES;
    }
    
    return @[name, subject, sector, teacher];
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
    if (section == SectionTypeInfo)
    {
        return [currentSection.items count];
    } else
    {
        return [currentSection.items count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDFormSection* section = [self.sections objectAtIndex:indexPath.section];
    
    if (indexPath.section == SectionTypeStudents)
    {
        static NSString* addStudentsIdentifier = @"AddStudentsCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addStudentsIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentsIdentifier];
        }
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"add_student", nil);
            cell.userInteractionEnabled = self.addUserEnable;
            if (!cell.userInteractionEnabled)
            {
                cell.textLabel.textColor = [UIColor lightGrayColor];
            } else
            {
                cell.textLabel.textColor = [UIColor blackColor];
            }
            
        } else
        {
            JDUser* user = [section.items objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    else if (indexPath.section == SectionTypeInfo)
    {
        JDLabelAndFieldCell* cell = [section.items objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == SectionTypeStudents)
    {
        if (indexPath.row == 0)
        {
            JDStudentsPicker* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JDStudentsPicker"];
            vc.course = self.course;
            [self presentViewController:vc animated:YES completion:nil];
        } else
        {
            JDFormSection* section = [self.sections objectAtIndex:indexPath.section];
            JDUser* user = [section.items objectAtIndex:indexPath.row - 1];
            JDUserDetailTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JDUserDetailTableViewController"];
            vc.user = user;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        JDFormSection* section = [self.sections objectAtIndex:SectionTypeStudents];
        JDUser* user = [section.items objectAtIndex:indexPath.row - 1];
        [self.course removeStudentsObject:user];
        [[JDDataManager sharedManager] saveContext];
        
        NSMutableArray* array = [section mutableArrayValueForKey:@"items"];
        [array removeObject:user];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SectionTypeStudents && indexPath.row > 0)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:[self textFieldForIndexRow:JDCourseDetailTeacher andSection:SectionTypeInfo]])
    {
        JDTeacherPicker* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JDTeacherPicker"];
        vc.delegate = self;
        if (self.teacher)
        {
            vc.selectedUser = self.teacher;
        }
        else
        {
            if (self.course.teacher)
            {
                vc.selectedUser = self.course.teacher;
            }
        }
        [self presentViewController:vc animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -JDTeacherPickerDelegate

- (void) selectedUser: (JDUser*) user
{
    self.teacher = user;
    JDFormSection* sectionInfo = [self.sections objectAtIndex:SectionTypeInfo];
    for (JDLabelAndFieldCell* cell in sectionInfo.items)
    {
        if ([cell.textField isEqual:[self textFieldForIndexRow:JDCourseDetailTeacher andSection:SectionTypeInfo]])
        {
            cell.textField.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        }
    }
}

@end
