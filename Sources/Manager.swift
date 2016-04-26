//
//  Manager.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public typealias Action = () -> Void

public class Manager {
  public static var action: Action?

  public static var window: UIWindow = {
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window.rootViewController = viewController

    return window
  }()

  public static var viewController: ViewController = {
    let viewController = ViewController()

    viewController.close = {
      Manager.hide()
    }

    viewController.action = action

    return viewController
  }()

  public static func show() {
    window.hidden = false
  }

  public static func hide() {
    window.hidden = true
  }
}
