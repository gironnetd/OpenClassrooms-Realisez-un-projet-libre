//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import remote
import FirebaseAuth

public class DefaultUserRepository: UserRepository {
    
    private let userDao: UserDao
    private let remoteFirebase: OlaRemoteFirebase
    
    public init(userDao: UserDao, remoteFirebase: OlaRemoteFirebase) {
        self.userDao = userDao
        self.remoteFirebase = remoteFirebase
    }
    
    /// SignIn a User with a Credential
    ///
    /// - Parameters:
    ///   - credential: The AuthCredential of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    public func signIn(with credential: AuthCredential) -> AnyPublisher<model.User, Error> {
        self.remoteFirebase.signIn(with: credential)
            .map { $0.asCached() }
            .map { user in
                self.userDao.saveOrUpdate(currentUser: user)
                return user.asExternalModel()
            }
            .eraseToAnyPublisher()
    }
    
    /// SignIn a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    public func signIn(withEmail email: String, password: String) -> AnyPublisher<model.User, Error> {
        self.remoteFirebase.signIn(withEmail: email, password: password)
            .map { $0.asCached() }
            .map { user in
                self.userDao.saveOrUpdate(currentUser: user)
                return user.asExternalModel()
            }
            .eraseToAnyPublisher()
    }
    
    /// SignOut current User
    ///
    /// - Returns: An AnyPublisher returning Void or an Error
    public func signOut() -> AnyPublisher<Void, Error> {
        self.remoteFirebase.signOut()
            .append(self.userDao.deleteCurrentUser())
            .eraseToAnyPublisher()
    }
    
    /// Create a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    public func createUser(withEmail email: String, password: String) -> AnyPublisher<model.User, Error> {
        self.remoteFirebase.createUser(withEmail: email, password: password)
            .map { $0.asCached() }
            .map { user in
                self.userDao.saveOrUpdate(currentUser: user)
                return user.asExternalModel()
            }
            .eraseToAnyPublisher()
    }
    
    /// Retrieve current user, from the cache
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    public func findCurrentUser() -> AnyPublisher<model.User?, Error> {
        self.userDao.findCurrentUser()
            .map { $0.asExternalModel() }
            .eraseToAnyPublisher()
    }
    
    /// Delete current user
    ///
    /// - Returns: An AnyPublisher returning Void or an Error
    @discardableResult
    public func deleteCurrentUser() -> AnyPublisher<Void, Error> {
        self.remoteFirebase.deleteCurrentUser()
            .append(self.userDao.deleteCurrentUser())
            .eraseToAnyPublisher()
    }
    
    /// Save or update an favourite
    ///
    /// - Parameters:
    ///   - user: A favourite
    @discardableResult
    public func saveOrUpdate(favourite: Favourite) -> AnyPublisher<Void, Error> {
        self.remoteFirebase.saveOrUpdate(favourite: favourite.toRemote())
            .append(self.userDao.saveOrUpdate(favourite: favourite.asCached()))
            .eraseToAnyPublisher()
    }
    
    /// Delete a favourite
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    public func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        self.remoteFirebase.deleteFavourite(byIdDirectory: idDirectory)
            .append(self.userDao.deleteFavourite(byIdDirectory: idDirectory))
            .eraseToAnyPublisher()
    }
}
