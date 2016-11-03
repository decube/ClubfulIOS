//
//  LoginViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    //이전 컨트롤러
    var preView : UIViewController!
    //이전 컨트롤러 버튼
    var preBtn : UIButton!
    
    //맵뷰
    @IBOutlet var mapView: MKMapView!
    //마커
    var marker : MKPointAnnotation!
    
    //검색 필드
    @IBOutlet var searchField: UITextField!
    //확인버튼
    @IBOutlet var confirmBtn: UIButton!
    //취소뷰
    @IBOutlet var cancelView: UIView!
    //스크롤뷰
    var mapListView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //마커
        self.marker = MKPointAnnotation()
        self.mapView.addAnnotation(marker)
        let deviceUser = Storage.getRealmDeviceUser()
        self.locationMove(latitude: deviceUser.latitude, longitude: deviceUser.longitude)
        
        
        //맵뷰 터치했을때 이벤트
        self.mapView.isUserInteractionEnabled = true
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.mapViewTouch)))
        self.cancelView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.cancelAction)))
        self.mapView.delegate = self
        self.searchField.delegate = self
        
        //코트 검색
        self.mapListView = UIScrollView(frame: CGRect(x: 0, y: mapView.frame.origin.y, width: self.view.frame.width/3*2, height: mapView.frame.height))
        self.mapListView.backgroundColor = UIColor(red:0.86, green:0.90, blue:0.93, alpha:1.00)
        self.mapListView.isHidden = true
        
        
        self.view.addSubview(self.mapListView)
    }
    
    
    //지도 위치 수정
    func locationMove(latitude: Double, longitude: Double){
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        
        self.marker.coordinate = location
    }
    
    //검색 클릭
    func searchAction() {
        if (self.searchField.text?.characters.count)! < 2{
            Util.alert(self, message: "검색어를 2글자 이상 넣어주세요")
        }else{
            self.view.endEditing(true)
            self.mapListView.subviews.forEach({$0.removeFromSuperview()})
            self.mapListView.scrollToTop()
            
            //지도 검색 통신
            let parameters : [String: AnyObject] = ["address": self.searchField.text! as AnyObject, "language": Util.language as AnyObject]
            URLReq.request(self, url: URLReq.apiServer+URLReq.api_location_geocode, param: parameters, callback: { (dic) in
                if let result = dic["results"] as? [String: AnyObject]{
                    if let results = result["results"] as? [[String: AnyObject]]{
                        //카운트가 1보다 많으면
                        if results.count > 1{
                            self.view.endEditing(true)
                            self.mapListView.subviews.forEach({$0.removeFromSuperview()})
                            var i : CGFloat = 0
                            let locObjHeight : CGFloat = 80
                            
                            for element : [String: AnyObject] in results{
                                let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
                                
                                if let customView = Bundle.main.loadNibNamed("MapListElementView", owner: self, options: nil)?.first as? MapListElementView {
                                    customView.setLayout(self, height: locObjHeight, idx: i, location: (latitude, longitude, addressShort, address))
                                }
                                i += 1
                            }
                            self.mapListView.contentSize = CGSize(width: self.mapListView.frame.width, height: locObjHeight*i)
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
                                self.mapListView.isHidden = true
                                self.locationMove(latitude: elementLatitude, longitude: elementLongitude)
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
            })
        }
    }
    
    
    
    //등록 클릭
    @IBAction func confirmAction(_ sender: AnyObject) {
        let parameters : [String: AnyObject] = ["latitude": self.mapView.region.center.latitude as AnyObject, "longitude": self.mapView.region.center.longitude as AnyObject, "language": Util.language as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+URLReq.api_location_geocode, param: parameters, callback: {(dic) in
            if let result = dic["results"] as? [String: AnyObject]{
                if let results = result["results"] as? [[String: AnyObject]]{
                    if results.count > 0{
                        let element : [String: AnyObject] = results[0]
                        let (_, _, addressShort, address) = Util.googleMapParse(element)
                        
                        if let vc = self.preView as? CourtCreateViewController{
                            vc.courtLatitude = self.mapView.region.center.latitude
                            vc.courtLongitude = self.mapView.region.center.longitude
                            vc.courtAddress = "\(address)"
                            vc.courtAddressShort = "\(addressShort)"
                        }else if let vc = self.preView as? UserConvertViewController{
                            vc.addView.userLatitude = self.mapView.region.center.latitude
                            vc.addView.userLongitude = self.mapView.region.center.longitude
                            vc.addView.userAddress = "\(address)"
                            vc.addView.userAddressShort = "\(addressShort)"
                        }else if let vc = self.preView as? ViewController{
                            vc.addView.userLatitude = self.mapView.region.center.latitude
                            vc.addView.userLongitude = self.mapView.region.center.longitude
                            vc.addView.userAddress = "\(address)"
                            vc.addView.userAddressShort = "\(addressShort)"
                        }
                        
                        self.preBtn.setTitle("\(addressShort)", for: UIControlState())
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }else{
                if let isMsgView = dic["isMsgView"] as? Bool{
                    if isMsgView == true{
                        Util.alert(self, message: "\(dic["msg"]!)")
                    }
                }
            }
        })
    }
    
    
    
    
    
    
    //키보드 검색이 리턴됫을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchField {
            textField.resignFirstResponder()
            self.searchAction()
            return false
        }
        return true
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //맵 렌더링 시작
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    //맵 렌더링 끝
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    //맵 지역 변경시작
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    //맵 지역 변경후
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.marker.coordinate = location
    }
    
    
    //취소뷰를 클릭했을 때
    func cancelAction(){
        self.searchField.text = ""
        self.scrollHidden()
    }
    
    //맵뷰 터치
    func mapViewTouch(){
        self.scrollHidden()
    }
    
    //스크롤히든
    func scrollHidden(){
        self.view.endEditing(true)
        let tmpRect = self.mapListView.frame
        //애니메이션 적용
        UIView.animate(withDuration: 0.2, animations: {
            self.mapListView.frame.origin.x = -tmpRect.width
            }, completion: { (_) in
                self.mapListView.frame = tmpRect
                self.mapListView.isHidden = true
                self.mapListView.scrollToTop()
        })
    }
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
