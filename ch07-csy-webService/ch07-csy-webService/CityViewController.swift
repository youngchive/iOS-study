//
//  ViewController.swift
//  ch06-조서영-tabBarController
//
//  Created by hansung on 2023/04/10.
//

import UIKit
import CoreLocation

class CityViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var cityPickerView: UIPickerView!
    
    let locationManager = CLLocationManager()
    
    var cities: [String: [String:Double?]] = [
        "Seoul" : ["lon":126.9778,"lat":37.5683], "Athens" : ["lon":23.7162,"lat":37.9795],
        "Bangkok" : ["lon":100.5167,"lat":13.75], "Berlin" : ["lon":13.4105,"lat":52.5244],
        "Jerusalem" : ["lon":35.2163,"lat":31.769], "Lisbon" : ["lon":-9.1333,"lat":38.7167],
        "London" : ["lon":-0.1257,"lat":51.5085], "New York" : ["lon":-74.006,"lat":40.7143],
        "Paris" : ["lon":2.3488,"lat":48.8534], "Sydney" : ["lon":151.2073,"lat":-33.8679],
        "현재위치" : ["lon": nil, "lat": nil]
    ]
}
 
extension CityViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("CityViewController: ViewDidLoad")
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
}

extension CityViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let cityNames = Array(cities.keys)
        return cityNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var cityNames = Array(cities.keys)
        cityNames.sort()

        return cityNames[row]
    }
}

extension CityViewController {
    func getCurrentLonLat() -> (String, Double?, Double?) {
        
        var cityNames = Array(cities.keys)
        cityNames.sort()
        let selectedCity = cityNames[cityPickerView.selectedRow(inComponent: 0)]
        guard let city = cities[selectedCity], let lon = city["lon"] ?? nil, let lat = city["lat"] ?? nil else {
            print("city: \(selectedCity), latitude: nil, longitude: nil")
            return (selectedCity, nil, nil)
        }
        print("city: \(selectedCity), latitude: \(lat), longitude: \(lon)")
                return (selectedCity,lon,lat)
    }
}
    
    extension CityViewController{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            cities["현재위치"]?["lon"] = longitude
            cities["현재위치"]?["lat"] = latitude
            print("위도: \(latitude), 경도: \(longitude)")
        }
    }
