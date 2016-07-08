//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import MapKit

class CourtCreateMapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    var courtCreateView : CourtCreateViewController!
    var courtCreateViewLocationBtn : UIButton!
    
    var mapView : MKMapView!
    //마커
    var annotation : MKPointAnnotation!
    
    override func viewDidLoad() {
        print("CourtCreateMapViewController viewDidLoad")
        
        let user = Storage.getRealmUser()
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height-20))
        self.view.addSubview(mapView)
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(user.latitude, user.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        self.annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        //맵뷰 터치했을때 이벤트
        self.mapView.userInteractionEnabled = true
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.mapViewTouch(_:))))
        self.mapView.delegate = self
        
        
        let searchField = UITextField(frame: CGRect(x: 10, y: 90, width: self.view.frame.width-90, height: 40), placeholder: "위치를 검색해주세요", textAlignment: .Left, delegate: self)
        searchField.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(searchField)
        
        let searchBtn = UIButton(frame: CGRect(x: self.view.frame.width-70, y: 90, width: 60, height: 40), text: "검색", color: UIColor.whiteColor())
        searchBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.blackColor(), borderColor: Util.commonColor)
        self.view.addSubview(searchBtn)
        
        
        //서브레이아웃
        let leftCourtView = UIScrollView(frame: CGRect(x: 0, y: 140, width: Util.screenSize.width/2, height: Util.screenSize.height-200), backgroundColor: UIColor.whiteColor())
        leftCourtView.hidden = true
        self.view.addSubview(leftCourtView)
        
        searchBtn.addControlEvent(.TouchUpInside){
            if searchField.text?.characters.count < 2{
                Util.alert(message: "검색어를 2글자 이상 넣어주세요", ctrl: self)
            }else{
                self.view.endEditing(true)
                leftCourtView.subviews.forEach({$0.removeFromSuperview()})
                leftCourtView.scrollToTop()
                leftCourtView.hidden = false
                
                //지도 검색 통신
                var i : CGFloat = 0
                let locObjHeight : CGFloat = 80
                for j in 0 ... 10{
                    let objBtn = UIButton(frame: CGRect(x: 0, y: locObjHeight*i, width: leftCourtView.frame.width, height: locObjHeight-1))
                    let addressShortLbl = UILabel(frame: CGRect(x: 5, y: 10, width: objBtn.frame.width-5, height: 15), text: "1234어디주소", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
                    let addressLbl = UILabel(frame: CGRect(x: 5, y: 25, width: objBtn.frame.width-5, height: 65), text: "어디어디주소길게길게어디어디주소길게길게어디어디주소길게길게", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 13)
                    addressLbl.numberOfLines = 2
                    objBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
                    leftCourtView.addSubview(objBtn)
                    objBtn.addSubview(addressShortLbl)
                    objBtn.addSubview(addressLbl)
                    
                    objBtn.addControlEvent(.TouchUpInside){
                        leftCourtView.hidden = true
                        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.5571274, 126.9239304)
                        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                        self.mapView.region = region
                        self.annotation.coordinate = location
                    }
                    i += 1
                }
                leftCourtView.contentSize = CGSize(width: leftCourtView.frame.width, height: locObjHeight*i)
            }
        }
        
        let confirmBtn = UIButton(frame: CGRect(x: 10, y: self.view.frame.height-50, width: self.view.frame.width-20   , height: 40), text: "등록", color: UIColor.whiteColor())
        confirmBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: Util.commonColor, borderColor: UIColor.blackColor())
        self.view.addSubview(confirmBtn)
        
        confirmBtn.addControlEvent(.TouchUpInside){
            self.courtCreateView.courtLatitude = self.mapView.region.center.latitude
            self.courtCreateView.courtLongitude = self.mapView.region.center.longitude
            self.courtCreateViewLocationBtn.setTitle("홍대", forState: .Normal)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        CustomView.initLayout(self, title: "코트위치 설정")
    }
    
    func mapViewWillStartRenderingMap(mapView: MKMapView) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.annotation.coordinate = location
    }
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.annotation.coordinate = location
    }
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.annotation.coordinate = location
    }
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.annotation.coordinate = location
    }
    
    //맵뷰 터치
    func mapViewTouch(sender: AnyObject){
        self.view.endEditing(true)
    }
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


