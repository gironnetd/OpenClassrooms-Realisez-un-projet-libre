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
    /// - Returns: An AnyPublisher returning a CachedFavourite or an Error
    func findFavourite(byIdDirectory idDirectory: Int) -> AnyPublisher<CachedFavourite, Error> {
        if let favourite = try? Realm().objects(CachedFavourite.self)
            .where({ favourite in favourite.idDirectory == idDirectory }).first {
            return Just(favourite).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all favorites, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedFavourite or an Error
    func findAllFavourites() -> AnyPublisher<[CachedFavourite], Error> {
        if let favourites = try? Realm().objects(CachedFavourite.self) {
            return Just(favourites.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Save a list of favorites to the cache
    ///
    /// - Parameters:
    ///   - favorites: An Array of CachedFavourite
    /// - Remark: This function is used only for Unit Testing
    func save(favourites: [CachedFavourite]) -> AnyPublisher<Void, Error> {
        do {
            try Realm().write {
                try Realm().add(favourites, update: .modified)
            }
            return Empty().eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    /// Save or update a favorite to the cache
    ///
    /// - Parameters:
    ///   - favorite: A CachedFavourite
    func saveOrUpdate(favourite: CachedFavourite) -> AnyPublisher<Void, Error> {
        do {
            try Realm().write {
                try Realm().add(favourite, update: .modified)
            }
            return Empty().eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Delete a favorite to the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favorite folder
    func delete(byIdDirectory idDirectory: Int) -> AnyPublisher<Void, Error> {
        do {
            try Realm().write {
                if let favourite = try Realm().object(ofType: CachedFavourite.self, forPrimaryKey: idDirectory) {
                    try Realm().delete(favourite)
                }
            }
            return Empty().eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
