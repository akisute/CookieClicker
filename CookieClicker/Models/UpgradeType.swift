//
//  UpgradeType.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import RxSwift
import BigInt


public protocol UpgradeType {
    var id: Int {get}
    var name: String {get}
    var desc: String {get}
    var upgradeLevel: Int {get}
    var upgradeCost: BigUInt {get}
    
    func upgrade()
}


public class UpgradeBase: UpgradeType {
    public let id: Int
    public let name: String
    public let desc: String
    public private(set) var upgradeLevel: Int
    public let upgradeCostFunc: (Int) -> (BigUInt)
    
    public init(id: Int, name: String, desc: String, upgradeCostFunc: (Int) -> (BigUInt)) {
        self.id = id
        self.name = name
        self.desc = desc
        self.upgradeLevel = 0
        self.upgradeCostFunc = upgradeCostFunc
    }
    
    public var upgradeCost: BigUInt {
        return self.upgradeCostFunc(self.upgradeLevel)
    }
    
    public func upgrade() {
        self.upgradeLevel += 1
    }
    
}
