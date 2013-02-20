//
//  JCSlidingMenuViewController.h
//  SlidingMenu
//
//  Created by Jon Crooke on 20/02/2013.
//  Copyright (c) 2013 jc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _slidingViewControllerState {
  SlidingMenuViewControllerStateCenter = 0,
  SlidingMenuViewControllerStateLeft,
  SlidingMenuViewControllerStateRight,
  kNumberOfSlidingMenuViewControllerStates
} SlidingMenuViewControllerState;

@interface JCSlidingMenuViewController : UIViewController

@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, assign, readonly) SlidingMenuViewControllerState state;

@end
