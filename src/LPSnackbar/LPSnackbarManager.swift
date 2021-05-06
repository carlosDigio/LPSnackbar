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
 The controller for an `LPSnackbarView`.
 
 This class handles everything that has to do with showing, dismissing and performing actions in a `LPSnackbarView`.
 There are several static helper methods, which allow presenting a basic snack without needing instantiate an `LPSnackbar` yourself.
 */
@objc
open class LPSnackbarManager: NSObject {
    @objc public static let shared: LPSnackbarManager = LPSnackbarManager(maxSnacks: 3)
    
    /// Max number of snacks allowed in the stack
    private var maxSnacks: Int
    
    private var snacks: [LPSnackbarItem] = [] {
        didSet {
            if snacks.count < maxSnacks {
                snacks.removeFirst().showSnackBar()
            }
        }
    }
    
    @objc public init(maxSnacks: Int) {
        self.maxSnacks = maxSnacks
        
        super.init()
        // Register for snack removal notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.snackWasRemoved(notification:)),
                                               name: snackRemoval, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc open func createSnackBar(title: String, buttonTitle: String?) -> LPSnackbar {
        LPSnackbar(title: title, buttonTitle: buttonTitle)
    }
    
    @objc open func show(snackBar: LPSnackbar,
              displayDuration: TimeInterval = 3.0,
              animated: Bool = true,
              completion: LPSnackbar.SnackbarCompletion? = nil) {
        snacks.append(LPSnackbarItem(snackBar: snackBar,
                                     displayDuration: displayDuration,
                                     animated: animated,
                                     completion: completion))
    }
    
    @objc private func snackWasRemoved(notification: Notification) {
        guard let snackbar = notification.object as? LPSnackbar else { return }
        snacks.removeAll(where: { $0.checkSnackbar(snackbar) })
    }
}
