//
//  CachedQuoteDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Data Access Object of Quotes.
 */
protocol CachedQuoteDao {
    
    /// Retrieve a quote from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idQuote: The identifier of the quote
    ///
    /// - Returns: A Future returning a CachedQuote or an Error
    func findQuote(byIdQuote idQuote: Int) -> Future<CachedQuote, Error>
    
    /// Retrieve a list of quotes from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byIdAuthor idAuthor: Int) -> Future<[CachedQuote], Error>
    
    /// Retrieve a list of quotes from a author name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byAuthor name: String) -> Future<[CachedQuote], Error>
    
    /// Retrieve a list of quotes from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byIdBook idBook: Int) -> Future<[CachedQuote], Error>
    
    /// Retrieve a list of quotes from a book name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byBook name: String) -> Future<[CachedQuote], Error>
    
    /// Retrieve a list of quotes from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byIdMovement idMovement: Int) -> Future<[CachedQuote], Error>
    
    /// Retrieve a list of quotes from a movement name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byMovement name: String) -> Future<[CachedQuote], Error>
    
    /// Retrieve a list of quotes from an identifier theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byIdTheme idTheme: Int) -> Future<[CachedQuote], Error>
    
    /// Retrieve a list of quotes from a theme name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the theme
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findQuotes(byTheme name: String) -> Future<[CachedQuote], Error>
    
    /// Retrieve all quotes, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    func findAllQuotes() -> Future<[CachedQuote], Error>
}
