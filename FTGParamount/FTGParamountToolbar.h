//
//  FTGParamountToolbar.h
//  FTGParamountDemo
//
//  Created by Khoa Pham on 8/27/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTGParamountToolbarItem;

@interface FTGParamountToolbar : UIView

/// A view for moving the entire toolbar.
/// Users of the toolbar can attach a pan gesture recognizer to decide how to reposition the toolbar.
@property (nonatomic, strong, readonly) UIView *dragHandle;

/// Toolbar item for perform action.
/// Users of the toolbar can configure the enabled/selected state and event targets/actions.
@property (nonatomic, strong, readonly) FTGParamountToolbarItem *actionItem;

@end
