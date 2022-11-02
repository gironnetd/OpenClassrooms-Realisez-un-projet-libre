//
//  File.swift
//  
//
//  Created by damien on 31/10/2022.
//

import Foundation
import Combine
import remote
import testing
import FirebaseAuth

class TestOlaRemoteFirebase: OlaRemoteFirebase {
    
    internal var currentUser: RemoteUser?
    internal var users: [RemoteUser]  = []
    internal var favourites: [RemoteFavourite]  = []
    internal var emailPassword: [(email: String, password: String)] = []
    
    public func signIn(with credential: AuthCredential) -> AnyPublisher<RemoteUser, Error> {
        guard let currentUser = self.currentUser else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        return Just(currentUser).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func signIn(withEmail email: String, password: String) -> AnyPublisher<RemoteUser, Error> {
        guard let currentUser = self.currentUser else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        return Just(currentUser).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func signOut() -> AnyPublisher<Void, Error> {
        guard self.currentUser != nil else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        self.currentUser = nil
        return Empty().eraseToAnyPublisher()
    }
    
    public func createUser(withEmail email: String, password: String) -> AnyPublisher<RemoteUser, Error> {
        currentUser = RemoteUser.testUser()
        currentUser?.email = email
        return Just(currentUser!).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func deleteCurrentUser() -> AnyPublisher<Void, Error> {
        guard self.currentUser != nil else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        self.currentUser = nil
        return Empty().eraseToAnyPublisher()
    }

    func saveOrUpdate(favourite: RemoteFavourite) -> AnyPublisher<Void, Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        Empty().eraseToAnyPublisher()
    }
}
