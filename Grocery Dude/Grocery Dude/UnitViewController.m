//
//  UnitViewController.m
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/21.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import "UnitViewController.h"

@interface UnitViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation UnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.managedObjectModel = appDelegate.managedObjectModel;
    
    [self hideKeyboardWhenBackgroundIsTapped];
    self.nameTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshInterface];
    [self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshInterface
{
    if (self.selectedObjectID) {
        Unit *unit = (Unit *)[self.managedObjectContext existingObjectWithID:self.selectedObjectID error:nil];
        self.nameTextField.text = unit.name;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        
        Unit *unit = (Unit *)[self.managedObjectContext existingObjectWithID:self.selectedObjectID error:nil];
        unit.name = self.nameTextField.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    }
}

- (IBAction)done:(id)sender
{
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboardWhenBackgroundIsTapped
{
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tgr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tgr];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
