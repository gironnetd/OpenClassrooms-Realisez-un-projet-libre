//
//  CachedFavouriteDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedFavourite Dao Protocol
 */
public class CachedFavouriteDaoImpl : CachedFavouriteDao {
    
    /// Retrieve a favorite from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favorite folder
    ///
    /// - Returns: A Future returning a CachedFavourite or an Error
    func findFavourite(byIdDirectory idDirectory: Int) -> Future<CachedFavourite, Error> {
        Future { promise in
            guard let favourite = try? Realm().objects(CachedFavourite.self)
                .where({ favourite in favourite.idDirectory == idDirectory }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(favourite))
        }
    }
    
    /// Retrieve all favorites, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedFavourite or an Error
    func findAllFavourites() -> Future<[CachedFavourite], Error> {
        Future { promise in
            guard let favourites = try? Realm().objects(CachedFavourite.self), !favourites.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(favourites.toArray()))
        }
    }
    
    /// Save a list of favorites to the cache
    ///
    /// - Parameters:
    ///   - favorites: An Array of CachedFavourite
    /// - Remark: This function is used only for Unit Testing
    @discardableResult
    func save(favourites: [CachedFavourite]) -> AnyPublisher<Void, Error> {
        favourites.forEach { favourite in saveOrUpdate(favourite: favourite) }
        return Empty().eraseToAnyPublisher()
    }

    /// Save or update a favorite to the cache
    ///
    /// - Parameters:
    ///   - favorite: A CachedFavourite
    @discardableResult
    func saveOrUpdate(favourite: CachedFavourite) -> AnyPublisher<Void, Error> {
        try! Realm().write {
            try Realm().add(favourite, update: .modified)
            return Empty().eraseToAnyPublisher()
        }
    }
    
    /// Delete a favorite to the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favorite folder
    @discardableResult
    func delete(byIdDirectory idDirectory: Int) -> AnyPublisher<Void, Error> {
        Future { promise in
            try? Realm().write {
                guard let favourite = try Realm().object(ofType: CachedFavourite.self, forPrimaryKey: idDirectory) else {
                    return promise(.failure(Realm.Error(Realm.Error.fail)))
                }
                try Realm().delete(favourite)
                return promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}
