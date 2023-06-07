//
//  ViewController.swift
//  ch11-seoyoungcho-navigationController
//
//  Created by hansung on 2023/05/20.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func presentWithout(_ sender: UIButton) {
        guard let secondViewController = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
        }
        secondViewController.delegate = self
        secondViewController.textToShow = textField.text
        present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func presentWith(_ sender: UIButton) {
        guard let secondViewController = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
        }
        secondViewController.delegate = self
        secondViewController.textToShow = textField.text
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowText" {
            if let secondViewController = segue.destination as? SecondViewController {
                secondViewController.delegate = self
                secondViewController.textToShow = textField.text
            }
        }
    }
}

extension FirstViewController: SecondViewControllerDelegate {
    func updateTextField(with text: String) {
        textField.text = text
    }
}
