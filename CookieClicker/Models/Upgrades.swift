//
//  Upgrades.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import RxSwift
import BigInt

public class Upgrade_1_Click: UpgradeBase {
    public static let ID: Int = 1
    public init() {
        super.init(
            id: Upgrade_1_Click.ID,
            name: "Upgrade_1_name".localized,
            desc: "Upgrade_1_desc".localized,
            upgradeCostFunc: { upgrade, inGame in
                return BigUInt((upgrade.upgradeLevel + 1) * 20)
            },
            onClickFunc: { upgrade, inGame, baseValue in
                return (BigUInt(upgrade.upgradeLevel * 1), 0)
            },
            onTickFunc: { upgrade, inGame in
                return BigUInt(0)
            }
        )
    }
}

public class Upgrade_2_Periodic: UpgradeBase {
    public static let ID: Int = 2
    public init() {
        super.init(
            id: Upgrade_2_Periodic.ID,
            name: "Upgrade_2_name".localized,
            desc: "Upgrade_2_desc".localized,
            upgradeCostFunc: { upgrade, inGame in
                return BigUInt((upgrade.upgradeLevel + 1) * 40)
            },
            onClickFunc: { upgrade, inGame, baseValue in
                return (BigUInt(0), Double(upgrade.upgradeLevel) * 0.005)
            },
            onTickFunc: { upgradeLevel, inGame in
                return BigUInt(0)
            }
        )
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
