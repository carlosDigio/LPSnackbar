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
internal let snackRemoval: Notification.Name = Notification.Name(rawValue: "com.lpsnackbar.removalNotification")

/**
 The `LPSnackbarView` which contains 3 subviews.
 
 - titleLabel: The label on the left hand side of the view used to display text.
 - button: The button on the right hand side of the view which allows an action to be performed.

 */
@objcMembers
internal class LPSnackbarView: UIView {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var leftIconView: UIView!
    @IBOutlet weak var leftIconImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var rightButton: UIButton?
    
    // MARK: Properties
    
    /// The controller for this view
    internal var controller: LPSnackbar?
    
    /// The amount of padding of the stackview`, default is `16.0`
    @objc internal var padding: UIEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    
    /// The corner radious of the view, default is `8.0`
    @objc internal var cornerRadius: CGFloat = 8.0
    
    /// The backgroundColor of the view, default is `UIColor(red: 44 / 255, green: 44 / 255, blue: 45 / 255, alpha: 1.00)`
    @objc internal var backColor: UIColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 45 / 255, alpha: 1.00)
    
    /// The (attributed) title text
    @objc internal var title: String? {
        willSet {
            let style = NSMutableParagraphStyle()
            style.minimumLineHeight = 18
            style.maximumLineHeight = 18
            style.lineBreakMode = .byTruncatingTail
            titleLabel?.attributedText = NSAttributedString(string: newValue ?? "",
                                                            attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                         .foregroundColor: UIColor.white,
                                                                         .paragraphStyle: style])
            titleLabel?.sizeToFit()
        }
    }
    
    /// The title color, default is `white`
    @objc internal var titleColor: UIColor = UIColor.white {
        willSet {
            titleLabel?.textColor = newValue
        }
    }
    
    /// The button color, default is `white`
    @objc internal var buttonColor: UIColor = UIColor.white {
        willSet {
            rightButton?.setTitleColor(newValue, for: .normal)
        }
    }
    
    /// Show shadow or not.. Default is `false`
    @objc internal var showShadow: Bool = false {
        willSet {
            layer.shadowColor = newValue ? UIColor.black.cgColor : UIColor.clear.cgColor
            layer.shadowRadius = 5.0
            layer.shadowOpacity = 0.4
        }
    }
    
    /// Show fef iIcon. Default is `false`
    @objc internal var showLeftIcon: Bool = false {
        willSet {
            leftIconView?.isHidden = !newValue
        }
    }
    
    /// The left icon image. Default is `nil`
    @objc internal var leftIconimage: UIImage? = nil {
        willSet {
            leftIconImageView?.image = newValue
            showLeftIcon = newValue != nil
        }
    }
    
    /// The (attributed) button title text
    @objc internal var buttonTitle: String? {
        willSet {
            showRightButton = newValue != nil
            
            let style = NSMutableParagraphStyle()
            style.minimumLineHeight = 18
            style.maximumLineHeight = 18
            style.lineBreakMode = .byTruncatingTail
                
            let attributed = NSAttributedString(string: newValue ?? "",
                                                attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                             .foregroundColor: UIColor.orange,
                                                             .paragraphStyle: style])
            rightButton?.setAttributedTitle(attributed, for: .normal)
            rightButton?.sizeToFit()
        }
    }
    
    /// Show right button. Default is `false`
    @objc internal var showRightButton: Bool = false {
        willSet {
            buttonView?.isHidden = !newValue
        }
    }
    
    /// The default opacity for the view
    internal let defaultOpacity: Float = 1.0
    
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
    
    /// Overriden, posts `snackRemoval` notification.
    internal override func removeFromSuperview() {
        super.removeFromSuperview()
        // Will be removed from superview, post notification
        let notification = Notification(name: snackRemoval, object: self)
        NotificationCenter.default.post(notification)
    }
    
    internal override func didMoveToWindow() {
        super.didMoveToWindow()
        
        rightButton?.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
    }
    
    // MARK: Private methods
    
    /// Helper initializer which sets some customization for the view and adds the subviews/constraints.
    private func initialize() {
        // Accesibility
        isAccessibilityElement = true
        accessibilityLabel = titleLabel?.text
        accessibilityIdentifier = "LPSnackbarView.snack"
        
        // Customize UI
        backgroundColor = backColor
        
        layer.opacity = defaultOpacity
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        // Register for device rotation notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRotate(notification:)),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    /// Called whenever the screen is rotated, this will ask the controller to recalculate the frame for the view.
    @objc private func didRotate(notification: Notification) {
        // Layout the view/subviews again
        DispatchQueue.main.async {
            // Set frame for self
            self.frame = self.controller?.frameForView(recalculate: true) ?? .zero
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

// Gift extension
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
