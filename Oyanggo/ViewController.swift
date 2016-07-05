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
    var mapView : MKMapView!
    let locationManager = CLLocationManager()
    //내위치 표시 변수
    var myLocationMove = true
    //현재 내위치 검색
    var myLocationSearch = false
    //위치가져왔는지 못가져왔는지
    var isMyLocation = false
    //마커
    var annotation : MKPointAnnotation!
    
    
    //맵뷰터치 이벤트
    var mapViewTouch : ((Void) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let window = UIApplication.sharedApplication().windows[0] as UIWindow;
        UIView.transitionFromView(
            window.rootViewController!.view,
            toView: self.view,
            duration: 0.65,
            options: .TransitionCrossDissolve,
            completion: {
                finished in window.rootViewController = self
        })
        
        //현재 나의 위치설정
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //레이아웃 설정
        let statusBar = UIView().statusBar()
        self.view.addSubview(statusBar)
        
        //메인 레이아웃
        let headerView = UIView(frame : CGRect(x: 0, y: 20, width: Util.screenSize.width, height: 60), backgroundColor: Util.commonColor)
        let headerMyLocationBtn = UIButton(frame: CGRect(x: 5, y: 10, width: 40, height: 40), image: UIImage(named: "ic_myLocation.png")!)
        let headerSearchFieldWidth = headerView.frame.width-50-110
        
        let headerSearchField = UITextField(frame: CGRect(x: 50, y: 10, width: headerSearchFieldWidth, height: 40), placeholder: "검색할 코트 장소를 입력하세요.", placeholderColor: UIColor.blackColor(), textAlignment: .Left, delegate: self)
        headerSearchField.text = "가나"
        headerSearchField.returnKeyType = UIReturnKeyType.Done
        let headerSearchButton = UIButton(frame: CGRect(x: headerSearchFieldWidth+55, y: 10, width: 40, height: 40), text: "검색")
        let headerNavButton = UIButton(frame: CGRect(x: headerView.frame.width-40, y: 15, width: 30, height: 30), image: UIImage(named: "ic_nav_icon.png")!)
        let bottomButton = UIButton(frame: CGRect(x: 0, y: Util.screenSize.height-60, width: Util.screenSize.width, height: 60), text: "코트 등록")
        
        headerSearchButton.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.grayColor(), borderColor: UIColor.blackColor())
        bottomButton.backgroundColor = Util.commonColor
        
        self.view.addSubview(headerView)
        headerView.addSubview(headerMyLocationBtn)
        headerView.addSubview(headerSearchField)
        headerView.addSubview(headerSearchButton)
        headerView.addSubview(headerNavButton)
        self.view.addSubview(bottomButton)
        
        
        
        //서브레이아웃
        let leftCourtView = UIScrollView(frame: CGRect(x: 0, y: 80, width: Util.screenSize.width/2, height: Util.screenSize.height-80-60), backgroundColor: UIColor.whiteColor())
        leftCourtView.hidden = true
        self.view.addSubview(leftCourtView)
        
        let blackScreen = UIButton().blackScreen()
        self.view.addSubview(blackScreen)
        
        let centerLocView = UIView(frame: CGRect(x: (Util.screenSize.width-300)/2, y: (Util.screenSize.height-440)/2, width: 300, height: 440), backgroundColor: UIColor.whiteColor())
        centerLocView.hidden = true
        let centerLocHeader = UIView(frame: CGRect(x: 0, y: 0, width: centerLocView.frame.width, height: 60), backgroundColor: Util.commonColor)
        let centerLocHeaderField = UITextField(frame: CGRect(x: 5, y: 10, width: centerLocHeader.frame.width-130, height: 40), placeholder: "현재 위치를 검색하세요.", placeholderColor: UIColor.blackColor(), textAlignment: .Left, delegate: self, fontSize: 15)
        let centerLocHeaderMyLocBtn = UIButton(frame: CGRect(x: centerLocHeader.frame.width-110, y: 10, width: 40, height: 40), image: UIImage(named: "ic_myLocation.png")!)
        let centerLocHeaderBtn = UIButton(frame: CGRect(x: centerLocHeader.frame.width-55, y: 10, width: 50, height: 40), text: "검색", fontSize: 13)
        let centerLocScroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: centerLocView.frame.width, height: centerLocView.frame.height-60), backgroundColor: UIColor.whiteColor())
        
        centerLocHeaderBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.grayColor(), borderColor: UIColor.blackColor())
        centerLocHeaderField.returnKeyType = UIReturnKeyType.Done
        
        self.view.addSubview(centerLocView)
        centerLocView.addSubview(centerLocHeader)
        centerLocHeader.addSubview(centerLocHeaderField)
        centerLocHeader.addSubview(centerLocHeaderMyLocBtn)
        centerLocHeader.addSubview(centerLocHeaderBtn)
        centerLocView.addSubview(centerLocScroll)
        
        
        //네비뷰
        let navView = UIView().navView(self, blackScreen: blackScreen, statusBar: statusBar)
        self.view.addSubview(navView)
        
        //코트등록 클릭
        bottomButton.addControlEvent(.TouchUpInside){
            let user = Storage.getRealmUser()
            if user.isLogin == -1{
                Util.alert(message: "로그인을 하셔야 이용 가능합니다.", ctrl: self)
            }else{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtCreateVC")
                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.presentViewController(uvc, animated: true, completion: nil)
            }
        }
        
        
        //위치검색 클릭
        headerMyLocationBtn.addControlEvent(.TouchUpInside){
            centerLocScroll.subviews.forEach({$0.removeFromSuperview()})
            centerLocScroll.scrollToTop()
            centerLocView.hidden = false
            blackScreen.hidden = false
            leftCourtView.hidden = true
        }
        //자기위치 가져오기
        centerLocHeaderMyLocBtn.addControlEvent(.TouchUpInside){
            blackScreen.hidden = true
            centerLocView.hidden = true
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
                centerLocScroll.subviews.forEach({$0.removeFromSuperview()})
                //자기위치 검색 통신
                var i : CGFloat = 0
                let locObjHeight : CGFloat = 80
                for j in 0 ... 10{
                    let objBtn = UIButton(frame: CGRect(x: 0, y: locObjHeight*i, width: centerLocScroll.frame.width, height: locObjHeight-1))
                    let addressShortLbl = UILabel(frame: CGRect(x: 5, y: 10, width: objBtn.frame.width-5, height: 15), text: "어디어디주소", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
                    let addressLbl = UILabel(frame: CGRect(x: 5, y: 25, width: objBtn.frame.width-5, height: 65), text: "어디어디주소길게길게어디어디주소길게길게어디어디주소길게길게", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 13)
                    addressLbl.numberOfLines = 2
                    objBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
                    centerLocScroll.addSubview(objBtn)
                    objBtn.addSubview(addressShortLbl)
                    objBtn.addSubview(addressLbl)
                    
                    objBtn.addControlEvent(.TouchUpInside){
                        blackScreen.hidden = true
                        centerLocView.hidden = true
                        let user = Storage.copyUser()
                        user.latitude = 37.5571274
                        user.longitude = 126.9239304
                        user.address = "어디어디주소길게길게어디어디주소길게길게어디어디주소길게길게"
                        user.addressShort = "어디어디주소"
                        Storage.setRealmUser(user)
                        self.myLocationSearch = true
                        self.mapView.removeAnnotation(self.annotation)
                        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.5571274, 126.9239304)
                        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                        self.mapView.region = region
                        self.annotation = MKPointAnnotation()
                        self.annotation.coordinate = location
                        self.mapView.addAnnotation(self.annotation)
                    }
                    
                    i += 1
                }
                centerLocScroll.contentSize = CGSize(width: centerLocScroll.frame.width, height: locObjHeight*i)
            }else{
                Util.alert(message: "검색어는 2글자 이상으로 넣어주세요.", ctrl: self)
            }
        }
        
        
        
        
        
        
        
        
        //코트 검색 클릭
        headerSearchButton.addControlEvent(.TouchUpInside){
            if headerSearchField.text?.characters.count >= 2{
                self.view.endEditing(true)
                leftCourtView.subviews.forEach({$0.removeFromSuperview()})
                leftCourtView.scrollToTop()
                leftCourtView.hidden = false
                //코트 검색 통신
                var i : CGFloat = 0
                let locObjHeight : CGFloat = 80
                for j in 0 ... 10{
                    let objBtn = UIButton(frame: CGRect(x: 0, y: locObjHeight*i, width: centerLocScroll.frame.width, height: locObjHeight-1))
                    let addressShortLbl = UILabel(frame: CGRect(x: 5, y: 10, width: objBtn.frame.width-5, height: 15), text: "1234어디주소", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
                    let addressLbl = UILabel(frame: CGRect(x: 5, y: 25, width: objBtn.frame.width-5, height: 65), text: "어디어디주소길게길게어디어디주소길게길게어디어디주소길게길게", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 13)
                    addressLbl.numberOfLines = 2
                    objBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
                    leftCourtView.addSubview(objBtn)
                    objBtn.addSubview(addressShortLbl)
                    objBtn.addSubview(addressLbl)
                    
                    objBtn.addControlEvent(.TouchUpInside){
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtVC")
                        (uvc as! CourtViewController).courtSeq = j
                        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                        self.presentViewController(uvc, animated: true, completion: nil)
                    }
                    i += 1
                }
                leftCourtView.contentSize = CGSize(width: leftCourtView.frame.width, height: locObjHeight*i)
            }else{
                Util.alert(message: "검색어는 2글자 이상으로 넣어주세요.", ctrl: self)
            }
        }
        //맵뷰터치 이벤트 전달하기
        self.mapViewTouch = {(_) in
            self.view.endEditing(true)
            leftCourtView.subviews.forEach({$0.removeFromSuperview()})
            leftCourtView.scrollToTop()
            leftCourtView.hidden = true
        }
        
        
        //네비 클릭
        headerNavButton.addControlEvent(.TouchUpInside){
            blackScreen.hidden = false
            leftCourtView.hidden = true
            
            let tmpRect = navView.frame
            navView.frame = CGRect(x: Util.screenSize.width, y: 20, width: tmpRect.width, height: tmpRect.height)
            navView.hidden = false
            statusBar.backgroundColor = UIColor.blackColor()
            //애니메이션 적용
            UIView.animateWithDuration(0.2, animations: {
                navView.frame = CGRect(x: Util.screenSize.width-tmpRect.width, y: 20, width: tmpRect.width, height: tmpRect.height)
                }, completion: nil)
        }
        
        
        
        blackScreen.addControlEvent(.TouchUpInside){
            if leftCourtView.hidden == false{
                leftCourtView.hidden = true
                blackScreen.hidden = true
            }
            if centerLocView.hidden == false{
                centerLocView.hidden = true
                blackScreen.hidden = true
            }
            if navView.hidden == false{
                let tmpRect = navView.frame
                statusBar.backgroundColor = Util.statusColor
                //애니메이션 적용
                UIView.animateWithDuration(0.2, animations: {
                    navView.frame = CGRect(x: Util.screenSize.width, y: 20, width: tmpRect.width, height: tmpRect.height)
                    }, completion: {(_) in
                        blackScreen.hidden = true
                        navView.hidden = true
                        navView.frame = CGRect(x: Util.screenSize.width, y: 0, width: tmpRect.width, height: tmpRect.height)
                })
            }
            
        }
    }
    
    //현재 나의 위치
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isMyLocation = true
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        if myLocationSearch == false{
            let user = Storage.copyUser()
            user.latitude = locValue.latitude
            user.longitude = locValue.longitude
            Storage.setRealmUser(user)
            self.mapView.removeAnnotation(annotation)
            let appDelegateLocationMove = (UIApplication.sharedApplication().delegate as! AppDelegate).vcMyLocationMove
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
            if myLocationMove == true || appDelegateLocationMove == true{
                myLocationMove = false
                (UIApplication.sharedApplication().delegate as! AppDelegate).vcMyLocationMove = false
                let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                self.mapView.region = region
            }
            self.annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
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
    
    
    //맵뷰 터치
    func mapViewTouch(sender: AnyObject){
        self.mapViewTouch()
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

