//
//  CachedPresentationDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

protocol CachedPresentationDao {
    
    /// Retrieve a presentation from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdPresentation idPresentation: Int) -> Future<CachedPresentation, Error>
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdAuthor idAuthor: Int) -> Future<CachedPresentation, Error>
    
    /// Retrieve a presentation from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdBook idBook: Int) -> Future<CachedPresentation, Error>
    
    /// Retrieve a presentation from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning a CachedPresentation or an Error
    func findPresentation(byIdMovement idMovement: Int) -> Future<CachedPresentation, Error>
    
    /// Retrieve all presentations, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedPresentationor an Error
    func findAllPresentations() -> Future<[CachedPresentation], Error>
}
