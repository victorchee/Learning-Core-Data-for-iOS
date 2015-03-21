//
//  PrepareTableViewContorller.m
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/18.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import "PrepareTableViewContorller.h"
#import "AppDelegate.h"
#import "ItemViewController.h"

@interface PrepareTableViewContorller ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation PrepareTableViewContorller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.managedObjectModel = appDelegate.managedObjectModel;
    
    [self configureFetch];
    [self performFetch];
    
    self.clearConfirmActionSheet.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clear:(UIBarButtonItem *)sender {
    NSFetchRequest *request = [self.managedObjectModel fetchRequestTemplateForName:@"ShoppingList"];
    NSArray *shoppingList = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    if (shoppingList.count) {
        self.clearConfirmActionSheet = [[UIActionSheet alloc] initWithTitle:@"Clear Entire Shopping List?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:@"Clear"
                                                          otherButtonTitles: nil];
        [self.clearConfirmActionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing to Clear"
                                                        message:@"Add items to the Shop tab by tapping them on the Prepare tab. Remove all items from the Shopp tab by clicking Clear on the Prepare tab"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    shoppingList = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:self.clearConfirmActionSheet]) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            [self clearList];
        } else if (buttonIndex == actionSheet.cancelButtonIndex) {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }
}

- (void)clearList
{
    NSFetchRequest *request = [self.managedObjectModel fetchRequestTemplateForName:@"ShoppingList"];
    NSArray *shoppingList = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (Item *item in shoppingList) {
        item.listed = @NO;
    }
}

- (void)configureFetch
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storedIn" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.fetchBatchSize = 50;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"locationAtHome.storedIn" cacheName:nil];
    self.fetchedResultsController.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Item Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@%@ %@", item.quantity, item.unit.name, item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, title.length)];
    cell.textLabel.text = title;
    
    if ([item.listed boolValue]) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        cell.textLabel.textColor = [UIColor orangeColor];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil; // we don't want a section index.
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Item *deleteTarget = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:deleteTarget];
        [self.fetchedResultsController.managedObjectContext save:nil];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectID *itemId = [[self.fetchedResultsController objectAtIndexPath:indexPath] objectID];
    Item *item = (Item *)[self.fetchedResultsController.managedObjectContext existingObjectWithID:itemId error:nil];
    
    if ([item.listed boolValue]) {
        item.listed = @NO;
    } else {
        item.listed = @YES;
        item.collected = @NO;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ItemViewController *itemVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemVC"];
    itemVC.selectedItemID = [[self.fetchedResultsController objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Item Segue"]) {
        Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        
        NSError *error = nil;
        if (![self.managedObjectContext obtainPermanentIDsForObjects:@[newItem] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID for object %@", error);
        } else {
            ItemViewController *itemVC = segue.destinationViewController;
            itemVC.selectedItemID = newItem.objectID;
        }
    }
}
@end
