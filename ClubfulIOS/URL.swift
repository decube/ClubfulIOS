//
//  URL.swift
//  Oyanggo
//
//  Created by guanho on 2016. 7. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation

class URL{
    static let urlCheck = "https://clubfulstaticserver-guanho.c9users.io/urlCheck.json"
    
    static var appServer = ""
    static var imageServer = ""
    static var courtUpload = ""
    
    static let version_Check = URL.appServer+"version/check_success.json";
    static let version_app = URL.appServer+"version/app_success.json";
    
    static let court_create = URL.appServer+"court/create_success.json";
    static let court_detail = URL.appServer+"court/detail_success.json";
    static let court_interest = URL.appServer+"court/interest_success.json";
    static let court_listSearch = URL.appServer+"court/listSearch_success.json";
    static let court_replyInsert = URL.appServer+"court/replyInsert_success.json";
    
    static let location_geocode = URL.appServer+"location/geocode_success.json";
    
    static let user_join = URL.appServer+"user/join_success.json";
    static let user_login = URL.appServer+"user/login_success.json";
    static let user_logout = URL.appServer+"user/logout_success.json";
    static let user_mypage = URL.appServer+"user/mypage_success.json";
    static let user_set = URL.appServer+"user/set_success.json";
    static let user_update = URL.appServer+"user/update_success.json";
}