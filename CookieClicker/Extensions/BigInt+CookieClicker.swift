//
//  BigInt+CookieClicker.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/12.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import BigInt

extension BigUInt {
    public var ingameDescription: String {
        // TODO: describe self with K, M, G, etc...
        return self.description
    }
}
