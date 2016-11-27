//
//  CourtCreateViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

class CourtCreateViewController: UIViewController{
    @IBOutlet var spin: UIActivityIndicatorView!
    //위치설정 버튼
    @IBOutlet var locationBtn: UIButton!
    //종목설정 버튼
    @IBOutlet var categoryBtn: UIButton!
    //코트 별칭
    @IBOutlet var cnameTextField: UITextField!
    //코트 설명 텍스트뷰
    @IBOutlet var descTextView: UITextView!
    //전체 스크롤 뷰
    @IBOutlet var mainScrollView: UIScrollView!
    var mainScrollViewHeight: CGFloat = 0
    //이미지 스크롤 뷰
    @IBOutlet var picScrollView: UIScrollView!
    
    var court : Court!
    var address : Address!
    
    //이미지 피커
    let picker = UIImagePickerController()
    
    var nonUserView : NonUserView!
    var pic1: PicView!
    var pic2: PicView!
    var pic3: PicView!
    var pic4: PicView!
    var picTemp: PicView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        self.spin.isHidden = true
        self.cnameTextField.delegate = self
        self.descTextView.delegate = self
        self.court = Court()
        self.address = Address()
        
        DispatchQueue.main.async {
            self.layoutInit()
        }
    }
    
    func layoutInit(){
        self.picScrollView.subviews.forEach({$0.removeFromSuperview()})
        self.locationBtn.setTitle("위치 설정", for: UIControlState())
        categoryBtn.setTitle("종목 설정", for: UIControlState())
        cnameTextField.text = ""
        descTextView.text = ""
        self.court = Court()
        self.address = Address()
        
        func picClick(_ pic: PicView){
            self.picTemp = pic
            self.view.endEditing(true)
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
        
        
        if let customView = Bundle.main.loadNibNamed("PicView", owner: self, options: nil)?.first as? PicView {
            self.pic1 = customView
        }
        if let customView = Bundle.main.loadNibNamed("PicView", owner: self, options: nil)?.first as? PicView {
            self.pic2 = customView
        }
        if let customView = Bundle.main.loadNibNamed("PicView", owner: self, options: nil)?.first as? PicView {
            self.pic3 = customView
        }
        if let customView = Bundle.main.loadNibNamed("PicView", owner: self, options: nil)?.first as? PicView {
            self.pic4 = customView
        }
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async {
                self.mainScrollViewHeight = self.mainScrollView.contentSize.height
                
                let imageWidth = self.picScrollView.frame.width/2-5
                let imageHeight = imageWidth * 120 / 192
                
                self.picScrollView.contentSize = CGSize(width: self.picScrollView.frame.width, height: (imageHeight+10)*2)
                
                self.pic1.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
                self.pic2.frame = CGRect(x: imageWidth+10, y: 0, width: imageWidth, height: imageHeight)
                self.pic3.frame = CGRect(x: 0, y: imageHeight+10, width: imageWidth, height: imageHeight)
                self.pic4.frame = CGRect(x: imageWidth+10, y: imageHeight+10, width: imageWidth, height:imageHeight)
                self.pic1.touchCallback = {(_) in picClick(self.pic1)}
                self.pic2.touchCallback = {(_) in picClick(self.pic2)}
                self.pic3.touchCallback = {(_) in picClick(self.pic3)}
                self.pic4.touchCallback = {(_) in picClick(self.pic4)}
                self.picScrollView.addSubview(self.pic1)
                self.picScrollView.addSubview(self.pic2)
                self.picScrollView.addSubview(self.pic3)
                self.picScrollView.addSubview(self.pic4)
            }
        }
    }
    
    
    //이미지 콜백
    func imageCallback(_ sourceType : UIImagePickerControllerSourceType){
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: false, completion: nil)
    }
    
    //사이즈 줄이기
    func resizeImage(image: UIImage, size: CGSize) -> UIImage{
        let imageValue = Util.imageResize(image, sizeChange: size)
        if Util.returnImageData(imageValue, ext: .png).count > (1024*1024){
            return resizeImage(image: imageValue, size: CGSize(width: size.width-100, height: (size.width-100)/5*3))
        }else{
            return imageValue
        }
    }
    
    
    
    
    
    
    
    
    
    //위치설정 클릭
    @IBAction func locationAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if spin.isHidden == false{
            return
        }
        performSegue(withIdentifier: "courtCreate_map", sender: nil)
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
                self.court.categorySeq = category["seq"] as! Int
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
        if btn.currentImage != self.picAddImage{
            cropImageCnt += 1
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
                let user = Storage.getRealmUser()
                let parameters : [String: AnyObject] = ["id": user.userId as AnyObject, "latitude": self.courtLatitude as AnyObject, "longitude": self.courtLongitude as AnyObject, "address": self.courtAddress as AnyObject, "addressShort": self.courtAddressShort as AnyObject, "category": self.category as AnyObject, "description": self.descTextView.text! as AnyObject, "picNameArray": picNameArray as AnyObject, "cname": cnameTextField.text! as AnyObject]
                URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_create, param: parameters, callback: { (dic) in
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
                                    multipartFormData.append(imageData, withName: nameArray[idx], fileName: "\(nameArray[idx]).jpeg", mimeType: "image/jpeg")
                                    idx += 1
                                }
                            },
                            to: "\(URLReq.courtUpload)\(seq)",
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
                                case .failure(_):
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
}

extension CourtCreateViewController{
    override func viewWillAppear(_ animated: Bool) {
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
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController{
            vc.preAddress = self.address
            vc.preBtn = self.locationBtn
        }
    }
    
    //로그인했을때 로그아웃했을때 레이아웃 변경
    func layout(){
        if Storage.isRealmUser(){
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
}


extension CourtCreateViewController: UINavigationControllerDelegate{
}

extension CourtCreateViewController: UITextViewDelegate{
}

extension CourtCreateViewController: UITextFieldDelegate{
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            mainScrollView.contentSize.height = self.mainScrollViewHeight+keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        mainScrollView.contentSize.height = self.mainScrollViewHeight
    }
    //뷰 클릭했을때
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}




extension CourtCreateViewController: UIImagePickerControllerDelegate{
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
                //사용자가 비율 마음대로 지정
                AdobeImageEditorCustomization.setCropToolCustomEnabled(false)
                AdobeImageEditorCustomization.setCropToolInvertEnabled(false)
                AdobeImageEditorCustomization.setCropToolOriginalEnabled(false)
                
                let _ : Array<Dictionary<String, Any>>  = [
                    [
                        "kAdobeImageEditorCropPresetName":"Option1",
                        "kAdobeImageEditorCropPresetWidth":3,
                        "kAdobeImageEditorCropPresetHeight":7
                    ]
                ]
                //AdobeImageEditorCustomization.setCropToolPresets(cropCustom)
                
                
                let adobeViewCtr = AdobeUXImageEditorViewController(image: newImage)
                adobeViewCtr.delegate = self
                self.present(adobeViewCtr, animated: false) { () -> Void in
                    
                }
            }
        })
    }
}
extension CourtCreateViewController: AdobeUXImageEditorViewControllerDelegate{
    //AdobeCreativeSDK 이미지 받아옴
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        editor.dismiss(animated: true, completion: {(_) in
            let imageCrop = self.resizeImage(image: (image?.crop(to: CGSize(width: 500, height: 300)))!, size: CGSize(width: 500, height: 300))
            self.picTemp.imageView.image = imageCrop
        })
    }
    //AdobeCreativeSDK 캔슬
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        editor.dismiss(animated: true, completion: nil)
    }
}
