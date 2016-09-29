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
    var mainScrollViewHeight: CGFloat = 0
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
    
    
    let pic1 = UIButton()
    let pic2 = UIButton()
    let pic3 = UIButton()
    let pic4 = UIButton()
    var picBtnList = [UIButton]()
    
    //회전됬을때
    func rotated(){
        if user.isLogin != -1{
            self.view.endEditing(true)
            picLayout()
            print("rotate : \(mainScrollView.bounds.height)")
        }
    }
    
    override func viewDidLoad() {
        print("CourtCreateViewController viewDidLoad")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //mainScrollViewHeight = mainScrollView.bounds.height
        spin.isHidden = true
        
        cnameTextField.delegate = self
        descTextView.delegate = self
        layoutInit()
    }
    
    func picLayout(){
        self.imageWidth = self.view.frame.width/2-5
        self.imageHeight = self.imageWidth * 120 / 192
        self.picScrollView.contentSize = CGSize(width: self.view.frame.width, height: (imageHeight+10)*2)
        
        self.pic1.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        self.pic2.frame = CGRect(x: imageWidth+10, y: 0, width: imageWidth, height: imageHeight)
        self.pic3.frame = CGRect(x: 0, y: imageHeight+10, width: imageWidth, height: imageHeight)
        self.pic4.frame = CGRect(x: imageWidth+10, y: imageHeight+10, width: imageWidth, height: imageHeight)
        for picObj in picList{
            picObj.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        }
    }
    
    func layoutInit(){
        picList = [UIButton]()
        picScrollView.subviews.forEach({$0.removeFromSuperview()})
        locationBtn.setTitle("위치 설정", for: UIControlState())
        courtLatitude = nil
        courtLongitude = nil
        courtAddress = nil
        courtAddressShort = nil
        categoryBtn.setTitle("종목 설정", for: UIControlState())
        category = nil
        cnameTextField.text = ""
        descTextView.text = ""
        
        picBtnList.append(pic1)
        picBtnList.append(pic2)
        picBtnList.append(pic3)
        picBtnList.append(pic4)
        
        for picObj in picBtnList{
            picScrollView.addSubview(picObj)
            
            //하나의 버튼 더 만듬
            let picBtn = UIButton(frame: CGRect(x: 0, y: 0, width: picObj.frame.width, height: picObj.frame.height))
            picBtn.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)
            picBtn.setImage(self.picAddImage, for: UIControlState())
            
            picList.append(picBtn)
            
            picObj.addSubview(picBtn)
            func btnClick(){
                self.view.endEditing(true)
                self.tempImageBtn = picBtn
                let alert = UIAlertController(title: "", message: "사진타입선택", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (alert) in
                    self.imageCallback(UIImagePickerControllerSourceType.camera)
                }))
                alert.addAction(UIAlertAction(title: "사진첩", style: .default, handler: { (alert) in
                    self.imageCallback(UIImagePickerControllerSourceType.photoLibrary)
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (alert) in
                    
                }))
                self.present(alert, animated: false, completion: {(_) in
                })
            }
            
            picObj.addAction(.touchUpInside){
                btnClick()
            }
            picBtn.addAction(.touchUpInside){
                btnClick()
            }
        }
        
        picLayout()
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
    func imageCallback(_ sourceType : UIImagePickerControllerSourceType){
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: false, completion: nil)
    }
    //이미지 끝
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //이미지 받아오기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        
        
        dismiss(animated: false, completion: {(_) in
            //AdobeImageEditor 실행
            DispatchQueue.main.async {
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
                self.present(adobeViewCtr, animated: false) { () -> Void in
                    
                }
            }
        })
    }
    
    
    //AdobeCreativeSDK 이미지 받아옴
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        editor.dismiss(animated: true, completion: {(_) in
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
            self.tempImageBtn.setImage(image, for: UIControlState())
        })
    }
    //AdobeCreativeSDK 캔슬
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        editor.dismiss(animated: true, completion: nil)
    }
    
    
    
    //위치설정 클릭
    @IBAction func locationAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if spin.isHidden == false{
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "mapVC")
        (uvc as! MapViewController).preView = self
        (uvc as! MapViewController).preBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    
    //종목설정 클릭
    @IBAction func categoryAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if spin.isHidden == false{
            return
        }
        let alert = UIAlertController(title: "종목을 선택해주세요", message: "종목설정", preferredStyle: .actionSheet)
        let categoryList = Storage.getStorage("categoryList") as! [[String: AnyObject]]
        for category in categoryList{
            alert.addAction(UIAlertAction(title: "\(category["name"]!)", style: .default, handler: { (alert) in
                self.categoryBtn.setTitle(alert.title, for: UIControlState())
                self.category = category["seq"] as! Int
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (alert) in
            
        }))
        self.present(alert, animated: false, completion: {(_) in})
    }
    
    //등록 클릭
    @IBAction func saveAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if spin.isHidden == false{
            return
        }
        var cropImageCnt = 0
        for btn in self.picList{
            if btn.currentImage != self.picAddImage{
                cropImageCnt += 1
            }
        }
        
        if cropImageCnt >= 2{
            if courtLatitude == nil || courtLongitude == nil || courtAddress == nil || courtAddressShort == nil || courtAddress == "" || courtAddressShort == ""{
                self.spin.isHidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "위치를 선택해 주세요.")
            }else if(category == nil){
                self.spin.isHidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "카테고리를 선택해 주세요.")
            }else if(cnameTextField.text! == ""){
                self.spin.isHidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "별칭을 입력해 주세요.")
            }else{
                //이미지 배열
                var picArray : [UIImage] = [UIImage]()
                var picNameArray : [String] = []
                var idx = 1
                for btn in self.picList{
                    if btn.currentImage != self.picAddImage{
                        let img = btn.currentImage
                        picArray.append(img!)
                        picNameArray.append("pic\(idx).jpeg")
                        idx += 1
                    }
                }
                spin.isHidden = false
                spin.startAnimating()
                let parameters : [String: AnyObject] = ["token": self.user.token as AnyObject, "id": self.user.userId as AnyObject, "latitude": self.courtLatitude as AnyObject, "longitude": self.courtLongitude as AnyObject, "address": self.courtAddress as AnyObject, "addressShort": self.courtAddressShort as AnyObject, "category": self.category as AnyObject, "description": self.descTextView.text! as AnyObject, "picNameArray": picNameArray as AnyObject, "cname": cnameTextField.text! as AnyObject]
                URL.request(self, url: URL.apiServer+URL.api_court_create, param: parameters, callback: { (dic) in
                    if let seq = dic["seq"] as? Int{
                        //이미지서버로 통신
                        self.spin.isHidden = false
                        self.spin.startAnimating()
                        //통신
                        Alamofire.upload(
                            multipartFormData: { multipartFormData in
                                var idx = 0
                                let nameArray = ["pic1", "pic2", "pic3", "pic4"]
                                for pic in picArray{
                                    let imageData : Data = Util.returnImageData(pic, ext: ExtType.jpeg)
                                    multipartFormData.append(imageData, withName: "\(nameArray[idx]).jpeg")
                                    idx += 1
                                }
                            },
                            to: "\(URL.courtUpload)\(seq)",
                            encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        self.spin.isHidden = true
                                        self.spin.stopAnimating()
                                        let data : NSData = response.data! as NSData
                                        let dic = Util.convertStringToDictionary(data as Data)
                                        if let code = dic["code"] as? Int{
                                            if code == 0{
                                                Util.alert(self, message: "등록이 완료되었습니다.", confirmTitle: "확인", confirmHandler: { (_) in
                                                    self.layoutInit()
                                                    self.view.endEditing(true)
                                                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                                                })
                                            }
                                        }
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                    self.spin.isHidden = true
                                    self.spin.stopAnimating()
                                }
                            }
                        )
                    }
                }, codeErrorCallback: { (dic) in
                    self.spin.isHidden = true
                    self.spin.stopAnimating()
                })
            }
        }else{
            self.spin.isHidden = true
            self.spin.stopAnimating()
            Util.alert(self, message: "이미지를 2장 이상 올려야 됩니다.")
            self.view.endEditing(true)
        }
    }
    
    
    
    
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(_ animated: Bool) {
        print("CourtCreateViewController viewWillAppear")
        if nonUserView == nil{
            if let customView = Bundle.main.loadNibNamed("NonUserView", owner: self, options: nil)?.first as? NonUserView {
                nonUserView = customView
                nonUserView.frame = self.view.frame
                layout()
            }
        }else{
            layout()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardWillShow : \(self.view.bounds.height)")
            mainScrollView.contentSize.height = mainScrollView.bounds.height+keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        mainScrollView.contentSize.height = mainScrollView.bounds.height
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
