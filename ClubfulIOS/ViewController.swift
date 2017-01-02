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

class ViewController: UIViewController{
    @IBOutlet var tableView: UITableView!
    //spin
    @IBOutlet var spin: UIActivityIndicatorView!
    //검색 텍스트 필드
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var leftEdge: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var rightEdge: UIScreenEdgePanGestureRecognizer!
    
    var mainCourtArray = Array<Court>()
    
    var page = 1
    var tot_page: Int!
    
    //왼쪽 코트
    var courtArray: Array<Court> = Array<Court>()
    
    //현재위치 manager
    let locationManager = CLLocationManager()
    //위치 관련 앱을 실행했는지 실행 하지 않았는지
    var isFirstLocation = true
    //위치가져왔는지 못가져왔는지
    var isMyLocation = false
    
    //위치찾기뷰
    var myLocationView : MyLocationView?
    //코트검색뷰
    var courtSearchView: CourtSearchView?
    //추가정보 뷰
    var addView : AddView?
    
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
        
        let deviceUser = Storage.getRealmDeviceUser()
        if deviceUser.search != ""{
            self.searchTextField.text = deviceUser.search
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
        self.courtSearchView = Bundle.main.loadNibNamed("CourtSearchView", owner: self, options: nil)?.first as? CourtSearchView
        self.courtSearchView?.delegate = self
        self.courtSearchView?.load()
        
        //자기 위치 설정 뷰 만들기
        self.myLocationView = Bundle.main.loadNibNamed("MyLocationView", owner: self, options: nil)?.first as? MyLocationView
        self.myLocationView?.delegate = self
        self.myLocationView?.load()
        
        //추가정보 뷰 만들기
        self.addView = Bundle.main.loadNibNamed("AddView", owner: self, options: nil)?.first as? AddView
        self.addView?.delegate = self
        self.addView?.load()
        
        self.addCourt()
    }
    
    
    
    
    @IBAction func categoryAction(_ sender: Any) {
        _ = Util.alert(self, message: "카테고리")
    }
    
    //메인 코트 가져옴
    func addCourt(){
        if tot_page != nil && self.tot_page < self.page{
            self.spin.isHidden = true
            self.spin.stopAnimating()
            return
        }
        
        self.spin.isHidden = false
        self.spin.startAnimating()
        
        let deviceUser = Storage.getRealmDeviceUser()
        var latitude = deviceUser.latitude
        var longitude = deviceUser.longitude
        if deviceUser.isMyLocation == false{
            latitude = deviceUser.deviceLatitude
            longitude = deviceUser.deviceLongitude
        }
        
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(deviceUser.category as AnyObject, forKey: "categorySeq")
        parameters.updateValue(latitude as AnyObject, forKey: "latitude")
        parameters.updateValue(longitude as AnyObject, forKey: "longitude")
        parameters.updateValue("t" as AnyObject, forKey: "flag")
        parameters.updateValue(self.page as AnyObject, forKey: "page")
        parameters.updateValue(10 as AnyObject, forKey: "size")
        
        URLReq.request(self, url: URLReq.apiServer+"court/list", param: parameters, callback: { (dic) in
            self.spin.isHidden = true
            self.spin.stopAnimating()
            DispatchQueue.main.async {
                if let list = dic["list"] as? [[String: AnyObject]]{
                    for data in list{
                        let court = Court(data)
                        self.mainCourtArray.append(court)
                    }
                    self.page += 1
                    self.tableView.reloadData()
                }
                if let totalCnt = dic["totalCnt"] as? String{
                    self.tot_page = Int(ceil(Double(totalCnt)!/10))
                }else if let totalCnt = dic["totalCnt"] as? Int{
                    self.tot_page = Int(ceil(Double(totalCnt)/10))
                }
            }
        })
    }
    
    
    //코트 검색
    func courtSearchAction(){
        if (self.searchTextField.text?.characters.count)! >= 2{
            self.courtSearchView?.spin.isHidden = false
            self.courtSearchView?.spin.startAnimating()
            self.view.endEditing(true)
            
            let deviceUser = Storage.getRealmDeviceUser()
            var latitude = deviceUser.latitude
            var longitude = deviceUser.longitude
            if deviceUser.isMyLocation == false{
                latitude = deviceUser.deviceLatitude
                longitude = deviceUser.deviceLongitude
            }
            self.courtArray = Array<Court>()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.searchTextField.text! as AnyObject, forKey: "search")
            parameters.updateValue(deviceUser.category as AnyObject, forKey: "category")
            parameters.updateValue(latitude as AnyObject, forKey: "latitude")
            parameters.updateValue(longitude as AnyObject, forKey: "longitude")
            URLReq.request(url: URLReq.apiServer+"court/searchList", param: parameters, callback: { (dic) in
                self.courtSearchView?.spin.isHidden = true
                self.courtSearchView?.spin.stopAnimating()
                if let list = dic["list"] as? [[String: AnyObject]]{
                    if list.count == 0{
                        _ = Util.alert(self, message: "해당 검색어에 코트가 없습니다.")
                    }else{
                        for data in list{
                            self.courtArray.append(Court(data))
                        }
                        self.courtSearchView?.tableView.reloadData()
                        self.courtSearchView?.show()
                    }
                }
            })
        }else{
            _ = Util.alert(self, message: "검색어는 2글자 이상으로 넣어주세요.")
        }
    }
    
    
    @IBAction func locationSearchAction(_ sender: AnyObject) {
        self.myLocationView?.show()
    }
    
    
    //왼쪽 제스처
    @IBAction func leftEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
