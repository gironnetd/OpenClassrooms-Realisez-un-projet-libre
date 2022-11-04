//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestUrlDao: UrlDao {
    
    internal var urls: [CachedUrl] = []
    internal var authors: [CachedAuthor] = []
    internal var books: [CachedBook] = []
    internal var movements: [CachedMovement] = []
    
    func findUrl(byIdUrl idUrl: Int) -> Future<CachedUrl, Error> {
        Future { promise in
            guard let url = self.urls.filter({ url in url.idUrl == idUrl }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(url))
        }
    }
    
    func findUrls(byIdAuthor idAuthor: Int) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.authors.filter({ author in author.idAuthor == idAuthor }).first?.urls, !urls.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    func findUrls(byIdBook idBook: Int) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.books.filter({ book in book.idBook == idBook }).first?.urls,
                  !urls.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    func findUrls(byIdMovement idMovement: Int) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.movements.filter({ movement in movement.idMovement == idMovement }).first?.urls,
                  !urls.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    func findUrls(byIdSource idSource: Int, sourceType: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = Optional(self.urls.filter({ url in url.sourceType == sourceType })
                    .filter({ url in url.idSource == idSource })), !urls.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls))
        }
    }
    
    func findUrls(bySourceType sourceType: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = Optional(self.urls.filter({ url in url.sourceType == sourceType })),
                     !urls.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls))
        }
    }
    
    func findAllUrls() -> Future<[CachedUrl], Error> {
        Future { promise in
            guard !self.urls.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.urls))
        }
    }
}
