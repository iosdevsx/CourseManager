//
//  JDUser+CoreDataProperties.h
//  CoursesManager
//
//  Created by jsd on 18.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *teach;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *study;

@end

@interface JDUser (CoreDataGeneratedAccessors)

- (void)addTeachObject:(NSManagedObject *)value;
- (void)removeTeachObject:(NSManagedObject *)value;
- (void)addTeach:(NSSet<NSManagedObject *> *)values;
- (void)removeTeach:(NSSet<NSManagedObject *> *)values;

- (void)addStudyObject:(NSManagedObject *)value;
- (void)removeStudyObject:(NSManagedObject *)value;
- (void)addStudy:(NSSet<NSManagedObject *> *)values;
- (void)removeStudy:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
