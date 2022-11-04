//
//  File.swift
//  
//
//  Created by damien on 24/10/2022.
//

import Foundation
import Combine
import FirebaseAuth

public protocol OlaRemoteFirebase {
    
    /// SignIn an User with a Credential, from remote
    ///
    /// - Parameters:
    ///   - credential: The AuthCredential of the user
    ///
    /// - Returns: An AnyPublisher returning an RemoteUser or an Error
    func signIn(with credential: AuthCredential) -> AnyPublisher<RemoteUser, Error>
    
    /// SignIn an User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an RemoteUser or an Error
    func signIn(withEmail email: String, password: String) -> AnyPublisher<RemoteUser, Error>
    
    /// SignOut current User
    ///
    /// - Returns: An AnyPublisher returning Void or an Error
    func signOut() -> AnyPublisher<Void, Error>
    
    /// Create a User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an RemoteUser or an Error
    func createUser(withEmail email: String, password: String) -> AnyPublisher<RemoteUser, Error>
    
    /// Delete current user
    @discardableResult
    func deleteCurrentUser() -> AnyPublisher<Void, Error>
    
    /// Save or update an Favourite to remote
    ///
    /// - Parameters:
    ///   - user: A RemoteFavourite
    @discardableResult
    func saveOrUpdate(favourite: RemoteFavourite) -> AnyPublisher<Void, Error>
    
    /// Delete a Favourite to the remote
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error>
}
