//
//  JDCourse+CoreDataProperties.h
//  CoursesManager
//
//  Created by jsd on 18.02.16.
//  Copyright © 2016 jsd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JDCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDCourse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSString *sector;
@property (nullable, nonatomic, retain) JDUser *teacher;
@property (nullable, nonatomic, retain) NSSet<JDUser *> *students;

@end

@interface JDCourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(JDUser *)value;
- (void)removeStudentsObject:(JDUser *)value;
- (void)addStudents:(NSSet<JDUser *> *)values;
- (void)removeStudents:(NSSet<JDUser *> *)values;

@end

NS_ASSUME_NONNULL_END
