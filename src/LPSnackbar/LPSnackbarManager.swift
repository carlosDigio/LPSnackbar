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
 The manager for an `LPSnackbar`.
 
 This class handles everything that has to do with showing, dismissing and performing actions in a `LPSnackbar`.
 */
@objc
open class LPSnackbarManager: NSObject {
    @objc public static let shared: LPSnackbarManager = LPSnackbarManager()
    
    /// Max number of snacks allowed in the stack
    @objc open var maxSnacks: Int = 3
    
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
    
    
    @objc open func createSnackBarOk(title: String) -> LPSnackbar {
        createSnackBar(title: title, leftIconImage: UIImage(named: "ic_t_ok"))
    }
    
    @objc open func createSnackBarError(title: String) -> LPSnackbar {
        createSnackBar(title: title, leftIconImage: UIImage(named: "ic_t_error"))
    }
    
    @objc open func createSnackBar(title: String, buttonTitle: String? = nil, leftIconImage: UIImage? = nil) -> LPSnackbar {
        let snack = LPSnackbar()
        snack.view.title = title
        snack.view.leftIconimage = leftIconImage
        snack.view.buttonTitle = buttonTitle
        
        return snack
    }
    
    @objc open func show(snackBar: LPSnackbar,
              displayDuration: TimeInterval = 2.0,
              animated: Bool = true,
              completion: LPSnackbar.SnackbarCompletion? = nil) {
        snacks.append(LPSnackbarItem(snackBar: snackBar,
                                     displayDuration: displayDuration,
                                     animated: animated,
                                     completion: completion))
        presentNextSnack()
    }
    
    @objc open func resetSnacks() {
        snacks.removeAll()
    }
    
    @objc private func snackWasRemoved(notification: Notification) {
        guard let snackbarView = notification.object as? LPSnackbarView else { return }
        snacks.removeAll(where: { $0.checkSnackbarView(snackbarView) })
        presentNextSnack()
    }
    
    private func presentNextSnack() {
        if snacks.filter({ $0.isDisplayed }).count >= maxSnacks { return }
        snacks.filter({ !$0.isDisplayed }).prefix(maxSnacks).map({ $0.showSnackBar() })
    }
}
