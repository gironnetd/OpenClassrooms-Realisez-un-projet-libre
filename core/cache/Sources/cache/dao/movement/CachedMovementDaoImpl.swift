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
    /// - Returns: A Future returning a CachedMovement or an Error
    func findMovement(byIdMovement idMovement: Int) -> Future<CachedMovement, Error> {
        Future { promise in
            guard let movement = try? Realm().objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(movement))
        }
    }
    
    /// Retrieve a movement from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: A Future returning an Array of CachedMovement or an Error
    func findMovements(byName name: String) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = try? Realm().objects(CachedMovement.self)
                    .where({ book in book.name == name }), !movements.isEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            
            guard movements.count == 1, let movement = movements.first, !movement.idRelatedMovements.isEmpty else {
                return promise(.success(movements.toArray()))
            }
            
            promise(
                .success(
                    movement.idRelatedMovements
                        .reduce(into: [CachedMovement](arrayLiteral: movement)) { result, idMovement in
                            if let movement = try? Realm().objects(CachedMovement.self)
                                .where({ movement in movement.idMovement == idMovement }).first {
                                result.append(movement)
                            }
                        }
                )
            )
        }
    }
    
    /// Retrieve a list of movements containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent movement
    ///
    /// - Returns: A Future returning an Array of CachedMovement or an Error
    func findMovements(byIdParent idParent: Int) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = try? Realm().objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idParent }).first?.movements, !movements.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(movements.toArray()))
        }
    }
    
    /// Retrieve a list of main movements containing  authors, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedMovement or an Error
    func findMainMovements() -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = try? Realm().objects(CachedMovement.self)
                    .where({ movement in movement.idParentMovement == nil }), !movements.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(movements.toArray()))
        }
    }
    
    /// Retrieve all movements, from the cache
    ///
    /// - Returns: A Future returning an Array of CachedMovement or an Error
    func findAllMovements() -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = try? Realm().objects(CachedMovement.self), !movements.isEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(movements.toArray()))
        }
    }
}
