//
//  MainLeftViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 29..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainLeftViewController: UIViewController{
    var interactor:Interactor? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}