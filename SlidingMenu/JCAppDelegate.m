//
//  JCAppDelegate.m
//  SlidingMenu
//
//  Created by Jon Crooke on 20/02/2013.
//  Copyright (c) 2013 jc. All rights reserved.
//

#import "JCAppDelegate.h"

#import "JCSlidingMenuViewController.h"
#import "JCLeftTableMenuViewController.h"
#import "JCRightTableMenuViewController.h"

@implementation JCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];

  JCSlidingMenuViewController *slidingMenu = [[JCSlidingMenuViewController alloc] init];
  slidingMenu.leftViewController = [[JCLeftTableMenuViewController alloc] init];
  slidingMenu.rightViewController = [[JCRightTableMenuViewController alloc] init];

  UIViewController *placeholder = [[UIViewController alloc] init];
  placeholder.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
  slidingMenu.centerViewController = [[UINavigationController alloc]
                                      initWithRootViewController:placeholder];

  self.window.rootViewController = slidingMenu;

  [self.window makeKeyAndVisible];
  return YES;
}


@end
