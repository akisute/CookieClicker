//
//  InGame.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/12.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BigInt

public class InGame {
    
    public static let instance: InGame = InGame()
    
    public let cookieStack: CookieStack
    private let upgradesVariable: Variable<[UpgradeType]>
    
    public init() {
        self.cookieStack = CookieStack()
        self.upgradesVariable = Variable([
            Upgrade_1_Click(),
            Upgrade_2_Periodic(),
            ])
    }
    
}

extension InGame {
    
    public var upgrades: [UpgradeType] {
        return self.upgradesVariable.value
    }
    
    public var rx_upgrades: Observable<[UpgradeType]> {
        return self.upgradesVariable.asObservable()
    }
    
}

extension InGame {
    
    public func action_click() -> Observable<BigUInt> {
        return Observable.create { [unowned self] observer in
            let baseValue = BigUInt(1)
            let (bonusValue, bonusPercent): (BigUInt, Double) = self.upgrades.reduce((BigUInt(0), 0), combine: { currentBonuses, upgrade in
                let (currentValue, currentPercent) = currentBonuses
                let (upgradeValue, upgradePercent) = upgrade.onClickFunc(upgrade, self, baseValue)
                return (currentValue + upgradeValue, currentPercent + upgradePercent)
            })

            let gainBase = (baseValue + bonusValue)
            let gainPercentBonus = gainBase.divideByDigit(100).div * BigUInt(Int(bonusPercent * 100))
            let gain = gainBase + gainPercentBonus
            print("onClick - bonusValue:\(bonusValue), bonusPercent:\(bonusPercent), gainBase:\(gainBase), gainPercentBonus:\(gainPercentBonus), gain:\(gain)")
            
            self.cookieStack.add(gain)
            observer.on(.Next(gain))
            observer.on(.Completed)
            return AnonymousDisposable {}
        }
    }
    
    public enum UpgradeResult {
        case Success
        case NotEnoughCost
    }
    
    public func action_upgrade(index: Int) -> Observable<InGame.UpgradeResult> {
        return Observable.create { [unowned self] observer in
            var upgrades = self.upgrades
            if (index < 0 || index >= upgrades.count) {
                observer.on(.Error(RxError.ArgumentOutOfRange))
                return AnonymousDisposable {}
            }
            let upgrade = upgrades[index]
            let upgradeCost = upgrade.upgradeCost(self)
            if (upgradeCost > self.cookieStack.count) {
                observer.on(.Next(.NotEnoughCost))
                observer.on(.Completed)
                return AnonymousDisposable {}
            }
            self.cookieStack.sub(upgradeCost)
            upgrade.upgrade(self)
            upgrades[index] = upgrade
            self.upgradesVariable.value  = upgrades
            observer.on(.Next(.Success))
            observer.on(.Completed)
            return AnonymousDisposable {}
        }
    }
    
}
