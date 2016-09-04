//
//  CourtCreateViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

class CourtCreateViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, AdobeUXImageEditorViewControllerDelegate{
    
    @IBOutlet var spin: UIActivityIndicatorView!
    //전체 스크롤 뷰
    @IBOutlet var mainScrollView: UIScrollView!
    //전체 스크롤뷰 스크롤 height
    var mainScrollViewHeight: CGFloat!
    //이미지 스크롤 뷰
    @IBOutlet var picScrollView: UIScrollView!
    //크롭버튼 어떤것을 클릭했는지 담아두는 변수
    var cropBtnSpace : UIButton!
    //빈 크롭 버튼 이미지
    let picAddImage = UIImage(named: "ic_image.png")!
    //크롭 버튼 리스트
    var picList = [UIButton]()
    //이미지 피커
    let picker = UIImagePickerController()
    //블랙스크린
    var blackScreen : UIButton!
    
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
    //코트 별칭
    @IBOutlet var cnameTextField: UITextField!
    //코트 설명 텍스트뷰
    @IBOutlet var descTextView: UITextView!
    
    
    //user
    let user = Storage.getRealmUser()
    
    var nonUserView : NonUserView!
    
    
    //temp이미지버튼
    var tempImageBtn: UIButton!
    
    override func viewDidLoad() {
        print("CourtCreateViewController viewDidLoad")
        
        spin.hidden = true
        mainScrollViewHeight = mainScrollView.frame.height
        imageWidth = picScrollView.frame.width/2-5
        imageHeight = imageWidth * 120 / 192
        picScrollView.contentSize = CGSize(width: picScrollView.frame.width, height: (imageHeight+10)*2)
        cnameTextField.delegate = self
        descTextView.delegate = self
        
        layoutInit()
    }
    
