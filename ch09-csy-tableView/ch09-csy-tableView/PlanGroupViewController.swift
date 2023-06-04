//
//  ViewController.swift
//  ch09-csy-tableView
//
//  Created by hansung on 2023/05/05.
//

import UIKit

class PlanGroupViewController: UIViewController {

    @IBOutlet weak var planGroupTableView: UITableView!
    var planGroup: PlanGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        planGroupTableView.dataSource = self        // 테이블뷰의 데이터 소스로 등록
        planGroupTableView.delegate = self          // 딜리게이터로 등록

        // 단순히 planGroup객체만 생성한다
        planGroup = PlanGroup(parentNotification: receivingNotification)
        planGroup.queryData(date: Date())
        // 이달의 데이터를 가져온다. 데이터가 오면 planGroupListener가 호출된다.
        planGroupTableView.isEditing = true

    }

    func receivingNotification(plan: Plan?, action: DbAction?){
    // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.planGroupTableView.reloadData()
        // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
    }
}

extension PlanGroupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let planGroup = planGroup{
            return planGroup.getPlans().count
        }
        return 0    // planGroup가 생성되기전에 호출될 수도 있다
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell")!

        // planGroup는 대략 1개월의 플랜을 가지고 있다. 그중에서 선택된 날짜의 데이터만 테이블에 보인다.
        let plan = planGroup.getPlans()[indexPath.row]

        // 적절히 cell에 데이터를 채움
    //        cell.textLabel!.text = plan.date.toStringDateTime()
    //        cell.detailTextLabel?.text = plan.content

        // 0, 1, 2순서가 맞아야 한다. 안맞으면 스트로보드에서 다시 맞도록 위치를 바꾸어야 한다
        (cell.contentView.subviews[0] as! UIImageView).image = UIImage(named:"csyy.png")
        (cell.contentView.subviews[2] as! UILabel).text = plan.date.toStringDateTime()
        //(cell.contentView.subviews[1] as! UILabel).text = plan.owner
        (cell.contentView.subviews[1] as! UILabel).text = plan.content

        cell.accessoryType = .none
        cell.accessoryView = nil
//        if indexPath.row % 2 == 0 {
//            cell.accessoryType = .detailDisclosureButton    // type
//        }else{
//            cell.accessoryView = UISwitch(frame: CGRect())  // View
//        }
        return cell
    }
}

extension PlanGroupViewController {
    @IBAction func editingPlans(_ sender: UIButton) {
        if planGroupTableView.isEditing == true{
            planGroupTableView.isEditing = false
            sender.setTitle("Edit", for: .normal)
        }else{
            planGroupTableView.isEditing = true
            sender.setTitle("Done", for: .normal)
        }
    }
}

extension PlanGroupViewController {
    @IBAction func addingPlan(_ sender: UIButton) {
        let plan = Plan(date: nil, withData: true)        // 가짜 데이터 생성
        planGroup.saveChange(plan: plan, action: .Add)
    }
}

extension PlanGroupViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            // 선택된 row의 플랜을 가져온다
            let plan = self.planGroup.getPlans()[indexPath.row]

            // 단순히 데이터베이스에 지우기만 하면된다. 꺼꾸로 데이터베이스에서 지워졌음을 알려준다
            self.planGroup.saveChange(plan: plan, action: .Delete)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // 이것은 데이터베이스에 까지 영향을 미치지 않는다. 그래서 planGroup에서만 위치 변경
        let from = planGroup.getPlans()[sourceIndexPath.row]
        let to = planGroup.getPlans()[destinationIndexPath.row]
        planGroup.changePlan(from: from, to: to)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}
