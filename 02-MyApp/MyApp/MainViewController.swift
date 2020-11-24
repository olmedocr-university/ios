//
//  ViewController.swift
//  MyApp
//
//  Created by Raul Olmedo on 19/11/20.
//

import UIKit

class MainViewController: UIViewController {
    
    var alert: UIAlertController?
    var actionSheet: UIAlertController?
    
    // MARK: IBOutlets
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setAlert { (alertAction) in
            // Once it is completed
            // Check the actionSheet existance
            guard let actionSheet = self.actionSheet else {
                print("Action sheet is not defined")
                return
            }
            
            //  Launch it
            self.navigationController?.present(actionSheet, animated: true, completion: {
                print("Presented action sheet")
            })
        }
        
        setActionSheet { (alertAction) in
            switch alertAction.title {
            case "Red":
                self.view.backgroundColor = UIColor.red
                print("Red selected")
            default:
                print("None selected")
            }
        }
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.textField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let alert = self.alert else {
            print("Alert is not defined")
            return
        }
        
        self.navigationController?.present(alert, animated: true, completion: {
            print("Presented alert")
        })
    
    }
    
    func setAlert(onCompletion: @escaping (UIAlertAction) -> Void) {
        alert = UIAlertController(title: "Welcome!", message: "Set your username and your password", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: onCompletion)
                
        alert?.addAction(action)
        
        alert?.addTextField { (textField) in
            textField.placeholder = "Username"
        }
        
        alert?.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
    }
    
    func setActionSheet(onCompletion: @escaping (UIAlertAction) -> Void) {
        actionSheet = UIAlertController(title: "Select color", message: "Select the background color for the app", preferredStyle: .actionSheet)
        
        let actionColorRed = UIAlertAction(title: "Red", style: .default, handler: onCompletion)
        let actionColorNone = UIAlertAction(title: "None", style: .default, handler: onCompletion)
        
        actionSheet?.addAction(actionColorRed)
        actionSheet?.addAction(actionColorNone)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let target = segue.destination as? EditViewController {
            target.textToEdit = self.textField.text
            target.delegate = self
            target.onCompletion = {(result) in
                self.textField.text = result
            }
        }
    }
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? EditViewController
        self.textField.text = sourceViewController?.textField.text
        
    }

}

extension MainViewController: EditDelegate {
    func didEndEditing(result: String) {
        self.textField.text = result
    }
    
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
