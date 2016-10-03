//
//  TabBar.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class TabBar: UITabBarController{
    let customTabBarView = UIView()
    let tabBtn01 = UIButton()
    let tabBtn02 = UIButton()
    let tabBtn03 = UIButton()
    let tabBtn04 = UIButton()
    
    let tabImg01_n = UIImage(named: "ic_tab_home_n.png")
    let tabImg02_n = UIImage(named: "ic_tab_add_n.png")
    let tabImg03_n = UIImage(named: "ic_tab_mypage_n.png")
    let tabImg04_n = UIImage(named: "ic_tab_setting_n.png")
    
    let tabImg01_s = UIImage(named: "ic_tab_home_s.png")
    let tabImg02_s = UIImage(named: "ic_tab_add_s.png")
    let tabImg03_s = UIImage(named: "ic_tab_mypage_s.png")
    let tabImg04_s = UIImage(named: "ic_tab_setting_s.png")
    
    let tabImg01 = UIImageView()
    let tabImg02 = UIImageView()
    let tabImg03 = UIImageView()
    let tabImg04 = UIImageView()
    
    let tabLbl01 = UILabel()
    let tabLbl02 = UILabel()
    let tabLbl03 = UILabel()
    let tabLbl04 = UILabel()
    
    //navVC
    var navVC : UINavigationController!
    
    
    //회전됬을때
    func rotated(){
        func setRotate(){
            customTabBarView.frame = CGRect(x: 0, y: self.view.frame.height-60, width: self.view.frame.size.width, height: 60)
            let widthOfOneBtn = self.tabBar.frame.size.width/4
            let heightOfOneBtn = self.customTabBarView.frame.height
            
            tabBtn01.frame = CGRect(x: widthOfOneBtn*0, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
            tabBtn02.frame = CGRect(x: widthOfOneBtn*1, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
            tabBtn03.frame = CGRect(x: widthOfOneBtn*2, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
            tabBtn04.frame = CGRect(x: widthOfOneBtn*3, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
            
            let widthPadding = (widthOfOneBtn-(heightOfOneBtn-30))/2
            
            tabImg01.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
            tabImg02.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
            tabImg03.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
            tabImg04.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
            
            tabLbl01.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
            tabLbl02.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
            tabLbl03.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
            tabLbl04.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
        }
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            setRotate()
        }
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
            setRotate()
        }
        
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        self.tabBar.isHidden = true
        
        customTabBarView.frame = CGRect(x: 0, y: self.view.frame.height-60, width: self.view.frame.size.width, height: 60)
        customTabBarView.backgroundColor = UIColor(red:0.05, green:0.35, blue:0.17, alpha:1.00)
        
        let widthOfOneBtn = self.tabBar.frame.size.width/4
        let heightOfOneBtn = self.customTabBarView.frame.height
        
        tabBtn01.frame = CGRect(x: widthOfOneBtn*0, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
        tabBtn02.frame = CGRect(x: widthOfOneBtn*1, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
        tabBtn03.frame = CGRect(x: widthOfOneBtn*2, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
        tabBtn04.frame = CGRect(x: widthOfOneBtn*3, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
        
        let widthPadding = (widthOfOneBtn-(heightOfOneBtn-30))/2
        
        tabImg01.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
        tabImg02.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
        tabImg03.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
        tabImg04.frame = CGRect(x: widthPadding, y: 5, width: heightOfOneBtn-30, height: heightOfOneBtn-30)
        
        tabImg01.image = tabImg01_s
        tabImg02.image = tabImg02_n
        tabImg03.image = tabImg03_n
        tabImg04.image = tabImg04_n
        
        tabLbl01.textColor = UIColor.black
        tabLbl02.textColor = UIColor.white
        tabLbl03.textColor = UIColor.white
        tabLbl04.textColor = UIColor.white
        
        tabLbl01.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
        tabLbl02.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
        tabLbl03.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
        tabLbl04.frame = CGRect(x: 0, y: heightOfOneBtn-25, width: widthOfOneBtn, height: 25)
        
        tabLbl01.text = "홈"
        tabLbl02.text = "등록"
        tabLbl03.text = "내정보"
        tabLbl04.text = "설정"
        
        tabLbl01.textAlignment = .center
        tabLbl02.textAlignment = .center
        tabLbl03.textAlignment = .center
        tabLbl04.textAlignment = .center
        
        tabBtn01.tag = 0
        tabBtn02.tag = 1
        tabBtn03.tag = 2
        tabBtn04.tag = 3
        
        tabBtn01.addSubview(tabImg01)
        tabBtn02.addSubview(tabImg02)
        tabBtn03.addSubview(tabImg03)
        tabBtn04.addSubview(tabImg04)
        
        tabBtn01.addSubview(tabLbl01)
        tabBtn02.addSubview(tabLbl02)
        tabBtn03.addSubview(tabLbl03)
        tabBtn04.addSubview(tabLbl04)
        
        
        setAttributeTabBarButton(tabBtn01)
        setAttributeTabBarButton(tabBtn02)
        setAttributeTabBarButton(tabBtn03)
        setAttributeTabBarButton(tabBtn04)
        
        self.view.addSubview(customTabBarView)
    }
    
    func setAttributeTabBarButton(_ btn : UIButton){
        btn.addTarget(self, action: #selector(self.onBtnClick(_:)), for: UIControlEvents.touchUpInside)
        self.customTabBarView.addSubview(btn)
    }
    
    func onBtnClick(_ sender : UIButton){
        self.tabLbl01.textColor = UIColor.white
        self.tabLbl02.textColor = UIColor.white
        self.tabLbl03.textColor = UIColor.white
        self.tabLbl04.textColor = UIColor.white
        
        self.tabImg01.image = tabImg01_n
        self.tabImg02.image = tabImg02_n
        self.tabImg03.image = tabImg03_n
        self.tabImg04.image = tabImg04_n
        
        sender.subviews.forEach({ (subView) in
            if let lbl = subView as? UILabel{
                lbl.textColor = UIColor.black
            }
            if let imgView = subView as? UIImageView{
                if imgView.image == tabImg01_n{
                    imgView.image = tabImg01_s
                }else if imgView.image == tabImg02_n{
                    imgView.image = tabImg02_s
                }else if imgView.image == tabImg03_n{
                    imgView.image = tabImg03_s
                }else if imgView.image == tabImg04_n{
                    imgView.image = tabImg04_s
                }
            }
        })
        if self.selectedIndex == sender.tag{
            if navVC != nil{
                navVC.popViewController(animated: true)
                navVC = nil
            }
        }else{
            self.selectedIndex = sender.tag
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
