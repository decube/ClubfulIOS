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
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight: CGFloat = 0
    
    var court : Court!
    var address : Address!
    
    //이미지 피커
    let picker = UIImagePickerController()
    
    @IBOutlet var pic1: PicView!
    @IBOutlet var pic2: PicView!
    @IBOutlet var pic3: PicView!
    @IBOutlet var pic4: PicView!
    var nonUserView : NonUserView!
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
        
        func picClick(_ pic: PicView){
            if spin.isHidden == false{
                return
            }
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
        self.pic1.touchCallback = {(_) in picClick(self.pic1)}
        self.pic2.touchCallback = {(_) in picClick(self.pic2)}
        self.pic3.touchCallback = {(_) in picClick(self.pic3)}
        self.pic4.touchCallback = {(_) in picClick(self.pic4)}
        
        DispatchQueue.main.async {
            self.layoutInit()
        }
    }
    
    func layoutInit(){
        self.locationBtn.setTitle("위치 설정", for: UIControlState())
        categoryBtn.setTitle("종목 설정", for: UIControlState())
        cnameTextField.text = ""
        descTextView.text = ""
        self.court = Court()
        self.address = Address()
        self.picTemp = nil
        func imageInit(_ tempView: UIView){
            tempView.subviews.forEach { (v) in
                if let imgView = v as? PicImageView{
                    imgView.image = UIImage()
                }
            }
        }
        imageInit(self.pic1)
        imageInit(self.pic2)
        imageInit(self.pic3)
        imageInit(self.pic4)
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async {
                self.scrollViewHeight = self.scrollView.contentSize.height
            }
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
            alert.addAction(UIAlertAction(title: "\(category["categoryNM"]!)", style: .default, handler: { (alert) in
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
            //return
        }
        self.spin.isHidden = false
        self.spin.startAnimating()
        
        var picArray : [UIImage] = [UIImage]()
        var picNameArray : [String] = []
        var idx = 1
        func imageCnt(_ tempView: UIView){
            tempView.subviews.forEach { (v) in
                if let imgView = v as? PicImageView{
                    if imgView.image?.size != CGSize(width: 0, height: 0){
                        picArray.append(imgView.image!)
                        picNameArray.append("pic\(idx).jpeg")
                        idx += 1
                    }
                }
            }
        }
        imageCnt(self.pic1)
        imageCnt(self.pic2)
        imageCnt(self.pic3)
        imageCnt(self.pic4)
        
        if idx >= 2{
            if self.address.latitude == nil || self.address.longitude == nil || self.address.address == nil || self.address.addressShort == nil || self.address.address == "" || self.address.addressShort == ""{
                self.spin.isHidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "위치를 선택해 주세요.")
            }else if(self.court.categorySeq == nil){
                self.spin.isHidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "카테고리를 선택해 주세요.")
            }else if(cnameTextField.text! == ""){
                self.spin.isHidden = true
                self.spin.stopAnimating()
                Util.alert(self, message: "별칭을 입력해 주세요.")
            }else{
                self.courtInsert(picArray: picArray, picNameArray: picNameArray)
            }
        }else{
            self.spin.isHidden = true
            self.spin.stopAnimating()
            Util.alert(self, message: "이미지를 2장 이상 올려야 됩니다.")
            self.view.endEditing(true)
        }
    }
    
    
    func courtInsert(picArray: [UIImage], picNameArray: [String]){
        let user = Storage.getRealmUser()
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(user.userId as AnyObject, forKey: "id")
        parameters.updateValue(self.address.latitude as AnyObject, forKey: "latitude")
        parameters.updateValue(self.address.longitude as AnyObject, forKey: "longitude")
        parameters.updateValue(self.address.address as AnyObject, forKey: "address")
        parameters.updateValue(self.address.addressShort as AnyObject, forKey: "addressShort")
        parameters.updateValue(self.court.categorySeq as AnyObject, forKey: "category")
        parameters.updateValue(self.descTextView.text! as AnyObject, forKey: "description")
        parameters.updateValue(picNameArray as AnyObject, forKey: "picNameArray")
        parameters.updateValue(cnameTextField.text! as AnyObject, forKey: "cname")
        
        URLReq.request(self, url: URLReq.apiServer+"court/create", param: parameters, callback: { (dic) in
            if let seq = dic["seq"] as? Int{
                self.courtImageInsert(seq, picArray: picArray, picNameArray: picNameArray)
            }
        }, codeErrorCallback: { (dic) in
            self.spin.isHidden = true
            self.spin.stopAnimating()
        })
    }
    
    func courtImageInsert(_ seq: Int, picArray: [UIImage], picNameArray: [String]){
        self.spin.isHidden = false
        self.spin.startAnimating()
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
        })
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
}


extension CourtCreateViewController: UINavigationControllerDelegate{
}

extension CourtCreateViewController: UITextViewDelegate{
}

extension CourtCreateViewController: UITextFieldDelegate{
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentSize.height = self.scrollViewHeight+keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentSize.height = self.scrollViewHeight
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
                
//                let _ : Array<Dictionary<String, Any>>  = [
//                    [
//                        "kAdobeImageEditorCropPresetName":"Option1",
//                        "kAdobeImageEditorCropPresetWidth":3,
//                        "kAdobeImageEditorCropPresetHeight":7
//                    ]
//                ]
//                AdobeImageEditorCustomization.setCropToolPresets(cropCustom)
                
                
                let adobeViewCtrl = AdobeUXImageEditorViewController(image: newImage)
                adobeViewCtrl.delegate = self
                self.present(adobeViewCtrl, animated: false) { () -> Void in
                    
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
            self.picTemp.subviews.forEach({ (view) in
                if let v = view as? PicImageView{
                    v.image = imageCrop
                }
            })
        })
    }
    //AdobeCreativeSDK 캔슬
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        editor.dismiss(animated: true, completion: nil)
    }
}
