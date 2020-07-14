//
//  AppCoordinator.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class AppCoordinator: Coordinator {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignUpScreen()
    }
    
    func showSignUpScreen() {
        let signUpViewController = SignUpViewController.instantiate()
        navigationController.pushViewController(signUpViewController, animated: false)
        let signUpViewModel = SignUpViewModel(authenticationService: AuthenticationService())
        signUpViewController.viewModel = signUpViewModel
        setUpSignUpScreenBindings(signUpViewModel: signUpViewModel)
        navigationController.viewControllers = [signUpViewController]
    }
    
    func showSignInScreen() {
        let signInViewController: SignInViewController = .loadFromNib()
        let signInViewModel = SignInViewModel()
        signInViewController.viewModel = signInViewModel
        navigationController.pushViewController(signInViewController, animated: true)
    }
}

private extension AppCoordinator {
    func setUpSignUpScreenBindings(signUpViewModel: SignUpViewModel) {
        signUpViewModel.didSignUp.subscribe(onNext: {
            print("Signed In")
        })
        .disposed(by: disposeBag)
        
        signUpViewModel.didFailSignUp.subscribe(onNext: { error in
            print("Signed Up Failure: \(error)")
        })
        .disposed(by: disposeBag)
        
        signUpViewModel.didSignInTapped.subscribe(onNext: {
            self.showSignInScreen()
        })
        .disposed(by: disposeBag)
    }
}
