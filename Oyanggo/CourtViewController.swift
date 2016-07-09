//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import ImageSlideshow

class CourtViewController: UIViewController, UITextFieldDelegate {
    var courtSeq : Int!
    @IBOutlet var gcmPushBtn: UIButton!
    @IBOutlet var courtMapBtn: UIButton!
    @IBOutlet var interestBtn: UIButton!
    @IBOutlet var interestLbl: UILabel!
    //이미지
    @IBOutlet var imageSlide: ImageSlideshow!
    //내용 뷰
    @IBOutlet var contentView: UIView!
    //내용 뷰 origin Y
    var contentViewY: CGFloat!
    //설명 textView
    @IBOutlet var descTextView: UITextView!
    //댓글 입력 필드
    @IBOutlet var replyInsertField: UITextField!
    //댓글 입력 버튼
    @IBOutlet var replyInsertBtn: UIButton!
    override func viewDidLoad() {
        print("CourtViewController viewDidLoad")
        
        imageSlide.backgroundColor = UIColor.whiteColor()
        imageSlide.pageControlPosition = PageControlPosition.UnderScrollView
        imageSlide.pageControl.currentPageIndicatorTintColor = Util.commonColor
        imageSlide.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        imageSlide.zoomEnabled = true
        var imageList = [ImageSource]()
        for j in 0...6{
            imageList.append(ImageSource(image: UIImage(named: "courtTemp.png")!))
        }
        imageSlide.setImageInputs(imageList)
        
        gcmPushBtn.boxLayout(radius: 6)
        courtMapBtn.boxLayout(radius: 6)
        descTextView.boxLayout(borderWidth: 1, borderColor: UIColor.blackColor())
        descTextView.scrollToTop()
        replyInsertField.delegate = self
        replyInsertBtn.boxLayout(radius: 6, backgroundColor: Util.commonColor)
        contentViewY = contentView.frame.origin.y
    }
    
    
    
    
    //temp 변수
    var isStar = false
    
    
    //관심 클릭
    @IBAction func interestAction(sender: AnyObject) {
        var starImage = "ic_star_normal.png"
        isStar = !isStar
        if isStar{
            starImage = "ic_star_select.png"
        }
        //애니메이션 적용
        interestBtn.alpha = 0
        interestBtn.setImage(UIImage(named: starImage), forState: .Normal)
        UIView.animateWithDuration(0.4, animations: {
            self.interestBtn.alpha = 1
            }, completion: nil)
    }
    
    
    
    //gcm 클릭
    @IBAction func gcmPushAction(sender: AnyObject) {
        print("gcm")
    }
    
    //약도보기 클릭
    @IBAction func courtMapAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtMapVC")
        (uvc as! CourtMapViewController).courtLatitude = 37.5571274
        (uvc as! CourtMapViewController).courtLongitude = 126.9239304
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    //리플 등록 클릭
    @IBAction func replyInsertAction(sender: AnyObject) {
    
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //키보드생길때
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            contentView.frame.origin.y = contentViewY - keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(notification: NSNotification) {
        contentView.frame.origin.y = contentViewY
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


