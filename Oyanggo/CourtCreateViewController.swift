//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtCreateViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    var picList = [UIButton]()
    let picker = UIImagePickerController()
    var blackScreen : UIButton!
    var picSelectedView : UIView!
    var imgCropView : UIView!
    var canvasView : UIView!
    var crop : ImageCrop!
    
    var imageWidth : CGFloat!
    var imageHeight : CGFloat!
    
    var cropTmpBtn : UIButton!
    override func viewDidLoad() {
        print("CourtCreateViewController viewDidLoad")
        
        let picInputLbl = UILabel(frame: CGRect(x: 10, y: 95, width: Util.screenSize.width-10, height: 20), text: "사진은 최소 2장이상 올리셔야 합니다.", textAlignment: .Left, fontSize: 17)
        let picView = UIScrollView(frame: CGRect(x: 10, y: 120, width: Util.screenSize.width-20, height: Util.screenSize.height/3))
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
        picView.boxLayout(borderWidth: 1, borderColor: Util.commonColor)
        picSelectedView.backgroundColor = UIColor.whiteColor()
        picSelectedHeaderView.backgroundColor = Util.commonColor
        cameraView.boxLayout(borderWidth: 1, borderColor: UIColor.orangeColor())
        gallaryView.boxLayout(borderWidth: 1, borderColor: UIColor.orangeColor())
        
        
        self.view.addSubview(picInputLbl)
        self.view.addSubview(picView)
        //이미지크롭 이후 레이아웃
        nextLayout()
        /////////////
        self.view.addSubview(blackScreen)
        self.view.addSubview(picSelectedView)
        picSelectedView.addSubview(picSelectedHeaderView)
        picSelectedHeaderView.addSubview(picSelectedHeaderLbl)
        picSelectedView.addSubview(cameraView)
        cameraView.addSubview(cameraLbl)
        picSelectedView.addSubview(gallaryView)
        gallaryView.addSubview(gallaryLbl)
        
        let picAddImage = UIImage(named: "pic_add.png")!
        
        imageWidth = picView.frame.width/2-5
        imageHeight = imageWidth * 120 / 192
        
        let pic1 = UIButton(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic2 = UIButton(frame: CGRect(x: picView.frame.width/2+5, y: 0, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic3 = UIButton(frame: CGRect(x: 0, y: imageHeight+10, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic4 = UIButton(frame: CGRect(x: picView.frame.width/2+5, y: imageHeight+10, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic5 = UIButton(frame: CGRect(x: 0, y: (imageHeight+10)*2, width: imageWidth, height: imageHeight), image: picAddImage)
        let pic6 = UIButton(frame: CGRect(x: picView.frame.width/2+5, y: (imageHeight+10)*2, width: imageWidth, height: imageHeight), image: picAddImage)
        
        picList.append(pic1)
        picList.append(pic2)
        picList.append(pic3)
        picList.append(pic4)
        picList.append(pic5)
        picList.append(pic6)
        
        for picObj in picList{
            picObj.boxLayout(backgroundColor: UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00))
            picView.addSubview(picObj)
            picObj.addControlEvent(.TouchUpInside){
                self.blackScreen.hidden = false
                self.picSelectedView.hidden = false
                self.cropTmpBtn = picObj
            }
        }
        picView.contentSize = CGSize(width: picView.frame.width, height: (imageHeight+10)*3)
        
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
        
        
        
        CustomView.initLayout(self, title: "코트등록")
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
            self.cropTmpBtn.setImage(image, forState: .Normal)
            self.imgCropView.hidden = true
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
    
    
    
    
    
    
    //이미지 크롭 다음 레이아웃
    func nextLayout(){
        let locationBtn = UIButton(frame: CGRect(x: 10, y: 140+Util.screenSize.height/3, width: self.view.frame.width/2-20, height: 30))
        locationBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: Util.commonColor, borderColor: UIColor.blackColor())
        locationBtn.setTitle("위치설정", forState: .Normal)
        locationBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.view.addSubview(locationBtn)
        
        let categorySelect = UIButton(frame: CGRect(x: self.view.frame.width/2+10, y: 140+Util.screenSize.height/3, width: self.view.frame.width/2-20, height: 30))
        categorySelect.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.blackColor(), borderColor: Util.commonColor)
        categorySelect.setTitle("종목설정", forState: .Normal)
        categorySelect.setTitleColor(Util.commonColor, forState: .Normal)
        self.view.addSubview(categorySelect)
        
        categorySelect.addControlEvent(.TouchUpInside){
            let alert = UIAlertController(title: "종목을 선택해주세요", message: "종목설정", preferredStyle: .ActionSheet)
            for i in 1 ... 10{
                alert.addAction(UIAlertAction(title: "농구", style: .Default, handler: { (alert) in
                    categorySelect.setTitle(alert.title, forState: .Normal)
                }))
            }
            self.presentViewController(alert, animated: false, completion: {(_) in})
        }
        
        
        let descText = UITextView(frame: CGRect(x: 10, y: 200+Util.screenSize.height/3, width: self.view.frame.width-20, height: 80))
        descText.boxLayout(radius: 6, borderWidth: 1, borderColor: Util.commonColor)
        descText.delegate = self
        self.view.addSubview(descText)
        
        let saveBtn = UIButton(frame: CGRect(x: 10, y: Util.screenSize.height - 40, width: self.view.frame.width-20, height: 30))
        saveBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: Util.commonColor, borderColor: UIColor.blackColor())
        saveBtn.setTitle("등록", forState: .Normal)
        saveBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.view.addSubview(saveBtn)
    }
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}


