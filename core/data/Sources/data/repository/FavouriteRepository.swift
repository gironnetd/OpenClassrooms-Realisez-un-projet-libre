//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol FavouriteRepository {
    
    /// Retrieve a favourite from its identifier
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    ///
    /// - Returns: An AnyPublisher returning a Favourite or an Error
    func findFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Favourite, Error>
    
    /// Retrieve all favourites
    ///
    /// - Returns: An AnyPublisher returning an Array of Favourite or an Error
    func findAllFavourites() -> AnyPublisher<[Favourite], Error>
    
    /// Save a list of favourites
    ///
    /// - Parameters:
    ///   - favorites: An Array of Favourite
    /// - Remark: This function is used only for Unit Testing
    @discardableResult
    func save(favourites: [Favourite]) -> AnyPublisher<Void, Error>

    /// Save or update a favourite
    ///
    /// - Parameters:
    ///   - favorite: A Favourite
    @discardableResult
    func saveOrUpdate(favourite: Favourite) -> AnyPublisher<Void, Error>
    
    /// Delete a favourite
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    func delete(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error>
}
