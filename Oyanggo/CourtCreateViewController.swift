//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

class CourtCreateViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    //전체 스크롤 뷰
    @IBOutlet var mainScrollView: UIScrollView!
    //전체 스크롤뷰 스크롤 height
    var mainScrollViewHeight: CGFloat!
    //이미지 스크롤 뷰
    @IBOutlet var picScrollView: UIScrollView!
    //크롭버튼 어떤것을 클릭했는지 담아두는 변수
    var cropBtnSpace : UIButton!
    //빈 크롭 버튼 이미지
    let picAddImage = UIImage(named: "pic_add.png")!
    //크롭 버튼 리스트
    var picList = [UIButton]()
    //이미지 피커
    let picker = UIImagePickerController()
    //블랙스크린
    var blackScreen : UIButton!
    //카메라, 앨범 선택 뷰
    var picSelectedView : UIView!
    //이미지 크롭 뷰
    var imgCropView : UIView!
    //캔버스 영역 뷰
    var canvasView : UIView!
    //크롭 클래스
    var crop : ImageCrop!
    
    //이미지 사이즈
    var imageWidth : CGFloat!
    var imageHeight : CGFloat!
    
    //위치설정 버튼
    @IBOutlet var locationBtn: UIButton!
    //종목설정 버튼
    @IBOutlet var categoryBtn: UIButton!
    
    //위치 변수
    var courtLatitude : Double!
    var courtLongitude : Double!
    var courtAddress : String!
    var courtAddressShort : String!
    
    //카테고리 시컨스
    var category : Int!
    
    //코트 설명 텍스트뷰
    @IBOutlet var descTextView: UITextView!
    
    
    //user
    let user = Storage.getRealmUser()
    
    override func viewDidLoad() {
        print("CourtCreateViewController viewDidLoad")
        
        mainScrollViewHeight = mainScrollView.frame.height
        
        imageWidth = picScrollView.frame.width/2-5
        imageHeight = imageWidth * 120 / 192
        
        let pic1 = UIButton(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic2 = UIButton(frame: CGRect(x: picScrollView.frame.width/2+5, y: 0, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic3 = UIButton(frame: CGRect(x: 0, y: imageHeight+10, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic4 = UIButton(frame: CGRect(x: picScrollView.frame.width/2+5, y: imageHeight+10, width: imageWidth, height: imageHeight), image: picAddImage)
        
        picList.append(pic1)
        picList.append(pic2)
        picList.append(pic3)
        picList.append(pic4)
        
        for picObj in picList{
            picObj.boxLayout(backgroundColor: UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00))
            picScrollView.addSubview(picObj)
            picObj.addControlEvent(.TouchUpInside){
                self.blackScreen.hidden = false
                self.picSelectedView.hidden = false
                self.cropBtnSpace = picObj
            }
        }
        picScrollView.contentSize = CGSize(width: picScrollView.frame.width, height: (imageHeight+10)*2)
        
        locationBtn.boxLayout(radius: 6)
        categoryBtn.boxLayout(radius: 6)
        descTextView.boxLayout(radius: 6, borderWidth: 1, borderColor: Util.commonColor)
        descTextView.delegate = self
        
        
        
        
        //layout
        
        blackScreen = UIButton(frame: self.view.frame)
        picSelectedView = UIView(frame: CGRect(x: (self.view.frame.width/2-125), y: (self.view.frame.height/2-125), width: 250, height: 250))
        let picSelectedHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: picSelectedView.frame.width, height: 40))
        let picSelectedHeaderLbl = UILabel(frame: CGRect(x: 0, y: 0, width: picSelectedHeaderView.frame.width, height: picSelectedHeaderView.frame.height), text: "타입 선택", color: UIColor.whiteColor(), textAlignment: NSTextAlignment.Center)
        let cameraView = UIView(frame: CGRect(x: 5, y: 60, width: (picSelectedView.frame.width-20)/2, height: picSelectedView.frame.height-80))
        let cameraLbl = UILabel(frame: CGRect(x: 0, y: cameraView.frame.width+10, width: cameraView.frame.width, height: 20), text: "카메라", textAlignment: NSTextAlignment.Center)
        let cameraBtn = UIButton(frame: CGRect(x: 20, y: 40, width: cameraView.frame.width-40, height: cameraView.frame.width-40), named: "ic_pic_type_camera.png", view: cameraView)
        let gallaryView = UIView(frame: CGRect(x: 15+(picSelectedView.frame.width-20)/2, y: 60, width: (picSelectedView.frame.width-20)/2, height: picSelectedView.frame.height-80))
        let gallaryLbl = UILabel(frame: CGRect(x: 0, y: gallaryView.frame.width+10, width: gallaryView.frame.width, height: 20), text: "앨범", textAlignment: NSTextAlignment.Center)
        let gallaryBtn = UIButton(frame: CGRect(x: 20, y: 40, width: gallaryView.frame.width-40, height: gallaryView.frame.width-40), named: "ic_pic_type_gallary.png", view: gallaryView)
        
        blackScreen.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        blackScreen.hidden = true
        picSelectedView.hidden = true
        picSelectedView.backgroundColor = UIColor.whiteColor()
        picSelectedHeaderView.backgroundColor = Util.commonColor
        cameraView.boxLayout(borderWidth: 1, borderColor: UIColor.orangeColor())
        gallaryView.boxLayout(borderWidth: 1, borderColor: UIColor.orangeColor())
        
        self.view.addSubview(blackScreen)
        self.view.addSubview(picSelectedView)
        picSelectedView.addSubview(picSelectedHeaderView)
        picSelectedView.addSubview(cameraView)
        picSelectedView.addSubview(gallaryView)
        picSelectedHeaderView.addSubview(picSelectedHeaderLbl)
        cameraView.addSubview(cameraLbl)
        gallaryView.addSubview(gallaryLbl)
        
        //카메라 클릭
        cameraBtn.addControlEvent(.TouchUpInside){
            self.imageCallback(UIImagePickerControllerSourceType.Camera)
        }
        //갤러리 클릭
        gallaryBtn.addControlEvent(.TouchUpInside){
            self.imageCallback(UIImagePickerControllerSourceType.PhotoLibrary)
        }
        blackScreen.addControlEvent(.TouchUpInside){
            self.blackScreen.hidden = true
            self.picSelectedView.hidden = true
        }
    }
    
    
    
    
    
    //이미지 콜백
    func imageCallback(sourceType : UIImagePickerControllerSourceType){
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        presentViewController(picker, animated: true, completion: nil)
    }
    //이미지 끝
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //이미지 받아오기
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        imageCropLayout()
        self.blackScreen.hidden = true
        self.picSelectedView.hidden = true
        self.imgCropView.hidden = false
        crop = ImageCrop()
        self.crop.setCrop(canvasView, image: newImage, width: self.imageWidth, height: self.imageHeight, initRate: 1, minRate: 1/2, maxRate: self.view.frame.width/self.imageWidth, cropColor: UIColor.whiteColor(), cropDotSize: 18)
        dismissViewControllerAnimated(true, completion: nil)
    }
    /////////크롭화면
    func imageCropLayout(){
        if imgCropView != nil{
            self.imgCropView.subviews.forEach {$0.removeFromSuperview()}
        }
        imgCropView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: imgCropView.frame.width, height: 20))
        let centerView = UIView(frame: CGRect(x: 0, y: 20, width: imgCropView.frame.width, height: imgCropView.frame.height-20))
        
        let scaleBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30), view: centerView, text: "축소")
        let rotateBtn = UIButton(frame: CGRect(x: 50, y: 10, width: 30, height: 30), view: centerView, text: "회전")
        canvasView = UIView(frame: CGRect(x: 0, y: 50, width: centerView.frame.width, height: centerView.frame.height-160))
        let backBtn = UIButton(frame: CGRect(x: 20, y: centerView.frame.height-30, width: 20, height: 20), image: UIImage(named: "ic_back.png")!)
        let saveBtn = UIButton(frame: CGRect(x: centerView.frame.width-40, y: centerView.frame.height-30, width: 20, height: 20), view: centerView, text: "✓")
        saveBtn.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: (saveBtn.titleLabel?.font.fontName)!, size: 25), size: 25)
        
        imgCropView.hidden = true
        topView.backgroundColor = UIColor.lightGrayColor()
        centerView.backgroundColor = UIColor.blackColor()
        scaleBtn.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: (scaleBtn.titleLabel!.font?.fontName)!, size: 10.0), size: 10.0)
        scaleBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.whiteColor(), borderColor: UIColor.brownColor())
        rotateBtn.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: (scaleBtn.titleLabel!.font?.fontName)!, size: 10.0), size: 10.0)
        rotateBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.whiteColor(), borderColor: UIColor.brownColor())
        saveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.view.addSubview(imgCropView)
        imgCropView.addSubview(topView)
        imgCropView.addSubview(centerView)
        centerView.addSubview(canvasView)
        centerView.addSubview(saveBtn)
        centerView.addSubview(rotateBtn)
        centerView.addSubview(backBtn)
        centerView.addSubview(saveBtn)
        
        backBtn.addControlEvent(.TouchUpInside){
            self.imgCropView.hidden = true
        }
        scaleBtn.addControlEvent(.TouchUpInside){
            if self.crop.scale(){
                scaleBtn.setTitle("확대", forState: .Normal)
            }else{
                scaleBtn.setTitle("축소", forState: .Normal)
            }
        }
        rotateBtn.addControlEvent(.TouchUpInside){
            self.crop.rotate()
        }
        
        saveBtn.addControlEvent(.TouchUpInside){
            let image = self.crop.capture()
            self.cropBtnSpace.setImage(image, forState: .Normal)
            self.imgCropView.hidden = true
        }
    }
    
    
    
    
    
    //위치설정 클릭
    @IBAction func locationAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtCreateMapVC")
        (uvc as! CourtCreateMapViewController).courtCreateView = self
        (uvc as! CourtCreateMapViewController).courtCreateViewLocationBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    //종목설정 클릭
    @IBAction func categoryAction(sender: AnyObject) {
        let alert = UIAlertController(title: "종목을 선택해주세요", message: "종목설정", preferredStyle: .ActionSheet)
        let categoryList = Storage.getStorage("categoryList") as! [[String: AnyObject]]
        for category in categoryList{
            alert.addAction(UIAlertAction(title: "\(category["name"]!)", style: .Default, handler: { (alert) in
                self.categoryBtn.setTitle(alert.title, forState: .Normal)
                self.category = category["seq"] as! Int
            }))
        }
        self.presentViewController(alert, animated: false, completion: {(_) in})
    }
    
    //등록 클릭
    @IBAction func saveAction(sender: AnyObject) {
        var cropImageCnt = 0
        for btn in self.picList{
            if btn.currentImage != self.picAddImage{
                cropImageCnt += 1
            }
        }
        
        if cropImageCnt >= 2{
            if courtLatitude == nil || courtLongitude == nil || courtAddress == nil || courtAddressShort == nil || courtAddress == "" || courtAddressShort == ""{
                Util.alert("", message: "위치를 선택해 주세요.", confirmTitle: "확인", ctrl: self, confirmHandler: { (_) in
                })
            }else if(category == nil){
                Util.alert("", message: "카테고리를 선택해 주세요.", confirmTitle: "확인", ctrl: self, confirmHandler: { (_) in
                })
            }else{
                var parameters : [String: AnyObject] = ["token": self.user.token, "id": self.user.userId, "latitude": self.courtLatitude, "longitude": self.courtLongitude, "address": self.courtAddress, "addressShort": self.courtAddressShort, "category": self.category, "description": self.descTextView.text!]
                
                var idx = 1
                for btn in self.picList{
                    break;
                    if btn.currentImage != self.picAddImage{
                        let img = btn.currentImage
                        
                        let imageData = Util.returnImageData(img, ext: Ext.JPEG)
                        let base64 = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                        if idx == 1{
                            parameters["pic1"] = base64
                        }else if idx == 2{
                            parameters["pic2"] = base64
                        }else if idx == 3{
                            parameters["pic3"] = base64
                        }else if idx == 4{
                            parameters["pic4"] = base64
                        }
                        idx += 1
                    }
                }
                
                Alamofire.request(.GET, URL.court_create, parameters: parameters)
                    .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .responseData { response in
                        let data : NSData = response.data!
                        let dic = Util.convertStringToDictionary(data)
                        if let code = dic["code"] as? Int{
                            if code == 0{
                                Util.alert("", message: "등록이 완료되었습니다.", confirmTitle: "확인", ctrl: self, confirmHandler: { (_) in
                                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                                })
                            }else{
                                if let isMsgView = dic["isMsgView"] as? Bool{
                                    if isMsgView == true{
                                        Util.alert(message: "\(dic["msg"]!)", ctrl: self)
                                    }
                                }
                            }
                        }
                }
            }
        }else{
            Util.alert("", message: "이미지를 2장 이상 올려야 됩니다.", confirmTitle: "확인", ctrl: self, confirmHandler: { (_) in
            })
        }
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
            
            mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: mainScrollViewHeight+keyboardSize.height+10)
            mainScrollView.scrollToBottom()
        }
    }
    //키보드없어질때
    func keyboardWillHide(notification: NSNotification) {
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: mainScrollViewHeight)
        mainScrollView.scrollToTop()
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


