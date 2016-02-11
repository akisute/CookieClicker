//
//  CookieStackManager.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation

public class CookieStackManager {
    public static let instance: CookieStackManager = CookieStackManager()
    
    public let cookieStack: CookieStack = CookieStack()
}
