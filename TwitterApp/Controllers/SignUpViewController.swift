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
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    private let usernameMaxLength = 14
    private let realNameMaxLength = 14
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
        setTextFieldMaxLengths()
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        realNameTextField.rx.text.orEmpty
            .bind(to: viewModel.realName)
            .disposed(by: disposeBag)
        
        viewModel.isRegistrationActive
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.signUpButtonTapped()
            }).disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.signInButtonTapped()
            }).disposed(by: disposeBag)
    }
    
    func setTextFieldMaxLengths() {
        usernameTextField.rx.text.orEmpty.scan("") { [weak self] (previous, new) in
            guard let self = self else { return nil }
            return new.count > self.usernameMaxLength ?
                previous ?? String(new.prefix(self.usernameMaxLength))
                : new
        }.subscribe(usernameTextField.rx.text).disposed(by: disposeBag)
        
        realNameTextField.rx.text.orEmpty.scan("") { [weak self] (previous, new) in
            guard let self = self else { return nil }
            return new.count > self.realNameMaxLength ?
                previous ?? String(new.prefix(self.realNameMaxLength))
                : new
        }.subscribe(realNameTextField.rx.text).disposed(by: disposeBag)
    }
}

// MARK: - Alertable
extension SignUpViewController: Alertable {
    func actionsForAlert() -> [UIAlertAction] {
        return [UIAlertAction(title: "Ok", style: .cancel, handler: nil)]
    }
}
