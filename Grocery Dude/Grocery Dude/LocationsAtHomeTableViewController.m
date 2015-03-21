//
//  LocationsAtHomeTVC.m
//  Grocery Dude
//
//  Created by Tim Roadley on 24/12/12.
//  Copyright (c) 2012 Tim Roadley. All rights reserved.
//

#import "LocationsAtHomeTableViewController.h"
#import "LocationAtHomeViewController.h"
#import "AppDelegate.h"

@interface LocationsAtHomeTableViewController ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation LocationsAtHomeTableViewController

#pragma mark - DATA
- (void)configureFetch {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
    request.sortDescriptors = [NSArray arrayWithObjects:
                               [NSSortDescriptor sortDescriptorWithKey:@"storedIn" ascending:YES],nil];
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
    static NSString *cellIdentifier = @"LocationAtHome Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    LocationAtHome *locationAtHome = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = locationAtHome.storedIn;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocationAtHome *deleteTarget = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
    LocationAtHomeViewController *locationAtHomeVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Add Object Segue"])
    {
        LocationAtHome *newLocationAtHome =
        [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome"
                                      inManagedObjectContext:self.managedObjectContext];
        NSError *error = nil;
        if (![self.managedObjectContext obtainPermanentIDsForObjects:[NSArray arrayWithObject:newLocationAtHome] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID for object %@", error);
        }
        locationAtHomeVC.selectedObjectID = newLocationAtHome.objectID;
    }
    else if ([segue.identifier isEqualToString:@"Edit Object Segue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        locationAtHomeVC.selectedObjectID = [[self.fetchedResultsController objectAtIndexPath:indexPath] objectID];
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

@end