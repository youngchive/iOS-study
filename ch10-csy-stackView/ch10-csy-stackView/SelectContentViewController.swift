//
//  SelectContentViewController.swift
//  ch10-csy-stackView
//
//  Created by hansung on 2023/05/14.
//

import Foundation
import UIKit

class SelectContentViewController: UIViewController {
    
    let contents = [
        "엄마 도와드리기",
        "아르바이트",
        "청소하기",
        "IOS 즐겁게 숙제하기",
        "학교 가서 밥 먹기",
        "친구와 카페가기",
        "데이트 하기"
    ]
    
    @IBOutlet weak var selectContentTableView: UITableView!
    var planDetailViewController: PlanDetailViewController?
    var oldValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectContentTableView.dataSource = self
        selectContentTableView.delegate = self
        oldValue = planDetailViewController?.contentTextView.text
    }

    @IBAction func unselectContent(_ sender: UIButton) {
        if let planDetailViewController = planDetailViewController {
            planDetailViewController.contentTextView.text = oldValue
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectContent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentViewCell")!
        let content = contents[indexPath.row]
        (cell.contentView.subviews[0] as! UILabel).text = content
       
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContent = contents[indexPath.row]
        if let planDetailViewController = planDetailViewController {
            planDetailViewController.contentTextView.text = selectedContent
        }
    }
}
