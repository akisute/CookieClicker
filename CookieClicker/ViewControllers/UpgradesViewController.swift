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
        
        CookieStackManager.instance.cookieStack.rx_count.asDriver(onErrorJustReturn: 0).driveNext { count in
            self.navigationItem.title = "Current xaxtsuxo: %@".localized(count.ingameDescription)
            }.addDisposableTo(self.disposeBag)
        
        UpgradeManager.instance.rx_upgrades.bindTo(self.tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { index, upgrade, cell in
            }.addDisposableTo(self.disposeBag)
        
        self.tableView.rx_itemSelected.subscribeNext { indexPath in
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }.addDisposableTo(self.disposeBag)
        
        self.tableView.rx_modelSelected(UpgradeType.self).subscribeNext { upgrade in
            debugPrint(upgrade)
            }.addDisposableTo(self.disposeBag)
        
    }
    
}
