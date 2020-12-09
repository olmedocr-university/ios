//
//  ProvinceDetailViewController.swift
//  MyProvinces
//
//  Created by Raul Olmedo on 8/12/20.
//

import UIKit
import os.log

protocol ProvinceDetailViewControllerDelegate: AnyObject {
    func didTapSaveButton(data: String?)
}

class ProvinceDetailViewController: UIViewController {
    // MARK: Properties
    let TAG = OSLog(subsystem: "ProvinceDetailViewController", category: "ViewController")
    
    weak var delegate: ProvinceDetailViewControllerDelegate?
    var provinceName: String? = nil
    var provinceInfo: String? = nil
    var isDefaultText = true
    
    
    // MARK: IBOutlets
    @IBOutlet weak var textViewInformation: UITextView!
    
    // MARK: IBActions
    @IBAction func buttonSave(_ sender: Any) {
        if isDefaultText {
            delegate?.didTapSaveButton(data: nil)
        } else {
            delegate?.didTapSaveButton(data: textViewInformation.text)
        }
        
        self.navigationController?.popViewController(animated: true)

    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        if let provinceInfo = self.provinceInfo {
            textViewInformation.text = provinceInfo
        } else {
            textViewInformation.textColor = .lightGray
            textViewInformation.text = "Write here any information that you want to store about \(provinceName ?? "this province")"
        }
        
        
        textViewInformation.autocapitalizationType = .sentences
        textViewInformation.isScrollEnabled = false
        textViewInformation.delegate = self
        
    }
    
}

extension ProvinceDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if textViewInformation.textColor == UIColor.lightGray && textViewInformation.isFirstResponder {
            textViewInformation.text = nil
            textViewInformation.textColor = .none
            
            isDefaultText = false
        }
    }
    
}
