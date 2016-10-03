//
//  ViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 9. 26..
//  Copyright © 2016년 guanho. All rights reserved.
//


import UIKit
import Darwin
import MapKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}


class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    //user 저장소
    var user : User!
    
    //광고영역
    @IBOutlet var adView: UIImageView!
    
    //내위치 표시 변수
    var myLocationMove = true
    //현재 내위치 검색
    var myLocationSearch = false
    //위치가져왔는지 못가져왔는지
    var isMyLocation = false
    
    
    //현재위치 manager
    let locationManager = CLLocationManager()
    //맵뷰
    @IBOutlet var mapView: MKMapView!
    //마커
    var marker : MKPointAnnotation!
    
    //blackScreen
    var blackScreen : UIButton!
    //코트검색뷰
    var courtSearchView : UIScrollView!
    //위치찾기뷰
    var locationView : MainCenterView!
    //위치찾기스크롤
    var locationScrollView : UIScrollView!
    
    
    //코트 검색 텍스트필드
    @IBOutlet var courtSearchTextField: UITextField!
    
    
    //위치 관련 앱을 실행했는지 실행 하지 않았는지
    var isFirstLocation = true
    
    //위치 리스트
    var locationResults : [[String: AnyObject]]!
    
    var isRotated = true
    
    //회전됬을때
    func rotated(){
        func rotatedSet(){
            blackScreen.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            locationView.frame = CGRect(x: (self.view.frame.width-300)/2, y: (self.view.frame.height-300)/2, width: 300, height: 300)
            if self.courtSearchView.isHidden == false{
                self.courtSearchView.isHidden = true
                self.setCourtLayout()
            }
            if self.locationView.isHidden == false{
                self.locationSetLayout()
            }
        }
        if(self.isRotated == false && UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
            self.isRotated = true
            mapView.frame = CGRect(x: 0, y: 140, width: self.view.frame.width, height: self.view.frame.height - 140)
            courtSearchView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width/3*2, height: self.adView.frame.height+self.mapView.frame.height)
            rotatedSet()
        }
        if(self.isRotated == true && UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            self.isRotated = false
            mapView.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height - 120)
            courtSearchView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width/3*2, height: self.adView.frame.height+self.mapView.frame.height)
            rotatedSet()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController viewDidLoad")
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //cache지우기
        //                NSURLCache.sharedURLCache().removeAllCachedResponses()
        //                NSURLCache.sharedURLCache().diskCapacity = 0
        //                NSURLCache.sharedURLCache().memoryCapacity = 0
        
        
        //GET Async 동기 통신
        var request : NSMutableURLRequest
        let apiUrl = Foundation.URL(string: URL.urlCheck)
        request = NSMutableURLRequest(url: apiUrl!)
        request.httpMethod = "GET"
        var data = Data()
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(responseData,_,_) -> Void in
            if responseData != nil{
                data = responseData!
            }
            semaphore.signal()
        }).resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
            URL.apiServer = json["apiServer"] as! String
            URL.viewServer = json["viewServer"] as! String
            URL.courtUpload = json["courtUpload"] as! String
            
            URL.view_info = json["view_info"] as! String
            URL.view_notice = json["view_notice"] as! String
            URL.view_guide = json["view_guide"] as! String
            URL.view_inquiry = json["view_inquiry"] as! String
            
            URL.api_version_check = json["api_version_check"] as! String
            URL.api_version_app = json["api_version_app"] as! String
            URL.api_court_create = json["api_court_create"] as! String
            URL.api_court_detail = json["api_court_detail"] as! String
            URL.api_court_interest = json["api_court_interest"] as! String
            URL.api_court_listSearch = json["api_court_listSearch"] as! String
            URL.api_court_replyInsert = json["api_court_replyInsert"] as! String
            URL.api_location_geocode = json["api_location_geocode"] as! String
            URL.api_location_user = json["api_location_user"] as! String
            URL.api_user_join = json["api_user_join"] as! String
            URL.api_user_login = json["api_user_login"] as! String
            URL.api_user_logout = json["api_user_logout"] as! String
            URL.api_user_mypage = json["api_user_mypage"] as! String
            URL.api_user_set = json["api_user_set"] as! String
            URL.api_user_update = json["api_user_update"] as! String
            URL.api_user_info = json["api_user_info"] as! String
            
            self.setLoad()
        } catch _ as NSError {}
    }
    
    
    
    func setLoad(){
        //유저 객체
        user = Storage.getRealmUser()
        
        //버전체크 통신
        let parameters = URL.vesion_checkParam()
        URL.request(self, url: URL.apiServer+URL.api_version_check, param: parameters, callback: { (dic) in
            self.user = Storage.copyUser()
            self.user.token = dic["token"] as! String
            Util.newVersion = dic["ver"] as! String
            self.user.categoryVer = dic["categoryVer"] as! Int
            self.user.noticeVer = dic["noticeVer"] as! Int
            if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                Storage.setStorage("categoryList", value: categoryList as AnyObject)
            }
            Storage.setRealmUser(self.user)
        })
        
        
        //현재 나의 위치설정
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        courtSearchTextField.delegate = self
        
        //layout create
        blackScreen = UIButton()
        blackScreen.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        blackScreen.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        blackScreen.isHidden = true
        self.view.addSubview(blackScreen)
        
        //코트 검색
        courtSearchView = UIScrollView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width/3*2, height: self.adView.frame.height+self.mapView.frame.height))
        courtSearchView.backgroundColor = UIColor.white
        courtSearchView.isHidden = true
        self.view.addSubview(courtSearchView)
        
        
        
        //자기 위치 설정
        if let customView = Bundle.main.loadNibNamed("MainCenterView", owner: self, options: nil)?.first as? MainCenterView {
            locationView = customView
            locationView.frame = CGRect(x: (self.view.frame.width-300)/2, y: (self.view.frame.height-300)/2, width: 300, height: 300)
            locationView.backgroundColor = UIColor.white
            locationView.isHidden = true
            locationView.searchTextField.delegate = self
            self.view.addSubview(locationView)
            
            locationView.myLocationActionCallback = {(_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.locationView.alpha = 0
                    }, completion: { (_) in
                        self.locationView.isHidden = true
                        self.locationView.alpha = 1
                        self.blackScreen.isHidden = true
                        self.myLocationSearch = false
                        self.myLocationMove = true
                        if self.isMyLocation == false{
                            Util.alert(self, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
                        }else{
                            self.locationManager.startUpdatingLocation()
                        }
                })
            }
            
            
            locationView.searchActionCallback = {(_) in
                if self.locationView.searchTextField.text?.characters.count >= 2{
                    self.view.endEditing(true)
                    self.locationView.scrollView.subviews.forEach({$0.removeFromSuperview()})
                    //자기위치 검색 통신
                    let parameters : [String: AnyObject] = ["token": self.user.token as AnyObject, "address": self.locationView.searchTextField.text! as AnyObject, "language": Util.language as AnyObject]
                    URL.request(self, url: URL.apiServer+URL.api_location_geocode, param: parameters, callback: { (dic) in
                        if let result = dic["results"] as? [String: AnyObject]{
                            if let results = result["results"] as? [[String: AnyObject]]{
                                self.locationResults = results
                                self.locationSetLayout()
                            }
                        }
                    })
                }else{
                    Util.alert(self, message: "검색어는 2글자 이상으로 넣어주세요.")
                }
            }
        }
        
        
        self.rotated()
        
        
        let location = setMapLocation(user.latitude, longitude: user.longitude)
        initMarket(location)
        
        
        //맵뷰 터치했을때 이벤트
        self.mapView.isUserInteractionEnabled = true
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.mapViewTouch(_:))))
        
        //블랙스크린 클릭
        blackScreen.addTarget(self, action: #selector(self.blackScreenAction), for: .touchUpInside)
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.01)
            DispatchQueue.main.async {
                if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
                    self.isRotated = true
                    self.mapView.frame = CGRect(x: 0, y: 140, width: self.view.frame.width, height: self.view.frame.height - 140)
                    self.courtSearchView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width/3*2, height: self.adView.frame.height+self.mapView.frame.height)
                }
                if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
                    self.isRotated = false
                    self.mapView.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height - 120)
                    self.courtSearchView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width/3*2, height: self.adView.frame.height+self.mapView.frame.height)
                }
            }
        }
    }
    
    func locationSetLayout(){
        var i : CGFloat = 0
        let locObjHeight : CGFloat = 80
        self.locationView.scrollView.subviews.forEach({$0.removeFromSuperview()})
        for element : [String: AnyObject] in self.locationResults{
            let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
            
            if let customView = Bundle.main.loadNibNamed("MainCenterElementView", owner: self, options: nil)?.first as? MainCenterElementView {
                customView.frame = CGRect(x: 5, y: locObjHeight*i+5, width: self.locationView.frame.width-10, height: locObjHeight-10)
                customView.setAddr(addressShort: addressShort, address: address)
                self.locationView.scrollView.addSubview(customView)
                customView.setAction({ (_) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.locationView.alpha = 0
                        }, completion: { (_) in
                            self.locationView.isHidden = true
                            self.locationView.alpha = 1
                            self.blackScreen.isHidden = true
                            let user = Storage.copyUser()
                            user.latitude = latitude
                            user.longitude = longitude
                            user.address = "\(address)"
                            user.addressShort = "\(addressShort)"
                            Storage.setRealmUser(user)
                            self.myLocationSearch = true
                            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                            self.mapView.region = region
                            self.marker.coordinate = location
                            self.locationView.searchTextField.text = ""
                    })
                })
            }
            i += 1
        }
        self.locationView.scrollView.contentSize.height = locObjHeight*i+30
    }
    
    
    func blackScreenAction(){
        if self.locationView.isHidden == false{
            let tmpRect = self.locationView.frame
            //애니메이션 적용
            UIView.animate(withDuration: 0.2, animations: {
                self.locationView.frame.origin.y = -tmpRect.height
                }, completion: {(_) in
                    self.blackScreen.isHidden = true
                    self.locationView.isHidden = true
                    self.locationView.frame = tmpRect
            })
        }
    }
    
    
    var tempCourtData: [[String:AnyObject]]!
    @IBAction func courtSearchAction(_ sender: AnyObject) {
        if courtSearchTextField.text?.characters.count >= 2{
            self.view.endEditing(true)
            courtSearchView.subviews.forEach({$0.removeFromSuperview()})
            courtSearchView.scrollToTop()
            //코트 검색 통신
            
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "address": courtSearchTextField.text! as AnyObject, "category": user.category as AnyObject, "latitude": user.latitude as AnyObject, "longitude": user.longitude as AnyObject]
            URL.request(self, url: URL.apiServer+URL.api_court_listSearch, param: parameters, callback: { (dic) in
                if let list = dic["list"] as? [[String: AnyObject]]{
                    self.tempCourtData = list
                    self.setCourtLayout()
                }
            })
        }else{
            Util.alert(self, message: "검색어는 2글자 이상으로 넣어주세요.")
        }
    }
    //코트 실제 레이아웃만듬
    func setCourtLayout(){
        self.view.endEditing(true)
        courtSearchView.subviews.forEach({$0.removeFromSuperview()})
        var i : CGFloat = 0
        let locObjHeight : CGFloat = 90
        for obj in self.tempCourtData{
            let titleStr = "\(obj["cname"]!) (\(obj["categoryName"]!) / \(obj["addressShort"]!))"
            let descStr = "\(obj["description"]!)"
            if let customView = Bundle.main.loadNibNamed("MainCourtSearchElementView", owner: self, options: nil)?.first as? MainCourtSearchElementView {
                customView.frame = CGRect(x: 0, y: locObjHeight*i, width: self.courtSearchView.frame.width, height: locObjHeight-1)
                customView.setLbl(title: titleStr, desc: descStr)
                if self.view.frame.width > self.view.frame.height{
                    customView.setImage(obj["image"]! as! String, height: locObjHeight-1, isCenter: true)
                }else{
                    customView.setImage(obj["image"]! as! String, height: locObjHeight-1)
                }
                
                _ = customView.layer()
                self.courtSearchView.addSubview(customView)
                customView.setAction({ (_) in
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let uvc = storyBoard.instantiateViewController(withIdentifier: "courtVC")
                    (uvc as! CourtViewController).courtSeq = obj["seq"] as! Int
                    self.navigationController?.pushViewController(uvc, animated: true)
                })
                customView.setSimplemapAction({ (_) in
                    let sname : String = "내위치".queryValue()
                    let sx : Double = (self.locationManager.location?.coordinate.latitude)!
                    let sy : Double = (self.locationManager.location?.coordinate.longitude)!
                    let ename : String = "\(obj["addressShort"]!)".queryValue()
                    let ex : Double = obj["latitude"] as! Double
                    let ey : Double = obj["longitude"] as! Double
                    let simplemapUrl = "https://m.map.naver.com/route.nhn?menu=route&sname=\(sname)&sx=\(sx)&sy=\(sy)&ename=\(ename)&ex=\(ex)&ey=\(ey)&pathType=1&showMap=true"
                    if let url = Foundation.URL(string: simplemapUrl){
                        if UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:])
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }
                })
            }
            i += 1
        }
        self.courtSearchView.contentSize.height = locObjHeight*i+i+50
        if self.courtSearchView.isHidden != false{
            let tmpRect = self.courtSearchView.frame
            self.courtSearchView.frame.origin.x = -tmpRect.width
            self.courtSearchView.isHidden = false
            //애니메이션 적용
            UIView.animate(withDuration: 0.2, animations: {
                self.courtSearchView.frame = tmpRect
                }, completion: {(_) in
            })
        }
    }
    
    @IBAction func locationSearchAction(_ sender: AnyObject) {
        locationView.scrollView.subviews.forEach({$0.removeFromSuperview()})
        locationView.scrollView.scrollToTop()
        blackScreen.isHidden = false
        locationView.isHidden = false
        courtSearchView.isHidden = true
        
        let tmpRect = locationView.frame
        locationView.frame.origin.y = -tmpRect.height
        //애니메이션 적용
        UIView.animate(withDuration: 0.3, animations: {
            self.locationView.frame = tmpRect
            }, completion: nil)
    }
    
    //mapView init
    func initMarket(_ location : CLLocationCoordinate2D){
        self.marker = MKPointAnnotation()
        mapView.addAnnotation(self.marker)
        markerMove(location)
    }
    //marker 위치 이동
    func markerMove(_ location : CLLocationCoordinate2D){
        self.marker.coordinate = location
    }
    //mapView 위치 이동
    func setMapLocation(_ latitude: Double, longitude: Double, mapViewRegion : Bool = true) -> CLLocationCoordinate2D{
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        if mapViewRegion == true{
            mapView.setRegion(region, animated: true)
        }
        return location
    }
    //맵뷰 터치
    func mapViewTouch(_ sender: AnyObject){
        self.view.endEditing(true)
        
        let tmpRect = courtSearchView.frame
        //애니메이션 적용
        UIView.animate(withDuration: 0.2, animations: {
            self.courtSearchView.frame.origin.x = -tmpRect.width
            }, completion: { (_) in
                self.courtSearchView.frame = tmpRect
                self.courtSearchView.isHidden = true
                self.courtSearchView.subviews.forEach({$0.removeFromSuperview()})
                self.courtSearchView.scrollToTop()
        })
    }
    //현재 나의위치 가져오기 실패함
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isMyLocation = false
        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil{
            print("It's an iOS Simulator")
        }else{
            print("It's a device")
            Util.alert(self, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
        }
    }
    
    
    //현재 나의 위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isMyLocation = true
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        Storage.latitude = locValue.latitude
        Storage.longitude = locValue.longitude
        
        if isFirstLocation == true{
            isFirstLocation = false
            Storage.locationThread(self)
        }
        
        if myLocationSearch == false{
            user = Storage.copyUser()
            user.latitude = locValue.latitude
            user.longitude = locValue.longitude
            Storage.setRealmUser(user)
            let appDelegateLocationMove = (UIApplication.shared.delegate as! AppDelegate).vcMyLocationMove
            
            if myLocationMove == true || appDelegateLocationMove == true{
                myLocationMove = false
                (UIApplication.shared.delegate as! AppDelegate).vcMyLocationMove = false
                let location = setMapLocation(user.latitude, longitude: user.longitude)
                markerMove(location)
            }else{
                let location = setMapLocation(user.latitude, longitude: user.longitude, mapViewRegion: false)
                markerMove(location)
            }
        }
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
