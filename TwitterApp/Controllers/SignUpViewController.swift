//
//  SignUpViewController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController, Storyboarded {
    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var realNameTextField: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    var viewModel: SignUpViewModel?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
}

// MARK: - Private Methods
private extension SignUpViewController {
    func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        realNameTextField.rx.text.orEmpty
            .bind(to: viewModel.realName)
            .disposed(by: disposeBag)
        
        viewModel.isRegistrationActive
            .bind(to: continueButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - IBActions
private extension SignUpViewController {
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        viewModel?.continueButtonTapped()
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        viewModel?.signInButtonTapped()
    }
}
