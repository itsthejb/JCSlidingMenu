//
//  TestBundle.m
//  TestBundle
//
//  Created by Jon Crooke on 20/02/2013.
//  Copyright (c) 2013 jc. All rights reserved.
//

#import "TestBundle.h"

#import "JCSlidingMenuViewController.h"

@interface JCSlidingMenuViewController (Testing)
- (void) handleGesture:(UIGestureRecognizer*)gestureRecognizer;
@end

@interface TestBundle ()
@property (strong) JCSlidingMenuViewController *controller;
@end

@implementation TestBundle

- (void)setUp
{
    [super setUp];

  self.controller = [[JCSlidingMenuViewController alloc] init];
    // Set-up code here.

//  STAssertTrue(NSClassFromString(@"SenTestCase"), @"");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
  UIPanGestureRecognizer *testGesture = [[UIPanGestureRecognizer alloc] init];
  

  [self.controller handleGesture:nil];
}

@end
