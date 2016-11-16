//
//  MainLeftViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 29..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import MapKit

class MainLeftViewController: UIViewController, CLLocationManagerDelegate{
    var interactor:Interactor? = nil
    var vc: ViewController!
    
    //현재위치 manager
    let locationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        let deviceUser = Storage.getRealmDeviceUser()
        var latitude = deviceUser.latitude
        var longitude = deviceUser.longitude
        if deviceUser.isMyLocation == false{
            latitude = deviceUser.deviceLatitude
            longitude = deviceUser.deviceLongitude
        }
        self.locationMove(latitude: latitude, longitude: longitude)
        
        
        
        
        
        
        
        
        self.addMarker(latitude: 35.2587209, longitude: 127.0229413)
        self.addMarker(latitude: 35.9877689, longitude: 128.6321409)
        self.addMarker(latitude: 36.3320526, longitude: 129.5003811)
        self.addMarker(latitude: 35.6806774, longitude: 129.4977022)
        self.addMarker(latitude: 35.2782706, longitude: 129.0633961)
        self.addMarker(latitude: 37.48480, longitude: 126.9416)
        self.addMarker(latitude: 37.45480, longitude: 126.9616)
        self.addMarker(latitude: 37.49480, longitude: 126.9316)
    }
    
    func addMarker(latitude: Double, longitude: Double){
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let marker = MKPointAnnotation()
        marker.coordinate = location
        self.mapView.addAnnotation(marker)
    }
    
    //지도 위치 수정
    func locationMove(latitude: Double, longitude: Double){
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
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
