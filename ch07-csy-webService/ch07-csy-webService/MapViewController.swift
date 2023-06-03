//
//  MapViewController.swift
//  ch06-조서영-tabBarController
//
//  Created by hansung on 2023/04/10.
//

import UIKit
import MapKit
import Progress


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //ch07
    let baseURLString = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "b1b309715ec6323704bb4d1cd8687a20"

    
    @IBAction func sgcValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}

extension MapViewController{
    
    override func viewDidLoad() {
            super.viewDidLoad()
            print("MapViewController.viewDidLoad")
        }


    override func viewWillAppear(_ animated: Bool) {
        print("mapViewController.viewWillAppear")

        let parent = self.parent as! UITabBarController
        let cityViewController = parent.viewControllers![0] as! CityViewController
        let (city, longitute, latitute) = cityViewController.getCurrentLonLat()
        
        //ch07
        getWeatherData(cityName: city)
        
        //ch06
        //updateMap(title: city, longitute: longitute, latitute: latitute)
    }
    override func viewWillDisappear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }
}

extension MapViewController{

    func updateMap(title: String, longitute: Double?, latitute: Double?){

        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        var center = mapView.centerCoordinate // 일단 기존의 중심을 저장
        if let longitute = longitute, let latitute = latitute{
            center = CLLocationCoordinate2D(latitude: latitute, longitude: longitute) // 새로운 중심 설정
        }
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true) // 주어진 영역으로 지도를 설정
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center    // 센터에 annotation을 설치
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
}

//ch07
extension MapViewController {
    func getWeatherData(cityName city: String){
        
        Prog.start(in: self, .activityIndicator)

        var urlStr = baseURLString+"?"+"q="+city+"&"+"appid="+apiKey
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let session = URLSession(configuration: .default)
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        
        let dataTask = session.dataTask(with: request){
            (data, response, error) in
            guard let jsonData = data else{ print(error!); return }
            if let jsonStr = String(data:jsonData, encoding: .utf8){
                print(jsonStr)
            }
            
            let (temperature, longitute, latitute) = self.extractWeatherData(jsonData: jsonData)
            var title = city
            if let temperature = temperature{
                title += String.init(format: ": %.2f℃", temperature)
            }
            DispatchQueue.main.async {
                self.updateMap(title: title, longitute: longitute, latitute: latitute)
                //print("1")
                Prog.dismiss(in: self)

            }
            //print("2")
        }
        dataTask.resume()
    }
}

extension MapViewController {
    func extractWeatherData(jsonData: Data) -> (Double?, Double?, Double?){
        
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]

        // {"cod":"404","message":"city not found"} for unknown city
        if let code = json["cod"] {
            if code is String, code as! String == "404"{
                return (nil, nil, nil)
            }
        }
        
        let latitude = (json["coord"] as! [String: Double])["lat"]
        let longitude = (json["coord"] as! [String: Double])["lon"]
        
        guard var temperature = (json["main"] as! [String: Double])["temp"] else{
            return (nil, longitude, latitude)
        }
        temperature = temperature - 273.0
        return (temperature, longitude, latitude)
    }
}
