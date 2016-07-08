//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import MapKit

class CourtMapViewController: UIViewController, MKMapViewDelegate{
    var courtLatitude : Double!
    var courtLongitude : Double!
    
    var mapView : MKMapView!
    //마커
    var annotation : MKPointAnnotation!
    
    
    override func viewDidLoad() {
        print("CourtMapViewController viewDidLoad")
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height-20))
        self.view.addSubview(mapView)
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(courtLatitude, courtLongitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        self.annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        CustomView.initLayout(self, title: "약도")
    }
}


