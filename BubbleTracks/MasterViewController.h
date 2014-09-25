//
//  MasterViewController.h
//  MasterDetailiPad
//
//  Created by Jules Testard on 21/09/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemsController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) ItemsController *detailViewController;

@end
