//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class ProfileViewController: UIViewController, Storyboarded {
    // MARK: - IBOutlets
    @IBOutlet private weak var realNameTextField: UITextField!
    @IBOutlet private weak var surnameTextField: UITextField! {
        didSet {
            surnameTextField.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 15
        }
    }
    
    // MARK: - Public Properties
    var viewModel: ProfileViewModel?
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    private let realNameMaxLength = 14
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        setUpView()
    }
}

// MARK: - Private Methods
private extension ProfileViewController {
    func setUpBindings() {
        guard let viewModel = viewModel else { return }
        realNameTextField.rx.text.orEmpty
            .bind(to: viewModel.realName)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: { _ in
            viewModel.saveButtonTapped()
        })
        .disposed(by: disposeBag)
        
        viewModel.isSaveActive
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        realNameTextField.rx.text.orEmpty.scan("") { [weak self] (previous, new) in
            guard let self = self else { return nil }
            return new.count > self.realNameMaxLength ?
                previous ?? String(new.prefix(self.realNameMaxLength))
                : new
        }.subscribe(realNameTextField.rx.text).disposed(by: disposeBag)
    }
    
    func setUpView() {
        realNameTextField.text = viewModel?.loggedUser.realName
        surnameTextField.text = viewModel?.loggedUser.username
    }
}

// MARK: - Alertable
extension ProfileViewController: Alertable {
    func actionsForAlert() -> [UIAlertAction] {
        return [UIAlertAction(title: "Ok", style: .cancel, handler: nil)]
    }
}
