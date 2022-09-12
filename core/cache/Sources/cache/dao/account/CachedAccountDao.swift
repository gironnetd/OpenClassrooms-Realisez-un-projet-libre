//
//  CachedAccountDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Data Access Object of Accounts.
 */
protocol CachedAccountDao {
    
    /// Retrieve an account from its identifier UUID, from the cache
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    ///
    /// - Returns: An  AnyPublisher returning an CachedAccount or an Error
    func findAccount(byUuid uuid: UUID) -> AnyPublisher<CachedAccount, Error>
    
    /// Retrieve an array of all accounts, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedAccount or an Error
    func findAllAccounts() -> AnyPublisher<[CachedAccount], Error>
        
    /// Save a list of accounts to the cache
    ///
    /// - Parameters:
    ///   - accounts: An Array of CachedAccount
    func save(accounts: [CachedAccount]) -> AnyPublisher<Void, Error>
    
    /// Save or update an account to the cache
    ///
    /// - Parameters:
    ///   - account: An CachedAccount
    func saveOrUpdate(account: CachedAccount) -> AnyPublisher<Void, Error>
    
    /// Delete an account to the cache
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    func delete(byUuid uuid: UUID) -> AnyPublisher<Void, Error>
}
