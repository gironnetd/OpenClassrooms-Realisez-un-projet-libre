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
 * Default Implementation for the Remote Authentication Protocol.
 */
class AuthenticationRemoteDataSource: OlaRemoteAuthentication {
    
    private let firebaseAuth: Auth
    
    init() {
        firebaseAuth = Auth.auth()
    }
    
    /// SignIn an Account with a Credential, from remote
    ///
    /// - Parameters:
    ///   - credential: The AuthCredential of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func signIn(with credential: AuthCredential) -> Future<RemoteAccount, Error> {
        Future { [self] promise in
            firebaseAuth.signIn(with: credential) { authResult, error in
                guard let authResult = authResult else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }

                var account = RemoteAccount(uuid: UUID(uuidString: authResult.user.uid)!,
                                            providerId: authResult.user.providerID,
                                            email: authResult.user.email,
                                            displayName: authResult.user.displayName,
                                            phoneNumber: authResult.user.phoneNumber)
                
                guard let photoUrl = authResult.user.photoURL else {
                    return promise(.success(account))
                }
                
                URLSession.shared.dataTask(with: photoUrl) { data, response, error in
                    if let photo = data {
                        account.photo = photo
                    }
                    promise(.success(account))
                }.resume()
            }
        }
    }
    
    /// SignIn an Account with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the account
    ///   - password: The password of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func signIn(withEmail email: String, password: String) -> Future<RemoteAccount, Error> {
        Future { [self] promise in
            firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
                guard let authResult = authResult else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                
                var account = RemoteAccount(uuid: UUID(uuidString: authResult.user.uid)!,
                                            providerId: authResult.user.providerID,
                                            email: authResult.user.email,
                                            displayName: authResult.user.displayName,
                                            phoneNumber: authResult.user.phoneNumber)
                
                guard let photoUrl = authResult.user.photoURL else {
                    return promise(.success(account))
                }
                
                URLSession.shared.dataTask(with: photoUrl) { data, response, error in
                    if let photo = data {
                        account.photo = photo
                    }
                    promise(.success(account))
                }.resume()
            }
        }
    }
    
    /// Create a User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the account
    ///   - password: The password of the account
    ///
    /// - Returns: A Future returning an RemoteAccount or an Error
    func createUser(withEmail email: String, password: String) -> Future<RemoteAccount, Error> {
        Future { [self] promise in
            firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
                guard let authResult = authResult else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }

                var account = RemoteAccount(uuid: UUID(uuidString: authResult.user.uid)!,
                                            providerId: authResult.user.providerID,
                                            email: authResult.user.email,
                                            displayName: authResult.user.displayName,
                                            phoneNumber: authResult.user.phoneNumber)
                
                guard let photoUrl = authResult.user.photoURL else {
                    return promise(.success(account))
                }
                
                URLSession.shared.dataTask(with: photoUrl) { data, response, error in
                    if let photo = data {
                        account.photo = photo
                    }
                    promise(.success(account))
                }.resume()
            }
        }
    }
}
