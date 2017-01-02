//
//  MypageViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController {
    @IBOutlet var tabAdd: UIView!
    @IBOutlet var tabIns: UIView!
    var tabSlide: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.tabAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tab_1)))
        self.tabIns.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tab_2)))
        
        self.tabSlide = UIView(frame: CGRect(x: 0, y: 120, width: self.tabAdd.frame.width, height: 3))
        self.tabSlide?.backgroundColor = UIColor.blue
        self.view.addSubview(self.tabSlide!)
    }
    
    func tab_1(){
        self.pageViewController?.scrollToViewController(index: 0)
    }
    func tab_2(){
        self.pageViewController?.scrollToViewController(index: 1)
    }
    
    
    //페이지 슬라이드
    var pageViewController: MypagePageViewController? {
        didSet {
            pageViewController?.pdelegate = self
        }
    }
}

extension MypageViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MypagePageViewController {
            self.pageViewController = vc
        }
    }
}

extension MypageViewController: MypagePageViewControllerDelegate {
    func mypagePageViewControllerDelegate(_ pageViewController: MypagePageViewController, didUpdatePageCount count: Int) {
        
    }
    func mypagePageViewControllerDelegate(_ pageViewController: MypagePageViewController, didUpdatePageIndex index: Int) {
        var animationX: CGFloat = 0
        if index == 0{
            self.tabAdd.subviews.forEach { (v) in
                if let view = v as? UIImageView{
                    view.image = UIImage(named: "page_add_s")
                }
            }
            self.tabIns.subviews.forEach { (v) in
                if let view = v as? UIImageView{
                    view.image = UIImage(named: "page_ins_n")
                }
            }
        }else if index == 1{
            self.tabAdd.subviews.forEach { (v) in
                if let view = v as? UIImageView{
                    view.image = UIImage(named: "page_add_n")
                }
            }
            self.tabIns.subviews.forEach { (v) in
                if let view = v as? UIImageView{
                    view.image = UIImage(named: "page_ins_s")
                }
            }
            animationX = self.tabAdd.frame.width
        }
        UIView.animate(withDuration: 0.2) {
            self.tabSlide?.frame.origin.x = animationX
        }
    }
}

