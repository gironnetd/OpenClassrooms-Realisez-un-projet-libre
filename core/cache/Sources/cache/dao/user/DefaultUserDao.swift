//
//  CachedAccountDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import RealmException
import Combine

/**
 * Implementation for the CachedUser Dao Protocol
 */
public class DefaultUserDao: UserDao {
    
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    /// Retrieve current user, from the cache
    ///
    /// - Returns: A Future returning an CachedUser or an Error
    public func findCurrentUser() -> Future<CachedUser, Error> {
        Future { promise in
            guard let currentUser = self.realm.objects(CachedUser.self).first else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(currentUser))
        }
    }
    
    /// Save or update current user to the cache
    ///
    /// - Parameters:
    ///   - currentUser: A CachedUser
    @discardableResult
    public func saveOrUpdate(currentUser: CachedUser) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            do {
                try RealmException.catch {
                    try! realm.write {
                        realm.add(currentUser, update: .modified)
                        try realm.commitWrite()
                    }
                    promise(.success(()))
                }
            } catch (let error) {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    /// Delete current user to the cache
    @discardableResult
    public func deleteCurrentUser() -> AnyPublisher<Void, Error> {
        self.findCurrentUser()
            .tryMap { [self] currentUser in
                try realm.write {
                    realm.delete(currentUser)
                    realm.objects(CachedFavourite.self).forEach { favourite in
                        realm.delete(favourite)
                    }
                    try realm.commitWrite()
                }
            }.eraseToAnyPublisher()
    }
    
    /// Save or update a favourite to the cache
    ///
    /// - Parameters:
    ///   - favorite: A CachedFavourite
    @discardableResult
    public func saveOrUpdate(favourite: CachedFavourite) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            do {
                try RealmException.catch {
                    try! realm.write {
                        realm.add(favourite, update: .modified)
                        try realm.commitWrite()
                    }
                    promise(.success(()))
                }
            } catch (let error) {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    /// Delete a favourite to the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    public func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        guard let favourite = realm.object(ofType: CachedFavourite.self, forPrimaryKey: idDirectory) else {
            return Fail(error: Realm.Error(Realm.Error.fail)).eraseToAnyPublisher()
        }
        
        guard !realm.isInWriteTransaction else {
            return Publishers.Sequence(sequence: favourite.subDirectories.toArray())
                .flatMap { [self] subDirectory in
                    deleteFavourite(byIdDirectory: subDirectory.idDirectory)
                }
                .collect()
                .map { _ in }
                .handleEvents(receiveCompletion: { _ in
                    self.realm.delete(favourite)
                }).eraseToAnyPublisher()
        }
        
        realm.beginWrite()
        
        return Publishers.Sequence(sequence: favourite.subDirectories.toArray())
            .flatMap { [self] subDirectory in
                deleteFavourite(byIdDirectory: subDirectory.idDirectory)
            }
            .collect()
            .map { _ in }
            .handleEvents(receiveCompletion: { [self] _ in
                realm.delete(favourite)
                try? realm.commitWrite()
            }).eraseToAnyPublisher()
    }
}
