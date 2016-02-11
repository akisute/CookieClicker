//
//  UpgradeManager.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation

public class UpgradeManager {
    
    public static let instance = UpgradeManager()
    
    private var upgrades: [UpgradeType]
    
    private init() {
        self.upgrades = [Upgrade_1_Click()]
    }
    
}
