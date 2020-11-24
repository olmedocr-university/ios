//
//  EditViewController.swift
//  MyApp
//
//  Created by Raul Olmedo on 22/11/20.
//

import UIKit

protocol EditDelegate {
    func didEndEditing(result: String)
}

class EditViewController: UIViewController {
    
    var textToEdit: String?
    var onCompletion: ((String) -> Void)?
    var delegate: EditDelegate?
    
    //MARK: IBOutlets
    @IBOutlet weak var textField: UITextField!
    
    //MARK: IBActions
    @IBAction func didPressDelegationButton(_ sender: Any) {
        self.delegate?.didEndEditing(result: self.textField.text ?? "")
        self.dismiss(animated: true) {
            print("Delegation used")
        }
    }
    
    @IBAction func didPressClosureButton(_ sender: Any) {
        guard let onCompletion = self.onCompletion else {
            print("Callback closure does not exist")
            return
        }
        
        onCompletion(self.textField.text ?? "")
        
        self.dismiss(animated: true) {
            print("Callback used")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.text = textToEdit ?? ""
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.textField.delegate = self
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Unwind used")
        
        let destinationVC = segue.destination as? MainViewController
        destinationVC?.textField.text = self.textField.text
    }
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
