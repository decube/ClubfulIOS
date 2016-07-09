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
    
    //맵뷰
    @IBOutlet var mapView: MKMapView!
    //마커
    var marker : MKPointAnnotation!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var confirmBtn: UIButton!
    
    //왼쪽 스크롤
    var leftCourtView : UIScrollView!
    override func viewDidLoad() {
        print("CourtCreateMapViewController viewDidLoad")
        
        let user = Storage.getRealmUser()
        
        self.marker = MKPointAnnotation()
        mapView.addAnnotation(marker)
        locationMove(user.latitude, longitude: user.longitude)
        
        
        //맵뷰 터치했을때 이벤트
        self.mapView.userInteractionEnabled = true
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.mapViewTouch(_:))))
        self.mapView.delegate = self
        
        
        searchField.delegate = self
        searchBtn.boxLayout(radius: 6)
        
        
        leftCourtView = UIScrollView(frame: CGRect(x: 0, y: mapView.frame.origin.y, width: Util.screenSize.width/2, height: mapView.frame.height), backgroundColor: UIColor.whiteColor())
        leftCourtView.hidden = true
        self.view.addSubview(leftCourtView)
    }
    
    
    //지도 위치 수정
    func locationMove(latitude: Double, longitude: Double){
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        marker.coordinate = location
    }
    
    //검색 클릭
    @IBAction func searchAction(sender: AnyObject) {
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
                    self.leftCourtView.hidden = true
                    self.locationMove(37.5571274, longitude: 126.9239304)
                }
                i += 1
            }
            leftCourtView.contentSize = CGSize(width: leftCourtView.frame.width, height: locObjHeight*i)
        }
    }
    
    
    
    //등록 클릭
    @IBAction func confirmAction(sender: AnyObject) {
        self.courtCreateView.courtLatitude = self.mapView.region.center.latitude
        self.courtCreateView.courtLongitude = self.mapView.region.center.longitude
        self.courtCreateViewLocationBtn.setTitle("홍대", forState: .Normal)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //맵 렌더링 시작
    func mapViewWillStartRenderingMap(mapView: MKMapView) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    //맵 렌더링 끝
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    //맵 지역 변경시작
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    //맵 지역 변경후
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    
    //맵뷰 터치
    func mapViewTouch(sender: AnyObject){
        self.view.endEditing(true)
        leftCourtView.subviews.forEach({$0.removeFromSuperview()})
        leftCourtView.scrollToTop()
        leftCourtView.hidden = true
    }
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


