//
//  CachedUrlDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Data Access Object of Urls.
 */
protocol CachedUrlDao {
    
    /// Retrieve a url from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idUrl: The identifier of the url
    ///
    /// - Returns: An AnyPublisher returning an CachedUrl or an Error
    func findUrl(byIdUrl idUrl : Int) -> AnyPublisher<CachedUrl, Error>
    
    /// Retrieve a list of urls from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedUrl or an Error
    func findUrls(byIdAuthor idAuthor: Int) -> AnyPublisher<[CachedUrl], Error>
    
    /// Retrieve a list of urls from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedUrl or an Error
    func findUrls(byIdBook idBook: Int) -> AnyPublisher<[CachedUrl], Error>
    
    /// Retrieve a list of urls from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedUrl or an Error
    func findUrls(byIdMovement idMovement: Int) -> AnyPublisher<[CachedUrl], Error>
    
    /// Retrieve a list of urls from an identifier source, from the cache
    ///
    /// - Parameters:
    ///   - idSource: The identifier of the source
    ///   - sourceType: The type of the source
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedUrl or an Error
    func findUrls(byIdSource idSource: Int, sourceType: String) -> AnyPublisher<[CachedUrl], Error>
    
    /// Retrieve a list of urls from an type source, from the cache
    ///
    /// - Parameters:
    ///   - sourceType: The type of the source
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedUrl or an Error
    func findUrls(bySourceType sourceType: String) -> AnyPublisher<[CachedUrl], Error>
    
    /// Retrieve all urls, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedUrl or an Error
    func findAllUrls() -> AnyPublisher<[CachedUrl], Error>
}
