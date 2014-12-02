//
//  ItemsController.m
//  BubbleTracksMasterDetailComponent
//
//  Created by Jules Testard on 21/09/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "ItemsController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface ItemsController () {
    AppDelegate* _appDelegate;
}

@end

@implementation ItemsController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setCategoryName:(NSString *)categoryName andItems:(NSArray*) items {
    _categoryName = categoryName;
    _items = items;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString* fullname = (NSString*)[_items objectAtIndex:indexPath.row];
    NSArray* components = [fullname componentsSeparatedByString:@"_"];
    if (components.count < 2) {
        //It's an effect
        cell.textLabel.text = fullname;
    } else {
        //It's a track
        cell.textLabel.text = components[1];
    }
    return cell;
}


/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _categoryName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //We want to create the corresponding track at the location given by the
    UITableViewCell * tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* selectedName = tableViewCell.textLabel.text;
    if ([_categoryName isEqualToString:@"effects"]) {
        //It's an effect
        [_appDelegate.viewController loadFXFiles:selectedName];
    } else {
        //It's a track
        NSString* fullName = [@[_categoryName, selectedName] componentsJoinedByString:@"_"];
        [_appDelegate.viewController loadTrackFiles:fullName];
    }

    [_appDelegate showViewController];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

#pragma mark - UISplitViewDelegate methods
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //Set the title of the bar button item
    barButtonItem.title = _categoryName;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
}

@end
