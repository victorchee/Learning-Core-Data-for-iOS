//
//  PrepareTableViewContorller.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/18.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface PrepareTableViewContorller : CoreDataTableViewController <UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet *clearConfirmActionSheet;

@end
