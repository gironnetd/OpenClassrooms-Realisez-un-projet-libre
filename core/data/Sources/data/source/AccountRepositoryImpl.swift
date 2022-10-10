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

public class AccountRepositoryImpl: AccountRepository {
    
    private let accountDao: AccountDao
    
    public init() {
        accountDao = AccountDaoImpl()
    }
    
    /// Retrieve an account from its identifier UUID
    ///
    /// - Parameters:
    ///   - uid: The UUID of the account
    ///
    /// - Returns: An AnyPublisher returning an Account or an Error
    public func findAccount(byUid uid: String) -> AnyPublisher<Account, Error> {
        accountDao.findAccount(byUid: uid).map { account in account.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve an array of all accounts
    ///
    /// - Returns: An AnyPublisher returning an Array of Account or an Error
    public func findAllAccounts() -> AnyPublisher<[Account], Error> {
        accountDao.findAllAccounts().map { accounts in
            accounts.map { account in account.asExternalModel()
            }
        }.eraseToAnyPublisher()
    }
        
    /// Save a list of accounts
    ///
    /// - Parameters:
    ///   - accounts: An Array of Account
    @discardableResult
    public func save(accounts: [Account]) -> AnyPublisher<Void, Error> {
        accountDao.save(accounts: accounts.map { account in account.asCached()})
    }
    
    /// Save or update an account
    ///
    /// - Parameters:
    ///   - account: An Account
    @discardableResult
    public func saveOrUpdate(account: Account) -> AnyPublisher<Void, Error> {
        accountDao.saveOrUpdate(account: account.asCached())
    }
    
    /// Delete an account
    ///
    /// - Parameters:
    ///   - uid: The UUID of the account
    @discardableResult
    public func delete(byUid uid: String) -> AnyPublisher<Void, Error> {
        accountDao.delete(byUid: uid)
    }
}
