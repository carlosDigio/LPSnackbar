//
//  LPSnackbarItem.swift
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

@objcMembers
internal class LPSnackbarItem: Equatable {
    weak var snackBar: LPSnackbar?
    var displayDuration: TimeInterval
    var animated: Bool
    var isDisplayed: Bool = false
    var allowDuplicates: Bool = true
    var completion: LPSnackbar.SnackbarCompletion?
    
    init(snackBar: LPSnackbar,
         displayDuration: TimeInterval = 2.0,
         animated: Bool = true,
         allowDuplicates: Bool = true,
         completion: LPSnackbar.SnackbarCompletion? = nil) {
        self.snackBar = snackBar
        self.displayDuration = displayDuration
        self.animated = animated
        self.allowDuplicates = allowDuplicates
        self.completion = completion
    }
    
    func showSnackBar() {
        isDisplayed = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.snackBar?.show(displayDuration: self.displayDuration,
                                animated: self.animated,
                                completion: self.completion)
        }
    }
    
    func checkSnackbarView(_ snackbarView: LPSnackbarView) -> Bool {
        snackbarView === snackBar?.view
    }
    
    static func == (lhs: LPSnackbarItem, rhs: LPSnackbarItem) -> Bool {
        lhs.snackBar?.view.title == rhs.snackBar?.view.title
    }
}
