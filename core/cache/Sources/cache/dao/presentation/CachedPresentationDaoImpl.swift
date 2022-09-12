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
    /// - Returns: An AnyPublisher returning a CachedPresentation or an Error
    func findPresentation(byIdPresentation idPresentation: Int) -> AnyPublisher<CachedPresentation, Error> {
        if let presentation = try? Realm().objects(CachedPresentation.self)
            .where({ presentation in presentation.idPresentation == idPresentation }).first {
            return Just(presentation).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a CachedPresentation or an Error
    func findPresentation(byIdAuthor idAuthor: Int) -> AnyPublisher<CachedPresentation, Error> {
        if let presentation = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.idAuthor == idAuthor }).first?.presentation {
            return Just(presentation).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a CachedPresentation or an Error
    func findPresentation(byIdBook idBook: Int) -> AnyPublisher<CachedPresentation, Error> {
        if let presentation = try? Realm().objects(CachedBook.self)
            .where({ book in book.idBook == idBook }).first?.presentation {
            return Just(presentation).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a CachedPresentation or an Error
    func findPresentation(byIdMovement idMovement: Int) -> AnyPublisher<CachedPresentation, Error> {
        if let presentation = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.idMovement == idMovement }).first?.presentation {
            return Just(presentation).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all presentations, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPresentationor an Error
    func findAllPresentations() -> AnyPublisher<[CachedPresentation], Error> {
        if let presentations = try? Realm().objects(CachedMovement.self) {
            return Just(presentations.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
