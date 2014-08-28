//
//  FTGParamount.m
//  FTGParamountDemo
//
//  Created by Khoa Pham on 8/27/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import "FTGParamount.h"
#import "FTGParamountWindow.h"
#import "FTGParamountViewController.h"

@interface FTGParamount ()

@property (nonatomic, strong) FTGParamountWindow *window;
@property (nonatomic, strong) FTGParamountViewController *viewController;
@property (nonatomic, copy) FTGParamountActionBlock actionBlock;

@end

@implementation FTGParamount

+ (instancetype)sharedInstance
{
    static FTGParamount *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _window = [[FTGParamountWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        _viewController = [[FTGParamountViewController alloc] init];
        _window.rootViewController = _viewController;
        //[_window addSubview:_viewController.view];
    }

    return self;
}

#pragma mark - Public Interface
+ (void)show
{
    [FTGParamount sharedInstance].window.hidden = NO;
}

+ (void)hide
{
    [FTGParamount sharedInstance].window.hidden = YES;
}

+ (void)setActionBlock:(FTGParamountActionBlock)actionBlock
{
    [FTGParamount sharedInstance].actionBlock = actionBlock;
}


@end
