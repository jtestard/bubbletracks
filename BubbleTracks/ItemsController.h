//
//  ItemsController.h
//  BubbleTracksMasterDetailComponent
//
//  Created by Jules Testard on 21/09/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSString* categoryName;
@property (strong, nonatomic) NSArray* items;

-(void) setCategoryName:(NSString *)categoryName andItems:(NSArray*) items;

@end
