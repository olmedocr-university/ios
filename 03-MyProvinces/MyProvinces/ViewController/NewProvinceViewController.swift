//
//  NewProvinceViewController.swift
//  MyProvinces
//
//  Created by Raul Olmedo on 9/12/20.
//

import UIKit

protocol NewProvinceViewControllerDelegate: AnyObject {
    func didTapOnSaveButton(province: String)
}

class NewProvinceViewController: UIViewController {
    // MARK: Properties
    weak var delegate: NewProvinceViewControllerDelegate?
    
    // MARK: IBOutlets
    @IBOutlet weak var textFieldProvinceName: UITextField!
    
    // MARK: IBActions
    @IBAction func didTapButtonSave(_ sender: Any) {
        if let newProvince = textFieldProvinceName.text, !newProvince.isEmpty{
            delegate?.didTapOnSaveButton(province: newProvince)
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }

}
