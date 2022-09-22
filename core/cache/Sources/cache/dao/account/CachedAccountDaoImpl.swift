//
//  CachedAccountDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedAccount Dao Protocol
 */
public class CachedAccountDaoImpl : CachedAccountDao {
    
    /// Retrieve an account from its identifier UUID, from the cache
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    ///
    /// - Returns: A Future returning an CachedAccount or an Error
    func findAccount(byUuid uuid: UUID) -> Future<CachedAccount, Error> {
        Future { promise in
            guard let account = try? Realm().objects(CachedAccount.self)
                    .where({ account in account.uuid == uuid }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(account))
        }
    }
    
    /// Retrieve an array of all accounts, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedAccount or an Error
    func findAllAccounts() -> Future<[CachedAccount], Error> {
        Future { promise in
            guard let accounts = try? Realm().objects(CachedAccount.self), !accounts.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(accounts.toArray()))
        }
    }
    
    /// Save a list of accounts to the cache
    ///
    /// - Parameters:
    ///   - accounts: An Array of CachedAccount
    @discardableResult
    func save(accounts: [CachedAccount]) -> AnyPublisher<Void, Error> {
        accounts.forEach { account in saveOrUpdate(account: account) }
        return Empty().eraseToAnyPublisher()
    }
    
    /// Save or update an account to the cache
    ///
    /// - Parameters:
    ///   - account: An CachedAccount
    @discardableResult
    func saveOrUpdate(account: CachedAccount) -> AnyPublisher<Void, Error> {
        try! Realm().write {
            try Realm().add(account, update: .modified)
            return Empty().eraseToAnyPublisher()
        }
    }
    
    /// Delete an account to the cache
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    @discardableResult
    func delete(byUuid uuid: UUID) -> AnyPublisher<Void, Error> {
        Future { promise in
            try? Realm().write {
                guard let account = try Realm().object(ofType: CachedAccount.self, forPrimaryKey: uuid) else {
                    return promise(.failure(Realm.Error(Realm.Error.fail)))
                }
                try Realm().delete(account)
                return promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}
