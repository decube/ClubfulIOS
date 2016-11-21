//
//  LoginViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet var spin: UIActivityIndicatorView!
    @IBOutlet var msgView: UIView!
    var scrollView: UIScrollView!
    var messageTextView: MessageTextView!
    
    var scrollViewHeight: CGFloat = 0
    var textViewY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        
        self.spin.isHidden = false
        self.spin.startAnimating()
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async {
                self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.msgView.frame.size.width, height: self.msgView.frame.size.height-50))
                self.scrollView.delegate = self
                self.msgView.addSubview(self.scrollView)
                
                self.scrollViewHeight = self.scrollView.contentSize.height
                self.textViewY = self.msgView.frame.height-50
                
                if let customView = Bundle.main.loadNibNamed("MessageTextView", owner: self, options: nil)?.first as? MessageTextView {
                    self.messageTextView = customView
                    self.messageTextView.setLayout(self)
                }
                
                self.setScrollView(isBottom: true)
            }
        }
    }
    
    
    
    //무한스크롤
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = self.scrollView.contentOffset.y
        if currentOffset <= 0 && self.spin.isHidden == true{
            self.spin.isHidden = false
            self.spin.startAnimating()
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.setScrollView(isBottom: false)
                }
            }
        }
    }
    
    var heightValue: CGFloat = 0
    func setScrollView(isBottom: Bool){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                var sizeHeight: CGFloat = 0
                for _ in 0..<20{
                    var heightValue: CGFloat = 0
                    if Int(arc4random_uniform(2)) == 0{
                        if let customView = Bundle.main.loadNibNamed("SendNoteView", owner: self, options: nil)?.first as? SendNoteView {
                            heightValue += customView.setLayout(self, element: ["message":"가나다라마바사 아자차카 타파아 하다다다 아다다다" as AnyObject])
                        }
                    }else{
                        if let customView = Bundle.main.loadNibNamed("GetNoteView", owner: self, options: nil)?.first as? GetNoteView {
                            heightValue +=  customView.setLayout(self, element: ["message":"가나다라마바사 아자차카 타파아 하다다다 아다다다" as AnyObject])
                        }
                    }
                    sizeHeight += heightValue
                    self.heightValue += heightValue
                }
                
                self.scrollView.contentSize.height = ceil(self.heightValue)
                self.scrollViewHeight = self.scrollView.contentSize.height
                if isBottom{
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: self.heightValue-self.scrollView.frame.height), animated: false)
                }else{
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: sizeHeight), animated: false)
                }
                DispatchQueue.global().async {
                    Thread.sleep(forTimeInterval: 0.2)
                    DispatchQueue.main.async {
                        self.spin.isHidden = true
                        self.spin.stopAnimating()
                    }
                }
            }
        }
    }
    
    
    func addMessage(type: String, msg: String){
        DispatchQueue.main.async {
            if type == "s"{
                if let customView = Bundle.main.loadNibNamed("SendNoteView", owner: self, options: nil)?.first as? SendNoteView {
                    self.heightValue += customView.setLayout(self, element: ["message":msg as AnyObject], isNew: true)
                }
            }else{
                if let customView = Bundle.main.loadNibNamed("GetNoteView", owner: self, options: nil)?.first as? GetNoteView {
                    self.heightValue +=  customView.setLayout(self, element: ["message":msg as AnyObject], isNew: true)
                }
            }
            self.scrollView.contentSize.height = ceil(self.heightValue)+self.keyboardHeight
            self.scrollViewHeight = ceil(self.heightValue)
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.heightValue-self.scrollView.frame.height+self.keyboardHeight), animated: false)
        }
    }
    
    func sendAction(){
        self.addMessage(type: "s", msg: self.messageTextView.textField.text!)
        self.messageTextView.textField.text = ""
    }
    
    
    //키보드 검색이 리턴됫을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.messageTextView.textField {
            self.messageTextView.sendAction()
            return false
        }
        return true
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //view 화면 보일때 작동
    override func viewWillAppear(_ animated: Bool) {
        //키보드 생김/사라짐 셀렉터
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    var keyboardHeight: CGFloat = 0
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            self.scrollView.contentSize.height = self.scrollViewHeight+keyboardSize.height
            self.messageTextView.frame.origin.y = self.textViewY-keyboardSize.height
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y+keyboardSize.height), animated: false)
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        let currentOffset = self.scrollView.contentOffset.y
        let maximumOffset = self.scrollView.contentSize.height - self.scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= keyboardHeight{
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y), animated: false)
        }else{
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y-self.keyboardHeight), animated: false)
        }
        self.scrollView.contentSize.height = self.scrollViewHeight
        self.messageTextView.frame.origin.y = self.textViewY
        
        self.keyboardHeight = 0
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //뷰 클릭했을때
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    
    //제스처
    var interactor:Interactor? = nil
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
}
