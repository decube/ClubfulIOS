//
//  ViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import ActionKit
import Darwin
import MapKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    //user 저장소
    var user : User!
    //현재위치 manager
    let locationManager = CLLocationManager()
    //MapView
    @IBOutlet var mapView: MKMapView!
    //마커
    var marker : MKPointAnnotation!
    //blackScreen
    var blackScreen : UIButton!
    //leftScrollView
    var leftCourtView : UIScrollView!
    //centerLocationView
    var centerLocView : UIView!
    //centerLocationScroll
    var centerLocScroll : UIScrollView!
    //네비뷰
    var navView : UIView!
    //코트 검색 필드
    @IBOutlet var courtSearchField: UITextField!
    //코트 등록 버튼
    @IBOutlet var courtInsertBtn: UIButton!
    
    //카테고리 선택 버튼
    @IBOutlet var categoryBtn: UIButton!
    
    //로그인/로그아웃변수
    var logLbl : UILabel!
    
    
    //내위치 표시 변수
    var myLocationMove = true
    //현재 내위치 검색
    var myLocationSearch = false
    //위치가져왔는지 못가져왔는지
    var isMyLocation = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController viewDidLoad")
        
        var request : NSMutableURLRequest
        let apiUrl = NSURL(string: URL.urlCheck)
        request = NSMutableURLRequest(URL: apiUrl!)
        request.HTTPMethod = "GET"
        var data = NSData()
        let semaphore = dispatch_semaphore_create(0)
        NSURLSession.sharedSession().dataTaskWithRequest(request){(responseData,_,_) -> Void in
            if responseData != nil{
                data = responseData!
            }
            dispatch_semaphore_signal(semaphore)
            }.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String: AnyObject]
            URL.appServer = json["appServer"] as! String
            URL.imageServer = json["imageServer"] as! String
            URL.courtUpload = json["courtUpload"] as! String
            self.setLoad()
        } catch _ as NSError {}
    }
    
    
    
    func setLoad(){
        user = Storage.getRealmUser()
        let parameters : [String: AnyObject] = ["appType": "ios", "appVersion": Util.nsVersion, "deviceCD": NSDate().getFullDate(), "language": Util.language, "deviceId": Util.deviceId, "token": user.token, "categoryVer": user.categoryVer, "noticeVer": user.noticeVer]
        Alamofire.request(.GET, URL.version_Check, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        self.user = Storage.copyUser()
                        self.user.token = dic["token"] as! String
                        Util.newVersion = dic["iosVersion"] as! String
                        self.user.categoryVer = dic["categoryVer"] as! Int
                        self.user.noticeVer = dic["noticeVer"] as! Int
                        if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                            Storage.setStorage("categoryList", value: categoryList)
                        }
                        Storage.setRealmUser(self.user)
                    }else{
                        if let isMsgView = dic["isMsgView"] as? Bool{
                            if isMsgView == true{
                                Util.alert(message: "\(dic["msg"]!)", ctrl: self)
                            }
                        }
                    }
                }
        }
        
        
        
        
        
        //현재 나의 위치설정
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        courtSearchField.delegate = self
        
        
        
        
        
        //layout create
        categoryBtn.setTitle(user.categoryName, forState: .Normal)
        categoryBtn.boxLayout(borderWidth: 1, borderColor: UIColor.blackColor())
        blackScreen = UIButton().blackScreen()
        leftCourtView = UIScrollView(frame: CGRect(x: 0, y: 80, width: Util.screenSize.width/3*2, height: Util.screenSize.height-80-self.courtInsertBtn.frame.height), backgroundColor: UIColor.whiteColor())
        centerLocView = UIView(frame: CGRect(x: (Util.screenSize.width-300)/2, y: (Util.screenSize.height-300)/2, width: 300, height: 300), backgroundColor: UIColor.whiteColor())
        navView = UIView(frame: CGRect(x: Util.screenSize.width/5*2, y: 20, width: Util.screenSize.width/5*3, height: Util.screenSize.height-20))
        
        leftCourtView.hidden = true
        centerLocView.hidden = true
        
        self.view.addSubview(blackScreen)
        self.view.addSubview(leftCourtView)
        self.view.addSubview(centerLocView)
        self.view.addSubview(navView)
        
        
        
        
        
        //navView layout
        navLayout()
        
        
        
        
        //centerView layout
        let centerLocHeader = UIView(frame: CGRect(x: 0, y: 0, width: centerLocView.frame.width, height: 60), backgroundColor: Util.commonColor)
        let centerLocHeaderField = UITextField(frame: CGRect(x: 5, y: 10, width: centerLocHeader.frame.width-130, height: 40), placeholder: "현재 위치를 검색하세요.", placeholderColor: UIColor.blackColor(), textAlignment: .Left, delegate: self, fontSize: 15)
        let centerLocHeaderMyLocBtn = UIButton(frame: CGRect(x: centerLocHeader.frame.width-110, y: 10, width: 40, height: 40), image: UIImage(named: "ic_myLocation.png")!)
        let centerLocHeaderBtn = UIButton(frame: CGRect(x: centerLocHeader.frame.width-55, y: 10, width: 50, height: 40), text: "검색", fontSize: 13)
        centerLocScroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: centerLocView.frame.width, height: centerLocView.frame.height-60), backgroundColor: UIColor.whiteColor())
        
        centerLocHeaderBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.grayColor(), borderColor: UIColor.blackColor())
        centerLocHeaderField.returnKeyType = UIReturnKeyType.Done
        
        centerLocView.boxLayout(radius: 12)
        centerLocHeader.boxLayout(radius: 12)
        centerLocScroll.boxLayout(radius: 12)
        centerLocView.addSubview(centerLocHeader)
        centerLocHeader.addSubview(centerLocHeaderField)
        centerLocHeader.addSubview(centerLocHeaderMyLocBtn)
        centerLocHeader.addSubview(centerLocHeaderBtn)
        centerLocView.addSubview(centerLocScroll)
        
        
        
        
        
        let location = setMapLocation(user.latitude, longitude: user.longitude)
        initMarket(location)
        
        
        //맵뷰 터치했을때 이벤트
        self.mapView.userInteractionEnabled = true
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.mapViewTouch(_:))))
        
        
        //delegete 앱이 살아났을때??
        let window = UIApplication.sharedApplication().windows[0] as UIWindow;
        UIView.transitionFromView(
            window.rootViewController!.view,
            toView: self.view,
            duration: 0.65,
            options: .TransitionCrossDissolve,
            completion: {
                finished in window.rootViewController = self
        })
        
        
        
        
        
        //event
        
        
        
        //자기위치 가져오기
        centerLocHeaderMyLocBtn.addControlEvent(.TouchUpInside){
            self.blackScreen.hidden = true
            self.centerLocView.hidden = true
            self.myLocationSearch = false
            self.myLocationMove = true
            if self.isMyLocation == false{
                Util.alert(message: "설정-오양고에 들어가셔서 위치 항상을 눌려주세요.", ctrl: self)
            }else{
                self.locationManager.startUpdatingLocation()
            }
        }
        
        
        
        //검색어 기반 검색하기
        centerLocHeaderBtn.addControlEvent(.TouchUpInside){
            if centerLocHeaderField.text?.characters.count >= 2{
                self.view.endEditing(true)
                self.centerLocScroll.subviews.forEach({$0.removeFromSuperview()})
                //자기위치 검색 통신
                var i : CGFloat = 0
                let locObjHeight : CGFloat = 80
                
                let parameters : [String: AnyObject] = ["token": self.user.token, "address": centerLocHeaderField.text!, "language": Util.language]
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
                                            
                                            let objBtn = UIButton(frame: CGRect(x: 0, y: locObjHeight*i, width: self.centerLocScroll.frame.width, height: locObjHeight-1))
                                            let addressShortLbl = UILabel(frame: CGRect(x: 5, y: 10, width: objBtn.frame.width-5, height: 15), text: "\(elementAddressShort)", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
                                            let addressLbl = UILabel(frame: CGRect(x: 5, y: 25, width: objBtn.frame.width-5, height: 65), text: "\(elementAddress)", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 13)
                                            addressLbl.numberOfLines = 2
                                            objBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
                                            self.centerLocScroll.addSubview(objBtn)
                                            objBtn.addSubview(addressShortLbl)
                                            objBtn.addSubview(addressLbl)
                                            
                                            objBtn.addControlEvent(.TouchUpInside){
                                                self.blackScreen.hidden = true
                                                self.centerLocView.hidden = true
                                                let user = Storage.copyUser()
                                                user.latitude = elementLatitude
                                                user.longitude = elementLongitude
                                                user.address = "\(elementAddress)"
                                                user.addressShort = "\(elementAddressShort)"
                                                Storage.setRealmUser(user)
                                                self.myLocationSearch = true
                                                let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                                                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(elementLatitude, elementLongitude)
                                                let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                                                self.mapView.region = region
                                                self.marker.coordinate = location
                                                centerLocHeaderField.text = ""
                                            }
                                            i += 1
                                        }
                                        self.centerLocScroll.contentSize = CGSize(width: self.centerLocScroll.frame.width, height: locObjHeight*i)
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
            }else{
                Util.alert(message: "검색어는 2글자 이상으로 넣어주세요.", ctrl: self)
            }
        }
        
        
        //블랙스크린 클릭
        blackScreen.addControlEvent(.TouchUpInside){
            if self.leftCourtView.hidden == false{
                self.leftCourtView.hidden = true
                self.blackScreen.hidden = true
            }
            if self.centerLocView.hidden == false{
                let tmpRect1 = self.centerLocView.frame
                //애니메이션 적용
                UIView.animateWithDuration(0.2, animations: {
                    self.centerLocView.frame = CGRect(x: tmpRect1.origin.x, y: -tmpRect1.height, width: tmpRect1.width, height: tmpRect1.height)
                    }, completion: {(_) in
                        self.blackScreen.hidden = true
                        self.centerLocView.hidden = true
                        self.centerLocView.frame = tmpRect1
                })
            }
            if self.navView.hidden == false{
                let tmpRect1 = self.navView.frame
                //애니메이션 적용
                UIView.animateWithDuration(0.2, animations: {
                    self.navView.frame = CGRect(x: Util.screenSize.width, y: tmpRect1.origin.y, width: tmpRect1.width, height: tmpRect1.height)
                    }, completion: {(_) in
                        self.blackScreen.hidden = true
                        self.navView.hidden = true
                        self.navView.frame = tmpRect1
                })
            }
            
        }
    }
    
    
    
    
    //맵뷰 터치
    func mapViewTouch(sender: AnyObject){
        self.view.endEditing(true)
        leftCourtView.subviews.forEach({$0.removeFromSuperview()})
        leftCourtView.scrollToTop()
        leftCourtView.hidden = true
    }
    
    //mapView init
    func initMarket(location : CLLocationCoordinate2D){
        self.marker = MKPointAnnotation()
        mapView.addAnnotation(self.marker)
        markerMove(location)
    }
    
    //mapView 위치 이동
    func setMapLocation(latitude: Double, longitude: Double, mapViewRegion : Bool = true) -> CLLocationCoordinate2D{
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        if mapViewRegion == true{
            mapView.setRegion(region, animated: true)
        }
        return location
    }
    
    //marker 위치 이동
    func markerMove(location : CLLocationCoordinate2D){
        self.marker.coordinate = location
    }
    
    
    //왼쪽이미지 클릭
    @IBAction func myLocationAction(sender: AnyObject) {
        centerLocScroll.subviews.forEach({$0.removeFromSuperview()})
        centerLocScroll.scrollToTop()
        blackScreen.hidden = false
        centerLocView.hidden = false
        leftCourtView.hidden = true
        
        let tmpRect1 = centerLocView.frame
        centerLocView.frame = CGRect(x: tmpRect1.origin.x, y: -tmpRect1.height, width: tmpRect1.width, height: tmpRect1.height)
        //애니메이션 적용
        UIView.animateWithDuration(0.3, animations: {
            self.centerLocView.frame = CGRect(x: tmpRect1.origin.x, y: tmpRect1.origin.y, width: tmpRect1.width, height: tmpRect1.height)
            }, completion: nil)
    }
    
    //검색 클릭
    @IBAction func courtSearchAction(sender: AnyObject) {
        if courtSearchField.text?.characters.count >= 2{
            self.view.endEditing(true)
            leftCourtView.subviews.forEach({$0.removeFromSuperview()})
            leftCourtView.scrollToTop()
            //코트 검색 통신
            var i : CGFloat = 0
            let locObjHeight : CGFloat = 90
            let parameters : [String: AnyObject] = ["token": user.token, "address": courtSearchField.text!, "category": user.category, "latitude": user.latitude, "longitude": user.longitude]
            Alamofire.request(.GET, URL.court_listSearch, parameters: parameters)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    let data : NSData = response.data!
                    let dic = Util.convertStringToDictionary(data)
                    if let code = dic["code"] as? Int{
                        if code == 0{
                            if let list = dic["list"] as? [[String: AnyObject]]{
                                for obj in list{
                                    let objBtn = UIButton(frame: CGRect(x: 0, y: locObjHeight*i, width: self.leftCourtView.frame.width, height: locObjHeight-1))
                                    
                                    let infoStr = "\(obj["cname"]!) (\(obj["categoryName"]!) / \(obj["addressShort"]!))"
                                    
                                    let infoLbl = UILabel(frame: CGRect(x: 5, y: 3, width: objBtn.frame.width-5, height: 42), text: infoStr, color: UIColor.blackColor(), textAlignment: .Left, fontSize: 15)
                                    let descLbl = UILabel(frame: CGRect(x: 15, y: 45, width: objBtn.frame.width-20, height: 45), text: "\(obj["description"]!)", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 13)
                                    
                                    infoLbl.numberOfLines = 2
                                    descLbl.numberOfLines = 2
                                    descLbl.textColor = UIColor(red:0.34, green:0.33, blue:0.31, alpha:1.00)
                                    
                                    objBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor(red:0.94, green:0.96, blue:0.97, alpha:1.00))
                                    self.leftCourtView.addSubview(objBtn)
                                    objBtn.addSubview(infoLbl)
                                    objBtn.addSubview(descLbl)
                                    
                                    objBtn.addControlEvent(.TouchUpInside){
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                                        let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtVC")
                                        (uvc as! CourtViewController).courtSeq = obj["seq"] as! Int
                                        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                                        self.presentViewController(uvc, animated: true, completion: nil)
                                    }
                                    i += 1
                                }
                                self.leftCourtView.contentSize = CGSize(width: self.leftCourtView.frame.width, height: locObjHeight*i)
                                self.leftCourtView.hidden = false
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
        }else{
            Util.alert(message: "검색어는 2글자 이상으로 넣어주세요.", ctrl: self)
        }
    }
    
    
    
    
    //네비 클릭
    @IBAction func navAction(sender: AnyObject) {
        blackScreen.hidden = false
        leftCourtView.hidden = true
        navView.hidden = false
        
        let tmpRect1 = navView.frame
        navView.frame = CGRect(x: Util.screenSize.width, y: tmpRect1.origin.y, width: tmpRect1.width, height: tmpRect1.height)
        
        //애니메이션 적용
        UIView.animateWithDuration(0.2, animations: {
            self.navView.frame = CGRect(x: tmpRect1.origin.x, y: tmpRect1.origin.y, width: tmpRect1.width, height: tmpRect1.height)
            }, completion: nil)
    }
    
    //카테고리 클릭
    @IBAction func categoryAction(sender: AnyObject) {
        let alert = UIAlertController(title: "카테고리를 선택해주세요", message: "", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "전체", style: .Default, handler: { (alert) in
            self.categoryBtn.setTitle(alert.title, forState: .Normal)
            self.user = Storage.copyUser()
            self.user.category = -1
            self.user.categoryName = alert.title!
            Storage.setRealmUser(self.user)
        }))
        let categoryList = Storage.getStorage("categoryList") as! [[String: AnyObject]]
        for category in categoryList{
            alert.addAction(UIAlertAction(title: "\(category["name"]!)", style: .Default, handler: { (alert) in
                self.categoryBtn.setTitle(alert.title, forState: .Normal)
                self.user = Storage.copyUser()
                self.user.category = category["seq"] as! Int
                self.user.categoryName = alert.title!
                Storage.setRealmUser(self.user)
            }))
        }
        self.presentViewController(alert, animated: false, completion: {(_) in})
        
    }
    
    //코트등록 클릭
    @IBAction func courtInsertAction(sender: AnyObject) {
        if user.isLogin == -1{
            Util.alert(message: "로그인을 하셔야 이용 가능합니다.", ctrl: self)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtCreateVC")
            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(uvc, animated: true, completion: nil)
        }
    }
    
    //현재 나의 위치
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isMyLocation = true
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        if myLocationSearch == false{
            user = Storage.copyUser()
            user.latitude = locValue.latitude
            user.longitude = locValue.longitude
            Storage.setRealmUser(user)
            let appDelegateLocationMove = (UIApplication.sharedApplication().delegate as! AppDelegate).vcMyLocationMove
            
            if myLocationMove == true || appDelegateLocationMove == true{
                myLocationMove = false
                (UIApplication.sharedApplication().delegate as! AppDelegate).vcMyLocationMove = false
                let location = setMapLocation(user.latitude, longitude: user.longitude)
                markerMove(location)
            }else{
                let location = setMapLocation(user.latitude, longitude: user.longitude, mapViewRegion: false)
                markerMove(location)
            }
        }
    }
    
    
    
    //현재 나의위치 가져오기 실패함
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        isMyLocation = false
        if NSProcessInfo.processInfo().environment["SIMULATOR_DEVICE_NAME"] != nil{
            print("It's an iOS Simulator")
        }else{
            print("It's a device")
            Util.alert(message: "설정-오양고에 들어가셔서 위치 항상을 눌려주세요.", ctrl: self)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    //login after init
    func loginInit(){
        self.logLbl.text = "로그아웃"
        self.blackScreen.hidden = true
        self.navView.hidden = true
        user = Storage.getRealmUser()
    }
    
    
    
    
    
    
    
    
    
    //////////navLayout
    func navLayout(){
        navView.backgroundColor = UIColor.whiteColor()
        navView.hidden = true
        
        let logView = UIView(frame: CGRect(x: 0, y: 0, width: navView.frame.width, height: 40))
        let logBtn = UIButton(frame: CGRect(x: 0, y: 0, width: logView.frame.width-60, height: logView.frame.height))
        let settingBtn = UIButton(frame: CGRect(x: logView.frame.width-40, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_setting.png")!)
        let mypageBtn = UIButton(frame: CGRect(x: 0, y: 41, width: navView.frame.width, height: 40))
        let messageBtn = UIButton(frame: CGRect(x: 0, y: 90, width: navView.frame.width, height: 40))
        let friendBtn = UIButton(frame: CGRect(x: 0, y:140, width: navView.frame.width, height: 40))
        let noticeBtn = UIButton(frame: CGRect(x: 0, y: 181, width: navView.frame.width, height: 40))
        let appInfoBtn = UIButton(frame: CGRect(x: 0, y: 230, width: navView.frame.width, height: 40))
        let guideBtn = UIButton(frame: CGRect(x: 0, y: 280, width: navView.frame.width, height: 40))
        let inquiryBtn = UIButton(frame: CGRect(x: 0, y: 330, width: navView.frame.width, height: 40))
        let courtInsertBtn = UIButton(frame: CGRect(x: 10, y: navView.frame.height-50, width: navView.frame.width-20, height: 40), text: "코트등록", color: UIColor.whiteColor(), fontSize: 17)
        
        let mainView = UIImageView(frame: CGRect(x: 5, y: 2.5, width: 35, height: 35), image: UIImage(named: "ic_navi_main.png")!)
        let mypageImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_mypage.png")!)
        let messageImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_message.png")!)
        let friendImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_friend.png")!)
        let noticeImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_notice.png")!)
        let appInfoImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_appInfo.png")!)
        let guideImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_guide.png")!)
        let inquiryImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_inquiry.png")!)
        
        var loginStr = "로그아웃"
        if user.isLogin == -1{
            loginStr = "로그인"
        }
        
        logLbl = UILabel(frame: CGRect(x: 50, y: 0, width: logBtn.frame.width-50, height: logBtn.frame.height), text: loginStr, color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        let mypageLbl = UILabel(frame: CGRect(x: 50, y: 0, width: mypageBtn.frame.width-50, height: mypageBtn.frame.height), text: "내정보", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        let messageLbl = UILabel(frame: CGRect(x: 50, y: 0, width: messageBtn.frame.width-50, height: messageBtn.frame.height), text: "쪽지함", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        let friendLbl = UILabel(frame: CGRect(x: 50, y: 0, width: friendBtn.frame.width-50, height: friendBtn.frame.height), text: "친구초대", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        let noticeLbl = UILabel(frame: CGRect(x: 50, y: 0, width: noticeBtn.frame.width-50, height: noticeBtn.frame.height), text: "공지사항", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        let appInfoLbl = UILabel(frame: CGRect(x: 50, y: 0, width: appInfoBtn.frame.width-50, height: appInfoBtn.frame.height), text: "앱정보", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        let guideLbl = UILabel(frame: CGRect(x: 50, y: 0, width: guideBtn.frame.width-50, height: guideBtn.frame.height), text: "가이드", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        let inquiryLbl = UILabel(frame: CGRect(x: 50, y: 0, width: inquiryBtn.frame.width-50, height: inquiryBtn.frame.height), text: "문의하기", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
        
        logView.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
        friendBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
        courtInsertBtn.boxLayout(radius: 6, backgroundColor: UIColor.blackColor())
        
        navView.addSubview(logView)
        navView.addSubview(settingBtn)
        navView.addSubview(mypageBtn)
        navView.addSubview(messageBtn)
        navView.addSubview(friendBtn)
        navView.addSubview(noticeBtn)
        navView.addSubview(appInfoBtn)
        navView.addSubview(guideBtn)
        navView.addSubview(inquiryBtn)
        navView.addSubview(courtInsertBtn)
        
        logView.addSubview(logBtn)
        logView.addSubview(settingBtn)
        
        logBtn.addSubview(mainView)
        mypageBtn.addSubview(mypageImg)
        messageBtn.addSubview(messageImg)
        friendBtn.addSubview(friendImg)
        noticeBtn.addSubview(noticeImg)
        appInfoBtn.addSubview(appInfoImg)
        guideBtn.addSubview(guideImg)
        inquiryBtn.addSubview(inquiryImg)
        
        logBtn.addSubview(logLbl)
        mypageBtn.addSubview(mypageLbl)
        messageBtn.addSubview(messageLbl)
        friendBtn.addSubview(friendLbl)
        noticeBtn.addSubview(noticeLbl)
        appInfoBtn.addSubview(appInfoLbl)
        guideBtn.addSubview(guideLbl)
        inquiryBtn.addSubview(inquiryLbl)
        
        func storyBoard(destination : String){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let uvc = storyBoard.instantiateViewControllerWithIdentifier(destination)
            if uvc.classForCoder != self.classForCoder{
                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.presentViewController(uvc, animated: true, completion: nil)
            }
        }
        
        logBtn.addControlEvent(.TouchUpInside){
            func logout(){
                let parameters : [String: AnyObject] = ["token": self.user.token, "userId": self.user.userId]
                Alamofire.request(.GET, URL.user_logout, parameters: parameters)
                    .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .responseData { response in
                }
                self.user = Storage.copyUser()
                self.user.isLogin = -1
                self.user.nickName = ""
                self.user.sex = ""
                self.user.token = ""
                self.user.birth = NSDate()
                self.user.userLatitude = 0.0
                self.user.userLongitude = 0.0
                self.user.userAddress = ""
                self.user.userAddressShort = ""
                Storage.setRealmUser(self.user)
                self.logLbl.text = "로그인"
                self.blackScreen.hidden = true
                self.navView.hidden = true
            }
            if self.user.isLogin == -1{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let uvc = storyBoard.instantiateViewControllerWithIdentifier("loginVC")
                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                (uvc as! LoginViewController).mainViewController = self
                self.presentViewController(uvc, animated: true, completion: nil)
            }else{
                if self.user.isLogin == 1{
                    Util.alert("로그아웃", message: "로그아웃 하시겠습니까?", confirmTitle: "확인", ctrl: self, cancelStr: "취소", confirmHandler: {(_) in
                        logout()
                    })
                }else if self.user.isLogin == 2{
                    Util.alert("로그아웃", message: "카카오톡로그아웃 하시겠습니까?", confirmTitle: "확인", ctrl: self, cancelStr: "취소", confirmHandler: {(_) in
                        logout()
                    })
                }
            }
        }
        settingBtn.addControlEvent(.TouchUpInside){
            storyBoard("settingVC")
        }
        mypageBtn.addControlEvent(.TouchUpInside){
            if self.user.isLogin == -1{
                Util.alert(message: "로그인을 하셔야 이용 가능합니다.", ctrl: self)
            }else{
                storyBoard("mypageVC")
            }
        }
        
        
        func dummyLinkObject() -> [KakaoTalkLinkObject] {
            let image = KakaoTalkLinkObject.createImage("https://developers.kakao.com/assets/img/link_sample.jpg", width: 138, height: 80)
            let androidAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.Android, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: [:])
            let iphoneAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: [:])
            let ipadAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Pad, execparam: [:])
            let appLink = KakaoTalkLinkObject.createAppButton("앱 열기", actions: [androidAppAction, iphoneAppAction, ipadAppAction])
            return [image, appLink]
        }
        messageBtn.addControlEvent(.TouchUpInside){
            if self.user.isLogin == -1{
                Util.alert(message: "로그인을 하셔야 이용 가능합니다.", ctrl: self)
            }else{
                storyBoard("memoVC")
            }
        }
        friendBtn.addControlEvent(.TouchUpInside){
            if KOAppCall.canOpenKakaoTalkAppLink() {
                KOAppCall.openKakaoTalkAppLink(dummyLinkObject())
            } else {
                print("Cannot open kakaotalk.")
            }
        }
        noticeBtn.addControlEvent(.TouchUpInside){
            storyBoard("noticeVC")
        }
        appInfoBtn.addControlEvent(.TouchUpInside){
            storyBoard("appVersionVC")
        }
        guideBtn.addControlEvent(.TouchUpInside){
            storyBoard("appGuideVC")
        }
        inquiryBtn.addControlEvent(.TouchUpInside){
            storyBoard("inquiryVC")
        }
        courtInsertBtn.addControlEvent(.TouchUpInside){
            if self.user.isLogin == -1{
                Util.alert(message: "로그인을 하셔야 이용 가능합니다.", ctrl: self)
            }else{
                storyBoard("courtCreateVC")
            }
        }
    }
}

