//
//  AppDelegate.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/2/13.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MigrationViewController.h"
#import "Item.h"
#import "Unit.h"
#import "LocationAtHome.h"
#import "LocationAtShop.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) MigrationViewController *migrationViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

