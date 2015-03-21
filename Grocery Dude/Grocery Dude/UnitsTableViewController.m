//
//  UnitsTableViewController.m
//  Grocery Dude
//
//  Created by Victor Chee on 15/3/21.
//  Copyright (c) 2015年 Victor Chee. All rights reserved.
//

#import "UnitsTableViewController.h"
#import "AppDelegate.h"
#import "UnitViewController.h"

@interface UnitsTableViewController ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation UnitsTableViewController

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

- (IBAction)done:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureFetch
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.fetchBatchSize = 50;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Unit Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Unit *unit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = unit.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Unit *deleteTarget = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:deleteTarget];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UnitViewController *unitVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Add Object Segue"]) {
        Unit *newUnit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:self.managedObjectContext];
        NSError *error = nil;
        if (![self.managedObjectContext obtainPermanentIDsForObjects:@[newUnit] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID for object %@", error);
        }
        unitVC.selectedObjectID = newUnit.objectID;
    } else if ([segue.identifier isEqualToString:@"Edit Object Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        unitVC.selectedObjectID = [[self.fetchedResultsController objectAtIndexPath:indexPath] objectID];
    }
}


@end
