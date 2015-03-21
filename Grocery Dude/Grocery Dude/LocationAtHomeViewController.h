//
//  LocationAtHomeVC.h
//  Grocery Dude
//
//  Created by Tim Roadley on 24/12/12.
//  Copyright (c) 2012 Tim Roadley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LocationAtHomeViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectID *selectedObjectID;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@end