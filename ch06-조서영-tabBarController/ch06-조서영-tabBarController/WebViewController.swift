//
//  WebViewController.swift
//  ch06-조서영-tabBarController
//
//  Created by hansung on 2023/04/10.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
   
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        // CityViewController에서 선택한 도시이름을 getCurrentLonLat() 함수를 호출하여 가져와서 city변수에 저장하라.
        let parent = self.parent as! UITabBarController
        let cityViewController = parent.viewControllers![0] as! CityViewController
        var (city,longitute,latitute) = cityViewController.getCurrentLonLat()
        if city == "CurrentLocation" {
            city = "Seoul"
        }
        else if city == "New York"{
            city = "NewYork"
        }

         // url을 다음과 같이 문자열로 작성하라
        let urlStr = "https://en.wikipedia.org/wiki/" + city

        // 이를 이용하여 URL객체 생성하라
        if let url = URL(string: urlStr) {
            // 이 URL객체를 이용하여 URLRequest객체를 생성하라
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // 이 URLRequest객체를 이용하여 webView.load()함수를 호출하기
            webView.load(request)
        }
    }
   


}
