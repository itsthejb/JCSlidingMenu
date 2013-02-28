//
//  JCTableMenuViewController.m
//  SlidingMenu
//
//  Created by Jon Crooke on 20/02/2013.
//  Copyright (c) 2013 jc. All rights reserved.
//

#import "JCTableMenuViewController.h"

@interface JCTableMenuViewController ()

@end

static NSString *CellIdentifier = @"Cell";

@implementation JCTableMenuViewController

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

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTextAlignment)alignment { return NSTextAlignmentCenter; }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
  cell.textLabel.text = self.title;
  cell.textLabel.textAlignment = self.alignment;
    
    return cell;
}

- (void) viewControllerWillAppearFromSlidingViewController:(JCSlidingMenuViewController*)vc {
  NSLog(@"Will reveal %@", NSStringFromClass(self.class));
}
- (void) viewControllerWillHideFromSlidingViewController:(JCSlidingMenuViewController*)vc {
  NSLog(@"Will hide %@", NSStringFromClass(self.class));
}

- (void) viewControllerDidAppearFromSlidingViewController:(JCSlidingMenuViewController*)vc {
  NSLog(@"Did reveal %@", NSStringFromClass(self.class));
}
- (void) viewControllerDidHideFromSlidingViewController:(JCSlidingMenuViewController*)vc {
  NSLog(@"Did hide %@", NSStringFromClass(self.class));
}

@end
