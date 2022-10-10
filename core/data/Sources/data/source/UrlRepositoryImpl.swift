//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache

public class UrlRepositoryImpl: UrlRepository {
    
    private let urlDao: UrlDao
    
    public init() {
        urlDao = UrlDaoImpl()
    }
    
    /// Retrieve a url from its identifier
    ///
    /// - Parameters:
    ///   - idUrl: The identifier of the url
    ///
    /// - Returns: An AnyPublisher returning an Url or an Error
    public func findUrl(byIdUrl idUrl : Int) -> AnyPublisher<Url, Error> {
        urlDao.findUrl(byIdUrl: idUrl).map { url in url.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier author
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdAuthor idAuthor: Int) -> AnyPublisher<[Url], Error> {
        urlDao.findUrls(byIdAuthor: idAuthor).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdBook idBook: Int) -> AnyPublisher<[Url], Error> {
        urlDao.findUrls(byIdBook: idBook).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdMovement idMovement: Int) -> AnyPublisher<[Url], Error> {
        urlDao.findUrls(byIdMovement: idMovement).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier source
    ///
    /// - Parameters:
    ///   - idSource: The identifier of the source
    ///   - sourceType: The type of the source
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdSource idSource: Int, sourceType: String) -> AnyPublisher<[Url], Error> {
        urlDao.findUrls(byIdSource: idSource, sourceType: sourceType).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an type source
    ///
    /// - Parameters:
    ///   - sourceType: The type of the source
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(bySourceType sourceType: String) -> AnyPublisher<[Url], Error> {
        urlDao.findUrls(bySourceType: sourceType).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve all urls
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findAllUrls() -> AnyPublisher<[Url], Error> {
        urlDao.findAllUrls().map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
