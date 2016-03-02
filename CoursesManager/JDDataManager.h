//
//  JDDataManager.h
//  CoursesManager
//
//  Created by jsd on 17.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JDUser.h"
#import "JDCourse.h"

@interface JDDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (JDDataManager*) sharedManager;

- (JDUser*) addUser;
- (JDCourse*) addCourse;

@end
