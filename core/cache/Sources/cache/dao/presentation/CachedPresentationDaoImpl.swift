//
//  CachedPresentationDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedPresentation Dao Protocol
 */
public class CachedPresentationDaoImpl : CachedPresentationDao {
    
    /// Retrieve a presentation from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdPresentation idPresentation: Int) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let presentation = try? Realm().objects(CachedPresentation.self)
                .where({ presentation in presentation.idPresentation == idPresentation }).first else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentation))
        }
    }
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdAuthor idAuthor: Int) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let presentation = try? Realm().objects(CachedAuthor.self)
                    .where({ author in author.idAuthor == idAuthor }).first?.presentation else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentation))
        }
    }
    
    /// Retrieve a presentation from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdBook idBook: Int) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let presentation = try? Realm().objects(CachedBook.self)
                    .where({ book in book.idBook == idBook }).first?.presentation else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentation))
        }
    }
    
    /// Retrieve a presentation from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdMovement idMovement: Int) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let presentation = try? Realm().objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first?.presentation else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentation))
        }
    }
    
    /// Retrieve all presentations, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedPresentationor an Error
    func findAllPresentations() -> Future<[CachedPresentation], Error> {
        Future { promise in
            guard let presentations = try? Realm().objects(CachedPresentation.self), !presentations.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentations.toArray()))
        }
    }
}
