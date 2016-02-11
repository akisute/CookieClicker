//
//  String+Localization.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/12.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation

extension String {
    
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    public func localized(args: CVarArgType...) -> String {
        return NSString(format: self.localized, arguments: getVaList(args)) as String
    }
    
}