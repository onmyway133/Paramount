//
//  FTGParamountViewController.m
//  FTGParamountDemo
//
//  Created by Khoa Pham on 8/27/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import "FTGParamountViewController.h"

@interface FTGParamountViewController ()

@end

@implementation FTGParamountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates
{
    return YES;
}

@end
