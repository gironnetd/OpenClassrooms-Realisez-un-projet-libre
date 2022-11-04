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

public class DefaultPresentationRepository: PresentationRepository {
    
    private let presentationDao: PresentationDao
    
    public init(presentationDao: PresentationDao) {
        self.presentationDao = presentationDao
    }
    
    /// Retrieve a presentation from its identifier
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    public func findPresentation(byIdPresentation idPresentation: Int) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdPresentation: idPresentation).map { presentation in presentation.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    public func findPresentation(byIdAuthor idAuthor: Int) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdAuthor: idAuthor).map { presentation in presentation.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    public func findPresentation(byIdBook idBook: Int) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdBook: idBook).map { presentation in presentation.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    public func findPresentation(byIdMovement idMovement: Int) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdMovement: idMovement).map { presentation in presentation.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve all presentations
    ///
    /// - Returns: An AnyPublisher returning an Array of Presentationor an Error
    public func findAllPresentations() -> AnyPublisher<[Presentation], Error> {
        self.presentationDao.findAllPresentations().map { presentations in
            presentations.map { presentation in presentation.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
