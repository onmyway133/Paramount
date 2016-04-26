//
//  ToolbarItem.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class ToolbarItem: UIButton {

  let color = UIColor(white: 1.0, alpha: 0.95)

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = color
    self.setTitleColor(UIColor.blackColor(), forState: .Normal)
    self.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  static func make(title title: String, image: UIImage?) -> ToolbarItem {

    let item = ToolbarItem(type: .Custom)
    let attributedString = NSAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12)])
    item.setAttributedTitle(attributedString, forState: .Normal)
    item.setImage(image, forState: .Normal)

    return item
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    imageEdgeInsets = UIEdgeInsetsMake(-10, 10, 0, 0)
    titleEdgeInsets = UIEdgeInsetsMake(0, -self.bounds.size.width/2, -30, 0)
  }

  public override var highlighted: Bool {
    didSet {
      backgroundColor = highlighted ? UIColor.orangeColor() : color
    }
  }
}
