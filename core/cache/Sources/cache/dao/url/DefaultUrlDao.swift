//
//  CachedUrlDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedUrl Dao Protocol
 */
public class DefaultUrlDao: UrlDao {
    
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    /// Retrieve a url from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idUrl: The identifier of the url
    ///
    /// - Returns: A Future returning an CachedUrl or an Error
    public func findUrl(byIdUrl idUrl: Int) -> Future<CachedUrl, Error> {
        Future { promise in
            guard let url = self.realm.objects(CachedUrl.self)
                .where({ url in url.idUrl == idUrl }).first else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(url))
        }
    }
    
    /// Retrieve a list of urls from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning an Array of CachedUrl or an Error
    public func findUrls(byIdAuthor idAuthor: Int) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.realm.objects(CachedAuthor.self)
                    .where({ author in author.idAuthor == idAuthor }).first?.urls,
                  !urls.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    /// Retrieve a list of urls from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning an Array of CachedUrl or an Error
    public func findUrls(byIdBook idBook: Int) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.realm.objects(CachedBook.self)
                    .where({ book in book.idBook == idBook }).first?.urls,
                  !urls.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    /// Retrieve a list of urls from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning an Array of CachedUrl or an Error
    public func findUrls(byIdMovement idMovement: Int) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first?.urls,
                  !urls.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    /// Retrieve a list of urls from an identifier source, from the cache
    ///
    /// - Parameters:
    ///   - idSource: The identifier of the source
    ///   - sourceType: The type of the source
    ///
    /// - Returns: A Future returning an Array of CachedUrl or an Error
    public func findUrls(byIdSource idSource: Int, sourceType: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = Optional(self.realm.objects(CachedUrl.self)
                    .where({ url in url.sourceType == sourceType })
                    .where({ url in url.idSource == idSource })),
                  !urls.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    /// Retrieve a list of urls from an type source, from the cache
    ///
    /// - Parameters:
    ///   - sourceType: The type of the source
    ///
    /// - Returns: A Future returning an Array of CachedUrl or an Error
    public func findUrls(bySourceType sourceType: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = Optional(self.realm.objects(CachedUrl.self)
                    .where({ url in url.sourceType == sourceType })),
                  !urls.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    /// Retrieve all urls, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedUrl or an Error
    public func findAllUrls() -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = Optional(self.realm.objects(CachedUrl.self)),
                  !urls.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(urls.toArray()))
        }
    }
}
