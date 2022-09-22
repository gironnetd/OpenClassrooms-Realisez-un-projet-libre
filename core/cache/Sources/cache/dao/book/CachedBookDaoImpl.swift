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
    /// - Returns: A Future returning a CachedBook or an Error
    func findBook(byIdBook idBook: Int) -> Future<CachedBook, Error> {
        Future { promise in
            guard let book = try? Realm().objects(CachedBook.self)
                    .where({ book in book.idBook == idBook }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(book))
        }
    }
    
    /// Retrieve  books from a name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: A Future returning an Array of CachedBook or an Error
    func findBooks(byName name: String) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = try? Realm().objects(CachedBook.self)
                    .where({ book in book.name == name }), !books.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            
            guard books.count == 1, let book = books.first, !book.idRelatedBooks.isEmpty else {
                return promise(.success(books.toArray()))
            }
            
            promise(
                .success(
                        book.idRelatedBooks
                            .reduce(into: [CachedBook](arrayLiteral: book)) { result, idBook in
                                if let book = try? Realm().objects(CachedBook.self)
                                    .where({ book in book.idBook == idBook }).first {
                                    result.append(book)
                                }
                            }
                )
            )
        }
    }
    
    /// Retrieve a list of books from its identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the book
    ///
    /// - Returns: A Future returning an Array of CachedBook or an Error
    func findBooks(byIdMovement idMovement: Int) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = try? Realm().objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first?.books else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(books.toArray()))
        }
    }
    
    /// Retrieve a list of books containing in a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the book
    ///
    /// - Returns: A Future returning an Array of CachedBook or an Error
    func findBooks(byIdTheme idTheme: Int) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = try? Realm().objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idTheme }).first?.books, !books.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(books.toArray()))
        }
    }
    
    /// Retrieve a book from its identifier presentation, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Future returning a CachedBook or an Error
    func findBook(byIdPresentation idPresentation: Int) -> Future<CachedBook, Error> {
        Future { promise in
            guard let book = try? Realm().objects(CachedBook.self)
                    .where({ book in book.presentation.idPresentation == idPresentation }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(book))
        }
    }
    
    /// Retrieve a book from a identifier picture, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: A Future returning an AccountEntity or an Error
    func findBook(byIdPicture idPicture: Int) -> Future<CachedBook, Error> {
        Future { promise in
            guard let picture = try? Realm().objects(CachedPicture.self)
                    .where({ picture in picture.idPicture == idPicture}).first,
                  let book = try? Realm().objects(CachedBook.self)
                    .where({ book in book.pictures.contains(picture)}).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(book))
        }
    }
    
    /// Retrieve all books, from the cache
    ///
    /// - Returns: A Future returning an AccountEntity or an Error
    func findAllBooks() -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = try? Realm().objects(CachedBook.self), !books.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(books.toArray()))
        }
    }
}
