//
//  JCSlidingMenuViewController.m
//  SlidingMenu
//
//  Created by Jon Crooke on 20/02/2013.
//  Copyright (c) 2013 jc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "JCSlidingMenuViewController.h"

const CGFloat slideMinimumOffset = 50;
const CGFloat centerMenuRevealAmount = 100;

@interface JCSlidingMenuViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign, readwrite) SlidingMenuViewControllerState state;

//- (void) handleGesture;
- (void) handleGesture:(UIGestureRecognizer*)gestureRecognizer;

- (void) setState:(SlidingMenuViewControllerState)newState
         animated:(BOOL)animated;

- (SlidingMenuViewControllerState) stateForTransform:(CGAffineTransform)transform;
- (UIViewController*) viewControllerToTransitionToForTransform:(CGAffineTransform)transform;

@end

@implementation JCSlidingMenuViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // centre
  [self addChildViewController:self.centerViewController];
  [self.centerViewController didMoveToParentViewController:self];

  // left and right
  [self addChildViewController:self.leftViewController];
  [self.leftViewController didMoveToParentViewController:self];
  [self addChildViewController:self.rightViewController];
  [self.rightViewController didMoveToParentViewController:self];

  [self.view addSubview:self.leftViewController.view];
  [self.view addSubview:self.rightViewController.view];
  [self.view addSubview:self.centerViewController.view];

  self.gestureRecognizer = [[UIPanGestureRecognizer alloc]
                            initWithTarget:self
                            action:@selector(handleGesture:)];
  self.gestureRecognizer.delegate = self;
  [self.view addGestureRecognizer:self.gestureRecognizer];

  self.view.layer.shadowColor = [UIColor blackColor].CGColor;
  self.view.layer.shadowOpacity = 0.5;
  self.view.layer.shadowOffset = CGSizeZero;

  UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.frame];
  self.view.layer.shadowPath = path.CGPath;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
  CGPoint translation = [gestureRecognizer translationInView:self.view];
  CGAffineTransform transform = CGAffineTransformMakeTranslation(translation.x, 0);
  UIViewController *otherViewController = [self viewControllerToTransitionToForTransform:transform];

  switch (gestureRecognizer.state) {
    case UIGestureRecognizerStateChanged:
    {
      self.centerViewController.view.transform = transform;
      otherViewController.view.transform = transform;
    }
      break;

    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
    {
      [self setState:[self stateForTransform:self.centerViewController.view.transform]
            animated:YES];
    }

    default:
      break;
  }
}

- (SlidingMenuViewControllerState) stateForTransform:(CGAffineTransform)transform
{
  CGPoint offset = CGPointApplyAffineTransform(CGPointZero, transform);

  if (offset.x > slideMinimumOffset) {
    return SlidingMenuViewControllerStateLeft;
  }
  if (offset.x < -slideMinimumOffset) {
    return SlidingMenuViewControllerStateRight;
  }
  return SlidingMenuViewControllerStateCenter;
}



- (UIViewController*) viewControllerToTransitionToForTransform:(CGAffineTransform)transform
{
  CGPoint offset = CGPointApplyAffineTransform(CGPointZero, transform);

  if (offset.x > 0) {
    return self.rightViewController;
  } else {
    return self.leftViewController;
  }
}

- (void)setState:(SlidingMenuViewControllerState)state {
  [self setState:state animated:NO];
}

- (void) setState:(SlidingMenuViewControllerState)newState
         animated:(BOOL)animated
{
  _state = newState;

  NSArray *blocksForState = \
  @[
    ^{ // centre
      self.centerViewController.view.transform = CGAffineTransformIdentity;
      self.leftViewController.view.transform = CGAffineTransformIdentity;
      self.rightViewController.view.transform = CGAffineTransformIdentity;
    },
     ^{ // left
       self.leftViewController.view.transform = CGAffineTransformIdentity;

       CGAffineTransform offToRight = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.frame) - centerMenuRevealAmount, 0);
       self.centerViewController.view.transform = offToRight;
       self.rightViewController.view.transform = offToRight;
     },
     ^{ // right
       self.rightViewController.view.transform = CGAffineTransformIdentity;

       CGAffineTransform offToRight = CGAffineTransformMakeTranslation(-(CGRectGetWidth(self.view.frame) - centerMenuRevealAmount), 0);
       self.centerViewController.view.transform = offToRight;
       self.leftViewController.view.transform = offToRight;
     }
     ];
  NSAssert(blocksForState.count == kNumberOfSlidingMenuViewControllerStates, @"");

  dispatch_block_t block = blocksForState[self.state];

  [UIView animateWithDuration:animated ? 0.4 : 0.0
                   animations:block];
}

@end
