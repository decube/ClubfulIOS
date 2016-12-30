//
//  MypageViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var createArray = [Court]()
    var nonUserView : NonUserView!
    static var isReload = true
    var noneLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.noneLbl = UILabel(frame: CGRect(x: 0, y: 120, width: self.collectionView.frame.width, height: self.collectionView.frame.height))
        self.noneLbl.text = "내가 등록한 코트가 없습니다."
        self.noneLbl.textAlignment = .center
        self.noneLbl.font = UIFont(name: (noneLbl.font?.fontName)!, size: 20)
        self.noneLbl.isHidden = true
        self.view.addSubview(noneLbl)
    }
    
    func reloadData(){
        let user = Storage.getRealmUser()
        let parameters : [String: AnyObject] = ["userId": user.userId as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+"user/mypage", param: parameters, callback: { (dic) in
            DispatchQueue.main.async {
                if let list = dic["myCourtInsert"] as? [[String: AnyObject]]{
                    if list.count == 0{
                        self.noneLbl.isHidden = false
                    }else{
                        self.createArray = []
                        for data in list{
                            let court = Court(data)
                            self.createArray.append(court)
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        })
    }
    
    func layout(){
        if Storage.isRealmUser(){
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            if MypageViewController.isReload{
                MypageViewController.isReload = false
                self.reloadData()
            }
        }else{
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            self.view.addSubview(nonUserView)
        }
    }
}

extension MypageViewController{
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
            let path = self.collectionView.indexPath(for: sender as! MyCourtCell)
            let courtSeq = self.createArray[(path?.row)!].seq
            let detailVC = segue.destination as? CourtViewController
            detailVC?.courtSeq = courtSeq
        }
    }
}
extension MypageViewController: UICollectionViewDelegate{
    
}

extension MypageViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.createArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3-9, height: self.collectionView.frame.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCourtCell", for: indexPath) as! MyCourtCell
        let court = self.createArray[indexPath.row]
        cell.spin.startAnimating()
        cell.spin.isHidden = false
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if court.setImageData(){
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
