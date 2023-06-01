//
//  ViewController.swift
//  ch05-조서영-programmingView
//
//  Created by hansung on 2023/04/03.
//

import UIKit

class View조서영Controller: UIViewController, UITextFieldDelegate {
    /*
//    var helloLabel: Int
//
//    override func viewDidLoad(nibBame nibNameOrNil: String?, bundel nibBundle) {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }

    var helloLabel: UILabel! //암시적 optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helloLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 30))
        helloLabel.text = "Hello, Autolayout"
        helloLabel.backgroundColor = UIColor.green
        helloLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        helloLabel.textAlignment = .center
    
        view.addSubview(helloLabel)
        
        /*
        helloLabel.translatesAutoresizingMaskIntoConstraints = false // true로 해보라
        let centerXConstraint = helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        let centerYConstraint = helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)

        //(1)
        view.addSubview(helloLabel)
        centerXConstraint.isActive = true
        centerYConstraint.isActive = true   // 이것만 false로 해보라 또는 주석처리를 해보라
        //(2) view.addSubview(helloLabel)


        //auto layout을 적용할 때에는 자신의 부모가 누군지 알아야
        //active 되기 전에 실행해야(view.addSubview)*/
        
        helloLabel.translatesAutoresizingMaskIntoConstraints = false

        helloLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true

        helloLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        helloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true

    }
     */
    
    var fahrenheitTextField: UITextField!
    var celsiusLabel: UILabel!
    
    var isLabel, fdegreeLabel, cdegreeLabel: UILabel!
    var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLabel = createLabel("is", fontSize: 36)
        isLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        isLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        fahrenheitTextField = createTextField(placeHolder: "VALUE")
        fdegreeLabel = createLabel("degrees Fahrenheit", fontSize: 36)
        celsiusLabel = createLabel("???", fontSize: 70)
        cdegreeLabel = createLabel("degrees Celsius", fontSize: 36)
        
        connectVertically(views: fahrenheitTextField, fdegreeLabel, isLabel, celsiusLabel, cdegreeLabel, spacing: 10)
        connectHorizontally(views: fahrenheitTextField, fdegreeLabel, isLabel, celsiusLabel, cdegreeLabel)
        
        fahrenheitTextField.addTarget(self, action: #selector(fahrenheitEditingChanged), for: .editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        fahrenheitTextField.delegate = self
        addSegmentedControl()
    }
}

extension View조서영Controller{
    @objc func dismissKeyboard(sender: UIGestureRecognizer){
        fahrenheitTextField.resignFirstResponder()
    }
}

extension View조서영Controller{
    @objc func fahrenheitEditingChanged(sender: UITextField){
        if let text = sender.text {
            if let fahrenheitValue = Double(text){
                if segmentedControl.selectedSegmentIndex == 0{
                  let celsiusValue = 5.0/9.0*(fahrenheitValue - 32.0)
                  celsiusLabel.text = String.init(format: "%.2f", celsiusValue)
                  }else{
                     let celsiusValue = 9.0/5.0*fahrenheitValue + 32.0
                     celsiusLabel.text = String.init(format: "%.2f", celsiusValue)
                     }
                   }else{
                      celsiusLabel.text = "???"

            }
        }
    }
}

extension View조서영Controller{
    func addSegmentedControl(){
        
        segmentedControl = UISegmentedControl(items: ["Fahrenheit", "Celsius"])
        let font = UIFont.systemFont(ofSize: 20)
        segmentedControl!.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

        segmentedControl.addTarget(self, action: #selector(changeDegrees), for: .valueChanged)
    }
    @objc func changeDegrees(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            fdegreeLabel.text = "degrees Fahrenheit"
            cdegreeLabel.text = "degrees Celsius"
        }else{
            fdegreeLabel.text = "degrees Celsius"
            cdegreeLabel.text = "degrees Fahrenheit"
        }
        fahrenheitTextField.text = ""
        celsiusLabel.text = "???"
    }
}

extension View조서영Controller{
    func createTextField(placeHolder: String) -> UITextField{
        let textField = UITextField(frame: CGRect())
        textField.textAlignment = .center
        textField.placeholder = placeHolder
        textField.font = UIFont(name: textField.font!.fontName, size: 70)
        textField.keyboardType = .decimalPad
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    func createLabel(_ text: String, fontSize: CGFloat) -> UILabel{
        let label = UILabel(frame: CGRect())
        label.text = text
        label.textColor = UIColor(red: CGFloat(0xe1)/CGFloat(256), green: CGFloat(0x58)/CGFloat(256), blue: CGFloat(0x29)/CGFloat(256), alpha: CGFloat(1))
        label.textAlignment = .center
        label.font = UIFont(name: label.font!.fontName, size: fontSize)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension View조서영Controller{
    func connectVertically(views: UIView..., spacing: CGFloat){
        for i in 0..<views.count - 1{
            views[i].bottomAnchor.constraint(equalTo: views[i+1].topAnchor, constant: spacing).isActive = true
        }
    }
    func connectHorizontally(views: UIView...){
        for view in views{
            view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        }
    }
}
