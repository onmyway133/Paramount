//
//  FTGParamountViewController.h
//  FTGParamountDemo
//
//  Created by Khoa Pham on 8/27/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTGParamount.h"

@class FTGParamountViewController;

@protocol FTGParamountViewControllerDelegate <NSObject>

- (void)viewControllerDidClose:(FTGParamountViewController *)viewController;

@end

@interface FTGParamountViewController : UIViewController

@property (nonatomic, copy) FTGParamountActionBlock actionBlock;
@property (nonatomic, weak) id<FTGParamountViewControllerDelegate> delegate;

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates;

@end
