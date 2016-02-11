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

public class Upgrade_1_Click: UpgradeBase {
    public init() {
        super.init(
            id: 1,
            name: "Upgrade_1_name".localized,
            desc: "Upgrade_1_desc".localized,
            upgradeCostFunc: { BigUInt($0 * 20) } )
    }
}

public class Upgrade_2_Periodic: UpgradeBase {
    public init() {
        super.init(
            id: 1,
            name: "Upgrade_2_name".localized,
            desc: "Upgrade_2_desc".localized,
            upgradeCostFunc: { BigUInt($0 * 400) } )
    }
}





/*

/// Upgrade that can be decoded from external JSON data rather than hard-coded.
public struct DecodableUpgrade: UpgradeType {
    public init(json: String) {
        // decode json into the struct, including upgradeCost function and effect function
    }
}

*/
