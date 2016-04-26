//
//  UIImage.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public extension UIImage {
  static func make(name: String) -> UIImage? {
    let bundle = NSBundle(forClass: Paramount.Toolbar.self)
    return UIImage(named: "Paramount.bundle/\(name)", inBundle: bundle, compatibleWithTraitCollection: nil)
  }
}
