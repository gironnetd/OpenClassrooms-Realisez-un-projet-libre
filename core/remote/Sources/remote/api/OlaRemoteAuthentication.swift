//
//  File.swift
//  
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine
import FirebaseAuth

/**
 * Protocol defining methods for the Remote Authentication.
 */
public protocol OlaRemoteAuthentication {
    
    /// SignIn an User with a Credential, from remote
    ///
    /// - Parameters:
    ///   - credential: The AuthCredential of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    func signIn(with credential: AuthCredential) -> AnyPublisher<User, Error>
    
    /// SignIn an User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    func signIn(withEmail email: String, password: String) -> AnyPublisher<User, Error>
    
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
    /// - Returns: An AnyPublisher returning an User or an Error
    func createUser(withEmail email: String, password: String) -> AnyPublisher<User, Error>
    
    /// Delete a User
    ///
    /// - Parameters:
    ///   - uid: The user to delete
    @discardableResult
    func deleteUser(byUser user: User) -> AnyPublisher<Void, Error>
}
