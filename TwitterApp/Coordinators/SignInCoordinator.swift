//
//  SignInCoordinator.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class SignInCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    
    override func start() {
        let signInViewController: SignInViewController = .loadFromNib()
        buildSignInFlow(viewController: signInViewController)
        navigationController.pushViewController(signInViewController, animated: true)
    }
    
    private func buildSignInFlow(viewController: SignInViewController) {
        let signInViewModel = SignInViewModel()
        viewController.viewModel = signInViewModel
        setUpSignInScreenBindings(viewModel: signInViewModel)
    }
    
    private func setUpSignInScreenBindings(viewModel: SignInViewModel) {
        viewModel.didTapSignIn.subscribe(onNext: { [weak self] user in
            self?.startLoggedUserFlow(with: user)
        })
        .disposed(by: disposeBag)
    }
    
    private func startLoggedUserFlow(with user: User) {
        parentCoordinator?.didFinish(coordinator: self)
        let userFlowCoordinator = UserFlowCoordinator(loggedUser: user)
        userFlowCoordinator.navigationController = navigationController
        start(coordinator: userFlowCoordinator)
    }
}
