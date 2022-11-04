//
//  File.swift
//  
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift

/**
 * Default Implementation for the Remote Authentication Protocol.
 */
public class FirebaseRemoteAuthentication: OlaRemoteAuthentication {
    
    private let firebaseAuth: Auth
    
    public init(firebaseAuth: Auth) {
        self.firebaseAuth = firebaseAuth
    }
    
    /// SignIn an User with a Credential, from remote
    ///
    /// - Parameters:
    ///   - credential: The AuthCredential of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    public func signIn(with credential: AuthCredential) -> AnyPublisher<User, Error> {
        self.firebaseAuth.signIn(with: credential)
            .map { authResult in authResult.user }
            .eraseToAnyPublisher()
    }
    
    /// SignIn an User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an RemoteUser or an Error
    public func signIn(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        self.firebaseAuth.signIn(withEmail: email, password: password)
            .map { authResult in authResult.user }
            .eraseToAnyPublisher()
    }
    
    /// SignOut current User
    ///
    /// - Returns: An AnyPublisher returning Void or an Error
    public func signOut() -> AnyPublisher<Void, Error> {
        do {
            return Just(try self.firebaseAuth.signOut())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Create a User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an RemoteUser or an Error
    public func createUser(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        self.firebaseAuth.createUser(withEmail: email, password: password)
            .map { authResult in authResult.user }
            .eraseToAnyPublisher()
    }
    
    /// Delete a User
    ///
    /// - Parameters:
    ///   - uid: The user to delete
    public func deleteUser(byUser user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            user.delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
