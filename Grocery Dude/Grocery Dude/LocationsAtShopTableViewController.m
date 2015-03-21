//
//  LocationsAtShopTVC.m
//  Grocery Dude
//
//  Created by Tim Roadley on 24/12/12.
//  Copyright (c) 2012 Tim Roadley. All rights reserved.
//

#import "LocationsAtShopTableViewController.h"
#import "LocationAtShopViewController.h"
#import "AppDelegate.h"

@interface LocationsAtShopTableViewController ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation LocationsAtShopTableViewController

#pragma mark - DATA
- (void)configureFetch {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
    request.sortDescriptors = [NSArray arrayWithObjects:
                               [NSSortDescriptor sortDescriptorWithKey:@"aisle" ascending:YES],nil];
    [request setFetchBatchSize:50];
    self.fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
}

#pragma mark - VIEW
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.managedObjectModel = appDelegate.managedObjectModel;

    [self configureFetch];
    [self performFetch];
    // Respond to changes in underlying store
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:@"SomethingChanged"
                                               object:nil];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LocationAtShop Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    LocationAtShop *locationAtShop = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = locationAtShop.aisle;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocationAtShop *deleteTarget = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - INTERACTION
- (IBAction)done:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationAtShopViewController *locationAtShopVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Add Object Segue"])
    {
        LocationAtShop *newLocationAtShop =
        [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop"
                                      inManagedObjectContext:self.managedObjectContext];
        NSError *error = nil;
        if (![self.managedObjectContext obtainPermanentIDsForObjects:[NSArray arrayWithObject:newLocationAtShop] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID for object %@", error);
        }
        locationAtShopVC.selectedObjectID = newLocationAtShop.objectID;
    }
    else if ([segue.identifier isEqualToString:@"Edit Object Segue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        locationAtShopVC.selectedObjectID = [[self.fetchedResultsController objectAtIndexPath:indexPath] objectID];
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

@end