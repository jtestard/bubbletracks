//
//  ViewController.m
//  appAddMenu
//
//  Created by jules testard on 26/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "MenuViewController.h"
#import "BubbleTrackView.h"
#import "AudioUnitWrapper.h"
#import "TrackWrapper.h"
#import "FXWrapper.h"
#import "ViewController.h"


// The sections array and the collation are private.
@interface MenuViewController()
@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, strong) NSArray* titleForSections;
@property (nonatomic, strong) NSArray* indexTitleForSections;
- (void)configureSections;
@end


@implementation MenuViewController

@synthesize audioUnitArray, sectionsArray, selected, lastTouched, mainViewController;
@synthesize titleForSections,indexTitleForSections;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	self.title = @"Audio Units";
    NSLog(@"Counts : %i,%i", titleForSections.count,indexTitleForSections.count);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    return [titleForSections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	// The number of audio in the section is the count of the array associated with the section in the sections array.
    // There are two sections : one for tracks and one for effects. 
	NSArray *itemsInSection = [sectionsArray objectAtIndex:section];
	
    return [itemsInSection count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	NSArray *itemsInSection = [sectionsArray objectAtIndex:indexPath.section];
	
	AudioUnitWrapper *audioUnitWrapper = [itemsInSection objectAtIndex:indexPath.row];
    
    cell.textLabel.text = audioUnitWrapper.name;
	
    return cell;
}


/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [titleForSections objectAtIndex:section];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indexTitleForSections;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index==0)
        return 0;
    if (index==3)
        return 1;
    else 
        return index-1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController* viewController;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //We want to create the corresponding track at the location given by the
    UITableViewCell * tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * name = tableViewCell.textLabel.text;
    for (AudioUnitWrapper *audioUnit in audioUnitArray) {
        // Loads file or effect data from selected row.
        if (audioUnit.name == name) {
            viewController = (ViewController*)[[self.navigationController viewControllers] objectAtIndex:0];
            // This audioUnit is a track.
            if (audioUnit.type==0) {
                [viewController loadTrackFiles:name]; //XXX
            // This audioUnit is a effect.                
            } else if (audioUnit.type==1) {
                [viewController loadFXFiles:name];//XXX
            }
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    selected = false;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

#pragma mark -
#pragma mark Set the data array and configure the section data

- (void)setAudioUnitArray:(NSMutableArray *)newDataArray {
    self.titleForSections = [[NSArray alloc] initWithObjects:@"Loops",@"Effects", nil];
    self.indexTitleForSections = [[NSArray alloc] initWithObjects:@"Loops",@"Effects",@"#", nil];    
	if (newDataArray != audioUnitArray) {
		audioUnitArray = newDataArray;
	}
	if (audioUnitArray == nil) {
		self.sectionsArray = nil;
	}
	else {
		[self configureSections];
	}
}

- (void)configureSections {
	
	NSInteger index, sectionTitlesCount = [titleForSections count];
	
    // There are only two sections for now
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:3];
	
	// Set up the sections array: elements are mutable arrays that will contain the tracks for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
	}

    for (AudioUnitWrapper *audioUnit in audioUnitArray) {
        if (audioUnit.type==0) {
            // Get the array for the section.
            NSMutableArray *trackSection = [newSectionsArray objectAtIndex:0];
            [trackSection addObject:audioUnit];
        } else if (audioUnit.type==1) {
            // Get the array for the section.
            NSMutableArray *fXSection = [newSectionsArray objectAtIndex:1];
            //  Add the audio unit to the section.
            [fXSection addObject:audioUnit];            
        } else {
            NSLog(@"Object in configure sections is of the wrong class!!");
        }
    }
    
	self.sectionsArray = newSectionsArray;    
}

- (void) setUpMenuView:(CGPoint)touch {
    self.view.frame = CGRectMake(touch.x, touch.y, 320, 120);
    self.lastTouched = touch;
}
@end
