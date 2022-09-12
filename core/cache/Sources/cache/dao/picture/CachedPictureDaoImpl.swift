//
//  CachedPictureDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedPicture Dao Protocol
 */
public class CachedPictureDaoImpl : CachedPictureDao {
    
    /// Retrieve a picture from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPicture(byIdPicture idPicture: Int) -> AnyPublisher<CachedPicture, Error> {
        if let picture = try? Realm().objects(CachedPicture.self)
            .where({ picture in picture.idPicture == idPicture }).first {
            return Just(picture).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdAuthor idAuthor: Int) -> AnyPublisher<[CachedPicture], Error> {
        if let pictures = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.idAuthor == idAuthor }).first?.pictures {
            return Just(pictures.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from a identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdBook idBook: Int) -> AnyPublisher<[CachedPicture], Error> {
        if let pictures = try? Realm().objects(CachedBook.self)
            .where({ book in book.idBook == idBook }).first?.pictures {
            return Just(pictures.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from a movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdMovement idMovement: Int) -> AnyPublisher<[CachedPicture], Error> {
        if let pictures = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.idMovement == idMovement }).first?.pictures {
            return Just(pictures.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byIdTheme idTheme: Int) -> AnyPublisher<[CachedPicture], Error> {
        if let pictures = try? Realm().objects(CachedTheme.self)
            .where({ theme in theme.idTheme == idTheme }).first?.pictures {
            return Just(pictures.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from its small name, from the cache
    ///
    /// - Parameters:
    ///   - nameSmall: The nameSmall of the picture
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findPictures(byNameSmall nameSmall: String) -> AnyPublisher<[CachedPicture], Error> {
        if let pictures = try? Realm().objects(CachedPicture.self)
            .where({ picture in picture.nameSmall == nameSmall }) {
            return Just(pictures.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all pictures, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedPicture or an Error
    func findAllPictures() -> AnyPublisher<[CachedPicture], Error> {
        if let pictures = try? Realm().objects(CachedPicture.self) {
            return Just(pictures.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
