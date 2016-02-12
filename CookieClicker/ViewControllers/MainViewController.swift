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
        
        InGame.instance.cookieStack.rx_count
            .asDriver(onErrorJustReturn: 0)
            .driveNext { count in
                self.navigationItem.title = "Current xaxtsuxo: %@".localized(count.inGameDescription)
            }
            .addDisposableTo(self.disposeBag)
        
        self.cookieButton.rx_controlEvent(.TouchDown)
            .flatMapLatest {
                return ControlEvent(events: InGame.instance.action_click())
            }.bindNext { gain in
                debugPrint("click: gained \(gain)")
            }
            .addDisposableTo(self.disposeBag)
    }
    
}