    func layoutInit(){
        picScrollView.subviews.forEach({$0.removeFromSuperview()})
        locationBtn.setTitle("위치 설정", forState: .Normal)
        courtLatitude = nil
        courtLongitude = nil
        courtAddress = nil
        courtAddressShort = nil
        categoryBtn.setTitle("종목 설정", forState: .Normal)
        category = nil
        cnameTextField.text = ""
        descTextView.text = ""
        
        let pic1 = UIButton(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        let pic2 = UIButton(frame: CGRect(x: picScrollView.frame.width/2+5, y: 0, width: imageWidth, height: imageHeight))
        let pic3 = UIButton(frame: CGRect(x: 0, y: imageHeight+10, width: imageWidth, height: imageHeight))
        let pic4 = UIButton(frame: CGRect(x: picScrollView.frame.width/2+5, y: imageHeight+10, width: imageWidth, height: imageHeight))
        
        picList.append(pic1)
        picList.append(pic2)
        picList.append(pic3)
        picList.append(pic4)
        
        for picObj in picList{
            picScrollView.addSubview(picObj)
            
            //하나의 버튼 더 만듬
            let picBtn = UIButton(frame: CGRect(x: 0, y: 0, width: picObj.frame.width, height: picObj.frame.height))
            picBtn.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)
            picBtn.setImage(picAddImage, forState: .Normal)
            picObj.addSubview(picBtn)
            
            func btnClick(){
                self.tempImageBtn = picBtn
                let alert = UIAlertController(title: "", message: "사진타입선택", preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "카메라", style: .Default, handler: { (alert) in
                    self.imageCallback(UIImagePickerControllerSourceType.Camera)
                }))
                alert.addAction(UIAlertAction(title: "사진첩", style: .Default, handler: { (alert) in
                    self.imageCallback(UIImagePickerControllerSourceType.PhotoLibrary)
                }))
                self.presentViewController(alert, animated: false, completion: {(_) in})
            }
            
            picObj.addControlEvent(.TouchUpInside){
                btnClick()
            }
            picBtn.addControlEvent(.TouchUpInside){
                btnClick()
            }
        }
    }
    
    //로그인했을때 로그아웃했을때 레이아웃 변경
    func layout(){
        if user.isLogin != -1{
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
        }else{
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            self.view.addSubview(nonUserView)
        }
    }
    
    
    
    //이미지 콜백
    func imageCallback(sourceType : UIImagePickerControllerSourceType){
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        presentViewController(picker, animated: false, completion: nil)
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
        
        
        
        dismissViewControllerAnimated(false, completion: {(_) in
            //AdobeImageEditor 실행
            dispatch_async(dispatch_get_main_queue()) {
                AdobeImageEditorCustomization.setToolOrder([
                    kAdobeImageEditorEnhance,        /* Enhance */
                    kAdobeImageEditorEffects,        /* Effects */
                    kAdobeImageEditorStickers,       /* Stickers */
                    kAdobeImageEditorOrientation,    /* Orientation */
                    kAdobeImageEditorCrop,           /* Crop */
                    kAdobeImageEditorColorAdjust,    /* Color */
                    kAdobeImageEditorLightingAdjust, /* Lighting */
                    kAdobeImageEditorSharpness,      /* Sharpness */
                    kAdobeImageEditorDraw,           /* Draw */
                    kAdobeImageEditorText,           /* Text */
                    kAdobeImageEditorRedeye,         /* Redeye */
                    kAdobeImageEditorWhiten,         /* Whiten */
                    kAdobeImageEditorBlemish,        /* Blemish */
                    kAdobeImageEditorBlur,           /* Blur */
                    kAdobeImageEditorMeme,           /* Meme */
                    kAdobeImageEditorFrames,         /* Frames */
                    kAdobeImageEditorFocus,          /* TiltShift */
                    kAdobeImageEditorSplash,         /* ColorSplash */
                    kAdobeImageEditorOverlay,        /* Overlay */
                    kAdobeImageEditorVignette        /* Vignette */
                    ])
                
                let adobeViewCtr = AdobeUXImageEditorViewController(image: newImage)
                adobeViewCtr.delegate = self
                self.presentViewController(adobeViewCtr, animated: false) { () -> Void in
                    
                }
            }
        })
    }
    
    
    //AdobeCreativeSDK 이미지 받아옴
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        editor.dismissViewControllerAnimated(true, completion: {(_) in
            let rateWidth = (image?.size.width)!/self.imageWidth
            let rateHeight = (image?.size.height)!/self.imageHeight
            
            var widthValue : CGFloat! = self.imageWidth
            var heightValue : CGFloat! = self.imageHeight
            
            if rateWidth > rateHeight{
                heightValue = widthValue * (image?.size.height)! / (image?.size.width)!
            }else{
                widthValue = heightValue * (image?.size.width)! / (image?.size.height)!
            }
            self.tempImageBtn.frame = CGRect(x: (self.imageWidth-widthValue)/2, y: (self.imageHeight-heightValue)/2, width: widthValue, height: heightValue)
            self.tempImageBtn.setImage(image, forState: .Normal)
        })
    }
    //AdobeCreativeSDK 캔슬
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        editor.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //위치설정 클릭
    @IBAction func locationAction(sender: AnyObject) {
        if spin.hidden == false{
            return;
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("mapVC")
        (uvc as! MapViewController).preView = self
        (uvc as! MapViewController).preBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    //종목설정 클릭
    @IBAction func categoryAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
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
        if spin.hidden == false{
            return;
        }
        var cropImageCnt = 0
        for btn in self.picList{
            if btn.currentImage != self.picAddImage{
                cropImageCnt += 1
            }
        }
        
        if cropImageCnt >= 2{
            if courtLatitude == nil || courtLongitude == nil || courtAddress == nil || courtAddressShort == nil || courtAddress == "" || courtAddressShort == ""{
                self.spin.hidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "위치를 선택해 주세요.")
            }else if(category == nil){
                self.spin.hidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "카테고리를 선택해 주세요.")
            }else if(cnameTextField.text! == ""){
                self.spin.hidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "별칭을 입력해 주세요.")
            }else{
                //이미지 배열
                var picArray : [UIImage] = [UIImage]()
                for btn in self.picList{
                    if btn.currentImage != self.picAddImage{
                        let img = btn.currentImage
                        picArray.append(img!)
                    }
                }
                spin.hidden = false
                spin.startAnimating()
                let parameters : [String: AnyObject] = ["token": self.user.token, "id": self.user.userId, "latitude": self.courtLatitude, "longitude": self.courtLongitude, "address": self.courtAddress, "addressShort": self.courtAddressShort, "category": self.category, "description": self.descTextView.text!, "picArrayCount": picArray.count, "cname": cnameTextField.text!]
                Alamofire.request(.GET, URL.court_create, parameters: parameters)
                    .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .responseData { response in
                        self.spin.hidden = true
                        self.spin.stopAnimating()
                        let data : NSData = response.data!
                        let dic = Util.convertStringToDictionary(data)
                        if let code = dic["code"] as? Int{
                            if code == 0{
                                if let seq = dic["seq"] as? Int{
                                    //이미지서버로 통신
                                    self.spin.hidden = false
                                    self.spin.startAnimating()
                                    //통신
                                    Alamofire.upload(.POST, "\(URL.courtUpload)\(seq)",
                                        multipartFormData: { multipartFormData in
                                            var idx = 0
                                            let nameArray = ["pic1", "pic2", "pic3", "pic4"]
                                            for pic in picArray{
                                                let imageData : NSData = Util.returnImageData(pic, ext: ExtType.JPEG)
                                                multipartFormData.appendBodyPart(data: imageData, name: nameArray[idx], fileName: "\(nameArray[idx]).jpeg", mimeType: "image/jpeg")
                                                idx += 1
                                            }
                                        },encodingCompletion: { encodingResult in
                                            switch encodingResult {
                                            case .Success(let upload, _, _):
                                                upload.responseJSON { response in
                                                    self.spin.hidden = true
                                                    self.spin.stopAnimating()
                                                    let data : NSData = response.data!
                                                    let dic = Util.convertStringToDictionary(data)
                                                    if let code = dic["code"] as? Int{
                                                        if code == 0{
                                                            Util.alert(self, message: "등록이 완료되었습니다.", confirmTitle: "확인", confirmHandler: { (_) in
                                                                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                                                            })
                                                        }
                                                    }
                                                }
                                            case .Failure(let encodingError):
                                                print(encodingError)
                                                self.spin.hidden = true
                                                self.spin.stopAnimating()
                                            }
                                        }
                                    )
                                }
                            }else{
                                self.spin.hidden = true
                                self.spin.stopAnimating()
                                if let isMsgView = dic["isMsgView"] as? Bool{
                                    if isMsgView == true{
                                        Util.alert(self, message: "\(dic["msg"]!)")
                                    }
                                }
                            }
                        }
                }
            }
        }else{
            self.spin.hidden = true
            self.spin.stopAnimating()
            Util.alert(self, message: "이미지를 2장 이상 올려야 됩니다.")
        }
    }
    
    
    
    
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(animated: Bool) {
        print("CourtCreateViewController viewWillAppear")
        if nonUserView == nil{
            if let customView = NSBundle.mainBundle().loadNibNamed("NonUserView", owner: self, options: nil).first as? NonUserView {
                customView.frame = self.view.frame
                nonUserView = customView
                layout()
            }
        }else{
            layout()
        }
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