//
//  CachedMovementDaoImpl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

/**
 * Implementation for the CachedMovement Dao Protocol
 */
public class CachedMovementDaoImpl : CachedMovementDao {
    
    /// Retrieve a movement from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a CachedMovement or an Error
    func findMovement(byIdMovement idMovement: Int) -> AnyPublisher<CachedMovement, Error> {
        if let movement = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.idMovement == idMovement }).first {
            return Just(movement).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a movement from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findMovements(byName name: String) -> AnyPublisher<[CachedMovement], Error> {
        guard let movements = try? Realm().objects(CachedMovement.self)
                .where({ movement in movement.name == name }) else {
            return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
        }
        
        if movements.count == 1, let movement = movements.first {
            return Just(
                movement.idRelatedMovements
                    .reduce(into: [CachedMovement](arrayLiteral: movement)) { result, idMovement in
                          if let movement = try? Realm().objects(CachedMovement.self)
                              .where({ movement in movement.idMovement == idMovement }).first {
                              result.append(movement)
                          }
                }
            ).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Just(movements.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of movements containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent movement
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findMovements(byIdParent idParent: Int) -> AnyPublisher<[CachedMovement], Error> {
        if let movements = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.idMovement == idParent }).first?.movements {
            return Just(movements.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of main movements containing  authors, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findMainMovements() -> AnyPublisher<[CachedMovement], Error> {
        if let movements = try? Realm().objects(CachedMovement.self)
            .where({ movement in movement.idParentMovement == nil }) {
            return Just(movements.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
    
    /// Retrieve all movements, from the cache
    ///
    /// - Returns: An AnyPublisher returning an Array of CachedMovement or an Error
    func findAllMovements() -> AnyPublisher<[CachedMovement], Error> {
        if let movements = try? Realm().objects(CachedMovement.self) {
            return Just(movements.toArray()).setFailureType(to:Error.self).eraseToAnyPublisher()
        }
        return Fail(error: Realm.Error.init(Realm.Error.fail)).eraseToAnyPublisher()
    }
}
