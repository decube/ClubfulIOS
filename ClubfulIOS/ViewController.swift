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

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate{
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
    var blackScreen : BlackScreen!
    //위치찾기뷰
    var myLocationView : MyLocationView!
    //코트검색뷰
    var courtSearchView: CourtSearchView!
    //추가정보 뷰
    var addView : AddView!
    
    //제스처
    var direction: Direction!
    var snapshotNumber: Int!
    var menuWidth: CGFloat!
    let interactor = Interactor()
    @IBOutlet var leftEdge: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var rightEdge: UIScreenEdgePanGestureRecognizer!
    
    var courtDetailSeq: Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        
        //검색 필드 스타일
        self.searchTextField.borderStyle = .none
        self.searchTextField.delegate = self
        let deviceUser = Storage.getRealmDeviceUser()
        if deviceUser.search == ""{
            self.searchCancelImageView.alpha = 0
        }else{
            self.searchTextField.text = deviceUser.search
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
        
        
        self.scrollView.delegate = self
        
        
        //코트검색 뷰 만들기
        if let customView = Bundle.main.loadNibNamed("CourtSearchView", owner: self, options: nil)?.first as? CourtSearchView {
            self.courtSearchView = customView
            self.courtSearchView.setLayout(self)
        }
        
        
        //블랙스크린 만들기
        self.blackScreen = BlackScreen(self)
        
        
        //자기 위치 설정 뷰 만들기
        if let customView = Bundle.main.loadNibNamed("MyLocationView", owner: self, options: nil)?.first as? MyLocationView {
            self.myLocationView = customView
            self.myLocationView.setLayout(self)
        }
        
        //추가정보 뷰 만들기
        if let customView = Bundle.main.loadNibNamed("AddView", owner: self, options: nil)?.first as? AddView {
            self.addView = customView
            self.addView.setLayout(self)
        }
        
        ///////////////////
        //GET Async 동기 통신
        ///////////////////
        URLReq.initApiRequest(self){
            self.spin.isHidden = true
            self.addScrollView()
        }
    }
    
    
    var totalRow : Int!
    var page = 1
    var idx: CGFloat = 0
    //스크롤뷰 슬라이더 딜리게이트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = self.scrollView.contentOffset.y
        let maximumOffset = self.scrollView.contentSize.height - self.scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 && self.spin.isHidden == true{
            self.addScrollView()
        }
    }
    
    func addScrollView(){
        if self.totalRow != nil && self.totalRow <= Int(self.idx){
            self.spin.isHidden = true
            self.spin.stopAnimating()
            return
        }
        if self.spin.isHidden == false{
            return
        }
        
        self.spin.startAnimating()
        self.spin.isHidden = false
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.3)
            DispatchQueue.main.async{
                ///////////
                //통신//
                /////////
                self.spin.stopAnimating()
                self.spin.isHidden = true
                let height: CGFloat = 180
                for _ in 0...10{
                    if let customView = Bundle.main.loadNibNamed("CourtElementView", owner: self, options: nil)?.first as? CourtElementView {
                        customView.setLayout(self, idx: self.idx, height: height, element: [:])
                        self.idx += 1
                    }
                }
                self.scrollView.contentSize.height = (self.idx*(height+10))+70
            }
        }
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
        self.snapshotNumber = MainLeftHelper.snapshotNumber
        self.menuWidth = MainLeftHelper.menuWidth
        let translation = sender.translation(in: view)
        let progress = MainLeftHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MainLeftHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.performSegue(withIdentifier: "main_left", sender: nil)
        }
    }
    //오른쪽 제스처
    @IBAction func rightEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.direction = .left
        self.snapshotNumber = MainRightHelper.snapshotNumber
        self.menuWidth = MainRightHelper.menuWidth
        let translation = sender.translation(in: view)
        let progress = MainRightHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MainRightHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.performSegue(withIdentifier: "main_right", sender: nil)
        }
    }
    
    
    
    
    //세그
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MainLeftViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.vc = self
        }
        if let destinationViewController = segue.destination as? MainRightViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
        if let vc = segue.destination as? CourtViewController{
            vc.courtSeq = self.courtDetailSeq
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
        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] == nil{
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
    //뷰 클릭했을때
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
        if self.courtSearchView.isHidden == false{
            UIView.animate(withDuration: 0.2, animations: {
                self.courtSearchView.frame.origin.x = -self.courtSearchView.frame.width
            }, completion: {(_) in
                self.courtSearchView.isHidden = true
                self.courtSearchView.frame.origin.x = 0
            })
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator(direction: self.direction, snapshotNumber: self.snapshotNumber, menuWidth: self.menuWidth)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator(snapshotNumber: self.snapshotNumber)
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
