//
//  PlanDetailViewController.swift
//  ch10-csy-stackView
//
//  Created by hansung on 2023/05/13.
//

import UIKit

class PlanDetailViewController: UIViewController {
    
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var plan: Plan?
    var saveChangeDelegate:((Plan)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePicker.dataSource = self
        typePicker.delegate = self
        
        plan = plan ?? Plan(date: Date(), withData: true)
        dateDatePicker.date = plan?.date ?? Date()
        ownerLabel.text = plan?.owner   // palan!.owner과 차이는? optional chainingtype
        
        // typePickerView 초기화
        if let plan = plan {
            typePicker.selectRow(plan.kind.rawValue, inComponent: 0, animated: false)
        }
        contentTextView.text = plan?.content
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        contentTextView.addGestureRecognizer(longTapGesture)
    }
    @IBAction func gotoBack(_ sender: UIButton) {
    plan!.date = dateDatePicker.date
    plan!.owner = ownerLabel.text    // 수정할 수 없는 UILabel이므로 필요없는 연산임
    plan!.kind = Plan.Kind(rawValue: typePicker.selectedRow(inComponent: 0))!
    plan!.content = contentTextView.text

    saveChangeDelegate?(plan!)
    dismiss(animated: true, completion: nil)
        
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
    view.addGestureRecognizer(tapGesture)

    }
}

extension PlanDetailViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Plan.Kind.count   // Plan.swift파일에서 count를 확인하라
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let type = Plan.Kind(rawValue: row)    // 정수를 해당 Kind 타입으로 변환하는 것이다.
        return type!.toString()
    }
}

extension PlanGroupViewController{    // PlanGroupViewController.swift

    // prepare함수에서 PlanDetailViewController에게 전달한다
    func saveChange(plan: Plan){

        // 만약 현재 planGroupTableView에서 선택된 row가 있다면,
        // 즉, planGroupTableView의 row를 클릭하여 PlanDetailViewController로 전이 한다면
        if planGroupTableView.indexPathForSelectedRow != nil{
            planGroup.saveChange(plan: plan, action: .Modify)
        }else{
            // 이경우는 나중에 사용할 것이다.
            planGroup.saveChange(plan: plan, action: .Add)
        }
    }
}

extension PlanDetailViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowContent" {
            if let selectContentViewController = segue.destination as? SelectContentViewController {
                selectContentViewController.planDetailViewController = self
            }
        }
    }
}
extension PlanDetailViewController{
    @objc func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            performSegue(withIdentifier: "ShowContent", sender: self)
        }
    }
}
