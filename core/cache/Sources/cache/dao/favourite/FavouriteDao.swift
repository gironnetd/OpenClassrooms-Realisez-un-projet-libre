//
//  CachedFavouriteDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Data Access Object of Favourites.
 */
public protocol FavouriteDao: RealmDao {
    
    /// Retrieve a favourite from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favorite folder
    ///
    /// - Returns: A Future returning a CachedFavourite or an Error
    func findFavourite(byIdDirectory idDirectory: String) -> Future<CachedFavourite, Error>
    
    /// Retrieve all favourites, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedFavourite or an Error
    func findAllFavourites() -> Future<[CachedFavourite], Error>
    
    /// Save a list of favourites to the cache
    ///
    /// - Parameters:
    ///   - favorites: An Array of CachedFavourite
    /// - Remark: This function is used only for Unit Testing
    @discardableResult
    func save(favourites: [CachedFavourite]) -> AnyPublisher<Void, Error>

    /// Save or update a favourite to the cache
    ///
    /// - Parameters:
    ///   - favorite: A CachedFavourite
    @discardableResult
    func saveOrUpdate(favourite: CachedFavourite) -> AnyPublisher<Void, Error>
    
    /// Delete a favourite to the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    func delete(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error>
}
