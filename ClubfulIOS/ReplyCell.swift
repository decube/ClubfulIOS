//
//  ReplyCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 26..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {
    
    @IBOutlet var context: UILabel!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var date: UILabel!
    
    func setReply(_ reply: Reply){
        self.context.text = reply.context
        self.nickname.text = reply.nickName
        self.date.text = reply.date
    }
}
