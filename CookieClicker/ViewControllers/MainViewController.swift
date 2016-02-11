//
//  MainViewController.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet var cookieButton: UIButton!
    
}

extension MainViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cookieStackCountStringSubscription = CookieStackManager.instance.cookieStack.rx_countString.subscribeOn(MainScheduler.instance).subscribe { event in
            switch (event) {
            case let .Next(countString):
                self.navigationItem.title = countString
            case .Error: break
            case .Completed: break
            }
        }
        self.disposeBag.addDisposable(cookieStackCountStringSubscription)
        
        let cookieButtonSubscription = self.cookieButton.rx_controlEvent(.TouchDown).subscribeOn(MainScheduler.instance).subscribe { event in
            CookieStackManager.instance.cookieStack.add(1)
        }
        self.disposeBag.addDisposable(cookieButtonSubscription)
    }
    
}