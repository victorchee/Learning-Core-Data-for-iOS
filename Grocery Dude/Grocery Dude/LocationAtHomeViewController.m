//
//  LocationAtHomeVC.m
//  Grocery Dude
//
//  Created by Tim Roadley on 24/12/12.
//  Copyright (c) 2012 Tim Roadley. All rights reserved.
//

#import "LocationAtHomeViewController.h"

@interface LocationAtHomeViewController()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation LocationAtHomeViewController

#pragma mark - VIEW
- (void)refreshInterface {
    if (self.selectedObjectID) {
        LocationAtHome *locationAtHome = (LocationAtHome*)[self.managedObjectContext existingObjectWithID:self.selectedObjectID
                                                                                      error:nil];
        self.nameTextField.text = locationAtHome.storedIn;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.managedObjectModel = appDelegate.managedObjectModel;

    [self hideKeyboardWhenBackgroundIsTapped];
    self.nameTextField.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {    [self refreshInterface];
    [self.nameTextField becomeFirstResponder];
}

#pragma mark - TEXTFIELD
- (void)textFieldDidEndEditing:(UITextField *)textField {
    LocationAtHome *locationAtHome = (LocationAtHome*)[self.managedObjectContext existingObjectWithID:self.selectedObjectID
                                                                                  error:nil];
    if (textField == self.nameTextField) {
        locationAtHome.storedIn = self.nameTextField.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged"
                                                            object:nil];
    }
}

#pragma mark - INTERACTION
- (IBAction)done:(id)sender {
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hideKeyboardWhenBackgroundIsTapped {    UITapGestureRecognizer *tgr =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}
- (void)hideKeyboard {    [self.view endEditing:YES];
}
@end