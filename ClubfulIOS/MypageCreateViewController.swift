//
//  MypageCreateViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 12. 31..
//  Copyright © 2016년 guanho. All rights reserved.
//

class MypageCreateViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var noneLbl: UILabel!
    var array = [Court]()
    var nonUserView : NonUserView!
    static var isReload = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func reloadData(){
        self.noneLbl.isHidden = true
        self.array = []
        let user = Storage.getRealmUser()
        let parameters : [String: AnyObject] = ["userId": user.userId as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+"user/mypage", param: parameters, callback: { (dic) in
            DispatchQueue.main.async {
                if let list = dic["myCourtInsert"] as? [[String: AnyObject]]{
                    if list.count == 0{
                        self.noneLbl.isHidden = false
                    }else{
                        for data in list{
                            let court = Court(data)
                            self.array.append(court)
                        }
                    }
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    func layout(){
        func rm(){
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
        }
        if Storage.isRealmUser(){
            rm()
            if MypageCreateViewController.isReload{
                MypageCreateViewController.isReload = false
                DispatchQueue.global().async {
                    Thread.sleep(forTimeInterval: 0.3)
                    DispatchQueue.main.async {
                        self.reloadData()
                    }
                }
            }
        }else{
            rm()
            self.view.addSubview(nonUserView)
        }
    }
}

extension MypageCreateViewController{
    override func viewWillAppear(_ animated: Bool) {
        if nonUserView == nil{
            if let customView = Bundle.main.loadNibNamed("NonUserView", owner: self, options: nil)?.first as? NonUserView {
                customView.frame = self.view.frame
                nonUserView = customView
                layout()
            }
        }else{
            layout()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mypage_courtDetail"{
            let path = self.collectionView.indexPath(for: sender as! MyCourtCreateCell)
            let courtSeq = self.array[(path?.row)!].seq
            let detailVC = segue.destination as? CourtViewController
            detailVC?.courtSeq = courtSeq
        }
    }
}
extension MypageCreateViewController: UICollectionViewDelegate{
    
}

extension MypageCreateViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3-9, height: self.collectionView.frame.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCourtCreateCell", for: indexPath) as! MyCourtCreateCell
        let court = self.array[indexPath.row]
        cell.spin.startAnimating()
        cell.spin.isHidden = false
        DispatchQueue.global().async {
            if court.setImageData(){
                DispatchQueue.main.async {
                    cell.img.image = UIImage(data: court.imageData1)
                    cell.spin.stopAnimating()
                    cell.spin.isHidden = true
                }
            }
        }
        cell.txt.text = "\(court.cname!)"
        return cell
    }
}
