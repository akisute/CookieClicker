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
    private let countSubject:BehaviorSubject<BigUInt> = BehaviorSubject<BigUInt>(value: BigUInt(0))
}

private extension CookieStack {
    
}

public extension CookieStack {
    public var countString: String {
        do {
            return try self.countSubject.value().description
        } catch {
            fatalError()
        }
    }
    public var rx_countString: Observable<String> {
        return self.countSubject.asObservable().map{ count in
            return count.description
        }
    }
}
