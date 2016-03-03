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
    
    public class InGameClock: NSObject {
        
        public let FPS: Double = 20.0
        
        private weak var timer: NSTimer?
        private var startedDateVariable: Variable<NSDate?>
        private var lastTickDateVariable: Variable<NSDate?>
        private var tickDate: NSDate?
        
        private override init() {
            self.timer = nil
            self.startedDateVariable = Variable(nil)
            self.lastTickDateVariable = Variable(nil)
            self.tickDate = nil
        }
        
        deinit {
            self.stop()
        }
        
        private func start() {
            let timer = NSTimer.scheduledTimerWithTimeInterval(1.0/FPS, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
            self.timer = timer
            if self.startedDateVariable.value == nil {
                self.startedDateVariable.value = NSDate()
            }
            if self.tickDate == nil {
                self.tickDate = NSDate()
            }
        }
        
        private func pause() {
            self.timer?.invalidate()
        }
        
        private func stop() {
            self.timer?.invalidate()
            self.startedDateVariable.value = nil
            self.lastTickDateVariable.value = nil
            self.tickDate = nil
        }
        
        func onTimer(timer: NSTimer) {
            self.lastTickDateVariable.value = self.tickDate
            self.tickDate = NSDate()
        }
        
        public var gameTime: NSTimeInterval {
            if let date = self.startedDateVariable.value {
                return -date.timeIntervalSinceNow
            } else {
                return 0
            }
        }
        
        public var deltaTime: NSTimeInterval {
            if let date = self.lastTickDateVariable.value {
                return -date.timeIntervalSinceNow
            } else {
                return 0
            }
        }
        
        public var rx_tick: Observable<(gameTime: NSTimeInterval, deltaTime: NSTimeInterval)> {
            // Implementation #1. Very dumb, not cool nor Rx-ish
            return self.lastTickDateVariable
                .asObservable()
                .map { (_: NSDate?)-> (NSTimeInterval, NSTimeInterval) in
                    return (self.gameTime, self.deltaTime)
            }
        }
        
        public var rx_tick2: Observable<(gameTime: NSTimeInterval, deltaTime: NSTimeInterval)> {
            // Implementation #2, using CombineLatest (or in this case withLatestFrom)
            return self.lastTickDateVariable
                .asObservable()
                .withLatestFrom(self.startedDateVariable.asObservable()) { (lastTickDate: NSDate?, startedDate: NSDate?) -> (NSTimeInterval, NSTimeInterval) in
                    if let lastTickDate = lastTickDate, startedDate = startedDate {
                        return (-startedDate.timeIntervalSinceNow, -lastTickDate.timeIntervalSinceNow)
                    } else {
                        return (0, 0)
                    }
            }
        }
    }
    
    public static let instance: InGame = InGame()
    
    public let cookieStack: CookieStack
    public let clock: InGameClock
    private let upgradesVariable: Variable<[UpgradeType]>
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    public init() {
        self.cookieStack = CookieStack()
        self.upgradesVariable = Variable([
            Upgrade_1_Click(),
            Upgrade_2_Periodic(),
            ])
        self.clock = InGameClock()
    }
    
    public func start() {
        self.clock.rx_tick
            .asDriver(onErrorJustReturn: (0, 0))
            .driveNext { gameTime, deltaTime in
                //print("ぁっぉタイマー \(gameTime) \(deltaTime)")
                let (bonusValue, bonusPercent): (BigUInt, Double) = self.upgrades.reduce((BigUInt(0), 0), combine: { currentBonuses, upgrade in
                    let (currentValue, currentPercent) = currentBonuses
                    let (upgradeValue, upgradePercent) = (upgrade.onTickFunc(upgrade, self), Double(0))
                    return (currentValue + upgradeValue, currentPercent + upgradePercent)
                })
                let gainBase = bonusValue
                let gainPercentBonus =  (gainBase * BigUInt(Int(bonusPercent * 100))).divideByDigit(100).div
                let gain = gainBase + gainPercentBonus
                //print("onTick - bonusValue:\(bonusValue), bonusPercent:\(bonusPercent), gainBase:\(gainBase), gainPercentBonus:\(gainPercentBonus), gain:\(gain)")
                self.cookieStack.add(gain)
            }
            .addDisposableTo(self.disposeBag)
        self.clock.start()
    }
    
    public func pause() {
        self.clock.pause()
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
            let gainPercentBonus =  (gainBase * BigUInt(Int(bonusPercent * 100))).divideByDigit(100).div
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
