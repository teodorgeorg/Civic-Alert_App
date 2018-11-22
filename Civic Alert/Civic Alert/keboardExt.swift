//
//  keboardExt.swift
//  Civic Alert
//
//  Created by issd on 25/10/2018.
//  Copyright © 2018 David. All rights reserved.
//
import UIKit
import Foundation


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
