//
//  ItemViewController.m
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/19.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import "ItemViewController.h"
#import "AppDelegate.h"

@interface ItemViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.managedObjectModel = appDelegate.managedObjectModel;
    
    [self hideKeyboardWhenBackgroundIsTapped];
    self.nameTextField.delegate = self;
    self.quantityTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshInterface];
    if ([self.nameTextField.text isEqualToString:@"New Item"]) {
        self.nameTextField.text = @"";
        [self.nameTextField becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self ensureItemHomeLocationIsNotNull];
    [self ensureItemShopLocationIsNotNull];
    [self.managedObjectContext save:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshInterface
{
    if (self.selectedItemID) {
        Item *item = (Item *)[self.managedObjectContext existingObjectWithID:self.selectedItemID error:nil];
        self.nameTextField.text = item.name;
        self.quantityTextField.text = item.quantity.stringValue;
    }
}

- (IBAction)done:(UIBarButtonItem *)sender {
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        if ([self.nameTextField.text isEqualToString:@"New Item"]) {
            self.nameTextField.text = @"";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    Item *item = (Item *)[self.managedObjectContext existingObjectWithID:self.selectedItemID error:nil];
    if ([textField isEqual:self.nameTextField]) {
        if ([self.nameTextField.text isEqualToString:@""]) {
            self.nameTextField.text = @"New Item";
        }
        item.name = self.nameTextField.text;
    } else if ([textField isEqual:self.quantityTextField]) {
        item.quantity = @(self.quantityTextField.text.floatValue);
    }
}

- (void)ensureItemHomeLocationIsNotNull
{
    if (self.selectedItemID) {
        Item *item = (Item *)[self.managedObjectContext existingObjectWithID:self.selectedItemID error:nil];
        if (!item.locationAtHome) {
            NSFetchRequest *request = [self.managedObjectModel fetchRequestTemplateForName:@"UnknownLocationAtHome"];
            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:nil];
            if (fetchedObjects.count) {
                item.locationAtHome = fetchedObjects[0];
            } else {
                LocationAtHome *locationAtHome = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:self.managedObjectContext];
                NSError *error = nil;
                if (![self.managedObjectContext obtainPermanentIDsForObjects:@[locationAtHome] error:&error]) {
                    NSLog(@"Couldn't obtain a permanent ID for object %@", error);
                }
                locationAtHome.storedIn = @"..Unknown Location..";
                item.locationAtHome = locationAtHome;
            }
        }
    }
}

- (void)ensureItemShopLocationIsNotNull
{
    if (self.selectedItemID) {
        Item *item = (Item *)[self.managedObjectContext existingObjectWithID:self.selectedItemID error:nil];
        if (!item.locationAtShop) {
            NSFetchRequest *request = [self.managedObjectModel fetchRequestTemplateForName:@"UnknownLocationAtShop"];
            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:nil];
            if (fetchedObjects.count) {
                item.locationAtShop = fetchedObjects[0];
            } else {
                LocationAtShop *locationAtShop = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:self.managedObjectContext];
                NSError *error = nil;
                if (![self.managedObjectContext obtainPermanentIDsForObjects:@[locationAtShop] error:&error]) {
                    NSLog(@"Couldn't obtain a permanent ID for object %@", error);
                }
                locationAtShop.aisle = @"..Unknown Location..";
                item.locationAtShop = locationAtShop;
            }
        }
    }
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
