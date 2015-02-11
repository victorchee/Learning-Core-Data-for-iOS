//
//  CoreDataHelper.m
//  Grocery Dude
//
//  Created by Victor Chee on 15/2/10.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

#define debug 1

#pragma mark - FILES
NSString *storeFilename = @"Grocery-Dude.sqlite";

#pragma mark - PATHS
- (NSString *)applicationDocumentDirectory
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL *)applicationStoreDirectory
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storesDirectory.path]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
            if (debug == 1) {
                NSLog(@"Successfully created Stores directory");
            } else {
                NSLog(@"Failed to create Stores directory: %@", error);
            }
        }
    }
    return storesDirectory;
}

- (NSURL *)storeURL
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [[self applicationStoreDirectory] URLByAppendingPathComponent:storeFilename];
}

#pragma mark - SETUP
- (instancetype)init
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self = [super init]) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:_coordinator];
    }
    return self;
}

- (void)loadStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_store) {
        // Don't load store if it's already loaded
        return;
    } else {
        NSError *error = nil;
        NSDictionary *options = @{NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}};
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                            configuration:nil
                                                      URL:[self storeURL]
                                                  options:options
                                                    error:&error];
        if (!_store) {
            NSLog(@"Failed to add store. Error: %@", error);
            abort();
        } else {
            if (debug == 1) {
                NSLog(@"Successfully added store: %@", _store);
            }
        }
    }
}

- (void)setupCoreData
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self loadStore];
}

#pragma mark - SAVING
- (void)saveContext
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_context.hasChanges) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _context: %@", error);
        }
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

@end
