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

public class MovementRepositoryImpl: MovementRepository {
    
    private let movementDao: MovementDao
    
    public init() {
        movementDao = MovementDaoImpl()
    }
    
    /// Retrieve a movement from its identifier
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a Movement or an Error
    public func findMovement(byIdMovement idMovement: Int) -> AnyPublisher<Movement, Error> {
        movementDao.findMovement(byIdMovement: idMovement).map { movement in movement.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a movement from its name
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Movement or an Error
    public func findMovements(byName name: String) -> AnyPublisher<[Movement], Error> {
        movementDao.findMovements(byName: name).map { movements in
            movements.map { movement in movement.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of movements containing with same parent identifier
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Movement or an Error
    public func findMovements(byIdParent idParent: Int) -> AnyPublisher<[Movement], Error> {
        movementDao.findMovements(byIdParent: idParent).map { movements in
            movements.map { movement in movement.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of main movements containing  authors
    ///
    /// - Returns: An AnyPublisher returning an Array of Movement or an Error
    public func findMainMovements() -> AnyPublisher<[Movement], Error> {
        movementDao.findMainMovements().map { movements in
            movements.map { movement in movement.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve all movements
    ///
    /// - Returns: An AnyPublisher returning an Array of Movement or an Error
    public func findAllMovements() -> AnyPublisher<[Movement], Error> {
        movementDao.findAllMovements().map { movements in
            movements.map { movement in movement.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
