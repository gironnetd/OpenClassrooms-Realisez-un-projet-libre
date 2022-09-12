//
//  CachedMovementDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

/**
 * Protocol defining methods for the Data Access Object of Movements.
 */
protocol CachedMovementDao {
    
    /// Retrieve a movement from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a CachedMovement or an Error
    func findMovement(byIdMovement idMovement: Int) -> AnyPublisher<CachedMovement, Error>
    
    /// Retrieve a movement from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findMovements(byName name: String) -> AnyPublisher<[CachedMovement], Error>
    
    /// Retrieve a list of movements containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findMovements(byIdParent idParent: Int) -> AnyPublisher<[CachedMovement], Error>
    
    /// Retrieve a list of main movements containing  authors, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findMainMovements() -> AnyPublisher<[CachedMovement], Error>
    
    /// Retrieve all movements, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findAllMovements() -> AnyPublisher<[CachedMovement], Error>
}
