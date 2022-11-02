//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import FirebaseAuth

public protocol UserRepository {

    /// SignIn a User with a Credential
    ///
    /// - Parameters:
    ///   - credential: The AuthCredential of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    func signIn(with credential: AuthCredential) -> AnyPublisher<model.User, Error>
    
    /// SignIn a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    func signIn(withEmail email: String, password: String) -> AnyPublisher<model.User, Error>
    
    /// SignOut current User
    ///
    /// - Returns: An AnyPublisher returning Void or an Error
    func signOut() -> AnyPublisher<Void, Error>
    
    /// Create a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    func createUser(withEmail email: String, password: String) -> AnyPublisher<model.User, Error>
    
    /// Retrieve current user, from the cache
    ///
    /// - Returns: An AnyPublisher returning an User or an Error
    func findCurrentUser() -> AnyPublisher<model.User?, Error>
    
    /// Delete current user
    ///
    /// - Returns: An AnyPublisher returning Void or an Error
    @discardableResult
    func deleteCurrentUser() -> AnyPublisher<Void, Error>
    
    /// Save or update an Favourite
    ///
    /// - Parameters:
    ///   - user: A Favourite
    @discardableResult
    func saveOrUpdate(favourite: Favourite) -> AnyPublisher<Void, Error>
    
    /// Delete a Favourite
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error>
}
