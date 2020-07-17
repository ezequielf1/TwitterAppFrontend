//
//  UserFlowCoordinator.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class UserFlowCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private let storyboardName = "UserStoryboard"
    private let userService = UserServiceImplementation()
    private let loggedUsername = LoggedUser.shared.username ?? ""
    
    override func start() {
        let tabBarVC = TabBarController.instantiate(storyBoardName: storyboardName)
        tabBarVC.setUp(with: buildScreensForUserFlow())
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(tabBarVC, animated: true)
    }
    
    private func buildScreensForUserFlow() -> [UIViewController] {
        return [buildTweetsScreen(), buildFollowingsScreen(), buildProfileScreen()]
    }
    
    private func buildProfileScreen() -> ProfileViewController {
        let profileVC = ProfileViewController.instantiate(storyBoardName: storyboardName)
        let profileViewModel = ProfileViewModel(userService: userService)
        profileVC.viewModel = profileViewModel
        setUpBindingsForProfileVC(viewModel: profileViewModel, viewController: profileVC)
        return profileVC
    }
    
    private func buildFollowingsScreen() -> FollowingsViewController {
        let followingsVC = FollowingsViewController.instantiate(storyBoardName: storyboardName)
        let followingsViewModel = FollowingsViewModel(userService: userService, username: loggedUsername)
        followingsVC.viewModel = followingsViewModel
        setUpBindingsForFollowingsVC(viewModel: followingsViewModel, viewController: followingsVC)
        return followingsVC
    }
    
    private func buildTweetsScreen() -> TweetsViewController {
        let tweetsVC = TweetsViewController.instantiate(storyBoardName: storyboardName)
        tweetsVC.viewModel = TweetsViewModel(userService: userService, username: loggedUsername)
        return tweetsVC
    }
    
    private func setUpBindingsForFollowingsVC(viewModel: FollowingsViewModel, viewController: FollowingsViewController) {
        viewModel.didTapOnFollowingUser
            .subscribe(onNext: { [weak self] username in
                self?.startUserDetailFlow(username: username)
            }).disposed(by: disposeBag)
        
        viewModel.didFailAskingFollowings
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(with: error, viewController: viewController)
            }).disposed(by: disposeBag)
    }
    
    private func setUpBindingsForTweetsVC(viewModel: TweetsViewModel, viewController: TweetsViewController) {
        viewModel.didFailureRetrievingTweets
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(with: error, viewController: viewController)
            }).disposed(by: disposeBag)
        
        viewModel.didFailurePostingTweet
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(with: error, viewController: viewController)
            }).disposed(by: disposeBag)
    }
    
    private func setUpBindingsForProfileVC(viewModel: ProfileViewModel, viewController: ProfileViewController) {
        viewModel.didUpdateName
            .subscribe(onNext: {
                viewController.showAlertWith(title: "Realname updated successfully")
            }).disposed(by: disposeBag)
        
        viewModel.didFailUpdateName
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(with: error, viewController: viewController)
            }).disposed(by: disposeBag)
    }
    
    private func startUserDetailFlow(username: String) {
        parentCoordinator?.didFinish(coordinator: self)
        let userDetailCoordinator = UserDetailCoordinator(userService: userService, username: username)
        userDetailCoordinator.navigationController = navigationController
        start(coordinator: userDetailCoordinator)
    }
}
