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
    /// - Returns: A Future returning a CachedCentury or an Error
    func findCentury(byIdCentury idCentury: Int) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = try? Realm().objects(CachedCentury.self)
                .where({ century in century.idCentury == idCentury }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
    }

    /// Retrieve a century from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning a CachedCentury or an Error
    func findCentury(byIdAuthor idAuthor: Int) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = try? Realm().objects(CachedAuthor.self)
                .where({ author in author.idAuthor == idAuthor }).first?.century else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
        
    }
    
    /// Retrieve a century from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning a CachedCentury or an Error
    func findCentury(byIdBook idBook: Int) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = try? Realm().objects(CachedBook.self)
                .where({ book in book.idBook == idBook }).first?.century else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
    }
    
    /// Retrieve a century from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the century
    ///
    /// - Returns: A Future returning a CachedCentury or an Error
    func findCentury(byName name: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = try? Realm().objects(CachedCentury.self)
                    .where({ century in century.century == name }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
    }
    
    /// Retrieve all centuries, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedCentury or an Error
    func findAllCenturies() -> Future<[CachedCentury], Error> {
        Future { promise in
            guard let centuries = try? Realm().objects(CachedCentury.self), !centuries.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(centuries.toArray()))
        }
    }
}
