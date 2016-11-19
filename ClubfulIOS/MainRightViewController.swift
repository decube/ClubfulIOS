//
//  MainRightViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 29..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainRightViewController: UIViewController, UIWebViewDelegate{
    var interactor:Interactor? = nil
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url : Foundation.URL(string: "https://www.instagram.com/guanho9/")!))
        
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
