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

public class QuoteRepositoryImpl: QuoteRepository {
    
    private let quoteDao: QuoteDao
    
    public init() {
        quoteDao = QuoteDaoImpl()
    }
    
    /// Retrieve a quote from its identifier
    ///
    /// - Parameters:
    ///   - idQuote: The identifier of the quote
    ///
    /// - Returns: An AnyPublisher returning a Quote or an Error
    public func findQuote(byIdQuote idQuote: Int) -> AnyPublisher<Quote, Error> {
        quoteDao.findQuote(byIdQuote: idQuote).map { quote in quote.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdAuthor idAuthor: Int) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byIdAuthor: idAuthor).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a author name
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byAuthor name: String) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byAuthor: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdBook idBook: Int) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byIdBook: idBook).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a book name
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byBook name: String) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byBook: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdMovement idMovement: Int) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byIdMovement: idMovement).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a movement name
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byMovement name: String) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byMovement: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdTheme idTheme: Int) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byIdTheme: idTheme).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a theme name
    ///
    /// - Parameters:
    ///   - name: The name of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byTheme name: String) -> AnyPublisher<[Quote], Error> {
        quoteDao.findQuotes(byTheme: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve all quotes
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findAllQuotes() -> AnyPublisher<[Quote], Error> {
        quoteDao.findAllQuotes().map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