//        self.direction = .right
//        self.snapshotNumber = MainLeftHelper.snapshotNumber
//        self.menuWidth = MainLeftHelper.menuWidth
//        let translation = sender.translation(in: view)
//        let progress = MainLeftHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
//        MainLeftHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
//            self.performSegue(withIdentifier: "main_left", sender: nil)
//        }
    }
    //오른쪽 제스처
    @IBAction func rightEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
//        self.direction = .left
//        self.snapshotNumber = MainRightHelper.snapshotNumber
//        self.menuWidth = MainRightHelper.menuWidth
//        let translation = sender.translation(in: view)
//        let progress = MainRightHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
//        MainRightHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
//            self.performSegue(withIdentifier: "main_right", sender: nil)
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MainLeftViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }else if let destinationViewController = segue.destination as? MainRightViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }else if segue.identifier == "main_courtDetail"{
            let path = self.tableView.indexPath(for: sender as! CourtCell)
            let courtSeq = self.mainCourtArray[(path?.row)!].seq
            let detailVC = segue.destination as? CourtViewController
            detailVC?.courtSeq = courtSeq
        }else if let vc = segue.destination as? CourtViewController{
            vc.courtSeq = self.courtDetailSeq
        }else if let vc = segue.destination as? MapViewController{
            vc.returnCallback = {(address: Address) in
                self.addView?.address = address
                self.addView?.locationBtn.setTitle("\(address.addressShort!)", for: UIControlState())
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if (self.addView?.isHidden)!{
            self.addView?.addViewConfirm()
        }
    }
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
        if self.courtSearchView?.isHidden == false{
            UIView.animate(withDuration: 0.2, animations: {
                (self.courtSearchView?.frame.origin.x = -(self.courtSearchView?.frame.width)!)!
            }, completion: {(_) in
                self.courtSearchView?.isHidden = true
                self.courtSearchView?.frame.origin.x = 0
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
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.isMyLocation = false
        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] == nil{
            _ = Util.alert(self, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
        }
    }
    
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTextField {
            textField.resignFirstResponder()
            let deviceUser = Storage.getRealmDeviceUser()
            deviceUser.search = self.searchTextField.text!
            Storage.setRealmDeviceUser(deviceUser)
            self.courtSearchAction()
            return false
        }else if textField == self.myLocationView?.search{
            textField.resignFirstResponder()
            self.myLocationView?.searchAction()
            return false
        }
        return true
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.myLocationView?.tableView{
            return (self.myLocationView?.locationArray.count)!
        }else if tableView == self.courtSearchView?.tableView{
            return self.courtArray.count
        }else{
            return self.mainCourtArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.myLocationView?.tableView{
            let address = self.myLocationView?.locationArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationCell", for: indexPath) as! LocationCell
            cell.setAddress(address!)
            cell.clickCallback = {(addr: Address) in
                self.myLocationView?.hideAlpha {
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
        }else if tableView == self.courtSearchView?.tableView{
            let court = self.courtArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourtSearchCell", for: indexPath) as! CourtSearchCell
            cell.setCourt(court)
            cell.touchCallback = {(court: Court) in
                self.courtDetailSeq = court.seq
                self.performSegue(withIdentifier: "courtDetail", sender: nil)
            }
            cell.mapViewCallback = {(court: Court) in
                let sname : String = "내위치".queryValue()
                let sx : Double = (self.locationManager.location?.coordinate.latitude)!
                let sy : Double = (self.locationManager.location?.coordinate.longitude)!
                let ename : String = court.address.queryValue()
                let ex : Double = court.latitude
                let ey : Double = court.longitude
                
                let simplemapUrl = "https://m.map.naver.com/route.nhn?menu=route&sname=\(sname)&sx=\(sx)&sy=\(sy)&ename=\(ename)&ex=\(ex)&ey=\(ey)&pathType=1&showMap=true#/publicTransit/list/\(sname),\(sy),\(sx),,,true,/\(ename),\(ey),\(ex),,,false,/0"
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
                if self.courtSearchView?.isHidden == false{
                    self.courtSearchView?.hide()
                }else{
                    self.courtDetailSeq = court.seq
                    self.performSegue(withIdentifier: "courtDetail", sender: nil)
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


extension ViewController: MyLocationDelegate{
    func myLocationKeyboardHide() {
        self.view.endEditing(true)
    }
    func myLocation() {
        if self.isMyLocation == false{
            _ = Util.alert(self, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
        }else{
            self.locationManager.startUpdatingLocation()
        }
    }
    func myLocationAlert(_ alert: UIAlertController) {
        self.present(alert, animated: false, completion: {(_) in })
    }
    func myLocationLoad(_ myLocationView: MyLocationView) {
        self.myLocationView?.frame = self.view.frame
        self.myLocationView?.tableView.delegate = self
        self.myLocationView?.tableView.dataSource = self
        self.myLocationView?.search.delegate = self
        self.view.addSubview(self.myLocationView!)
    }
}

extension ViewController: AddViewDelegate{
    func addViewKeyboardHide() {
        self.view.endEditing(true)
    }
    func addViewMapMove() {
        self.performSegue(withIdentifier: "main_map", sender: nil)
    }
    func addViewAlert(_ alert: UIAlertController) {
        self.present(alert, animated: false, completion: {(_) in })
    }
    func addViewLoad() {
        self.addView?.frame = self.view.frame
        self.view.addSubview(self.addView!)
    }
}

extension ViewController: CourtSearchDelegate{
    func courtSearchKeyboardHide() {
        self.view.endEditing(true)
    }
    func courtSearchLoad() {
        self.courtSearchView?.tableView.delegate = self
        self.courtSearchView?.tableView.dataSource = self
        self.view.addSubview(self.courtSearchView!)
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.courtSearchView?.frame = CGRect(x: 0, y: 80, width: self.view.frame.width/3*2, height: self.view.frame.height-80-(self.tabBarController?.tabBar.frame.height)!)
                _ = self.courtSearchView?.layer(.right, borderWidth: 1, color: UIColor.black)
            }
        }
    }
}

