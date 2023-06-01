//
//  MapViewController.swift
//  ch06-조서영-tabBarController
//
//  Created by hansung on 2023/04/10.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        
        updateMap(title: city, longitute: longitute, latitute: latitute)
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
