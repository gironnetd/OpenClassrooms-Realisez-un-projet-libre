//
//  CachedAccountDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import CatchRealmException
import Combine

/**
 * Implementation for the CachedAccount Dao Protocol
 */
public class AccountDaoImpl : AccountDao {
    
    public init() {}
    
    /// Retrieve an account from its identifier UUID, from the cache
    ///
    /// - Parameters:
    ///   - uid: The UUID of the account
    ///
    /// - Returns: A Future returning an CachedAccount or an Error
    public func findAccount(byUid uid: String) -> Future<CachedAccount, Error> {
        Future { promise in
            guard let account = self.realm.objects(CachedAccount.self)
                    .where({ account in account.uid == uid }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(account))
        }
    }
    
    /// Retrieve an array of all accounts, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedAccount or an Error
    public func findAllAccounts() -> Future<[CachedAccount], Error> {
        Future { promise in
            guard let accounts = Optional(self.realm.objects(CachedAccount.self)), !accounts.isEmpty else {
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
    public func save(accounts: [CachedAccount]) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try CatchRealmException.catch {
                    try! self.realm.write {
                        self.realm.add(accounts, update: .modified)
                    }
                    promise(.success(()))
                }
            } catch (let error) {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    /// Save or update an account to the cache
    ///
    /// - Parameters:
    ///   - account: A CachedAccount
    @discardableResult
    public func saveOrUpdate(account: CachedAccount) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try CatchRealmException.catch {
                    try! self.realm.write {
                        self.realm.add(account, update: .modified)
                    }
                    promise(.success(()))
                }
            } catch (let error) {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    /// Delete an account to the cache
    ///
    /// - Parameters:
    ///   - uid: The UUID of the account
    @discardableResult
    public func delete(byUid uid: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try CatchRealmException.catch {
                    try! self.realm.write {
                        guard let account = self.realm.object(ofType: CachedAccount.self, forPrimaryKey: uid) else {
                            promise(.failure(Realm.Error(Realm.Error.fail)))
                            return
                        }
                        try autoreleasepool {
                            try Realm().delete(account)
                        }
                        promise(.success(()))
                    }
                }
            } catch (let error) {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
