//
//  JDTeacherPicker.m
//  CoursesManager
//
//  Created by jsd on 24.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDTeacherPicker.h"

@interface JDTeacherPicker ()

@property (strong, nonatomic) NSIndexPath* selectedRow;

@end

@implementation JDTeacherPicker
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets insets = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.tableView setContentInset:insets];
    
    if (self.selectedUser)
    {
        NSInteger rowsCount = [self.tableView numberOfRowsInSection:0];
        for (int i = 0; i < rowsCount; i++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            JDUser* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([user isEqual:self.selectedUser])
            {
                self.selectedRow = indexPath;
                break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"JDUser" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (IBAction)doneButtonAction:(UIBarButtonItem *)sender
{
    if (self.selectedRow)
    {
        JDUser* selectedUser = [self.fetchedResultsController objectAtIndexPath:self.selectedRow];
        [self.delegate selectedUser:selectedUser];
    }
    [self close];
}

- (IBAction)cancelButtonAction:(UIBarButtonItem *)sender
{
    [self close];
}

- (void) close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    JDUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    if ([indexPath isEqual:self.selectedRow])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath;
    [tableView reloadData];
}

@end
