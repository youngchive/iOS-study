//
//  chatViewController.swift
//  ch07-csy-webService
//
//  Created by hansung on 2023/04/17.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var queryTextView: UITextView!
    @IBOutlet weak var queryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBarcController = self.parent as! UITabBarController
        let cityViewController = tabBarcController.viewControllers![0] as! CityViewController
        let (city, _, _) = cityViewController.getCurrentLonLat()
        
        queryTextField.text = city
    }
    
    @IBAction func sendQuery(_ sender: UIButton) {
        let apiKey = "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"
        let apiEndpoint = "https://api.openai.com/v1/engines/curie/completions"
        
        let parameters: [String: Any] = [
            "prompt": "\(queryTextField.text!)",
            "temperature": 0.5,
            "max_tokens": 500
        ]
        
        guard let url = URL(string: apiEndpoint) else {
            print("Invalid API endpoint URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let jsonData = data else {
                print(error!);
                return
            }
            if let jsonStr = String(data:  jsonData, encoding: .utf8) {
                print(jsonStr)
            }
            
            let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            guard let choices = json["choices"] as? [[String: Any]], let text = choices.first?["text"] as? String else {
                print("Invalid response data")
                return
            }
            DispatchQueue.main.async {
                self.queryTextView.text = text
            }
        }
        task.resume()
    }
}
