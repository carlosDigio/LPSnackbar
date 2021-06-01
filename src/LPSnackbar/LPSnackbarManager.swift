//
//  LPSnackbarManager.swift
//  LPSnackbar
//
//  Copyright (c) 2021
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

/**
 The main manager  of `LPSnackbar`.
 
 This handles everything that has to do with showing, dismissing and performing actions in a `LPSnackbar`.
 */
@objc
open class LPSnackbarManager: NSObject {
    @objc static let shared: LPSnackbarManager = LPSnackbarManager()
    
    /// Max number of snacks allowed at the same time. Default is `3`
    @objc public var maxSnacks: Int = 3
    
    private var snacks: [LPSnackbarItem] = []
    
    @objc public override init() {
        super.init()
        // Register for snack removal notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.snackWasRemoved(notification:)),
                                               name: snackRemoval, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Create a custom snackbar with title, button title (optional) and left icon (optional)
    @objc public static func createSnackBar(title: String,
                                            buttonTitle: String? = nil,
                                            leftIconImage: UIImage? = nil,
                                            delegate: LPSnackbarDelegate? = nil) -> LPSnackbar {
        let snack = LPSnackbar()
        snack.view.title = title
        snack.view.leftIconimage = leftIconImage
        snack.view.buttonTitle = buttonTitle
        snack.delegate = delegate
        
        return snack
    }
    
    /// Shows a snackbar with displayDuration, animated and completion block
    @objc public static func show(snackBar: LPSnackbar,
              displayDuration: TimeInterval = 2.0,
              animated: Bool = true,
              completion: LPSnackbar.SnackbarCompletion? = nil) {
        snackBar.view.accessibilityIdentifier = "LPSnackbarView.snack_\(shared.snacks.count)"
        shared.snacks.append(LPSnackbarItem(snackBar: snackBar,
                                            displayDuration: displayDuration,
                                            animated: animated,
                                            completion: completion))
        presentNextSnack()
    }
    
    /// Resets current snacks array
    @objc public static func resetSnacks() {
        shared.snacks.removeAll()
    }
    
    @objc private func snackWasRemoved(notification: Notification) {
        guard let snackbarView = notification.object as? LPSnackbarView else { return }
        LPSnackbarManager.shared.snacks.removeAll(where: { $0.checkSnackbarView(snackbarView) })
        LPSnackbarManager.presentNextSnack()
    }
    
    private class func presentNextSnack() {
        if shared.snacks.filter({ $0.isDisplayed }).count >= shared.maxSnacks { return }
        shared.snacks.filter({ !$0.isDisplayed }).prefix(shared.maxSnacks).forEach({ $0.showSnackBar() })
    }
}
