//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache

public class FavouriteRepositoryImpl: FavouriteRepository {
    
    private let favouriteDao: FavouriteDao
    
    public init() {
        favouriteDao = FavouriteDaoImpl()
    }
    
    /// Retrieve a favourite from its identifier
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    ///
    /// - Returns: An AnyPublisher returning a Favourite or an Error
    public func findFavourite(byIdDirectory idDirectory: String) -> AnyPublisher<Favourite, Error> {
        favouriteDao.findFavourite(byIdDirectory: idDirectory).map { favourite in favourite.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve all favourites
    ///
    /// - Returns: An AnyPublisher returning an Array of Favourite or an Error
    public func findAllFavourites() -> AnyPublisher<[Favourite], Error> {
        favouriteDao.findAllFavourites().map { favourites in
            favourites.map { favourite in favourite.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Save a list of favourites
    ///
    /// - Parameters:
    ///   - favorites: An Array of Favourite
    /// - Remark: This function is used only for Unit Testing
    @discardableResult
    public func save(favourites: [Favourite]) -> AnyPublisher<Void, Error> {
        favouriteDao.save(favourites: favourites.map { favourite in favourite.asCached()})
    }

    /// Save or update a favourite
    ///
    /// - Parameters:
    ///   - favorite: A Favourite
    @discardableResult
    public func saveOrUpdate(favourite: Favourite) -> AnyPublisher<Void, Error> {
        favouriteDao.saveOrUpdate(favourite: favourite.asCached())
    }
    
    /// Delete a favourite
    ///
    /// - Parameters:
    ///   - idDirectory: The identifier of the favourite folder
    @discardableResult
    public func delete(byIdDirectory idDirectory: String) -> AnyPublisher<Void, Error> {
        favouriteDao.delete(byIdDirectory: idDirectory)
    }
}
