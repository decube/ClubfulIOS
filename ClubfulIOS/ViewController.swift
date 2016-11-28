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



//임시 데이터
var tempData : [[String: AnyObject]] = [
    [
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://post.phinf.naver.net/20160527_297/1464314639619UEOpr_JPEG/11.JPG?type=w1200" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://imagescdn.gettyimagesbank.com/500/12/912/606/6/174800730.jpg" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://postfiles5.naver.net/20120123_52/kenny790907_1327322190946s9Mjv_JPEG/IMG_5849.JPG?type=w1" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://postfiles15.naver.net/20150209_190/imatrancer_1423415348869O6PNR_PNG/%B3%F3%B1%B8%C0%E5_%B3%F3%B1%B8%C4%DA%C6%AE_%284%29.png?type=w2" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://imagescdn.gettyimagesbank.com/500/12/912/606/6/174800730.jpg" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://post.phinf.naver.net/20160527_297/1464314639619UEOpr_JPEG/11.JPG?type=w1200" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://imagescdn.gettyimagesbank.com/500/12/912/606/6/174800730.jpg" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://postfiles5.naver.net/20120123_52/kenny790907_1327322190946s9Mjv_JPEG/IMG_5849.JPG?type=w1" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://postfiles15.naver.net/20150209_190/imatrancer_1423415348869O6PNR_PNG/%B3%F3%B1%B8%C0%E5_%B3%F3%B1%B8%C4%DA%C6%AE_%284%29.png?type=w2" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "categorySeq":1 as AnyObject,
        "categoryName":"축구" as AnyObject,
        "address":"어디어디" as AnyObject,
        "addressShort":"어디" as AnyObject,
        "cname":"축구장" as AnyObject,
        "latitude":34.2342 as AnyObject,
        "longitude":123.243232 as AnyObject,
        "description":"코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다.코트 설명입니다. 코트 설명입니다." as AnyObject,
        "image":"http://imagescdn.gettyimagesbank.com/500/12/912/606/6/174800730.jpg" as AnyObject
    ]
]

class ViewController: UIViewController{
    @IBOutlet var tableView: UITableView!
    //spin
    @IBOutlet var spin: UIActivityIndicatorView!
    //검색 텍스트 필드
    @IBOutlet var searchTextField: UITextField!
    //검색 텍스트필드 x 이미지뷰
    @IBOutlet var searchCancelImageView: UIView!
    @IBOutlet var leftEdge: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var rightEdge: UIScreenEdgePanGestureRecognizer!
    
    var mainCourtArray = Array<Court>()
    
    //현재위치 manager
    let locationManager = CLLocationManager()
    //위치 관련 앱을 실행했는지 실행 하지 않았는지
    var isFirstLocation = true
    //위치가져왔는지 못가져왔는지
    var isMyLocation = false
    
    
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
    var courtDetailSeq: Int!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        
        //검색 취소 액션 추가
        self.searchCancelImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.searchCancelAction)))
        
        //검색 필드 스타일
        self.searchTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 190
        self.tableView.separatorStyle = .none
        //엣지 설정
        self.leftEdge.edges = .left
        self.rightEdge.edges = .right
        
        let deviceUser = Storage.getRealmDeviceUser()
        if deviceUser.search == ""{
            self.searchCancelImageView.alpha = 0
        }else{
            self.searchTextField.text = deviceUser.search
            self.searchCancelImageView.alpha = 1
        }
        
        //현재 나의 위치설정
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        //코트검색 뷰 만들기
        if let customView = Bundle.main.loadNibNamed("CourtSearchView", owner: self, options: nil)?.first as? CourtSearchView {
            self.courtSearchView = customView
            self.courtSearchView.setLayout(self)
        }
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
            self.addCourt()
        }
    }
    
    //메인 코트 가져옴
    func addCourt(){
        self.spin.isHidden = false
        self.spin.startAnimating()
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                for data in tempData{
                    let court = Court(data)
                    self.mainCourtArray.append(court)
                }
                self.tableView.reloadData()
                self.spin.stopAnimating()
                self.spin.isHidden = true
            }
        }
    }
    
    //자기위치 설정 뷰 나타내기
    @IBAction func locationSearchAction(_ sender: AnyObject) {
        self.myLocationView.show()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController{
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
            vc.preAddress = self.addView.address
            vc.preBtn = self.addView.locationBtn
        }
    }
    //화면 생겼을 때
    override func viewWillAppear(_ animated: Bool) {
        if self.addView.isHidden{
            self.addView.addViewConfirm()
        }
        //키보드 생김/사라짐 셀렉터
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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


extension ViewController: CLLocationManagerDelegate{
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
}

extension ViewController: UITextFieldDelegate{
    //키보드 검색이 리턴됫을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTextField {
            textField.resignFirstResponder()
            self.courtSearchView.courtSearchAction()
            return false
        }else if textField == self.myLocationView.search{
            textField.resignFirstResponder()
            self.myLocationView.searchAction()
            return false
        }
        return true
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
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.myLocationView.tableView{
            return self.myLocationView.locationArray.count
        }else if tableView == self.courtSearchView.tableView{
            return self.courtSearchView.courtArray.count
        }else{
            return self.mainCourtArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.myLocationView.tableView{
            let address = self.myLocationView.locationArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationCell", for: indexPath) as! LocationCell
            cell.setAddress(address)
            cell.clickCallback = {(addr: Address) in
                self.myLocationView.hideAlpha {
                    let deviceUser = Storage.getRealmDeviceUser()
                    deviceUser.latitude = addr.latitude
                    deviceUser.longitude = addr.longitude
                    deviceUser.addressShort = addr.addressShort
                    deviceUser.address = addr.address
                    deviceUser.isMyLocation = true
                    Storage.setRealmDeviceUser(deviceUser)
                }
            }
            return cell
        }else if tableView == self.courtSearchView.tableView{
            let court = self.courtSearchView.courtArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourtSearchCell", for: indexPath) as! CourtSearchCell
            cell.setCourt(court)
            cell.touchCallback = {(court: Court) in
                self.courtDetailSeq = court.seq
                self.performSegue(withIdentifier: "main_courtDetail", sender: nil)
            }
            cell.mapViewCallback = {(court: Court) in
                let sname : String = "내위치".queryValue()
                let sx : Double = (self.locationManager.location?.coordinate.latitude)!
                let sy : Double = (self.locationManager.location?.coordinate.longitude)!
                let ename : String = court.addressShort.queryValue()
                let ex : Double = court.latitude
                let ey : Double = court.longitude
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
            }
            return cell
        }else{
            let court = self.mainCourtArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourtCell", for: indexPath) as! CourtCell
            cell.setCourt(court)
            cell.callback = { (_) in
                if self.courtSearchView.isHidden == false{
                    self.courtSearchView.hide()
                }else{
                    self.courtDetailSeq = court.seq
                    self.performSegue(withIdentifier: "main_courtDetail", sender: nil)
                }
            }
            return cell
        }
    }
}
extension ViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 && self.spin.isHidden == true{
            if scrollView == self.tableView{
                self.addCourt()
            }
        }
    }
}



