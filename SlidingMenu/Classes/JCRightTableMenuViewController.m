//
//  JCRightTableMenuViewController.m
//  SlidingMenu
//
//  Created by Jon Crooke on 20/02/2013.
//  Copyright (c) 2013 jc. All rights reserved.
//

#import "JCRightTableMenuViewController.h"

@interface JCRightTableMenuViewController ()

@end

@implementation JCRightTableMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)title { return @"Right"; }

- (NSTextAlignment)alignment { return NSTextAlignmentRight; }

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
