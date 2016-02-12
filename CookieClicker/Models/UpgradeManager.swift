//
//  UpgradeManager.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class UpgradeManager {
    
    public static let instance = UpgradeManager()
    
    private let upgradeVariables: Variable<[UpgradeType]>
    
    private init() {
        self.upgradeVariables = Variable([
            Upgrade_1_Click(),
            Upgrade_2_Periodic(),
            ])
    }
    
}

extension UpgradeManager {
    
    public var upgrades: [UpgradeType] {
        return self.upgradeVariables.value
    }
    
    public var rx_upgrades: Observable<[UpgradeType]> {
        return self.upgradeVariables.asObservable()
    }
    
}
