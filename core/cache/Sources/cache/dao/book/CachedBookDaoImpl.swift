//
//  CachedBookDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedBook Dao Protocol
 */
public class CachedBookDaoImpl : CachedBookDao {
    
    /// Retrieve an book from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a CachedBook or an Error
    func findBook(byIdBook idBook: Int) -> AnyPublisher<CachedBook, Error> {
        if let book = try? Realm().objects(CachedBook.self)
            .where({ book in book.idBook == idBook }).first {
            return Just(book).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve  books from a name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedBook or an Error
    func findBooks(byName name: String) -> AnyPublisher<[CachedBook], Error> {
        guard let books = try? Realm().objects(CachedBook.self)
            .where({ book in book.name == name }) else {
            return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
        }
        
        if books.count == 1, let book = books.first {
            return Just(
                book.idRelatedBooks
                    .reduce(into: [CachedBook](arrayLiteral: book)) { result, idBook in
                          if let book = try? Realm().objects(CachedBook.self)
                              .where({ book in book.idBook == idBook }).first {
                              result.append(book)
                          }
                }
            ).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Just(books.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of books from its identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedBook or an Error
    func findBooks(byIdMovement idMovement: Int) -> AnyPublisher<[CachedBook], Error> {
        if let books = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.idMovement == idMovement }).first?.books {
            return Just(books.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of books containing in a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedBook or an Error
    func findBooks(byIdTheme idTheme: Int) -> AnyPublisher<[CachedBook], Error> {
        if let books = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.idTheme == idTheme }).first?.books {
            return Just(books.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a book from its identifier presentation, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning a CachedBook or an Error
    func findBook(byIdPresentation idPresentation: Int) -> AnyPublisher<CachedBook, Error> {
        if let book = try? Realm().objects(CachedBook.self)
            .where({ book in book.presentation.idPresentation == idPresentation }).first {
            return Just(book).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a book from a identifier picture, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning an AccountEntity or an Error
    func findBook(byIdPicture idPicture: Int) -> AnyPublisher<CachedBook, Error> {
        if let picture = try? Realm().objects(CachedPicture.self)
            .where({ picture in picture.idPicture == idPicture}).first,
           let book = try? Realm().objects(CachedBook.self)
            .where({ book in book.pictures.contains(picture)}).first {
            return Just(book).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all books, from the cache
    ///
    /// - Returns: An AnyPublisher returning an AccountEntity or an Error
    func findAllBooks() -> AnyPublisher<[CachedBook], Error> {
        if let books = try? Realm().objects(CachedBook.self) {
            return Just(books.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
