//
//  FollowingsViewController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FollowingsViewController: UIViewController, Storyboarded {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(forType: LabeledTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet private weak var followButton: UIButton! {
        didSet {
            followButton.layer.cornerRadius = 15
        }
    }
    @IBOutlet private weak var usernameTextField: UITextField!
    
    // MARK: - Public Properties
    var viewModel: FollowingsViewModel?
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getFollowings()
    }
}

// MARK: - Private Methods
private extension FollowingsViewController {
    func setUpBindings() {
        guard let viewModel = viewModel else { return }
        viewModel.followings
            .bind(to: tableView.rx.items(cellIdentifier: "LabeledTableViewCell",
                                         cellType: LabeledTableViewCell.self)) { _, tweet, cell in
                                            cell.setup(text: tweet)
            }.disposed(by: disposeBag)
        
        viewModel.followIsActive
            .bind(to: followButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        followButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.startFollow()
                self?.usernameTextField.text = nil
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.didTapOnFollowingUser(index: indexPath.row)
            }).disposed(by: disposeBag)
        
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.usernameToFollow)
            .disposed(by: disposeBag)
    }
}

// MARK: - Alertable
extension FollowingsViewController: Alertable {
    func actionsForAlert() -> [UIAlertAction] {
        return [UIAlertAction(title: "Ok", style: .cancel, handler: nil)]
    }
}
