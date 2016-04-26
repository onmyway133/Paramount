//
//  ViewController.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {

  public var action: Action?
  public var close: Action?

  var toolbar: Toolbar!

  // Only valid while a toolbar drag pan gesture is in progress.
  var toolbarFrameBeforeDragging: CGRect = CGRectZero

  // MARK: - Life cycle

  public override func viewDidLoad() {
    super.viewDidLoad()

    setupToolbar()
  }

  func setupToolbar() {
    toolbar = Toolbar()
    view.addSubview(toolbar)
    toolbar.frame.origin.y = 100

    toolbar.actionItem.addTarget(self, action: #selector(actionDidTouch), forControlEvents: .TouchUpInside)
    toolbar.closeItem.addTarget(self, action: #selector(closeDidTouch), forControlEvents: .TouchUpInside)

    let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    toolbar.dragHandle.addGestureRecognizer(panGR)
  }

  // MARK: - Action
  func actionDidTouch() {
    action?()
  }

  func closeDidTouch() {

  }

  // MARK: - Gesture

  func handlePanGesture(gr: UIPanGestureRecognizer) {
    switch gr.state {
    case .Began:
      toolbarFrameBeforeDragging = toolbar.frame
      updateToolbar(gr)
    case .Changed, .Ended:
      updateToolbar(gr)
    default:
      break
    }
  }

  func updateToolbar(gr: UIPanGestureRecognizer) {
    let translation = gr.translationInView(view)

    var newToolbarFrame = toolbarFrameBeforeDragging
    newToolbarFrame.origin.y += translation.y
    newToolbarFrame.origin.x += translation.x

    let maxY = CGRectGetMaxY(view.bounds) - newToolbarFrame.size.height
    let maxX = CGRectGetMaxX(view.bounds) - toolbar.frame.size.width

    // X
    if newToolbarFrame.origin.x < 0.0 {
      newToolbarFrame.origin.x = 0.0
    } else if newToolbarFrame.origin.x > maxX {
      newToolbarFrame.origin.x = maxX
    }

    // Y
    if newToolbarFrame.origin.y < 0.0 {
      newToolbarFrame.origin.y = 0.0
    } else if newToolbarFrame.origin.y > maxY {
      newToolbarFrame.origin.y = maxY
    }

    toolbar.frame = newToolbarFrame
  }

  // MARK: - Touch

  public func shouldReceiveTouch(windowPoint point: CGPoint) -> Bool {
    var shouldReceiveTouch = false

    let pointInLocalCoordinates = view.convertPoint(point, fromView: nil)

    // Always if it's on the toolbar
    if (CGRectContainsPoint(toolbar.frame, pointInLocalCoordinates)) {
      shouldReceiveTouch = true
    }

    return shouldReceiveTouch;
  }

  // MARK: Status Bar Wrangling for iOS 7

  // Try to get the preferred status bar properties from the app's root view controller (not us).
  // In general, our window shouldn't be the key window when this view controller is asked about the status bar.
  // However, we guard against infinite recursion and provide a reasonable default for status bar behavior in case our window is the keyWindow.
  func viewControllerForStatusBarAndOrientationProperties() -> UIViewController? {
    guard var viewControllerToAsk = UIApplication.sharedApplication().keyWindow?.rootViewController
      else { return nil }

    // On iPhone, modal view controllers get asked
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      while let vc = viewControllerToAsk.presentedViewController {
        viewControllerToAsk = vc
      }
    }

    return viewControllerToAsk
  }

  public override func preferredStatusBarStyle() -> UIStatusBarStyle {
    guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties()
      where viewControllerToAsk != self
      else { return .Default }

    // We might need to foward to a child
    if let childViewControllerToAsk = viewControllerToAsk.childViewControllerForStatusBarStyle() {
      return childViewControllerToAsk.preferredStatusBarStyle()
    } else {
      return viewControllerToAsk.preferredStatusBarStyle()
    }
  }

  public override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
    guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties()
      where viewControllerToAsk != self
      else { return .None }

    return viewControllerToAsk.preferredStatusBarUpdateAnimation()
  }

  public override func prefersStatusBarHidden() -> Bool {
    guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties()
      where viewControllerToAsk != self
      else { return false }

    // We might need to foward to a child
    if let childViewControllerToAsk = viewControllerToAsk.childViewControllerForStatusBarStyle() {
      return childViewControllerToAsk.prefersStatusBarHidden()
    } else {
      return viewControllerToAsk.prefersStatusBarHidden()
    }
  }

  // MARK: - Rotation

  public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    var supportedOrientations = infoPlistSupportedInterfaceOrientationsMask()

    guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties()
      where viewControllerToAsk != self
      else { return supportedOrientations }

    supportedOrientations = viewControllerToAsk.supportedInterfaceOrientations()

    // The UIViewController docs state that this method must not return zero.
    // If we weren't able to get a valid value for the supported interface orientations, default to all supported.
//    if (supportedOrientations == 0) {
//      supportedOrientations = .All;
//    }

    return supportedOrientations
  }

  public override func shouldAutorotate() -> Bool {
    guard let viewControllerToAsk = viewControllerForStatusBarAndOrientationProperties()
      where viewControllerToAsk != self
      else { return false }

    return viewControllerToAsk.shouldAutorotate()
  }

  // MARK: - Info
  func infoPlistSupportedInterfaceOrientationsMask() -> UIInterfaceOrientationMask {
    guard let supportedOrientations = NSBundle.mainBundle().infoDictionary?["UISupportedInterfaceOrientations"] as? [String]
      else { return .Portrait }

    var supportedOrientationsMask: UIInterfaceOrientationMask = [.Portrait]

    let mapping: [String: UIInterfaceOrientationMask] = [
      "UIInterfaceOrientationPortrait": .Portrait,
      "UIInterfaceOrientationMaskLandscapeRight": .LandscapeRight,
      "UIInterfaceOrientationMaskPortraitUpsideDown": .PortraitUpsideDown,
      "UIInterfaceOrientationLandscapeLeft": .LandscapeLeft,
    ]

    mapping.forEach {
      if supportedOrientations.contains($0) {
        supportedOrientationsMask.insert($1)
      }
    }

    return supportedOrientationsMask
  }
}
