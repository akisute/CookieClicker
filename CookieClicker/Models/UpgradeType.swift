//
//  UpgradeType.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import BigInt
import RxSwift


public protocol UpgradeType {
    var id: Int {get}
    var name: String {get}
    var desc: String {get}
    var upgradeLevel: Int {get}
    var upgradeCost: BigUInt {get}
    
    var rx_upgradeLevel: Observable<Int> {get}
    
    func upgrade()
}


public class UpgradeBase: UpgradeType {
    public let id: Int
    public let name: String
    public let desc: String
    public let upgradeCostFunc: (Int) -> (BigUInt)
    
    private let upgradeLevelSubject: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    public init(id: Int, name: String, desc: String, upgradeCostFunc: (Int) -> (BigUInt)) {
        self.id = id
        self.name = name
        self.desc = desc
        self.upgradeCostFunc = upgradeCostFunc
    }
    
    public var upgradeLevel: Int {
        return try! self.upgradeLevelSubject.value()
    }
    
    public var upgradeCost: BigUInt {
        return self.upgradeCostFunc(self.upgradeLevel)
    }
    
    public var rx_upgradeLevel: Observable<Int> {
        return self.upgradeLevelSubject.asObservable()
    }
    
    public func upgrade() {
        self.upgradeLevelSubject.onNext(self.upgradeLevel + 1)
    }
}
