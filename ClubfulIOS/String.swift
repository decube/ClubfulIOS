//
//  String.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation

extension String {
    //substring 추가
    public func substring(from:Int = 0, to:Int = -1) -> String {
        var toTmp = to
        if toTmp < 0 {
            toTmp = self.characters.count + toTmp
        }
        //from toTmp+1
        let range = self.startIndex.advancedBy(from)..<self.startIndex.advancedBy(toTmp+1)
        return self.substringWithRange(range)
    }
    public func substring(from:Int = 0, length:Int) -> String {
        let range = self.startIndex.advancedBy(from)..<self.startIndex.advancedBy(from+length)
        return self.substringWithRange(range)
    }
    
    public func range() -> Range<Index>{
        let range = self.startIndex.advancedBy(0)..<self.startIndex.advancedBy(self.characters.count-1)
        return range
    }
    public func queryValue() -> String{
        let value = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        return value!
    }
}