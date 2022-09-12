//
//  CachedBookDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Data Access Object of Books.
 */
protocol CachedBookDao {
    
    /// Retrieve an book from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a CachedBook or an Error
    func findBook(byIdBook idBook: Int) -> AnyPublisher<CachedBook, Error>
    
    /// Retrieve  books from a name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedBook or an Error
    func findBooks(byName name: String) -> AnyPublisher<[CachedBook], Error>
    
    /// Retrieve a list of books from its identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedBook or an Error
    func findBooks(byIdMovement idMovement: Int) -> AnyPublisher<[CachedBook], Error>
    
    /// Retrieve a list of books containing in a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedBook or an Error
    func findBooks(byIdTheme idTheme: Int) -> AnyPublisher<[CachedBook], Error>
    
    /// Retrieve a book from its identifier presentation, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning a CachedBook or an Error
    func findBook(byIdPresentation idPresentation: Int) -> AnyPublisher<CachedBook, Error>
    
    /// Retrieve a book from a identifier picture, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning an AccountEntity or an Error
    func findBook(byIdPicture idPicture: Int) -> AnyPublisher<CachedBook, Error>
    
    /// Retrieve all books, from the cache
    ///
    /// - Returns: An AnyPublisher returning an AccountEntity or an Error
    func findAllBooks() -> AnyPublisher<[CachedBook], Error>
}
