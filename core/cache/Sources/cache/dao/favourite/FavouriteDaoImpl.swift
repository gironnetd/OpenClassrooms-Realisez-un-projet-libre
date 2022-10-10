//
//  CachedFavouriteDaoImpl.swift
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
 * Implementation for the CachedFavourite Dao Protocol
 */
public class FavouriteDaoImpl : FavouriteDao {
    
    public init() {}
    
    /// Retrieve a favourite from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    ///
    /// - Returns: A Future returning a CachedFavourite or an Error
    public func findFavourite(byIdDirectory idDirectory: String) -> Future<CachedFavourite, Error> {
        Future { promise in
            guard let favourite = self.realm.objects(CachedFavourite.self)
                .where({ favourite in favourite.idDirectory == idDirectory }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(favourite))
        }
    }
    
    /// Retrieve all favourites, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedFavourite or an Error
    public func findAllFavourites() -> Future<[CachedFavourite], Error> {
        Future { promise in
            guard let favourites = Optional(self.realm.objects(CachedFavourite.self)), !favourites.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(favourites.toArray()))
        }
    }
    
    /// Save a list of favourites to the cache
    ///
    /// - Parameters:
    ///   - favorites: An Array of CachedFavourite
    /// - Remark: This function is used only for Unit Testing
    @discardableResult
    public func save(favourites: [CachedFavourite]) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try CatchRealmException.catch {
                    try! self.realm.write {
                        self.realm.add(favourites, update: .modified)
                    }
                    promise(.success(()))
                }
            } catch (let error) {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    /// Save or update a favourite to the cache
    ///
    /// - Parameters:
    ///   - favorite: A CachedFavourite
    @discardableResult
    public func saveOrUpdate(favourite: CachedFavourite) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try CatchRealmException.catch {
                    try! self.realm.write {
                        self.realm.add(favourite, update: .modified)
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
    public func delete(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try CatchRealmException.catch {
                    try! self.realm.write {
                        guard let favourite = self.realm.object(ofType: CachedFavourite.self, forPrimaryKey: idDirectory) else {
                            promise(.failure(Realm.Error(Realm.Error.fail)))
                            return
                        }
                        try autoreleasepool {
                            try Realm().delete(favourite)
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
