//
//  CoreDataHelper.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/2/10.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;

- (void)setupCoreData;
- (void)saveContext;

@end
