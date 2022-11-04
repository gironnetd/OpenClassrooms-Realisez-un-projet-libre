//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import testing
import remote
import cache
import model

@testable import data

class MovementRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var movementRepository: DefaultMovementRepository!
        var movementDao: MovementDao!
        
        var firstMovement: Movement!
        var secondMovement: Movement!
        var thirdMovement: Movement!
        
        beforeEach {
            movementDao = TestMovementDao()
            movementRepository = DefaultMovementRepository(movementDao: movementDao)
            
            firstMovement = Movement.testMovement()
            secondMovement = Movement.testMovement()
            thirdMovement = Movement.testMovement()
        }
        
        describe("Find movement by idMovement") {
            context("Found") {
                it("Movement is returned") {
                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovement(byIdMovement: firstMovement.idMovement).waitingCompletion().first }.to(equal(firstMovement))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovement(byIdMovement: firstMovement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find movements by name") {
            context("Found") {
                it("Movements are returned") {
                    secondMovement.name = firstMovement.name

                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Found with idRelatedMovements") {
                it("Movements are returned") {
                     firstMovement.idRelatedMovements?.append(secondMovement.idMovement)

                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    secondMovement.name = firstMovement.name
                    
                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find movements by idParent") {
            context("Found") {
                it("Movements are returned") {
                    firstMovement.movements = [secondMovement, thirdMovement]
                    
                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byIdParent: firstMovement.idMovement).waitingCompletion().first }.to(equal([secondMovement, thirdMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byIdParent: DataFactory.randomInt()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find main Movements") {
            context("Found") {
                it("Main movements are returned") {
                    firstMovement.idParentMovement = nil
                    secondMovement.idParentMovement = nil

                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMainMovements().waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMainMovements().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all movements") {
            context("Found") {
                it("All Movements are returned") {
                    (movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findAllMovements().waitingCompletion().first }.to(equal([firstMovement, secondMovement, thirdMovement]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try movementRepository.findAllMovements().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
