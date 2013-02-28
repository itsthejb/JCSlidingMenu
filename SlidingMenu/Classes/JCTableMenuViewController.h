//
//  JCTableMenuViewController.h
//  SlidingMenu
//
//  Created by Jon Crooke on 20/02/2013.
//  Copyright (c) 2013 jc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSlidingMenuViewController.h"

@interface JCTableMenuViewController : UITableViewController <SlidingMenuViewControllerDelegate>

- (NSTextAlignment)alignment;

@end
