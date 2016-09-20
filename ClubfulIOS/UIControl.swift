//
//  UIControl.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 9. 20..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class ActionSingleton {
    var allEventDict: [UIView : () -> ()] = Dictionary()
    var allEditingEventDict: [UIView : () -> ()] = Dictionary()
    var allTouchEventDict: [UIView : () -> ()] = Dictionary()
    var editingChangedEventDict: [UIView : () -> ()] = Dictionary()
    var editingDidBeginEventDict: [UIView : () -> ()] = Dictionary()
    var editingDidEndEventDict: [UIView : () -> ()] = Dictionary()
    var editingDidEndOnExitEventDict: [UIView : () -> ()] = Dictionary()
    var touchCancelEventDict: [UIView : () -> ()] = Dictionary()
    var touchDownEventDict: [UIView : () -> ()] = Dictionary()
    var touchDownRepeatEventDict: [UIView : () -> ()] = Dictionary()
    var touchDragEnterEventDict: [UIView : () -> ()] = Dictionary()
    var touchDragExitEventDict: [UIView : () -> ()] = Dictionary()
    var touchDragInsideEventDict: [UIView : () -> ()] = Dictionary()
    var touchDragOutsideEventDict: [UIView : () -> ()] = Dictionary()
    var touchUpInsideEventDict: [UIView : () -> ()] = Dictionary()
    var touchUpOutsideEventDict: [UIView : () -> ()] = Dictionary()
    
    class var sharedInstance : ActionSingleton {
        struct Action {
            static let instance : ActionSingleton = ActionSingleton()
        }
        return Action.instance
    }
}

extension UIControl{
    func addAction(type: UIControlEvents, action: ((Void) -> Void)){
        let actionSingleton = ActionSingleton.sharedInstance
        if type == .AllEvents{
            actionSingleton.allEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerAllAction), forControlEvents: type)
        }else if type == .AllEditingEvents{
            actionSingleton.allEditingEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerAllEditingAction), forControlEvents: type)
        }else if type == .AllTouchEvents{
            actionSingleton.allTouchEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerAllTouchAction), forControlEvents: type)
        }else if type == .EditingChanged{
            actionSingleton.editingChangedEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerEditingChangedAction), forControlEvents: type)
        }else if type == .EditingDidBegin{
            actionSingleton.editingDidBeginEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerEditingDidBeginAction), forControlEvents: type)
        }else if type == .EditingDidEnd{
            actionSingleton.editingDidEndEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerEditingDidEndAction), forControlEvents: type)
        }else if type == .EditingDidEndOnExit{
            actionSingleton.editingDidEndOnExitEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerEditingDidEndOnExitAction), forControlEvents: type)
        }else if type == .TouchCancel{
            actionSingleton.touchCancelEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchCancelAction), forControlEvents: type)
        }else if type == .TouchDown{
            actionSingleton.touchDownEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchDownAction), forControlEvents: type)
        }else if type == .TouchDownRepeat{
            actionSingleton.touchDownRepeatEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchDownRepeatAction), forControlEvents: type)
        }else if type == .TouchDragEnter{
            actionSingleton.touchDragEnterEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchDragEnterAction), forControlEvents: type)
        }else if type == .TouchDragExit{
            actionSingleton.touchDragExitEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchDragExitAction), forControlEvents: type)
        }else if type == .TouchDragInside{
            actionSingleton.touchDragInsideEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchDragInsideAction), forControlEvents: type)
        }else if type == .TouchDragOutside{
            actionSingleton.touchDragOutsideEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchDragOutsideAction), forControlEvents: type)
        }else if type == .TouchUpInside{
            actionSingleton.touchUpInsideEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchUpInsideAction), forControlEvents: type)
        }else if type == .TouchUpOutside{
            actionSingleton.touchUpOutsideEventDict.updateValue( action, forKey: self)
            self.addTarget(self, action: #selector(self.triggerTouchUpOutsideAction), forControlEvents: type)
        }
    }
    @objc private func triggerAllAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.allEventDict[self]!()
    }
    @objc private func triggerAllEditingAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.allEditingEventDict[self]!()
    }
    @objc private func triggerAllTouchAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.allTouchEventDict[self]!()
    }
    @objc private func triggerEditingChangedAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.editingChangedEventDict[self]!()
    }
    @objc private func triggerEditingDidBeginAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.editingDidBeginEventDict[self]!()
    }
    @objc private func triggerEditingDidEndAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.editingDidEndEventDict[self]!()
    }
    @objc private func triggerEditingDidEndOnExitAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.editingDidEndOnExitEventDict[self]!()
    }
    @objc private func triggerTouchCancelAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchCancelEventDict[self]!()
    }
    @objc private func triggerTouchDownAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchDownEventDict[self]!()
    }
    @objc private func triggerTouchDownRepeatAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchDownRepeatEventDict[self]!()
    }
    @objc private func triggerTouchDragEnterAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchDragEnterEventDict[self]!()
    }
    @objc private func triggerTouchDragExitAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchDragExitEventDict[self]!()
    }
    @objc private func triggerTouchDragInsideAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchDragInsideEventDict[self]!()
    }
    @objc private func triggerTouchDragOutsideAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchDragOutsideEventDict[self]!()
    }
    @objc private func triggerTouchUpInsideAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchUpInsideEventDict[self]!()
    }
    @objc private func triggerTouchUpOutsideAction(){
        let actionSingleton = ActionSingleton.sharedInstance
        actionSingleton.touchUpOutsideEventDict[self]!()
    }
}