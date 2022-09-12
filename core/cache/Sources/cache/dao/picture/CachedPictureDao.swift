//
//  CachedPictureDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Data Access Object of Pictures.
 */
protocol CachedPictureDao {
    
    /// Retrieve a picture from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPicture(byIdPicture idPicture: Int) -> AnyPublisher<CachedPicture, Error>
    
    /// Retrieve a list of pictures from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdAuthor idAuthor: Int) -> AnyPublisher<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from a identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdBook idBook: Int) -> AnyPublisher<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from a movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdMovement idMovement: Int) -> AnyPublisher<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdTheme idTheme: Int) -> AnyPublisher<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from its small name, from the cache
    ///
    /// - Parameters:
    ///   - nameSmall: The nameSmall of the picture
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byNameSmall nameSmall: String) -> AnyPublisher<[CachedPicture], Error>
    
    /// Retrieve all pictures, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findAllPictures() -> AnyPublisher<[CachedPicture], Error>
}
