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
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120.0
        
        InGame.instance.cookieStack.rx_count
            .asDriver(onErrorJustReturn: 0)
            .driveNext { count in
                self.navigationItem.title = "Current xaxtsuxo: %@".localized(count.inGameDescription)
            }
            .addDisposableTo(self.disposeBag)
        
        InGame.instance.rx_upgrades
            .bindTo(self.tableView.rx_itemsWithCellIdentifier("Cell", cellType: UpgradesListCell.self)) { index, upgrade, cell in
                cell.upgrade = upgrade
            }
            .addDisposableTo(self.disposeBag)
        
        self.tableView.rx_itemSelected
            .bindNext { indexPath in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            .addDisposableTo(self.disposeBag)
        
        self.tableView.rx_modelSelected(UpgradeType.self)
            .bindNext { upgrade in
                debugPrint("upgrade selected: \(upgrade)")
            }
            .addDisposableTo(self.disposeBag)
        
    }
    
}
