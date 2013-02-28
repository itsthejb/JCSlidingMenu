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
@property (nonatomic, assign) CGPoint positionAtStart;
@property (nonatomic, assign) BOOL hasSentRevealMessage;

//- (void) handleGesture;
- (void) handleGesture:(UIGestureRecognizer*)gestureRecognizer;

- (void) setState:(SlidingMenuViewControllerState)newState
         animated:(BOOL)animated;

- (SlidingMenuViewControllerState) stateForOffset:(CGFloat) offset;
- (UIViewController <SlidingMenuViewControllerDelegate>*) viewControllerToTransitionToForTransform:(CGAffineTransform)transform;

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

  self.leftViewController.view.frame = self.view.bounds;
  self.rightViewController.view.frame = self.view.bounds;
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

  CGAffineTransform transform = CGAffineTransformTranslate(self.centerViewController.view.transform, translation.x, 0);

  UIViewController <SlidingMenuViewControllerDelegate> *otherViewController = [self viewControllerToTransitionToForTransform:transform];

  switch (gestureRecognizer.state) {
    case UIGestureRecognizerStateBegan:
      self.positionAtStart = CGPointApplyAffineTransform(CGPointZero,
                                                         self.centerViewController.view.transform);
      self.hasSentRevealMessage = NO;
      // fall through
    case UIGestureRecognizerStateChanged:
    {
      if (!self.hasSentRevealMessage) {

        UIViewController <SlidingMenuViewControllerDelegate> *toBeRevealed = self.leftViewController;
        if (otherViewController == self.leftViewController) {
          toBeRevealed = self.rightViewController;
        }

        [toBeRevealed viewControllerWillAppearFromSlidingViewController:self];

        if (self.state != SlidingMenuViewControllerStateCenter) {
          [otherViewController viewControllerWillHideFromSlidingViewController:self];
        }

        self.hasSentRevealMessage = YES;
      }

      self.centerViewController.view.transform = transform;
      otherViewController.view.transform = transform;
    }
      break;

    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
    {
      CGPoint offset = CGPointApplyAffineTransform(CGPointZero,
                                                   self.centerViewController.view.transform);

      [self setState:[self stateForOffset:offset.x]
            animated:YES];

      self.positionAtStart = CGPointZero;
    }

    default:
      break;
  }

  [gestureRecognizer setTranslation:CGPointZero inView:self.view];
}

- (SlidingMenuViewControllerState) stateForOffset:(CGFloat) offset
{
  if (offset > slideMinimumOffset) {
    if (self.state == SlidingMenuViewControllerStateCenter) {
      return SlidingMenuViewControllerStateLeft;
    }
  }
  if (offset < -slideMinimumOffset) {
    if (self.state == SlidingMenuViewControllerStateCenter) {
      return SlidingMenuViewControllerStateRight;
    }
  }
  return SlidingMenuViewControllerStateCenter;
}

- (UIViewController <SlidingMenuViewControllerDelegate>*) viewControllerToTransitionToForTransform:(CGAffineTransform)transform
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
  __block UIViewController <SlidingMenuViewControllerDelegate> *toBeRevealed = nil;
  __block UIViewController <SlidingMenuViewControllerDelegate> *toBeHidden = nil;

  switch (newState) {
    case SlidingMenuViewControllerStateCenter:
    {
      toBeHidden = (
                    self.state == SlidingMenuViewControllerStateLeft ?
                    self.leftViewController :
                    self.rightViewController
                    );
    }
      break;

    case SlidingMenuViewControllerStateLeft:
      toBeRevealed = self.leftViewController;
      break;

    case SlidingMenuViewControllerStateRight:
      toBeRevealed = self.rightViewController;
      break;

    default:
      break;
  }

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

  [UIView animateWithDuration:animated ? 0.2 : 0.0
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:
   ^{
     self.gestureRecognizer.enabled = NO;
     block();
   } completion:^(BOOL finished) {
     self.gestureRecognizer.enabled = YES;

     [toBeRevealed viewControllerDidAppearFromSlidingViewController:self];
     [toBeHidden viewControllerDidHideFromSlidingViewController:self];
   }];
}

@end
