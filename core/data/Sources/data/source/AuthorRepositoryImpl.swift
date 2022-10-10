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

public class AuthorRepositoryImpl: AuthorRepository {
    
    private let authorDao: AuthorDao
    
    public init() {
        authorDao = AuthorDaoImpl()
    }
    
    // Retrieve an author from its identifier
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Author or an Error
    public func findAuthor(byIdAuthor idAuthor: Int) -> AnyPublisher<Author, Error> {
        authorDao.findAuthor(byIdAuthor: idAuthor).map { author in author.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve an author from its name
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Author or an Error
    public func findAuthors(byName name: String) -> AnyPublisher<[Author], Error> {
        authorDao.findAuthors(byName: name).map { authors in
            authors.map { author in author.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of authors from its identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Author or an Error
    public func findAuthors(byIdMovement idMovement: Int) -> AnyPublisher<[Author], Error> {
        authorDao.findAuthors(byIdMovement: idMovement).map { authors in
            authors.map { author in author.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of authors containing in a theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Author or an Error
    public func findAuthors(byIdTheme idTheme: Int) -> AnyPublisher<[Author], Error> {
        authorDao.findAuthors(byIdTheme: idTheme).map { authors in
            authors.map { author in author.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a author from its identifier presentation
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning an Author or an Error
    public func findAuthor(byIdPresentation idPresentation: Int) -> AnyPublisher<Author, Error> {
        authorDao.findAuthor(byIdPresentation: idPresentation).map { author in author.asExternalModel() }
        .eraseToAnyPublisher()
    }
    
    /// Retrieve a author from a identifier picture
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning an Author or an Error
    public func findAuthor(byIdPicture idPicture: Int) -> AnyPublisher<Author, Error> {
        authorDao.findAuthor(byIdPicture: idPicture).map { author in author.asExternalModel() }
        .eraseToAnyPublisher()
    }
    
    /// Retrieve all authors
    ///
    /// - Returns: An AnyPublisher returning an Array of Author or an Error
    public func findAllAuthors() -> AnyPublisher<[Author], Error> {
        authorDao.findAllAuthors().map { authors in
            authors.map { author in author.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
