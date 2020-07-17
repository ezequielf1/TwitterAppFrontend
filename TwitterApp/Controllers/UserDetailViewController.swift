//
//  UserDetailViewController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UserDetailViewController: UIViewController {
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(forType: LabeledTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    private let disposeBag = DisposeBag()
    var viewModel: UserDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    private func setUpBindings() {
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                index == 0 ? self?.viewModel?.didTapOnFollowingsTab() : self?.viewModel?.didTapOnTweetsTab()
            }).disposed(by: disposeBag)
        
        viewModel?.currentDataToShow
            .bind(to: tableView.rx.items(cellIdentifier: "LabeledTableViewCell",
                                         cellType: LabeledTableViewCell.self)) { _, model, cell in
                                            cell.setup(text: model)
        }.disposed(by: disposeBag)
    }
}
