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
    
    func action_click() -> Observable<BigUInt> {
        return Observable.create { observer in
            let gain = BigUInt(1)
            self.cookieStack.add(gain)
            observer.on(.Next(gain))
            observer.on(.Completed)
            return AnonymousDisposable {
            }
        }
    }
    
    func action_upgrade(id: Int) -> Observable<Void> {
        return Observable.create { observer in
            return AnonymousDisposable {
            }
        }
    }
    
}
