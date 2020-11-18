//
//  ViewController.swift
//  MyCalculator
//
//  Created by Raul Olmedo on 31/10/20.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var realATextField: UITextField!
    @IBOutlet weak var imaginaryATextField: UITextField!
    @IBOutlet weak var realBTextField: UITextField!
    @IBOutlet weak var imaginaryBTextField: UITextField!
    @IBOutlet weak var imaginaryResultLabel: UILabel!
    @IBOutlet weak var realResultLabel: UILabel!
    
    // MARK: IBActions
    @IBAction func didTapAdd(_ sender: UIButton) {
        let complexNumbers = getComplexNumbers()
        let result = complexNumbers.a + complexNumbers.b
        setTextFieldsResult(number: result)
    }
    
    @IBAction func didTapSubtract(_ sender: UIButton) {
        let complexNumbers = getComplexNumbers()
        let result = complexNumbers.a - complexNumbers.b
        setTextFieldsResult(number: result)
    }
    
    @IBAction func didTapMultiply(_ sender: UIButton) {
        let complexNumbers = getComplexNumbers()
        let result = complexNumbers.a * complexNumbers.b
        setTextFieldsResult(number: result)
    }
    
    @IBAction func didTapDivide(_ sender: UIButton) {
        let complexNumbers = getComplexNumbers()
        let result = complexNumbers.a / complexNumbers.b
        setTextFieldsResult(number: result)
    }
    
    
    // MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Methods
    private func getComplexNumbers() -> (a: Complex, b: Complex) {
        if let _ = realATextField.text {} else {
            realATextField.text = String(0)
        }
        
        if let _ = realBTextField.text {} else {
            realBTextField.text = String(0)
        }
        
        if let _ = imaginaryATextField.text {} else {
            imaginaryATextField.text = String(0)
        }
        
        if let _ = imaginaryBTextField.text {} else {
            imaginaryBTextField.text = String(0)
        }
        
        let complexA = Complex(realPart: Double(realATextField.text!)!, imaginaryPart: Double(imaginaryBTextField.text!)!)
        let complexB = Complex(realPart: Double(realBTextField.text!)!, imaginaryPart: Double(imaginaryBTextField.text!)!)
        
        return (complexA, complexB)
    }
    
    private func setTextFieldsResult(number: Complex) {
        realResultLabel.text = String(number.cartesianForm.x)
        imaginaryResultLabel.text = String(number.cartesianForm.y)
    }


}

