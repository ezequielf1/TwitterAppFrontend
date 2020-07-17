//
//  SignInViewController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 15
        }
    }
    @IBOutlet private weak var usernameTextField: UITextField!
    
    // MARK: - Public Properties
    var viewModel: SignInViewModel?
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
}

// MARK: - Private Methods
private extension SignInViewController {
    func setUpBindings() {
        guard let viewModel = viewModel else { return }
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.signInButtonTapped()
            }).disposed(by: disposeBag)
        
        viewModel.signInIsActive
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
