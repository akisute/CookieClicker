//
//  CookieStack.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import Foundation
import RxSwift
import BigInt

public struct CookieStack {
    private let disposeBag: DisposeBag = DisposeBag()
    private let countSubject:BehaviorSubject<BigUInt> = BehaviorSubject<BigUInt>(value: BigUInt(0))
    
    public init() {
        self.disposeBag.addDisposable(self.countSubject)
    }
}

extension CookieStack {
    
    public var count: BigUInt {
        return try! self.countSubject.value()
    }
    
    public var rx_count: Observable<BigUInt> {
        return self.countSubject.asObservable()
    }
    
    public func add(count: BigUInt) {
        let value = try! self.countSubject.value()
        self.countSubject.onNext(value + count)
    }
    
}
