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

private extension CookieStack {
    
}

public extension CookieStack {
    
    public var countString: String {
        return try! self.countSubject.value().description
    }
    
    public var rx_countString: Observable<String> {
        return self.countSubject.asObservable().map{ count in
            return count.description
        }
    }
    
    public func add(count: Int) {
        let value = try! self.countSubject.value()
        self.countSubject.onNext(value + BigUInt(count))
    }
    
}
