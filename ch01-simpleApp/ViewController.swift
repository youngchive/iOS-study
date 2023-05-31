//
//  ViewController.swift
//  ch01-simpleApp
//
//  Created by hansung on 2023/03/06.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        questionLabel.text = questions[currentIndex]
    }
    var questions = [
        "대한민국의 수도는 무엇인가요?",
        "한국 청년들에게 가장 인기있는 대학은 무슨 대학인가요?",
        "7+21은 얼마인가요?"
    ]
    var answers = [
        "서울",
        "한성대학교",
        "28"
    ]
    var currentIndex = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        currentIndex = (currentIndex+1)%questions.count
        questionLabel.text = questions[currentIndex]
    }
    @IBAction func showAnswer(_ sender: UIButton) {
        answerLabel.text = answers[currentIndex]
    }
}

