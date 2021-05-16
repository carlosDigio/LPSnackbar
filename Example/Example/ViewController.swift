//
//  ViewController.swift
//  Example
//
//  Created by Carlos Luis Seva Llor on 15/5/21.
//

import UIKit
import LPSnackbar

class ViewController: UIViewController {
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func firstButtonPressed(_ sender: Any) {
        var text: String = textfield.text ?? "Example"
        if text.isEmpty { text = "Example" }
        
        let snackbar = LPSnackbarManager.createSnackBar(title: text)
        snackbar.viewToDisplayIn = view

        LPSnackbarManager.show(snackBar: snackbar)
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        var text: String = textfield.text ?? "Example"
        if text.isEmpty { text = "Example" }
        
        let snackbar = LPSnackbarManager.createSnackBarOk(title: text)
        snackbar.viewToDisplayIn = view
        
        LPSnackbarManager.show(snackBar: snackbar)
    }
    
    @IBAction func thirdButtonPressed(_ sender: Any) {
        var text: String = textfield.text ?? "Example"
        if text.isEmpty { text = "Example" }
        
        let snackbar = LPSnackbarManager.createSnackBarError(title: text)
        snackbar.viewToDisplayIn = view
        
        LPSnackbarManager.show(snackBar: snackbar)
    }
    
    @IBAction func fourthButtonPressed(_ sender: Any) {
        var text: String = textfield.text ?? "Example"
        if text.isEmpty { text = "Example" }
        
        let snackbar = LPSnackbarManager.createSnackBar(title: text,
                                                        buttonTitle: "Undo",
                                                        delegate: self)
        snackbar.viewToDisplayIn = view
        snackbar.delegate = self
        
        LPSnackbarManager.show(snackBar: snackbar)
    }
}

extension ViewController: LPSnackbarDelegate {
    func buttonPressed() {
        print("LPSnackbar button pressed!")
    }
}
