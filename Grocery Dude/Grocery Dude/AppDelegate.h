//
//  AppDelegate.h
//  Grocery Dude
//
//  Created by Victor Chee on 15/2/10.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

@end

