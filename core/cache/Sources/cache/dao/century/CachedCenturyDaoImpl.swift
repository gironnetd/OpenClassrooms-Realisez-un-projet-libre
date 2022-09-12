//
//  CachedCenturyDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedCentury Dao Protocol
 */
public class CachedCenturyDaoImpl : CachedCenturyDao {
    
    /// Retrieve a century from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idCentury: The identifier of the century
    ///
    /// - Returns: An AnyPublisher returning a CachedCentury or an Error
    func findCentury(byIdCentury idCentury: Int) -> AnyPublisher<CachedCentury, Error> {
        if let century = try? Realm().objects(CachedCentury.self)
            .where({ century in century.idCentury == idCentury }).first {
            return Just(century).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }

    /// Retrieve a century from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a CachedCentury or an Error
    func findCentury(byIdAuthor idAuthor: Int) -> AnyPublisher<CachedCentury, Error> {
        if let century = try? Realm().objects(CachedAuthor.self)
            .where({ author in author.idAuthor == idAuthor }).first?.century {
            return Just(century).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a century from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a CachedCentury or an Error
    func findCentury(byIdBook idBook: Int) -> AnyPublisher<CachedCentury, Error> {
        if let century = try? Realm().objects(CachedBook.self)
            .where({ book in book.idBook == idBook }).first?.century {
            return Just(century).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a century from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the century
    ///
    /// - Returns: An AnyPublisher returning a CachedCentury or an Error
    func findCentury(byName name: String) -> AnyPublisher<CachedCentury, Error> {
        if let century = try? Realm().objects(CachedCentury.self)
            .where({ century in century.century == name }).first {
            return Just(century).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all centuries, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedCentury or an Error
    func findAllCenturies() -> AnyPublisher<[CachedCentury], Error> {
        if let centuries = try? Realm().objects(CachedCentury.self) {
            return Just(centuries.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
