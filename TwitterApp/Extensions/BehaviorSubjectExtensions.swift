//
//  BehaviorSubjectExtensions.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift
extension BehaviorSubject {
    func getUnwrappedValue() -> Element? {
        return try? self.value()
    }
}
