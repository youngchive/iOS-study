//
//  조서영ViewController.swift
//  ch04-조서영-Autolayout
//
//  Created by hansung on 2023/03/27.
//
//
//  ConversionController.swift
//  ch03-convert
//
//  Created by hansung on 2023/03/20.
//

import UIKit

class 조서영ViewController: UIViewController {
    
    @IBOutlet weak var fahrenheitTextField: UITextField!
    @IBOutlet weak var celsiusLabel: UILabel!
    
    var myDelegate: MyDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        myDelegate = MyDelegate()
        fahrenheitTextField.delegate = myDelegate // self
        }

    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        fahrenheitTextField.resignFirstResponder()
    }
    
        // Do any additional setup after loading the view.
    }

extension 조서영ViewController{
    @IBAction func fahrenheitEditingChange(_ sender: UITextField) {
        if let text = sender.text {
            if let fahrenheitValue = Double(text){
                let celsiusValue = 5.0/9.0*(fahrenheitValue - 32.0)
                celsiusLabel.text = String.init(format: "%.2f", celsiusValue)
            }else{
                celsiusLabel.text = "???"
            }
        }
    }
}

extension 조서영ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        let existing = textField.text?.firstIndex(of: ".")
        let comming = string.firstIndex(of: ".")
        
        if let _ = existing, let _ =  comming{
            return false
        }
        return true
    }
}

class MyDelegate: NSObject, UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        let existing = textField.text?.firstIndex(of: ".")
        let comming = string.firstIndex(of: ".")
        
        if let _ = existing, let _ =  comming{
            return false
        }
        return true
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
