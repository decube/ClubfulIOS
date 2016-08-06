//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class JoinMapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    var joinView : UIViewController!
    var joinLocationBtn : UIButton!
    
    //맵뷰
    @IBOutlet var mapView: MKMapView!
    //마커
    var marker : MKPointAnnotation!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var confirmBtn: UIButton!
    
    //왼쪽 스크롤
    var leftCourtView : UIScrollView!
    
    var user = Storage.getRealmUser()
    
    override func viewDidLoad() {
        print("CourtCreateMapViewController viewDidLoad")
        
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
            
            //지도 검색 통신
            var i : CGFloat = 0
            let locObjHeight : CGFloat = 80
            
            
            
            
            
            let parameters : [String: AnyObject] = ["token": self.user.token, "address": searchField.text!, "language": Util.language]
            Alamofire.request(.GET, URL.location_geocode, parameters: parameters)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    self.leftCourtView.hidden = false
                    let data : NSData = response.data!
                    let dic = Util.convertStringToDictionary(data)
                    if let code = dic["code"] as? Int{
                        if code == 0{
                            if let result = dic["results"] as? [String: AnyObject]{
                                if let results = result["results"] as? [[String: AnyObject]]{
                                    //카운트가 1보다 많으면
                                    if results.count > 1{
                                        for element : [String: AnyObject] in results{
                                            var elementLatitude = 0.0
                                            var elementLongitude = 0.0
                                            var elementAddressShort = ""
                                            var elementAddress = ""
                                            if let locationGeometry = element["geometry"] as? [String:AnyObject]{
                                                if let location = locationGeometry["location"] as? [String:Double]{
                                                    elementLatitude = location["lat"]!
                                                    elementLongitude = location["lng"]!
                                                }
                                            }
                                            if let locationComponents = element["address_components"] as? [[String:AnyObject]]{
                                                for components : [String:AnyObject] in locationComponents{
                                                    if let types = components["types"] as? [String]{
                                                        if types[0] == "sublocality_level_2"{
                                                            elementAddressShort = components["long_name"] as! String
                                                            break
                                                        }
                                                    }
                                                }
                                                if (elementAddressShort == ""){
                                                    for components : [String:AnyObject] in locationComponents{
                                                        if let types = components["types"] as? [String]{
                                                            if types[0] == "sublocality_level_1"{
                                                                elementAddressShort = components["long_name"] as! String
                                                                break
                                                            }
                                                        }
                                                    }
                                                }
                                                if (elementAddressShort == ""){
                                                    elementAddressShort = locationComponents[0]["long_name"] as! String
                                                }
                                                elementAddress = element["formatted_address"] as! String
                                            }
                                            
                                            let objBtn = UIButton(frame: CGRect(x: 0, y: locObjHeight*i, width: self.leftCourtView.frame.width, height: locObjHeight-1))
                                            let addressShortLbl = UILabel(frame: CGRect(x: 5, y: 10, width: objBtn.frame.width-5, height: 15), text: "\(elementAddressShort)", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
                                            let addressLbl = UILabel(frame: CGRect(x: 5, y: 25, width: objBtn.frame.width-5, height: 65), text: "\(elementAddress)", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 13)
                                            addressLbl.numberOfLines = 2
                                            objBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
                                            self.leftCourtView.addSubview(objBtn)
                                            objBtn.addSubview(addressShortLbl)
                                            objBtn.addSubview(addressLbl)
                                            
                                            objBtn.addControlEvent(.TouchUpInside){
                                                self.leftCourtView.hidden = true
                                                self.locationMove(elementLatitude, longitude: elementLongitude)
                                            }
                                            i += 1
                                        }
                                        self.leftCourtView.contentSize = CGSize(width: self.leftCourtView.frame.width, height: locObjHeight*i)
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
                                            self.leftCourtView.hidden = true
                                            self.locationMove(elementLatitude, longitude: elementLongitude)
                                        }
                                    }
                                }
                            }else{
                                if let isMsgView = dic["isMsgView"] as? Bool{
                                    if isMsgView == true{
                                        Util.alert(message: "\(dic["msg"]!)", ctrl: self)
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
                                    var elementAddressShort = ""
                                    var elementAddress = ""
                                    if let locationComponents = element["address_components"] as? [[String:AnyObject]]{
                                        for components : [String:AnyObject] in locationComponents{
                                            if let types = components["types"] as? [String]{
                                                if types[0] == "sublocality_level_2"{
                                                    elementAddressShort = components["long_name"] as! String
                                                    break
                                                }
                                            }
                                        }
                                        if (elementAddressShort == ""){
                                            for components : [String:AnyObject] in locationComponents{
                                                if let types = components["types"] as? [String]{
                                                    if types[0] == "sublocality_level_1"{
                                                        elementAddressShort = components["long_name"] as! String
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                        if (elementAddressShort == ""){
                                            elementAddressShort = locationComponents[0]["long_name"] as! String
                                        }
                                        elementAddress = element["formatted_address"] as! String
                                        if let vc = self.joinView as? JoinViewController{
                                            vc.latitude = self.mapView.region.center.latitude
                                            vc.longitude = self.mapView.region.center.longitude
                                            vc.address = "\(elementAddress)"
                                            vc.addressShort = "\(elementAddressShort)"
                                        }else if let vc = self.joinView as? UserConvertViewController{
                                            vc.latitude = self.mapView.region.center.latitude
                                            vc.longitude = self.mapView.region.center.longitude
                                            vc.address = "\(elementAddress)"
                                            vc.addressShort = "\(elementAddressShort)"
                                        }
                                        
                                        self.joinLocationBtn.setTitle("\(elementAddressShort)", forState: .Normal)
                                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                }
                            }
                        }else{
                            if let isMsgView = dic["isMsgView"] as? Bool{
                                if isMsgView == true{
                                    Util.alert(message: "\(dic["msg"]!)", ctrl: self)
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


