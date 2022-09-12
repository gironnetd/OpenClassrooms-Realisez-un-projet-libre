//
//  CachedQuoteDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedQuote Dao Protocol
 */
public class CachedQuoteDaoImpl : CachedQuoteDao {
    
    /// Retrieve a quote from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idQuote: The identifier of the quote
    ///
    /// - Returns: An AnyPublisher returning a CachedQuote or an Error
    func findQuote(byIdQuote idQuote: Int) -> AnyPublisher<CachedQuote, Error> {
        if let quote = try? Realm().objects(CachedQuote.self)
            .where({ quote in quote.idQuote == idQuote }).first {
            return Just(quote).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byIdAuthor idAuthor: Int) -> AnyPublisher<[CachedQuote], Error> {
        if let quotes = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.idAuthor == idAuthor }).first?.quotes {
            return Just(quotes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a author name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byAuthor name: String) -> AnyPublisher<[CachedQuote], Error> {
        if let quotes = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.name == name }).first?.quotes {
            return Just(quotes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byIdBook idBook: Int) -> AnyPublisher<[CachedQuote], Error> {
        if let quotes = try? Realm().objects(CachedBook.self)
            .where({ book in book.idBook == idBook }).first?.quotes {
            return Just(quotes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a book name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byBook name: String) -> AnyPublisher<[CachedQuote], Error> {
        if let quotes = try? Realm().objects(CachedBook.self)
            .where({ book in book.name == name }).first?.quotes {
            return Just(quotes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byIdMovement idMovement: Int) -> AnyPublisher<[CachedQuote], Error> {
        guard let movement = try? Realm().objects(CachedMovement.self)
                .where({ movement in movement.idMovement == idMovement }).first else {
            return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
        }
        
        if movement.nbTotalQuotes != 0 {
            return Just(
                movement.authors.reduce(into: [CachedQuote]()) { result, author in
                    result.append(contentsOf: author.quotes)
                } + movement.books.reduce(into: [CachedQuote]()) { result, book in
                    result.append(contentsOf: book.quotes)
                }
            ).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a movement name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byMovement name: String) -> AnyPublisher<[CachedQuote], Error> {
        guard let movement = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.name == name }).first else {
            return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
        }
        
        if movement.nbTotalQuotes != 0 {
            return Just(
                movement.authors.reduce(into: [CachedQuote]()) { result, author in
                    result.append(contentsOf: author.quotes)
                } + movement.books.reduce(into: [CachedQuote]()) { result, book in
                    result.append(contentsOf: book.quotes)
                }
            ).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byIdTheme idTheme: Int) -> AnyPublisher<[CachedQuote], Error> {
        if let quotes = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.idTheme == idTheme }).first?.quotes {
            return Just(quotes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a theme name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findQuotes(byTheme name: String) -> AnyPublisher<[CachedQuote], Error> {
        if let quotes = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.name == name }).first?.quotes {
            return Just(quotes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all quotes, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedQuote or an Error
    func findAllQuotes() -> AnyPublisher<[CachedQuote], Error> {
        if let quotes = try? Realm().objects(CachedQuote.self) {
            return Just(quotes.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
