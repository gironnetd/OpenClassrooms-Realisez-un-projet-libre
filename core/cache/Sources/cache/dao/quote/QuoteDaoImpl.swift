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
public class QuoteDaoImpl : QuoteDao {
    
    public init() {}
    
    /// Retrieve a quote from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idQuote: The identifier of the quote
    ///
    /// - Returns: A Future returning a CachedQuote or an Error
    public func findQuote(byIdQuote idQuote: Int) -> Future<CachedQuote, Error> {
        Future { promise in
            guard let quote = self.realm.objects(CachedQuote.self)
                    .where({ quote in quote.idQuote == idQuote }).first else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quote))
        }
    }
    
    /// Retrieve a list of quotes from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byIdAuthor idAuthor: Int) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let quotes = self.realm.objects(CachedAuthor.self)
                    .where({ author in author.idAuthor == idAuthor }).first?.quotes, !quotes.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes.toArray()))
        }
    }
    
    /// Retrieve a list of quotes from a author name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byAuthor name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let authors = Optional(self.realm.objects(CachedAuthor.self)
                    .where({ author in author.name == name })),
                  !authors.isEmpty,
                  let quotes = Optional(authors.reduce(into: [CachedQuote](), { result, author in
                    result += author.quotes
                  })),
                  !quotes.isEmpty
            else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes))
        }
    }
    
    /// Retrieve a list of quotes from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byIdBook idBook: Int) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let quotes = self.realm.objects(CachedBook.self)
                    .where({ book in book.idBook == idBook }).first?.quotes, !quotes.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes.toArray()))
        }
    }
    
    /// Retrieve a list of quotes from a book name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byBook name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let books = Optional(self.realm.objects(CachedBook.self)
                    .where({ book in book.name == name })),
                  !books.isEmpty,
                  let quotes = Optional(books.reduce(into: [CachedQuote](), { result, book in
                    result += book.quotes
                  })),
                  !quotes.isEmpty
            else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes))
        }
    }
    
    /// Retrieve a list of quotes from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byIdMovement idMovement: Int) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let movement = self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first,
                  let quotes = Optional(movement.authors.reduce(into: [CachedQuote]()) { result, author in
                    result.append(contentsOf: author.quotes)
                  } + movement.books.reduce(into: [CachedQuote]()) { result, book in
                    result.append(contentsOf: book.quotes)
                  }),
                  !quotes.isEmpty
            else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes))
        }
    }
    
    /// Retrieve a list of quotes from a movement name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byMovement name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let movements = Optional(self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.name == name })),
                  !movements.isEmpty,
                  let quotes = Optional(movements.reduce(into: [CachedQuote](), { result, movement in
                    result += movement.authors.reduce(into: [CachedQuote]()) { result, author in
                        result += author.quotes
                    } + movement.books.reduce(into: [CachedQuote]()) { result, book in
                        result += book.quotes
                    }})),
                  !quotes.isEmpty
            else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes))
        }
    }
    
    /// Retrieve a list of quotes from an identifier theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byIdTheme idTheme: Int) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let theme = self.realm.objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idTheme }).first,
                  let quotes = Optional(theme.authors.reduce(into: [CachedQuote]()) { result, author in
                    result.append(contentsOf: author.quotes)
                  } + theme.books.reduce(into: [CachedQuote]()) { result, book in
                    result.append(contentsOf: book.quotes)
                  }),
                  !quotes.isEmpty
            else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes))
        }
    }
    
    /// Retrieve a list of quotes from a theme name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the theme
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findQuotes(byTheme name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let themes = Optional(self.realm.objects(CachedTheme.self)
                    .where({ theme in theme.name == name })),
                  !themes.isEmpty,
                  let quotes = Optional(themes.reduce(into: [CachedQuote](), { result, theme in
                    result += theme.authors.reduce(into: [CachedQuote]()) { result, author in
                        result += author.quotes
                    } + theme.books.reduce(into: [CachedQuote]()) { result, book in
                        result += book.quotes
                    }})),
                  !quotes.isEmpty
            else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes))
        }
    }
    
    /// Retrieve all quotes, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedQuote or an Error
    public func findAllQuotes() -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let quotes = Optional(self.realm.objects(CachedQuote.self)), !quotes.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(quotes.toArray()))
        }
    }
}
