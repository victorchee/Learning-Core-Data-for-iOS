//
//  ShopTableViewController.m
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/19.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import "ShopTableViewController.h"
#import "AppDelegate.h"
#import "ItemViewController.h"

@interface ShopTableViewController ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end

@implementation ShopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.managedObjectModel = appDelegate.managedObjectModel;

    [self configureFetch];
    [self performFetch];
    
    // Respond to changes in underlying store
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clear:(UIBarButtonItem *)sender {
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing to Clear"
                                                        message:@"Add items using the Prepare tab"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    BOOL nothingCleared = YES;
    
    for (Item *item in self.fetchedResultsController.fetchedObjects) {
        if (item.collected.boolValue) {
            item.listed = @NO;
            item.collected = @NO;
            nothingCleared = NO;
        }
    }
    
    if (nothingCleared) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Select items to be removed from the list before pressing Clear"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)configureFetch
{
    NSFetchRequest *request = [[self.managedObjectModel fetchRequestTemplateForName:@"ShoppingList"] copy];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtShop.aisle" ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.fetchBatchSize = 50;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"locationAtShop.aisle" cacheName:nil];
    self.fetchedResultsController.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Shop Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@%@ %@", item.quantity, item.unit.name, item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, title.length)];
    cell.textLabel.text = title;
    
    // make collected item green
    if ([item.collected boolValue]) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        cell.textLabel.textColor = [UIColor colorWithRed:0.368627450 green:0.741176470 blue:0.349019607 alpha:1.0];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil; // prevent section index.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([item.collected boolValue]) {
        item.collected = @NO;
    } else {
        item.collected = @YES;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ItemViewController *itemVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemVC"];
    itemVC.selectedItemID = [[self.fetchedResultsController objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
