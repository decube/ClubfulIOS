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
    
    @IBOutlet var mapView : MKMapView!
    
    override func viewDidLoad() {
        print("CourtMapViewController viewDidLoad")
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(courtLatitude, courtLongitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        let marker = MKPointAnnotation()
        marker.coordinate = location
        mapView.addAnnotation(marker)
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}


