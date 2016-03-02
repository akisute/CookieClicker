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
    var upgradeCostFunc: (UpgradeType, InGame) -> BigUInt {get}
    var onClickFunc: (UpgradeType, InGame, BigUInt) -> (BigUInt, Double) {get}
    var onTickFunc: (UpgradeType, InGame) -> BigUInt {get}
    
    func upgradeCost(inGame: InGame) -> BigUInt
    func upgrade(inGame: InGame)
}


public class UpgradeBase: UpgradeType {
    public let id: Int
    public let name: String
    public let desc: String
    public private(set) var upgradeLevel: Int
    public let upgradeCostFunc: (UpgradeType, InGame) -> BigUInt
    public let onClickFunc: (UpgradeType, InGame, BigUInt) -> (BigUInt, Double)
    public let onTickFunc: (UpgradeType, InGame) -> BigUInt
    
    public init(
        id: Int,
        name: String,
        desc: String,
        upgradeCostFunc: (UpgradeType, InGame) -> BigUInt,
        onClickFunc: (UpgradeType, InGame, BigUInt) -> (BigUInt, Double),
        onTickFunc: (UpgradeType, InGame) -> BigUInt
        ) {
            self.id = id
            self.name = name
            self.desc = desc
            self.upgradeLevel = 0
            self.upgradeCostFunc = upgradeCostFunc
            self.onClickFunc = onClickFunc
            self.onTickFunc = onTickFunc
    }
    
    public func upgradeCost(inGame: InGame) -> BigUInt {
        return self.upgradeCostFunc(self, inGame)
    }
    
    public func upgrade(inGame: InGame) {
        self.upgradeLevel += 1
    }
    
}
