//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestMovementDao: MovementDao {
    
    internal var movements: [CachedMovement]  = []
    
    func findMovement(byIdMovement idMovement: Int) -> Future<CachedMovement, Error> {
        Future { promise in
            guard let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movement))
        }
    }
    
    func findMovements(byName name: String) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.name == name })), !movements.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard movements.count == 1, let movement = movements.first, !movement.idRelatedMovements.isEmpty else {
                return promise(.success(movements))
            }
            
            promise(
                .success(
                    movement.idRelatedMovements
                        .reduce(into: [CachedMovement](arrayLiteral: movement)) { result, idMovement in
                            if let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first {
                                result.append(movement)
                            }
                        }
                )
            )
        }
    }
    
    func findMovements(byIdParent idParent: Int) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = self.movements.filter({ movement in movement.idMovement == idParent }).first?.movements,
                  !movements.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movements.toArray()))
        }
    }
    
    func findMainMovements() -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.idParentMovement == nil })),
                  !movements.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movements))
        }
    }
    
    func findAllMovements() -> Future<[CachedMovement], Error> {
        Future { promise in
            guard !self.movements.isEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.movements))
        }
    }
}
