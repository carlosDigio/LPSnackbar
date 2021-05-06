//
//  LPSnackbarView.swift
//  LPSnackbar
//
//  Copyright (c) 2017 Luis Padron
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
//  OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

/// The `Notification.Name` for when a `LPSnackbarView` has been removed from it's superview.
internal let snackRemoval: Notification.Name = Notification.Name(rawValue: "com.lpSnackbar.removalNotification")

/**
 The `LPSnackbarView` which contains 3 subviews.
 
 - titleLabel: The label on the left hand side of the view used to display text.
 
 - button: The button on the right hand side of the view which allows an action to be performed.
 
 - separator: A small view which adds an accent that seperates the `titleLabel` and the `button`.
 */
@objcMembers
open class LPSnackbarView: UIView {
    
    // MARK: Properties
    
    /// The controller for this view
    internal var controller: LPSnackbar?
    
    /// The amount of padding from the left handside, used to layout the `titleLabel`, default is `8.0`
    @objc open var leftPadding: CGFloat = 16.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The amount of padding from the right handside, used to layout the `button`, default is `8.0`
    @objc open var rightPadding: CGFloat = 8.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /**
     The height percent of the total available size that the separator should take up inside the view.
     
     ## Important
     
     This should only be a value between `0.0` and `1.0`. If this value is set past this range, the value
     will be reset to the default value of `0.65`.
     */
    @objc open var separatorHeightPercent: CGFloat = 0.65 {
        didSet {
            // Clamp the percent between the correct range
            if separatorHeightPercent < 0.0 || separatorHeightPercent > 1.0 {
                self.separatorHeightPercent = 0.95
            }
            self.setNeedsLayout()
        }
    }
    
    /// The width for the separator, default is `1.5`
    @objc open var separatorWidth: CGFloat = 1.5 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The amount of padding from the right side of the separator (next to the button), default is `20.0`
    @objc open var separatorPadding: CGFloat = 20.0 {
        willSet {
            self.setNeedsLayout()
        }
    }
    
    /// Shows or hides the separator between titleLabel and button. Default is `true`
    @objc open var showSeparator: Bool = true {
        willSet {
            self.setNeedsLayout()
        }
    }
    
    /// The corner radious of the view, default is `8.0`
    @objc open var cornerRadius: CGFloat = 8.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The backgroundColor of the view, default is `UIColor(red: 44 / 255, green: 44 / 255, blue: 45 / 255, alpha: 1.00)`
    @objc open var backColor: UIColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 45 / 255, alpha: 1.00) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The title color, default is `white`
    @objc open var titleColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The button color, default is `white`
    @objc open var buttonColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The shadowcolor. Default is `black`
    @objc open var showShadow: Bool = true {
        willSet {
            self.setNeedsLayout()
        }
    }
    
    /// The showLeftIcon. Default is `true`
    @objc open var showLeftIcon: Bool = false {
        willSet {
            self.setNeedsLayout()
        }
    }
    
    /// The leftIconimage. Default is `nil`
    @objc open var leftIconimage: UIImage? = nil {
        willSet {
            self.setNeedsLayout()
        }
    }
    
    /// The default opacity for the view
    internal let defaultOpacity: Float = 0.98
    
    // MARK: Subviews
    
    /// The imageView on the left hand side of the view used to display an image.
    @objc open lazy var imageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = leftIconimage
        return imgView
    }()
    
    /// The label on the left hand side of the view used to display text.
    @objc open lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = titleColor
        label.numberOfLines = 0
        return label
    }()
    
    /// The button on the right hand side of the view which allows an action to be performed.
    @objc open lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(buttonColor, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    /// A small view which adds an accent that seperates the `titleLabel` and the `button`.
    @objc open lazy var separator: UIView = {
        let separator = UIView(frame: .zero)
        separator.isAccessibilityElement = false
        separator.backgroundColor = UIColor(red: 0.366, green: 0.364, blue: 0.368, alpha: 1.00)
        separator.layer.cornerRadius = 2.0
        return separator
    }()
    
    // MARK: Overrides
    
    /// Overriden
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    /// Overriden
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    /// Overriden, lays out the `separator`
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout the separator, want it next to the button and centered vertically
        let separatorHeight = frame.height * separatorHeightPercent
        let separatorY = (frame.height - separatorHeight) / 2
        separator.frame = CGRect(x: button.frame.minX - separatorWidth - separatorPadding, y: separatorY,
                                 width: separatorWidth, height: separatorHeight)
    }
    
    /// Overriden, posts `snackRemoval` notification.
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        // Will be removed from superview, post notification
        let notification = Notification(name: snackRemoval, object: self)
        NotificationCenter.default.post(notification)
    }
    
    // MARK: Private methods
    
    /// Helper initializer which sets some customization for the view and adds the subviews/constraints.
    private func initialize() {
        // Since this self is a container view, set accessibilty element to false
        isAccessibilityElement = false
        
        // Customize UI
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = backColor
        layer.opacity = defaultOpacity
        layer.cornerRadius = cornerRadius
        
        layer.shadowColor = showShadow ? UIColor.black.cgColor : UIColor.clear.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.4
        
        // Add subviews
        if showLeftIcon {
            addSubview(imageView)
        }
        addSubview(titleLabel)
        addSubview(button)
        
        if showSeparator {
            addSubview(separator)
        }
        
        //// Add constraints
        if showLeftIcon {
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal,
                               toItem: self, attribute: .leadingMargin, multiplier: 1.0, constant: leftPadding).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal,
                               toItem: self, attribute: .leadingMargin, multiplier: 1.0, constant: leftPadding).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal,
                               toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal,
                               toItem: titleLabel, attribute: .trailingMargin, multiplier: 1.0, constant: leftPadding).isActive = true
            
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal,
                           toItem: button, attribute: .trailingMargin, multiplier: 1.0, constant: leftPadding).isActive = true
        } else {
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal,
                               toItem: self, attribute: .trailingMargin, multiplier: 1.0, constant: leftPadding).isActive = true
        }
        
        NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal,
                           toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true

        NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal,
                           toItem: self, attribute: .trailingMargin, multiplier: 1.0, constant: -rightPadding).isActive = true
        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal,
                           toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        // Register for device rotation notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRotate(notification:)),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    /// Called whenever the screen is rotated, this will ask the controller to recalculate the frame for the view.
    @objc private func didRotate(notification: Notification) {
        // Layout the view/subviews again
        DispatchQueue.main.async {
            // Set frame for self
            self.frame = self.controller?.frameForView() ?? .zero
        }
    }
    
    // MARK: Actions
    
    /// Called whenever the button is tapped, will tell the controller to perform the button action
    @objc private func buttonTapped(sender: UIButton) {
        // Notify controller that button was tapped
        controller?.viewButtonTapped()
    }
    
    // MARK: Deinit
    
    /// Deinitializes the view
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

