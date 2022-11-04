//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol PresentationRepository {
    
    /// Retrieve a presentation from its identifier
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    func findPresentation(byIdPresentation idPresentation: Int) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    func findPresentation(byIdAuthor idAuthor: Int) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve a presentation from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    func findPresentation(byIdBook idBook: Int) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve a presentation from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    func findPresentation(byIdMovement idMovement: Int) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve all presentations
    ///
    /// - Returns: An AnyPublisher returning an Array of Presentationor an Error
    func findAllPresentations() -> AnyPublisher<[Presentation], Error>
}
