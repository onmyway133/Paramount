//
//  FTGParamountToolbar.m
//  FTGParamountDemo
//
//  Created by Khoa Pham on 8/27/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import "FTGParamountToolbar.h"
#import "FTGParamountToolbarItem.h"

@interface FTGParamountToolbar ()

@property (nonatomic, strong, readwrite) FTGParamountToolbarItem *actionItem;
@property (nonatomic, strong, readwrite) FTGParamountToolbarItem *closeItem;
@property (nonatomic, strong, readwrite) UIView *dragHandle;

@property (nonatomic, strong) UIImageView *dragHandleImageView;

@property (nonatomic, strong) NSArray *toolbarItems;

@end

@implementation FTGParamountToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *toolbarItems = [NSMutableArray array];

        self.dragHandle = [[UIView alloc] init];
        self.dragHandle.backgroundColor = [FTGParamountToolbarItem defaultBackgroundColor];
        [self addSubview:self.dragHandle];

        UIImage *dragHandle = [UIImage imageNamed:@"drag_handle"];
        self.dragHandleImageView = [[UIImageView alloc] initWithImage:dragHandle];
        [self.dragHandle addSubview:self.dragHandleImageView];

        UIImage *actionIcon = [UIImage imageNamed:@"action"];
        self.actionItem = [FTGParamountToolbarItem toolbarItemWithTitle:@"action" image:actionIcon];
        [self addSubview:self.actionItem];
        [toolbarItems addObject:self.actionItem];

        UIImage *closeIcon = [UIImage imageNamed:@"close"];
        self.closeItem = [FTGParamountToolbarItem toolbarItemWithTitle:@"close" image:closeIcon];
        [self addSubview:self.closeItem];
        [toolbarItems addObject:self.closeItem];

        self.toolbarItems = toolbarItems;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Drag Handle
    const CGFloat kToolbarItemHeight = [[self class] toolbarItemHeight];
    self.dragHandle.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, [[self class] dragHandleWidth], kToolbarItemHeight);
    CGRect dragHandleImageFrame = self.dragHandleImageView.frame;
    dragHandleImageFrame.origin.x = floor((self.dragHandle.frame.size.width - dragHandleImageFrame.size.width) / 2.0);
    dragHandleImageFrame.origin.y = floor((self.dragHandle.frame.size.height - dragHandleImageFrame.size.height) / 2.0);
    self.dragHandleImageView.frame = dragHandleImageFrame;


    // Toolbar Items
    CGFloat originX = CGRectGetMaxX(self.dragHandle.frame);
    CGFloat originY = self.bounds.origin.y;
    CGFloat height = kToolbarItemHeight;

    CGFloat width = [[self class] itemWidth];
    for (UIView *toolbarItem in self.toolbarItems) {
        toolbarItem.frame = CGRectMake(originX, originY, width, height);
        originX = CGRectGetMaxX(toolbarItem.frame);
    }
}

- (CGFloat)defaultWidth
{
    return [[self class] dragHandleWidth] + ([[self class] itemWidth] * self.toolbarItems.count);
}

#pragma mark - Sizing Convenience Methods

+ (CGFloat)toolbarItemHeight
{
    return 44.0;
}

+ (CGFloat)dragHandleWidth
{
    return 30.0;
}

+ (CGFloat)itemWidth
{
    return 44.0;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = 0.0;
    height += [[self class] toolbarItemHeight];
    return CGSizeMake(size.width, height);
}


@end
