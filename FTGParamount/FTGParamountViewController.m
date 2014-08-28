//
//  FTGParamountViewController.m
//  FTGParamountDemo
//
//  Created by Khoa Pham on 8/27/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import "FTGParamountViewController.h"
#import "FTGParamountToolbar.h"
#import "FTGParamountToolbarItem.h"


@interface FTGParamountViewController ()

@property (nonatomic, strong) FTGParamountToolbar *toolbar;

// Only valid while a toolbar drag pan gesture is in progress.
@property (nonatomic, assign) CGRect toolbarFrameBeforeDragging;

@end

@implementation FTGParamountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Toolbar
    self.toolbar = [[FTGParamountToolbar alloc] init];
    CGSize toolbarSize = [self.toolbar sizeThatFits:self.view.bounds.size];
    // Start the toolbar off below any bars that may be at the top of the view.
    CGFloat toolbarOriginY = 100.0;
    self.toolbar.frame = CGRectMake(0.0, toolbarOriginY, [self.toolbar defaultWidth], toolbarSize.height);
    
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.toolbar];

    [self setupToolbarActions];
    [self setupToolbarGestures];
}

#pragma mark - Status Bar Wrangling for iOS 7

// Try to get the preferred status bar properties from the app's root view controller (not us).
// In general, our window shouldn't be the key window when this view controller is asked about the status bar.
// However, we guard against infinite recursion and provide a reasonable default for status bar behavior in case our window is the keyWindow.

- (UIViewController *)viewControllerForStatusBarAndOrientationProperties
{
    UIViewController *viewControllerToAsk = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    // On iPhone, modal view controllers get asked
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        while (viewControllerToAsk.presentedViewController) {
            viewControllerToAsk = viewControllerToAsk.presentedViewController;
        }
    }

    return viewControllerToAsk;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *viewControllerToAsk = [self viewControllerForStatusBarAndOrientationProperties];
    UIStatusBarStyle preferredStyle = UIStatusBarStyleDefault;
    if (viewControllerToAsk && viewControllerToAsk != self) {
        // We might need to foward to a child
        UIViewController *childViewControllerToAsk = [viewControllerToAsk childViewControllerForStatusBarStyle];
        if (childViewControllerToAsk) {
            preferredStyle = [childViewControllerToAsk preferredStatusBarStyle];
        } else {
            preferredStyle = [viewControllerToAsk preferredStatusBarStyle];
        }
    }
    return preferredStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIViewController *viewControllerToAsk = [self viewControllerForStatusBarAndOrientationProperties];
    UIStatusBarAnimation preferredAnimation = UIStatusBarAnimationFade;
    if (viewControllerToAsk && viewControllerToAsk != self) {
        preferredAnimation = [viewControllerToAsk preferredStatusBarUpdateAnimation];
    }
    return preferredAnimation;
}

- (BOOL)prefersStatusBarHidden
{
    UIViewController *viewControllerToAsk = [self viewControllerForStatusBarAndOrientationProperties];
    BOOL prefersHidden = NO;
    if (viewControllerToAsk && viewControllerToAsk != self) {
        // Again, we might need to forward to a child
        UIViewController *childViewControllerToAsk = [viewControllerToAsk childViewControllerForStatusBarHidden];
        if (childViewControllerToAsk) {
            prefersHidden = [childViewControllerToAsk prefersStatusBarHidden];
        } else {
            prefersHidden = [viewControllerToAsk prefersStatusBarHidden];
        }
    }
    return prefersHidden;
}


#pragma mark - Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *viewControllerToAsk = [self viewControllerForStatusBarAndOrientationProperties];
    NSUInteger supportedOrientations = [self infoPlistSupportedInterfaceOrientationsMask];
    if (viewControllerToAsk && viewControllerToAsk != self) {
        supportedOrientations = [viewControllerToAsk supportedInterfaceOrientations];
    }

    // The UIViewController docs state that this method must not return zero.
    // If we weren't able to get a valid value for the supported interface orientations, default to all supported.
    if (supportedOrientations == 0) {
        supportedOrientations = UIInterfaceOrientationMaskAll;
    }

    return supportedOrientations;
}

- (BOOL)shouldAutorotate
{
    UIViewController *viewControllerToAsk = [self viewControllerForStatusBarAndOrientationProperties];
    BOOL shouldAutorotate = YES;
    if (viewControllerToAsk && viewControllerToAsk != self) {
        shouldAutorotate = [viewControllerToAsk shouldAutorotate];
    }
    return shouldAutorotate;
}

#pragma mark - Toolbar Buttons

- (void)setupToolbarActions
{
    [self.toolbar.actionItem addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.closeItem addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionButtonTapped:(FTGParamountToolbarItem *)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)closeButtonTapped:(FTGParamountToolbarItem *)sender
{
    [self.delegate viewControllerDidClose:self];
}

#pragma mark - Toolbar Dragging

- (void)setupToolbarGestures
{
    // Pan gesture for dragging.
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleToolbarPanGesture:)];
    [self.toolbar.dragHandle addGestureRecognizer:panGR];
}

- (void)handleToolbarPanGesture:(UIPanGestureRecognizer *)panGR
{
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
            self.toolbarFrameBeforeDragging = self.toolbar.frame;
            [self updateToolbarPostionWithDragGesture:panGR];
            break;

        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            [self updateToolbarPostionWithDragGesture:panGR];
            break;

        default:
            break;
    }
}

- (void)updateToolbarPostionWithDragGesture:(UIPanGestureRecognizer *)panGR
{
    CGPoint translation = [panGR translationInView:self.view];

    CGRect newToolbarFrame = self.toolbarFrameBeforeDragging;
    newToolbarFrame.origin.y += translation.y;
    newToolbarFrame.origin.x += translation.x;

    CGFloat maxY = CGRectGetMaxY(self.view.bounds) - newToolbarFrame.size.height;
    CGFloat maxX = CGRectGetMaxX(self.view.bounds) - [self.toolbar defaultWidth];

    // X
    if (newToolbarFrame.origin.x < 0.0) {
        newToolbarFrame.origin.x = 0.0;
    } else if (newToolbarFrame.origin.x > maxX) {
        newToolbarFrame.origin.x = maxX;
    }

    // Y
    if (newToolbarFrame.origin.y < 0.0) {
        newToolbarFrame.origin.y = 0.0;
    } else if (newToolbarFrame.origin.y > maxY) {
        newToolbarFrame.origin.y = maxY;
    }

    self.toolbar.frame = newToolbarFrame;
}

#pragma mark - Touch Handling

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates
{
    BOOL shouldReceiveTouch = NO;

    CGPoint pointInLocalCoordinates = [self.view convertPoint:pointInWindowCoordinates fromView:nil];

    // Always if it's on the toolbar
    if (CGRectContainsPoint(self.toolbar.frame, pointInLocalCoordinates)) {
        shouldReceiveTouch = YES;
    }

    return shouldReceiveTouch;
}

#pragma mark - Info
- (UIInterfaceOrientationMask)infoPlistSupportedInterfaceOrientationsMask
{
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
    UIInterfaceOrientationMask supportedOrientationsMask = 0;
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationPortrait"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskPortrait;
    }
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationMaskLandscapeRight"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskLandscapeRight;
    }
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationMaskPortraitUpsideDown"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeLeft"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskLandscapeLeft;
    }
    return supportedOrientationsMask;
}

@end

