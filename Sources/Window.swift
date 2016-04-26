//
//  Window.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class Window: UIWindow {

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor.clearColor()
    windowLevel = UIWindowLevelStatusBar + 100
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    var pointInside = false

    if let viewController = rootViewController as? ViewController
      where viewController.shouldReceiveTouch(windowPoint: point) {
      pointInside = super.pointInside(point, withEvent: event)
    }

    return pointInside
  }
}
