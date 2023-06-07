import UIKit
protocol SecondViewControllerDelegate: AnyObject {
    func updateTextField(with text: String)
}

class SecondViewController: UIViewController {

    var textToShow: String?
    
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: SecondViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let text = textToShow {
            textField.text = text
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
            if let text = textField.text {
                    delegate?.updateTextField(with: text)
                }
                dismiss(animated: true, completion: nil)
       }
}
