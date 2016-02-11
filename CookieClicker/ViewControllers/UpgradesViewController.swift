//
//  UpgradesViewController.swift
//  CookieClicker
//
//  Created by 小野 将司 on 2016/02/11.
//  Copyright © 2016年 akisute. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UpgradesViewController: UIViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    
}

extension UpgradesViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cookieStackCountSubscription = CookieStackManager.instance.cookieStack.rx_count.subscribeOn(MainScheduler.instance).subscribe { event in
            switch (event) {
            case let .Next(count):
                self.navigationItem.title = "Current xaxtsuxo: %@".localized(count.ingameDescription)
            case .Error: break
            case .Completed: break
            }
        }
        self.disposeBag.addDisposable(cookieStackCountSubscription)
    }
    
}

extension UpgradesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}