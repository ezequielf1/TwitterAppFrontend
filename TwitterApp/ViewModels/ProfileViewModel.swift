//
//  ProfileViewModel.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class ProfileViewModel {
    // MARK: - Public Properties
    let realName = BehaviorSubject(value: "")
    var isSaveActive: Observable<Bool> = .empty()
    
    let didUpdateName = PublishSubject<Void>()
    let didFailUpdateName = PublishSubject<Error>()
    
    // MARK: - Private Properties
    private let userService: UserService
    private let disposeBag = DisposeBag()
    let loggedUser: User
    
    init(user: User, userService: UserService) {
        self.userService = userService
        loggedUser = user
        setSaveStateBehavior()
    }
    
    func saveButtonTapped() {
        userService.updateUser(user: User(username: loggedUser.username,
                                          realName: realName.getUnwrappedValue() ?? ""))
            .observeOn(MainScheduler.instance).subscribe(onSuccess: { [weak self] in
                self?.didUpdateName.onNext(())
            }) { [weak self] error in
                self?.didFailUpdateName.onNext(error)
        }.disposed(by: disposeBag)
    }
    
    private func setSaveStateBehavior() {
        isSaveActive = realName.asObservable().map { $0 != self.loggedUser.realName && !$0.isEmpty }
    }
}
