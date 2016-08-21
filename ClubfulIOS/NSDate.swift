//
//  NSDate.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation


extension NSDate{
    func yearInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Year, fromDate: self)
        let year = components.year
        return year
    }
    func monthInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Month, fromDate: self)
        let month = components.month
        return month
    }
    func dayInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Day, fromDate: self)
        let day = components.day
        return day
    }
    func hourInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        return hour
    }
    func minuteInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        return minute
    }
    func secondInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Second, fromDate: self)
        let second = components.second
        return second
    }
    func year(calendar : NSCalendar) -> String{
        return "\(yearInt(calendar))"
    }
    func month(calendar : NSCalendar) -> String{
        let month = monthInt(calendar)
        if month < 10{
            return "0\(month)"
        }else{
            return "\(month)"
        }
    }
    func day(calendar : NSCalendar) -> String{
        let day = dayInt(calendar)
        if day < 10{
            return "0\(day)"
        }else{
            return "\(day)"
        }
    }
    func hour(calendar : NSCalendar) -> String{
        let hour = hourInt(calendar)
        if hour < 10{
            return "0\(hour)"
        }else{
            return "\(hour)"
        }
    }
    func minute(calendar : NSCalendar) -> String{
        let minute = minuteInt(calendar)
        if minute < 10{
            return "0\(minute)"
        }else{
            return "\(minute)"
        }
    }
    func second(calendar : NSCalendar) -> String{
        let second = secondInt(calendar)
        if second < 10{
            return "0\(second)"
        }else{
            return "\(second)"
        }
    }
    func getDate() -> String{
        let calendar = NSCalendar.currentCalendar()
        return "\(year(calendar))-\(month(calendar))-\(day(calendar))"
    }
    func getTime() -> String{
        let calendar = NSCalendar.currentCalendar()
        return "\(hour(calendar)):\(minute(calendar)):\(second(calendar))"
    }
    func getFullDate() -> String{
        return "\(getDate()) \(getTime())"
    }
}