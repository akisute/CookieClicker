//
//  Upgrades.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import BigInt
import RxSwift

public struct Upgrade_1_Click: UpgradeType {
    public var id: Int {
        return 1
    }
    public var name: String {
        return ""
    }
    public var desc: String {
        return ""
    }
    
    public private(set) var upgradeLevel: Int = 0
    
    public var upgradeCost: BigUInt {
        return BigUInt(20 * self.upgradeLevel)
    }
    
    public var rx_upgradeLevel: Observable<Int> {
        // TODO
        return Observable.just(self.upgradeLevel)
    }
    
    public var rx_effect: Observable<BigUInt> {
        // TODO
        return Observable.never()
    }
}



/*
public struct DecotableUpgrade: UpgradeType {
    public init(json: String) {
        // decode json into the struct, including upgradeCost function and effect function
    }
}
*/