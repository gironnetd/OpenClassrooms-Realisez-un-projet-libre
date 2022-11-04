//
//  CachedAccountDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine
import model

/**
 * Protocol defining methods for the Data Access Object of Users.
 */
public protocol UserDao {
    
    /// Retrieve current user, from the cache
    ///
    /// - Returns: A Future returning an CachedUser or an Error
    func findCurrentUser() -> Future<CachedUser, Error>
    
    /// Save or update current user to the cache
    ///
    /// - Parameters:
    ///   - currentUser: A CachedUser
    @discardableResult
    func saveOrUpdate(currentUser: CachedUser) -> AnyPublisher<Void, Error>
    
    /// Delete current user to the cache
    @discardableResult
    func deleteCurrentUser() -> AnyPublisher<Void, Error>
    
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
    func deleteFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error>
}
