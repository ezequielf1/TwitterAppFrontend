//
//  SignUpCoordinator.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class SignUpCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    
    override func start() {
        let viewController = SignUpViewController.instantiate()
        buildSignUpFlow(viewController: viewController)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func buildSignUpFlow(viewController: SignUpViewController) {
        let signUpViewModel = SignUpViewModel(authenticationService: AuthenticationService())
        viewController.viewModel = signUpViewModel
        setUpSignUpScreenBindings(signUpViewModel: signUpViewModel, viewController: viewController)
    }
    
    private func setUpSignUpScreenBindings(signUpViewModel: SignUpViewModel,
                                           viewController: SignUpViewController) {
        signUpViewModel.didSignUp.subscribe(onNext: { [weak self] user in
            self?.startLoggedUserFlow(with: user)
        })
        .disposed(by: disposeBag)
        
        signUpViewModel.didFailSignUp.subscribe(onNext: { [weak self] error in
            self?.showAlert(with: error, viewController: viewController)
        })
        .disposed(by: disposeBag)
        
        signUpViewModel.didSignInTapped.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.startSignInCoordinatorFlow()
        })
        .disposed(by: disposeBag)
    }
    
    private func startSignInCoordinatorFlow() {
        parentCoordinator?.didFinish(coordinator: self)
        let signInCoordinator = SignInCoordinator()
        signInCoordinator.navigationController = navigationController
        start(coordinator: signInCoordinator)
    }
    
    private func startLoggedUserFlow(with user: User) {
        parentCoordinator?.didFinish(coordinator: self)
        let userFlowCoordinator = UserFlowCoordinator(loggedUser: user)
        userFlowCoordinator.navigationController = navigationController
        start(coordinator: userFlowCoordinator)
    }
}
