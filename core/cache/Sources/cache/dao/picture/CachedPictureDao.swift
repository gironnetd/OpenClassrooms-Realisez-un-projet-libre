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
    /// - Returns: A Future returning an Array of CachedPicture or an Error
    func findPicture(byIdPicture idPicture: Int) -> Future<CachedPicture, Error>
    
    /// Retrieve a list of pictures from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning an Array of CachedPicture or an Error
    func findPictures(byIdAuthor idAuthor: Int) -> Future<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from a identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning an Array of CachedPicture or an Error
    func findPictures(byIdBook idBook: Int) -> Future<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from a movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning an Array of CachedPicture or an Error
    func findPictures(byIdMovement idMovement: Int) -> Future<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: A Future returning an Array of CachedPicture or an Error
    func findPictures(byIdTheme idTheme: Int) -> Future<[CachedPicture], Error>
    
    /// Retrieve a list of pictures from its small name, from the cache
    ///
    /// - Parameters:
    ///   - nameSmall: The nameSmall of the picture
    ///
    /// - Returns: A Future returning an Array of CachedPicture or an Error
    func findPictures(byNameSmall nameSmall: String) -> Future<[CachedPicture], Error>
    
    /// Retrieve all pictures, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedPicture or an Error
    func findAllPictures() -> Future<[CachedPicture], Error>
}
