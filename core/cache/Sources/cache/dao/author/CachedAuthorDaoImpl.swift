//
//  CachedAuthorDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedAuthor Dao Protocol
 */
public class CachedAuthorDaoImpl : CachedAuthorDao {
    
    /// Retrieve an author from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an CachedAuthor or an Error
    func findAuthor(byIdAuthor idAuthor: Int) -> AnyPublisher<CachedAuthor, Error> {
        if let author = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.idAuthor == idAuthor }).first {
            return Just(author).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve an author from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedAuthor or an Error
    func findAuthors(byName name: String) -> AnyPublisher<[CachedAuthor], Error> {
        guard let authors = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.name == name }) else {
            return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
        }
        
        if authors.count == 1, let author = authors.first {
            return Just(
                author.idRelatedAuthors
                    .reduce(into: [CachedAuthor](arrayLiteral: author)) { result, idAuthor in
                          if let author = try? Realm().objects(CachedAuthor.self)
                              .where({ author in author.idAuthor == idAuthor }).first {
                              result.append(author)
                          }
                }
            ).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Just(authors.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        
    }
    
    /// Retrieve a list of authors from its identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedAuthor or an Error
    func findAuthors(byIdMovement idMovement: Int) -> AnyPublisher<[CachedAuthor], Error> {
        if let authors = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.idMovement == idMovement }).first?.authors {
            return Just(authors.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of authors containing in a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedAuthor or an Error
    func findAuthors(byIdTheme idTheme: Int) -> AnyPublisher<[CachedAuthor], Error> {
        if let authors = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.idTheme == idTheme }).first?.authors {
            return Just(authors.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a author from its identifier presentation, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning an CachedAuthor or an Error
    func findAuthor(byIdPresentation idPresentation: Int) -> AnyPublisher<CachedAuthor, Error> {
        if let author = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.presentation.idPresentation == idPresentation }).first {
            return Just(author).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a author from a identifier picture, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning an CachedAuthor or an Error
    func findAuthor(byIdPicture idPicture: Int) -> AnyPublisher<CachedAuthor, Error> {
        if let picture = try? Realm().objects(CachedPicture.self)
            .where({ picture in picture.idPicture == idPicture}).first,
           let author = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.pictures.contains(picture)}).first {
            return Just(author).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all authors, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedAuthor or an Error
    func findAllAuthors() -> AnyPublisher<[CachedAuthor], Error> {
        if let authors = try? Realm().objects(CachedAuthor.self) {
            return Just(authors.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
