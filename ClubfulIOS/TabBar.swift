//
//  TabBar.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {
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
    
    let tabImg01_g = UIImage(named: "ic_tab_home_g.png")
    let tabImg02_g = UIImage(named: "ic_tab_add_g.png")
    let tabImg03_g = UIImage(named: "ic_tab_mypage_g.png")
    let tabImg04_g = UIImage(named: "ic_tab_setting_g.png")
    
    let tabImg01 = UIImageView()
    let tabImg02 = UIImageView()
    let tabImg03 = UIImageView()
    let tabImg04 = UIImageView()
    
    let tabLbl01 = UILabel()
    let tabLbl02 = UILabel()
    let tabLbl03 = UILabel()
    let tabLbl04 = UILabel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tabBar.hidden = true
        
        customTabBarView.frame = CGRectMake(0, self.view.frame.height-60, self.view.frame.size.width, 60)
        customTabBarView.backgroundColor = UIColor(red:0.05, green:0.35, blue:0.17, alpha:1.00)
        
        let widthOfOneBtn = self.tabBar.frame.size.width/4
        let heightOfOneBtn = self.customTabBarView.frame.height
        
        tabBtn01.frame = CGRectMake(widthOfOneBtn*0, 0, widthOfOneBtn, heightOfOneBtn)
        tabBtn02.frame = CGRectMake(widthOfOneBtn*1, 0, widthOfOneBtn, heightOfOneBtn)
        tabBtn03.frame = CGRectMake(widthOfOneBtn*2, 0, widthOfOneBtn, heightOfOneBtn)
        tabBtn04.frame = CGRectMake(widthOfOneBtn*3, 0, widthOfOneBtn, heightOfOneBtn)
        
        let widthPadding = (widthOfOneBtn-(heightOfOneBtn-30))/2
        
        tabImg01.frame = CGRectMake(widthPadding, 5, heightOfOneBtn-30, heightOfOneBtn-30)
        tabImg02.frame = CGRectMake(widthPadding, 5, heightOfOneBtn-30, heightOfOneBtn-30)
        tabImg03.frame = CGRectMake(widthPadding, 5, heightOfOneBtn-30, heightOfOneBtn-30)
        tabImg04.frame = CGRectMake(widthPadding, 5, heightOfOneBtn-30, heightOfOneBtn-30)
        
        tabImg01.image = tabImg01_s
        tabImg02.image = tabImg02_n
        tabImg03.image = tabImg03_n
        tabImg04.image = tabImg04_n
        
        tabLbl01.textColor = UIColor.blackColor()//UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.00)
        tabLbl02.textColor = UIColor.whiteColor()
        tabLbl03.textColor = UIColor.whiteColor()
        tabLbl04.textColor = UIColor.whiteColor()
        
        tabLbl01.frame = CGRectMake(0, heightOfOneBtn-25, widthOfOneBtn, 25)
        tabLbl02.frame = CGRectMake(0, heightOfOneBtn-25, widthOfOneBtn, 25)
        tabLbl03.frame = CGRectMake(0, heightOfOneBtn-25, widthOfOneBtn, 25)
        tabLbl04.frame = CGRectMake(0, heightOfOneBtn-25, widthOfOneBtn, 25)
        
        tabLbl01.text = "홈"
        tabLbl02.text = "등록"
        tabLbl03.text = "내정보"
        tabLbl04.text = "설정"
        
        tabLbl01.textAlignment = .Center
        tabLbl02.textAlignment = .Center
        tabLbl03.textAlignment = .Center
        tabLbl04.textAlignment = .Center
        
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
    
    func setAttributeTabBarButton(btn : UIButton){
        btn.addTarget(self, action: #selector(self.onBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.customTabBarView.addSubview(btn)
    }
    
    func onBtnClick(sender : UIButton){
        self.tabLbl01.textColor = UIColor.whiteColor()
        self.tabLbl02.textColor = UIColor.whiteColor()
        self.tabLbl03.textColor = UIColor.whiteColor()
        self.tabLbl04.textColor = UIColor.whiteColor()
        
        self.tabImg01.image = tabImg01_n
        self.tabImg02.image = tabImg02_n
        self.tabImg03.image = tabImg03_n
        self.tabImg04.image = tabImg04_n
        
        sender.subviews.forEach({ (subView) in
            if let lbl = subView as? UILabel{
                lbl.textColor = UIColor.blackColor()
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
        self.selectedIndex = sender.tag
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
