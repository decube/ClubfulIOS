//
//  MainLeftViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 29..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import MapKit

class MainLeftViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    var interactor:Interactor? = nil
    var vc: ViewController!
    
    //현재위치 manager
    let locationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.mapView.delegate = self
        
        let deviceUser = Storage.getRealmDeviceUser()
        var latitude = deviceUser.latitude
        var longitude = deviceUser.longitude
        if deviceUser.isMyLocation == false{
            latitude = deviceUser.deviceLatitude
            longitude = deviceUser.deviceLongitude
        }
        self.locationMove(latitude: latitude, longitude: longitude)
        
        
        
        self.addMarker(latitude: 35.2587209, longitude: 127.0229413, title: "축구장", subTitle: "가나축구장", type: 1)
        self.addMarker(latitude: 35.9877689, longitude: 128.6321409, title: "농구코트", subTitle: "오목농구장", type: 2)
        self.addMarker(latitude: 36.3320526, longitude: 129.5003811, title: "야구장", subTitle: "신림야구", type: 3)
        self.addMarker(latitude: 35.6806774, longitude: 129.4977022, title: "축구장", subTitle: "신도림축구", type: 1)
        self.addMarker(latitude: 35.2782706, longitude: 129.0633961, title: "미식축구", subTitle: "유럽미식축구장", type: 1)
        self.addMarker(latitude: 37.48480, longitude: 126.9416, title: "농구", subTitle: "부산농구장", type: 2)
        self.addMarker(latitude: 37.45480, longitude: 126.9616, title: "배구", subTitle: "서울배구", type: 4)
        self.addMarker(latitude: 37.49480, longitude: 126.9316, title: "골프", subTitle: "대한골프", type: 5)
    }
    
    func addMarker(latitude: Double, longitude: Double, title: String, subTitle: String, type: Int){
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let marker = CustomPointAnnotation()
        marker.title = title
        marker.subtitle = subTitle
        marker.coordinate = location
        marker.imageName = "ball_type_\(type)"
        self.mapView.addAnnotation(marker)
    }
    
    //지도 위치 수정
    func locationMove(latitude: Double, longitude: Double){
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "myLocation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }else {
            anView?.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        anView?.frame.size = CGSize(width: 40, height: 40)
        return anView
    }
    
    
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
