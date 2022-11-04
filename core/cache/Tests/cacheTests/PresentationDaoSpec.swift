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

class PresentationDaoSpec: QuickSpec {
    
    override func spec() {
        
        var presentationDatabase : Realm!
        var presentationDao : PresentationDao!
        
        var firstPresentation: CachedPresentation!
        var secondPresentation: CachedPresentation!
        var thirdPresentation: CachedPresentation!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-presentation-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            presentationDatabase = try? Realm()
            presentationDao = DefaultPresentationDao(realm: presentationDatabase)
            
            firstPresentation = CachedPresentation.testPresentation()
            secondPresentation = CachedPresentation.testPresentation()
            thirdPresentation = CachedPresentation.testPresentation()
        }
        
        afterEach {
            try? presentationDatabase.write {
                presentationDatabase.deleteAll()
                try? presentationDatabase.commitWrite()
            }
        }
        
        describe("Find presentation by idPresentation") {
            context("Found") {
                it("Presentation is returned") {
                    try? presentationDatabase.write {
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdPresentation: firstPresentation.idPresentation).waitingCompletion().first }.to(equal(firstPresentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    try? presentationDatabase.write {
                        presentationDatabase.add([secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdPresentation: firstPresentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idAuthor") {
            context("Found") {
                it("Presentation is returned") {
                    let author = CachedAuthor.testAuthor()
                    try? presentationDatabase.write {
                        presentationDatabase.add(author)
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()
                    try? presentationDatabase.write {
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        
        
        describe("Find presentation by idBook") {
            context("Found") {
                it("Presentation is returned") {
                    let book = CachedBook.testBook()
                    try? presentationDatabase.write {
                        presentationDatabase.add(book)
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let book = CachedBook.testBook()
                    try? presentationDatabase.write {
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idMovement") {
            context("Found") {
                it("Presentation is returned") {
                    let movement = CachedMovement.testMovement()
                    try? presentationDatabase.write {
                        presentationDatabase.add(movement)
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let movement = CachedMovement.testMovement()
                    try? presentationDatabase.write {
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all presentations") {
            context("Found") {
                it("All presentations are returned") {
                    try? presentationDatabase.write {
                        presentationDatabase.add([firstPresentation, secondPresentation, thirdPresentation])
                        try? presentationDatabase.commitWrite()
                    }
                    
                    expect { try presentationDao.findAllPresentations().waitingCompletion().first }.to(equal([firstPresentation, secondPresentation, thirdPresentation]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try presentationDao.findAllPresentations().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedPresentation {
    
    internal static func testPresentation() -> CachedPresentation {
        CachedPresentation(idPresentation: DataFactory.randomInt(),
                           presentation: DataFactory.randomString(),
                           presentationTitle1: DataFactory.randomString(),
                           presentation1: DataFactory.randomString(),
                           presentationTitle2: DataFactory.randomString(),
                           presentation2: DataFactory.randomString(),
                           presentationTitle3: DataFactory.randomString(),
                           presentation3: DataFactory.randomString(),
                           presentationTitle4: DataFactory.randomString(),
                           presentation4: DataFactory.randomString(),
                           sourcePresentation: DataFactory.randomString())
    }
}
