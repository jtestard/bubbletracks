//
//  MasterViewController.m
//  MasterDetailiPad
//
//  Created by Jules Testard on 21/09/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "MasterViewController.h"
#import "ItemsController.h"

@interface MasterViewController () {
    NSMutableDictionary* _categories;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void) setupCategories {
    if (!_categories) {
        NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
        NSPredicate *fltr = [NSPredicate predicateWithFormat:@"(self ENDSWITH '.mp3') OR (self ENDSWITH '.wav')"];
        NSArray *audiofiles = [dirContents filteredArrayUsingPredicate:fltr];
        NSMutableDictionary* categories = [[NSMutableDictionary alloc] initWithCapacity:[audiofiles count]];
        for (NSString* audiofile in audiofiles) {
            NSArray* components = [audiofile componentsSeparatedByString:@"_"];
            //Assumes there will be exactly two components.
            if (![categories objectForKey:components[0]]) {
                categories[components[0]] = [[NSMutableArray alloc] init];
                [(NSMutableArray*) categories[components[0]] addObject:audiofile];
            } else {
                [(NSMutableArray*) categories[components[0]] addObject:audiofile];
            }
        }
        categories[@"effects"] = [[NSMutableArray alloc] initWithObjects:
                                  @"Delay",
                                  @"HighPassFilter",
                                  @"Reverb",
                                  @"LowPassFilter",
                                  @"BandPassFilter",
                                  nil];
        _categories = categories;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupCategories];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int i = 0; i < _categories.count; i++) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    self.detailViewController = (ItemsController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [_categories allKeys][indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* category = [_categories allKeys][indexPath.row];
    [self.detailViewController setCategoryName:category andItems:_categories[category]];
}

@end
