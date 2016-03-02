//
//  UpgradesListCell.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/12.
//  Copyright © 2016年 akisute. All rights reserved.
//

import UIKit

class UpgradesListCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var upgradeLevelLabel: UILabel!
    @IBOutlet var upgradeCostLabel: UILabel!
    
    var upgrade: UpgradeType? {
        didSet {
            if let upgrade = upgrade {
                let upgradeCost = upgrade.upgradeCost(InGame.instance)
                self.nameLabel.text = upgrade.name
                self.descLabel.text = upgrade.desc
                self.upgradeLevelLabel.text = "Lv %@".localized(upgrade.upgradeLevel.description)
                self.upgradeCostLabel.text = "Cost: %@".localized(upgradeCost.inGameDescription)
            } else {
                self.nameLabel.text = ""
                self.descLabel.text = ""
                self.upgradeLevelLabel.text = "Lv %@".localized("0")
                self.upgradeCostLabel.text = "Cost: %@".localized("0")
            }
        }
    }
    
}
