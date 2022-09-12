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
protocol CachedFavouriteDao {
    
    /// Retrieve a favorite from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favorite folder
    ///
    /// - Returns: An AnyPublisher returning a CachedFavourite or an Error
    func findFavourite(byIdDirectory idDirectory: Int) -> AnyPublisher<CachedFavourite, Error>
    
    /// Retrieve all favorites, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedFavourite or an Error
    func findAllFavourites() -> AnyPublisher<[CachedFavourite], Error>
    
    /// Save a list of favorites to the cache
    ///
    /// - Parameters:
    ///   - favorites: An Array of CachedFavourite
    /// - Remark: This function is used only for Unit Testing
    func save(favourites: [CachedFavourite]) -> AnyPublisher<Void, Error>

    /// Save or update a favorite to the cache
    ///
    /// - Parameters:
    ///   - favorite: A CachedFavourite
    func saveOrUpdate(favourite: CachedFavourite) -> AnyPublisher<Void, Error>
    
    /// Delete a favorite to the cache
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favorite folder
    func delete(byIdDirectory idDirectory: Int) -> AnyPublisher<Void, Error>
}
