//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol AccountRepository {
    
    /// Retrieve an account from its identifier UUID
    ///
    /// - Parameters:
    ///   - uid: The UUID of the account
    ///
    /// - Returns: An AnyPublisher returning an Account or an Error
    func findAccount(byUid uid: String) -> AnyPublisher<Account, Error>
    
    /// Retrieve an array of all accounts
    ///
    /// - Returns: An AnyPublisher returning an Array of Account or an Error
    func findAllAccounts() -> AnyPublisher<[Account], Error>
        
    /// Save a list of accounts
    ///
    /// - Parameters:
    ///   - accounts: An Array of Account
    @discardableResult
    func save(accounts: [Account]) -> AnyPublisher<Void, Error>
    
    /// Save or update an account
    ///
    /// - Parameters:
    ///   - account: An Account
    @discardableResult
    func saveOrUpdate(account: Account) -> AnyPublisher<Void, Error>
    
    /// Delete an account
    ///
    /// - Parameters:
    ///   - uid: The UUID of the account
    @discardableResult
    func delete(byUid uid: String) -> AnyPublisher<Void, Error>
}
