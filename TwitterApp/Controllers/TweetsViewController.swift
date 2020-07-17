//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TweetsViewController: UIViewController, Storyboarded {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(forType: LabeledTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet private weak var tweetTextView: UITextView!
    @IBOutlet private weak var postTweetButton: UIButton!
    
    var viewModel: TweetsViewModel?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getTweets()
    }
}

// MARK: - Private Methods
private extension TweetsViewController {
    func setUpBindings() {
        guard let viewModel = viewModel else { return }
        
        viewModel.tweets
            .bind(to: tableView.rx.items(cellIdentifier: "LabeledTableViewCell",
                                         cellType: LabeledTableViewCell.self)) { _, tweet, cell in
                                            cell.setup(text: tweet)
        }.disposed(by: disposeBag)
        
        tweetTextView.rx.text.orEmpty
            .bind(to: viewModel.tweetText)
            .disposed(by: disposeBag)
        
        viewModel.isTweetPostActive
            .bind(to: postTweetButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        postTweetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.postTweet()
                self?.tweetTextView.text = nil
            }).disposed(by: disposeBag)
        
    }
}

// MARK: - Alertable
extension TweetsViewController: Alertable {
    func actionsForAlert() -> [UIAlertAction] {
        return [UIAlertAction(title: "Ok", style: .cancel, handler: nil)]
    }
}
