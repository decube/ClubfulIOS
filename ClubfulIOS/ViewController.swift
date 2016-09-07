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
    var courtSearchView : MainCourtSearchView!
    //위치찾기뷰
    var locationView : MainCenterView!
    //위치찾기스크롤
    var locationScrollView : UIScrollView!
    
    
    //코트 검색 텍스트필드
    @IBOutlet var courtSearchTextField: UITextField!
    
    var mainScreen : UIView!
    var mainScreenWhite = true
    var mainScreenBoom = true
    var boomArray : [UIImageView]!
    
    
    
    typealias Task = (cancel : Bool) -> ()
    func delay(time:NSTimeInterval, task:()->()) ->  Task? {
        func dispatch_later(block:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        var closure: dispatch_block_t? = task
        var result: Task?
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        return result;
    }
    
    func customClick(sender: UIImageView){
        for item in boomArray {
            item.boom()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController viewDidLoad")
        
        
        if let customView = NSBundle.mainBundle().loadNibNamed("MainScreen", owner: self, options: nil).first as? MainScreen {
            mainScreen = customView
            customView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height-20)
            self.view.addSubview(customView)
            
            boomArray = [
                customView.image1,
                customView.image2,
                customView.image3,
                customView.image4,
                customView.image5,
                customView.image6,
                customView.image7,
                customView.image8
            ]
            
            mainScreen.userInteractionEnabled = true
            mainScreen.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.customClick(_:))))
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                while self.mainScreenWhite == true {
                    if self.mainScreenBoom{
                        let numberRandom = Int(arc4random_uniform(3) + 3)
                        var indexArray = [Int]()
                        var idxAdd = 0
                        while(idxAdd != numberRandom){
                            let random = Int(arc4random_uniform(8))
                            var isAdd = true
                            for idx in indexArray{
                                if idx == random{
                                    isAdd = false
                                }
                            }
                            if isAdd == true{
                                indexArray.append(random)
                                idxAdd += 1
                            }
                        }
                        self.delay(0, task: {
                            dispatch_async(dispatch_get_main_queue()) {
                                for start in indexArray{
                                    self.boomArray[start].boom()
                                }
                            }
                        })
                    }else{
                        dispatch_async(dispatch_get_main_queue()) {
                            for image in self.boomArray{
                                image.reset()
                            }
                        }
                    }
                    self.mainScreenBoom = !self.mainScreenBoom
                    sleep(1)
                }
            })
        }
        
        
        //GET Async 동기 통신
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
        //유저 객체
        user = Storage.getRealmUser()
        
        //버전체크 통신
        let parameters : [String: AnyObject] = ["appType": "ios", "appVersion": Util.nsVersion, "deviceCD": NSDate().getFullDate(), "language": Util.language, "deviceId": Util.deviceId, "token": user.token, "categoryVer": user.categoryVer, "noticeVer": user.noticeVer]
        URL.request(self, url: URL.version_Check, param: parameters, callback: { (dic) in
            self.user = Storage.copyUser()
            self.user.token = dic["token"] as! String
            Util.newVersion = dic["iosVersion"] as! String
            self.user.categoryVer = dic["categoryVer"] as! Int
            self.user.noticeVer = dic["noticeVer"] as! Int
            if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                Storage.setStorage("categoryList", value: categoryList)
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
        blackScreen.frame = CGRect(x: 0, y: 20, width: Util.screenSize.width, height: Util.screenSize.height)
        blackScreen.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        blackScreen.hidden = true
        self.view.addSubview(blackScreen)
        
        //코트 검색
        if let customView = NSBundle.mainBundle().loadNibNamed("MainCourtSearchView", owner: self, options: nil).first as? MainCourtSearchView {
            courtSearchView = customView
            courtSearchView.frame = CGRect(x: 0, y: adView.frame.origin.y, width: Util.screenSize.width/3*2, height: adView.frame.height+mapView.frame.height)
            courtSearchView.backgroundColor = UIColor.whiteColor()
            courtSearchView.hidden = true
            self.view.addSubview(courtSearchView)
        }
        
        
        //자기 위치 설정
        if let customView = NSBundle.mainBundle().loadNibNamed("MainCenterView", owner: self, options: nil).first as? MainCenterView {
            locationView = customView
            locationView.frame = CGRect(x: (Util.screenSize.width-300)/2, y: (Util.screenSize.height-300)/2, width: 300, height: 300)
            locationView.backgroundColor = UIColor.whiteColor()
            locationView.hidden = true
            locationView.searchTextField.delegate = self
            self.view.addSubview(locationView)
            
            locationView.myLocationActionCallback = {(_) in
                UIView.animateWithDuration(0.2, animations: {
                    self.locationView.alpha = 0
                }) { (_) in
                    self.locationView.hidden = true
                    self.locationView.alpha = 1
                    self.blackScreen.hidden = true
                    self.myLocationSearch = false
                    self.myLocationMove = true
                    if self.isMyLocation == false{
                        Util.alert(self, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
                    }else{
                        self.locationManager.startUpdatingLocation()
                    }
                }
            }
            
            
            locationView.searchActionCallback = {(_) in
                if self.locationView.searchTextField.text?.characters.count >= 2{
                    self.view.endEditing(true)
                    self.locationView.scrollView.subviews.forEach({$0.removeFromSuperview()})
                    //자기위치 검색 통신
                    var i : CGFloat = 0
                    let locObjHeight : CGFloat = 80
                    
                    let parameters : [String: AnyObject] = ["token": self.user.token, "address": self.locationView.searchTextField.text!, "language": Util.language]
                    URL.request(self, url: URL.location_geocode, param: parameters, callback: { (dic) in
                        if let result = dic["results"] as? [String: AnyObject]{
                            if let results = result["results"] as? [[String: AnyObject]]{
                                for element : [String: AnyObject] in results{
                                    let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
                                    
                                    if let customView = NSBundle.mainBundle().loadNibNamed("MainCenterElementView", owner: self, options: nil).first as? MainCenterElementView {
                                        customView.frame = CGRect(x: 5, y: locObjHeight*i+5, width: self.locationView.frame.width-10, height: locObjHeight-10)
                                        customView.setAddr(addressShort: addressShort, address: address)
                                        self.locationView.scrollView.addSubview(customView)
                                        customView.setAction({ (_) in
                                            UIView.animateWithDuration(0.2, animations: {
                                                self.locationView.alpha = 0
                                            }) { (_) in
                                                self.locationView.hidden = true
                                                self.locationView.alpha = 1
                                                self.blackScreen.hidden = true
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
                                            }
                                        })
                                    }
                                    i += 1
                                }
                                self.locationView.scrollView.contentSize.height = locObjHeight*i
                            }
                        }
                    })
                }else{
                    Util.alert(self, message: "검색어는 2글자 이상으로 넣어주세요.")
                }
            }
        }
        
        
        
        let location = setMapLocation(user.latitude, longitude: user.longitude)
        initMarket(location)

        
        //맵뷰 터치했을때 이벤트
        self.mapView.userInteractionEnabled = true
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.mapViewTouch(_:))))
        
        
        //블랙스크린 클릭
        blackScreen.addControlEvent(.TouchUpInside){
            if self.courtSearchView.hidden == false{
                
            }
            if self.locationView.hidden == false{
                let tmpRect = self.locationView.frame
                //애니메이션 적용
                UIView.animateWithDuration(0.2, animations: {
                    self.locationView.frame.origin.y = -tmpRect.height
                    }, completion: {(_) in
                        self.blackScreen.hidden = true
                        self.locationView.hidden = true
                        self.locationView.frame = tmpRect
                })
            }
        }
        
        
        //boom 종료
        self.mainScreenWhite = false
        mainScreen.hidden = true
    }
    
    @IBAction func courtSearchAction(sender: AnyObject) {
        if courtSearchTextField.text?.characters.count >= 2{
            self.view.endEditing(true)
            courtSearchView.scrollView.subviews.forEach({$0.removeFromSuperview()})
            courtSearchView.scrollView.scrollToTop()
            //코트 검색 통신
            var i : CGFloat = 0
            let locObjHeight : CGFloat = 90
            let parameters : [String: AnyObject] = ["token": user.token, "address": courtSearchTextField.text!, "category": user.category, "latitude": user.latitude, "longitude": user.longitude]
            URL.request(self, url: URL.court_listSearch, param: parameters, callback: { (dic) in
                if let list = dic["list"] as? [[String: AnyObject]]{
                    for obj in list{
                        let titleStr = "\(obj["cname"]!) (\(obj["categoryName"]!) / \(obj["addressShort"]!))"
                        let descStr = "\(obj["description"]!)"
                        if let customView = NSBundle.mainBundle().loadNibNamed("MainCourtSearchElementView", owner: self, options: nil).first as? MainCourtSearchElementView {
                            customView.frame = CGRect(x: 5, y: locObjHeight*i+5, width: self.courtSearchView.frame.width-10, height: locObjHeight-5)
                            customView.setLbl(title: titleStr, desc: descStr)
                            self.courtSearchView.scrollView.addSubview(customView)
                            customView.setAction({ (_) in
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                                let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtVC")
                                (uvc as! CourtViewController).courtSeq = obj["seq"] as! Int
                                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                                self.presentViewController(uvc, animated: true, completion: nil)
                            })
                            customView.setSimplemapAction({ (_) in
                                let sname : String = "내위치".queryValue()
                                let sx : Double = (self.locationManager.location?.coordinate.latitude)!
                                let sy : Double = (self.locationManager.location?.coordinate.longitude)!
                                let ename : String = "\(obj["addressShort"]!)".queryValue()
                                let ex : Double = obj["latitude"] as! Double
                                let ey : Double = obj["longitude"] as! Double
                                let simplemapUrl = "https://m.map.naver.com/route.nhn?menu=route&sname=\(sname)&sx=\(sx)&sy=\(sy)&ename=\(ename)&ex=\(ex)&ey=\(ey)&pathType=1&showMap=true"
                                if let url = NSURL(string: simplemapUrl){
                                    if UIApplication.sharedApplication().canOpenURL(url) {
                                        UIApplication.sharedApplication().openURL(url)
                                    }
                                }
                            })
                        }
                        i += 1
                    }
                    self.courtSearchView.scrollView.contentSize.height = locObjHeight*i
                    if self.courtSearchView.hidden != false{
                        let tmpRect = self.courtSearchView.frame
                        self.courtSearchView.frame.origin.x = -tmpRect.width
                        self.courtSearchView.hidden = false
                        //애니메이션 적용
                        UIView.animateWithDuration(0.2, animations: {
                            self.courtSearchView.frame = tmpRect
                            }, completion: {(_) in
                        })
                    }
                }
            })
        }else{
            Util.alert(self, message: "검색어는 2글자 이상으로 넣어주세요.")
        }
    }
    
    @IBAction func locationSearchAction(sender: AnyObject) {
        locationView.scrollView.subviews.forEach({$0.removeFromSuperview()})
        locationView.scrollView.scrollToTop()
        blackScreen.hidden = false
        locationView.hidden = false
        courtSearchView.hidden = true
        
        let tmpRect = locationView.frame
        locationView.frame.origin.y = -tmpRect.height
        //애니메이션 적용
        UIView.animateWithDuration(0.3, animations: {
            self.locationView.frame = tmpRect
            }, completion: nil)
    }
    
    //mapView init
    func initMarket(location : CLLocationCoordinate2D){
        self.marker = MKPointAnnotation()
        mapView.addAnnotation(self.marker)
        markerMove(location)
    }
    //marker 위치 이동
    func markerMove(location : CLLocationCoordinate2D){
        self.marker.coordinate = location
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
    //맵뷰 터치
    func mapViewTouch(sender: AnyObject){
        self.view.endEditing(true)
        
        let tmpRect = courtSearchView.frame
        //애니메이션 적용
        UIView.animateWithDuration(0.2, animations: { 
            self.courtSearchView.frame.origin.x = -tmpRect.width
            }) { (_) in
                self.courtSearchView.frame = tmpRect
                self.courtSearchView.hidden = true
                self.courtSearchView.scrollView.scrollToTop()
        }
    }
    //현재 나의위치 가져오기 실패함
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        isMyLocation = false
        if NSProcessInfo.processInfo().environment["SIMULATOR_DEVICE_NAME"] != nil{
            print("It's an iOS Simulator")
        }else{
            print("It's a device")
            Util.alert(self, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
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
}

