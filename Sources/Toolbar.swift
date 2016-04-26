//
//  Toolbar.swift
//  Paramount
//
//  Created by Khoa Pham on 26/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

public class Toolbar: UIView {
  public private(set) var actionItem: ToolbarItem!
  public private(set) var closeItem: ToolbarItem!

  var dragHandle: UIView!
  var dragHandleImageView: UIImageView!
  var stackView: UIStackView!

  public override init(frame: CGRect) {
    super.init(frame: frame)

    dragHandle = UIView()
    dragHandle.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
    addSubview(dragHandle)

    dragHandleImageView = UIImageView(image: UIImage(named: "Paramount.bundle/drag_handle"))
    dragHandle.addSubview(dragHandleImageView)

    actionItem = ToolbarItem.make(title: "action", image: UIImage(named: "Paramount.bundle/action"))
    closeItem = ToolbarItem.make(title: "close", image: UIImage(named: "Paramount.bundle/close"))

    stackView = UIStackView(arrangedSubviews: [actionItem, closeItem])
    stackView.axis = .Horizontal
    stackView.distribution = .FillEqually
    addSubview(stackView)

    self.frame.size.width = Dimension.Handle.width + Dimension.ToolbarItem.width * CGFloat(stackView.arrangedSubviews.count)
    self.frame.size.height = Dimension.Toolbar.height

    setupContraints()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  func setupContraints() {
    // Drag Handle
    dragHandle.translatesAutoresizingMaskIntoConstraints = false
    dragHandle.topAnchor.constraintEqualToAnchor(topAnchor).active = true
    dragHandle.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
    dragHandle.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
    dragHandle.widthAnchor.constraintEqualToConstant(Dimension.Handle.width).active = true

    dragHandleImageView.translatesAutoresizingMaskIntoConstraints = false
    dragHandleImageView.centerXAnchor.constraintEqualToAnchor(dragHandle.centerXAnchor).active = true
    dragHandleImageView.centerYAnchor.constraintEqualToAnchor(dragHandle.centerYAnchor).active = true

    // Items
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
    stackView.leftAnchor.constraintEqualToAnchor(dragHandle.rightAnchor).active = true
    stackView.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
    stackView.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
  }
}
