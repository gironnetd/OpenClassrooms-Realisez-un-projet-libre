//
//  File.swift
//  
//
//  Created by damien on 14/09/2022.
//

import Foundation
import Quick
import Nimble
import RealmSwift
import testing

@testable import cache

class MovementDaoSpec: QuickSpec {
    
    override func spec() {
      
        var movementDatabase : Realm!
        var movementDao : MovementDao!

        var firstMovement: CachedMovement!
        var secondMovement: CachedMovement!
        var thirdMovement: CachedMovement!

        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-movement-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            movementDatabase = try? Realm()
            movementDao = MovementDaoImpl()

            firstMovement = CachedMovement.testMovement()
            secondMovement = CachedMovement.testMovement()
            thirdMovement = CachedMovement.testMovement()
        }

        afterEach {
            try? movementDatabase.write {
                movementDatabase.deleteAll()
                try? movementDatabase.commitWrite()
            }
        }
        
            describe("Find Movement by idMovement") {
                context("Found") {
                    it("Movement is returned") {
                        try? movementDatabase.write {
                            movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                            try? movementDatabase.commitWrite()
                        }
                        
                        expect { try movementDao.findMovement(byIdMovement: firstMovement.idMovement).waitingCompletion().first }.to(equal(firstMovement))
                    }
                }
                
                context("Not Found") {
                    it("Error is thrown") {
                        try? movementDatabase.write {
                            movementDatabase.add([secondMovement, thirdMovement])
                            try? movementDatabase.commitWrite()
                        }
                        
                        expect { try movementDao.findMovement(byIdMovement: firstMovement.idMovement).waitingCompletion().first }.to(throwError())
                    }
                }
            }
            
        describe("Find movements by name") {
            context("Found") {
                it("Movements are returned") {
                    secondMovement.name = firstMovement.name
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Found with idRelatedMovements") {
                it("Movements are returned") {
                    firstMovement.idRelatedMovements.append(secondMovement.idMovement)
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    secondMovement.name = firstMovement.name
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findMovements(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
            
            
        describe("Find Movements by idParent") {
            context("Found") {
                it("Movements are returned") {
                    firstMovement.movements.append(objectsIn: [secondMovement, thirdMovement])
                    
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findMovements(byIdParent: firstMovement.idMovement).waitingCompletion().first }.to(equal([secondMovement, thirdMovement]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findMovements(byIdParent: DataFactory.randomInt()).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Main Movements") {
            context("Found") {
                it("Main movements are returned") {
                    firstMovement.idParentMovement = nil
                    secondMovement.idParentMovement = nil
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findMainMovements().waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findMainMovements().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Movements") {
            context("Found") {
                it("All Movements are returned") {
                    try? movementDatabase.write {
                        movementDatabase.add([firstMovement, secondMovement, thirdMovement])
                        try? movementDatabase.commitWrite()
                    }
                    
                    expect { try movementDao.findAllMovements().waitingCompletion().first }.to(equal([firstMovement, secondMovement, thirdMovement]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try movementDao.findAllMovements().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedMovement {
    
    static func testMovement() -> CachedMovement {
        CachedMovement(idMovement: DataFactory.randomInt(),
                       idParentMovement: DataFactory.randomInt(),
                       name: DataFactory.randomString(),
                       language: .none,
                       idRelatedMovements: List<Int>(),
                       mcc1: DataFactory.randomString(),
                       mcc2: DataFactory.randomString(),
                       presentation: CachedPresentation.testPresentation(),
                       mcc3: DataFactory.randomString(),
                       nbQuotes: DataFactory.randomInt(),
                       nbAuthors: DataFactory.randomInt(),
                       nbAuthorsQuotes: DataFactory.randomInt(),
                       nbBooks: DataFactory.randomInt(),
                       nbBooksQuotes: DataFactory.randomInt(),
                       selected: DataFactory.randomBoolean(),
                       nbTotalQuotes: DataFactory.randomInt(),
                       nbTotalAuthors: DataFactory.randomInt(),
                       nbTotalBooks: DataFactory.randomInt(),
                       nbSubcourants: DataFactory.randomInt(),
                       nbAuthorsSubcourants: DataFactory.randomInt(),
                       nbBooksSubcourants: DataFactory.randomInt(),
                       authors: List<CachedAuthor>(),
                       books: List<CachedBook>(),
                       movements: List<CachedMovement>(),
                       pictures: List<CachedPicture>(),
                       urls: List<CachedUrl>())
    }
}
