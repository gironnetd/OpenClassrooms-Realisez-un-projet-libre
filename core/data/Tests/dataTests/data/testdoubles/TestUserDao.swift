//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestUserDao: UserDao {
    
    internal var currentUser: CachedUser?

    func findCurrentUser() -> Future<CachedUser, Error> {
        Future { promise in
            guard let currentUser = self.currentUser else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(currentUser))
        }
    }
    
    @discardableResult
    func saveOrUpdate(currentUser: CachedUser) -> AnyPublisher<Void, Error> {
        self.currentUser = currentUser
        return Empty().eraseToAnyPublisher()
    }
    
    @discardableResult
    func deleteCurrentUser() -> AnyPublisher<Void, Error> {
        guard self.currentUser != nil else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        self.currentUser = nil
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    @discardableResult
    func saveOrUpdate(favourite: CachedFavourite) -> AnyPublisher<Void, Error> {
        Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    @discardableResult
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
