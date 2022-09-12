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
    /// - Returns: An AnyPublisher returning an CachedAccount or an Error
    func findAccount(byUuid uuid: UUID) -> AnyPublisher<CachedAccount, Error> {
        if let account = try? Realm().objects(CachedAccount.self)
            .where({ account in account.uuid == uuid }).first {
            return Just(account).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve an array of all accounts, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedAccount or an Error
    func findAllAccounts() -> AnyPublisher<[CachedAccount], Error> {
        if let accounts = try? Realm().objects(CachedAccount.self), !accounts.isEmpty {
            return Just(accounts.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Save a list of accounts to the cache
    ///
    /// - Parameters:
    ///   - accounts: An Array of CachedAccount
    func save(accounts: [CachedAccount]) -> AnyPublisher<Void, Error> {
        do {
            try Realm().write {
                try Realm().add(accounts, update: .modified)
            }
            return Empty().eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Save or update an account to the cache
    ///
    /// - Parameters:
    ///   - account: An CachedAccount
    func saveOrUpdate(account: CachedAccount) -> AnyPublisher<Void, Error> {
        do {
            try Realm().write {
                try Realm().add(account, update: .modified)
            }
            return Empty().eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Delete an account to the cache
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the account
    func delete(byUuid uuid: UUID) -> AnyPublisher<Void, Error> {
        do {
            try Realm().write {
                if let account = try Realm().object(ofType: CachedAccount.self, forPrimaryKey: uuid) {
                    try Realm().delete(account)
                }
            }
            return Empty().eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
