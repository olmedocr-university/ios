//
//  UIAlertController+setAlert.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 29/12/20.
//

import UIKit

extension UIViewController {
    func setAlert(title: String, message: String, actionTitle: String, onCompletion: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default, handler: onCompletion)
                
        alert.addAction(action)
    
        return alert
    }
}
