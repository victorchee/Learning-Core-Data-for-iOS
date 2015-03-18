//
//  CoreDataTableViewController.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/18.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;

@end
