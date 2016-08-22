//
//  LoginViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    var preView : UIViewController!
    var preBtn : UIButton!
    
    //맵뷰
    @IBOutlet var mapView: MKMapView!
    //마커
    var marker : MKPointAnnotation!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var confirmBtn: UIButton!
    
    var user = Storage.getRealmUser()
    
    var mapListView : MapListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("JoinMapViewController viewDidLoad")
        
        self.marker = MKPointAnnotation()
        mapView.addAnnotation(marker)
        locationMove(user.latitude, longitude: user.longitude)
        
        
        //맵뷰 터치했을때 이벤트
        self.mapView.userInteractionEnabled = true
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.mapViewTouch(_:))))
        self.mapView.delegate = self
        
        
        searchField.delegate = self
        
        
        //코트 검색
        if let customView = NSBundle.mainBundle().loadNibNamed("MapListView", owner: self, options: nil).first as? MapListView {
            mapListView = customView
            mapListView.frame = CGRect(x: 0, y: mapView.frame.origin.y, width: Util.screenSize.width/3*2, height: mapView.frame.height)
            mapListView.backgroundColor = UIColor.whiteColor()
            mapListView.hidden = true
            self.view.addSubview(mapListView)
        }
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
            Util.alert(self, message: "검색어를 2글자 이상 넣어주세요")
        }else{
            self.view.endEditing(true)
            mapListView.scrollView.subviews.forEach({$0.removeFromSuperview()})
            mapListView.scrollView.scrollToTop()
            
            //지도 검색 통신
            var i : CGFloat = 0
            let locObjHeight : CGFloat = 80
            
            
            let parameters : [String: AnyObject] = ["token": self.user.token, "address": searchField.text!, "language": Util.language]
            Alamofire.request(.GET, URL.location_geocode, parameters: parameters)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    let data : NSData = response.data!
                    let dic = Util.convertStringToDictionary(data)
                    if let code = dic["code"] as? Int{
                        if code == 0{
                            if let result = dic["results"] as? [String: AnyObject]{
                                if let results = result["results"] as? [[String: AnyObject]]{
                                    //카운트가 1보다 많으면
                                    if results.count > 1{
                                        for element : [String: AnyObject] in results{
                                            let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
                                            
                                            
                                            if let customView = NSBundle.mainBundle().loadNibNamed("MapListElementView", owner: self, options: nil).first as? MapListElementView {
                                                customView.frame = CGRect(x: 5, y: locObjHeight*i+5, width: self.mapListView.frame.width-10, height: locObjHeight-10)
                                                customView.setAddr(addressShort: addressShort, address: address)
                                                self.mapListView.scrollView.addSubview(customView)
                                                
                                                if self.mapListView.hidden != false{
                                                    let tmpRect = self.mapListView.frame
                                                    self.mapListView.frame.origin.x = -tmpRect.width
                                                    self.mapListView.hidden = false
                                                    //애니메이션 적용
                                                    UIView.animateWithDuration(0.2, animations: {
                                                        self.mapListView.frame = tmpRect
                                                        }, completion: {(_) in
                                                    })
                                                }
                                                
                                                customView.setAction({ (_) in
                                                    UIView.animateWithDuration(0.2, animations: {
                                                        self.mapListView.alpha = 0
                                                    }) { (_) in
                                                        self.mapListView.hidden = true
                                                        self.mapListView.alpha = 1
                                                        self.locationMove(latitude, longitude: longitude)
                                                    }
                                                })
                                                
                                            }
                                            i += 1
                                        }
                                        self.mapListView.scrollView.contentSize = CGSize(width: self.mapListView.scrollView.frame.width, height: locObjHeight*i)
                                    }else{
                                        //카운트가 1개 이면
                                        for element : [String: AnyObject] in results{
                                            var elementLatitude = 0.0
                                            var elementLongitude = 0.0
                                            if let locationGeometry = element["geometry"] as? [String:AnyObject]{
                                                if let location = locationGeometry["location"] as? [String:Double]{
                                                    elementLatitude = location["lat"]!
                                                    elementLongitude = location["lng"]!
                                                }
                                            }
                                            self.mapListView.scrollView.hidden = true
                                            self.locationMove(elementLatitude, longitude: elementLongitude)
                                        }
                                    }
                                }
                            }else{
                                if let isMsgView = dic["isMsgView"] as? Bool{
                                    if isMsgView == true{
                                        Util.alert(self, message: "\(dic["msg"]!)")
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    
    
    //등록 클릭
    @IBAction func confirmAction(sender: AnyObject) {
        let parameters : [String: AnyObject] = ["token": self.user.token, "latitude": self.mapView.region.center.latitude, "longitude": self.mapView.region.center.longitude, "language": Util.language]
        Alamofire.request(.GET, URL.location_geocode, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        if let result = dic["results"] as? [String: AnyObject]{
                            if let results = result["results"] as? [[String: AnyObject]]{
                                if results.count > 0{
                                    let element : [String: AnyObject] = results[0]
                                    let (_, _, addressShort, address) = Util.googleMapParse(element)
                                    
                                    if let vc = self.preView as? JoinViewController{
                                        vc.latitude = self.mapView.region.center.latitude
                                        vc.longitude = self.mapView.region.center.longitude
                                        vc.address = "\(address)"
                                        vc.addressShort = "\(addressShort)"
                                    }else if let vc = self.preView as? UserConvertViewController{
                                        vc.latitude = self.mapView.region.center.latitude
                                        vc.longitude = self.mapView.region.center.longitude
                                        vc.address = "\(address)"
                                        vc.addressShort = "\(addressShort)"
                                    }else if let vc = self.preView as? CourtCreateViewController{
                                        vc.courtLatitude = self.mapView.region.center.latitude
                                        vc.courtLongitude = self.mapView.region.center.longitude
                                        vc.courtAddress = "\(address)"
                                        vc.courtAddressShort = "\(addressShort)"
                                    }
                                    
                                    self.preBtn.setTitle("\(addressShort)", forState: .Normal)
                                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                        }else{
                            if let isMsgView = dic["isMsgView"] as? Bool{
                                if isMsgView == true{
                                    Util.alert(self, message: "\(dic["msg"]!)")
                                }
                            }
                        }
                    }
                }
        }
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
        
        let tmpRect = mapListView.frame
        //애니메이션 적용
        UIView.animateWithDuration(0.2, animations: {
            self.mapListView.frame.origin.x = -tmpRect.width
        }) { (_) in
            self.mapListView.frame = tmpRect
            self.mapListView.hidden = true
            self.mapListView.scrollView.scrollToTop()
        }
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
