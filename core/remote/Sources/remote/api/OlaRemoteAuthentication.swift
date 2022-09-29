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
protocol OlaRemoteAuthentication {
    
    /// SignIn an Account with a Credential, from remote
    ///
    /// - Parameters:
    ///   - credential: The AuthCredential of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func signIn(with credential: AuthCredential) -> Future<RemoteAccount, Error>
    
    /// SignIn an Account with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the account
    ///   - password: The password of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func signIn(withEmail email: String, password: String) -> Future<RemoteAccount, Error>
    
    /// Create a User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the account
    ///   - password: The password of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func createUser(withEmail email: String, password: String) -> Future<RemoteAccount, Error>
}
