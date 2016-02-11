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
    var rx_effect: Observable<BigUInt> {get}
}
