//
//  ItemViewController.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/19.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ItemViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectID *selectedItemID;

@end
