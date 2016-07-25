//
//  URL.swift
//  Oyanggo
//
//  Created by guanho on 2016. 7. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation

class URL{
    static private let path = "https://oyanggo-guanho.c9users.io/";
    static let version_Check = URL.path+"version/check_success.json";
    static let version_app = URL.path+"version/app_success.json";
    
    static let court_create = URL.path+"court/create_success.json";
    static let court_detail = URL.path+"court/detail_success.json";
    static let court_interest = URL.path+"court/interest_success.json";
    static let court_listSearch = URL.path+"court/listSearch_success.json";
    static let court_replyInsert = URL.path+"court/replyInsert_success.json";
    
    static let location_geocode = URL.path+"location/geocode_success.json";
    
    static let user_join = URL.path+"user/join_success.json";
    static let user_login = URL.path+"user/login_success.json";
    static let user_logout = URL.path+"user/logout_success.json";
    static let user_mypage = URL.path+"user/mypage_success.json";
    static let user_set = URL.path+"user/set_success.json";
    static let user_update = URL.path+"user/update_success.json";
}