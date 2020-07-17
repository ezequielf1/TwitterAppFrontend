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
    let realName = BehaviorSubject(value: LoggedUser.shared.realName ?? "")
    let surname = LoggedUser.shared.username
    var initialRealName = LoggedUser.shared.realName ?? ""
    var isSaveActive: Observable<Bool> = .empty()
    
    let didUpdateName = PublishSubject<Void>()
    let didFailUpdateName = PublishSubject<Error>()
    
    // MARK: - Private Properties
    private let userService: UserService
    private let disposeBag = DisposeBag()
    private let loggedUser = LoggedUser.shared
    
    init(userService: UserService) {
        self.userService = userService
        isSaveActive = realName.asObservable().map { $0 != self.initialRealName && !$0.isEmpty }
    }
    
    func saveButtonTapped() {
        guard let username = loggedUser.username else { return }
        userService.updateUser(user: User(username: username,
                                          realName: realName.getUnwrappedValue() ?? ""))
            .observeOn(MainScheduler.instance).subscribe(onSuccess: { [weak self] in
                self?.didUpdateName.onNext(())
            }) { [weak self] error in
                self?.didFailUpdateName.onNext(error)
        }.disposed(by: disposeBag)
    }
}
