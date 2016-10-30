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
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    //현재위치 manager
    let locationManager = CLLocationManager()
    
    //위치 관련 앱을 실행했는지 실행 하지 않았는지
    var isFirstLocation = true

    //위치가져왔는지 못가져왔는지
    var isMyLocation = false
    
    //scrollView
    @IBOutlet var scrollView: UIScrollView!
    //spin
    @IBOutlet var spin: UIActivityIndicatorView!
    //검색 텍스트 필드
    @IBOutlet var searchTextField: UITextField!
    //검색 텍스트필드 x 이미지뷰
    @IBOutlet var searchCancelImageView: UIView!
    
    //blackScreen
    var blackScreen : UIButton!
    //위치찾기뷰
    var myLocationView : MyLocationView!
    //코트검색뷰
    var courtSearchView: CourtSearchView!
    //추가정보 뷰
    var addView : AddView!
    
    //제스처
    var direction: Direction!
    let interactor = Interactor()
    @IBOutlet var leftEdge: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var rightEdge: UIScreenEdgePanGestureRecognizer!
    
    func removeCache(){
        //cache지우기
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController viewDidLoad")
        
        //self.removeCache()
        
        
        
        let user = Storage.getRealmUser()
        //검색 필드 스타일
        self.searchTextField.borderStyle = .none
        self.searchTextField.delegate = self
        if user.search == ""{
            self.searchCancelImageView.alpha = 0
        }else{
            self.searchTextField.text = user.search
            self.searchCancelImageView.alpha = 1
        }
        
        //검색 취소 액션 추가
        self.searchCancelImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.searchCancelAction)))
        
        
        //엣지 설정
        self.leftEdge.edges = .left
        self.rightEdge.edges = .right
        
        
        //현재 나의 위치설정
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        
        
        
        //블랙스크린 만들기
        self.blackScreen = UIButton()
        self.blackScreen.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.blackScreen.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        self.blackScreen.isHidden = true
        self.view.addSubview(self.blackScreen)
        //블랙스크린 클릭
        self.blackScreen.addAction(.touchUpInside) { (_) in
            self.view.endEditing(true)
            if self.myLocationView.isHidden == false{
                let tmpRect = self.myLocationView.frame
                //애니메이션 적용
                UIView.animate(withDuration: 0.2, animations: {
                    self.myLocationView.frame.origin.y = -tmpRect.height
                    }, completion: {(_) in
                        self.blackScreen.isHidden = true
                        self.myLocationView.isHidden = true
                        self.myLocationView.frame = tmpRect
                })
            }
        }
        
        
        
        
        //자기 위치 설정 뷰 만들기
        if let customView = Bundle.main.loadNibNamed("MyLocationView", owner: self, options: nil)?.first as? MyLocationView {
            self.myLocationView = customView
            self.myLocationView.setLayout(self)
        }
        
        //코트검색 뷰 만들기
        if let customView = Bundle.main.loadNibNamed("CourtSearchView", owner: self, options: nil)?.first as? CourtSearchView {
            self.courtSearchView = customView
            self.courtSearchView.setLayout(self)
        }
        
        
        //추가정보 뷰 만들기
        if let customView = Bundle.main.loadNibNamed("AddView", owner: self, options: nil)?.first as? AddView {
            self.addView = customView
            self.addView.setLayout(self)
        }
        
        
        ///////////////////
        //GET Async 동기 통신
        ///////////////////
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
            
            //버전체크 통신
            let parameters = URL.vesion_checkParam()
            URL.request(self, url: URL.apiServer+URL.api_version_check, param: parameters, callback: { (dic) in
                let user = Storage.copyUser()
                user.token = dic["token"] as! String
                Util.newVersion = dic["ver"] as! String
                user.categoryVer = dic["categoryVer"] as! Int
                user.noticeVer = dic["noticeVer"] as! Int
                if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                    Storage.setStorage("categoryList", value: categoryList as AnyObject)
                }
                Storage.setRealmUser(user)
            })
            
        } catch _ as NSError {}
        
    }
    
    
    
    //검색 취소 X표시 버튼 액션
    func searchCancelAction(){
        self.searchTextField.text = ""
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.searchCancelImageView.alpha = 0
        })
        if self.courtSearchView.isHidden == false{
            UIView.animate(withDuration: 0.2, animations: {
                self.courtSearchView.frame.origin.x = -self.courtSearchView.frame.width
                }, completion: {(_) in
                    self.courtSearchView.isHidden = true
                    self.courtSearchView.frame.origin.x = 0
            })
        }
    }
    
    
    
    
    //자기위치 설정 뷰 나타내기
    @IBAction func locationSearchAction(_ sender: AnyObject) {
        self.myLocationView.centerViewShow()
    }
    
    
    
    
    
    
    
    //왼쪽 제스처
    @IBAction func leftEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.direction = .right
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.performSegue(withIdentifier: "main_left", sender: nil)
        }
    }
    //오른쪽 제스처
    @IBAction func rightEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.direction = .left
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.performSegue(withIdentifier: "main_right", sender: nil)
        }
    }
    
    
    
    
    //세그
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MainLeftViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
        if let destinationViewController = segue.destination as? MainRightViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
        if let vc = segue.destination as? CourtViewController{
            vc.courtSeq = self.courtSearchView.courtSeq
        }
        if let vc = segue.destination as? MapViewController{
            vc.preView = self
            vc.preBtn = self.addView.locationBtn
        }
    }
    
    
    //키보드 검색이 리턴됫을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTextField {
            textField.resignFirstResponder()
            self.courtSearchView.courtSearchAction()
            return false
        }else if textField == self.myLocationView.searchTextField{
            textField.resignFirstResponder()
            self.myLocationView.searchAction()
            return false
        }
        return true
    }
    
    
    
    
    //현재 나의위치 가져오기 실패함
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.isMyLocation = false
        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil{
            print("It's an iOS Simulator")
        }else{
            print("It's a device")
            Util.alert(self, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
        }
    }
    
    
    
    //현재 나의 위치 딜리게이트 가져옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.isMyLocation = true
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        Storage.latitude = locValue.latitude
        Storage.longitude = locValue.longitude
        
        //앱 처음 실행할때
        if isFirstLocation == true{
            isFirstLocation = false
            Storage.locationThread(self)
        }
    }
    
   
    
    
    
    
    //화면 생겼을 때
    override func viewWillAppear(_ animated: Bool) {
        self.addView.addViewConfirm()
        //키보드 생김/사라짐 셀렉터
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if self.myLocationView.isHidden{
            self.searchCancelImageView.alpha = 0
            UIView.animate(withDuration: 1, animations: {
                self.searchCancelImageView.alpha = 1
            })
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        if self.myLocationView.isHidden{
            if self.searchTextField.text == ""{
                UIView.animate(withDuration: 0.3, animations: {
                    self.searchCancelImageView.alpha = 0
                })
            }
        }
    }
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator(direction: self.direction)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
