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

class AuthorDaoSpec: QuickSpec {
    
    override func spec() {
        
        var authorDatabase: Realm!
        var authorDao: AuthorDao!
        
        var firstAuthor: CachedAuthor!
        var secondAuthor: CachedAuthor!
        var thirdAuthor: CachedAuthor!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-author-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            authorDatabase = try? Realm()
            authorDao = AuthorDaoImpl()
            
            firstAuthor = CachedAuthor.testAuthor()
            secondAuthor = CachedAuthor.testAuthor()
            thirdAuthor = CachedAuthor.testAuthor()
        }
        
        afterEach {
            try? authorDatabase.write {
                authorDatabase.deleteAll()
                try? authorDatabase.commitWrite()
            }
        }
        
        describe("Find Author by idAuthor") {
            context("Found") {
                it("Author is returned") {
                    try? authorDatabase.write {
                        authorDatabase.add(
                            [firstAuthor, secondAuthor, thirdAuthor],
                            update: .all
                        )
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? authorDatabase.write {
                        authorDatabase.add([secondAuthor, thirdAuthor])
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Authors by name") {
            context("Found") {
                it("Authors are returned") {
                    try? authorDatabase.write {
                        secondAuthor.name = firstAuthor.name
                        authorDatabase.add([firstAuthor, secondAuthor, thirdAuthor])
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Found with idRelatedAuthors") {
                it("Authors are returned") {
                    try? authorDatabase.write {
                        firstAuthor.idRelatedAuthors.append(secondAuthor.idAuthor)
                        authorDatabase.add([firstAuthor, secondAuthor, thirdAuthor])
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? authorDatabase.write {
                        authorDatabase.add([secondAuthor, thirdAuthor])
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Authors by idMovement") {
            context("Found") {
                it("Authors are returned") {
                    let movement = CachedMovement.testMovement()
                    try? authorDatabase.write {
                        
                        firstAuthor.idMovement = movement.idMovement
                        secondAuthor.idMovement = movement.idMovement
                        
                        movement.authors.append(objectsIn: [firstAuthor, secondAuthor])
                        
                        authorDatabase.add(movement)
                        
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthors(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? authorDatabase.write {
                        let movement = CachedMovement.testMovement()
                        firstAuthor.idMovement = movement.idMovement
                        secondAuthor.idMovement = movement.idMovement
                        
                        movement.authors.append(objectsIn: [firstAuthor, secondAuthor])
                        
                        authorDatabase.add(movement)
                        authorDatabase.add(thirdAuthor)
                        
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthors(byIdMovement: thirdAuthor.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Authors by idTheme") {
            context("Found") {
                it("Authors are returned") {
                    let theme = CachedTheme.testTheme()
                    try? authorDatabase.write {
                        
                        theme.authors.append(objectsIn: [firstAuthor, secondAuthor])
                        authorDatabase.add(theme, update: .all)
                        
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthors(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    try? authorDatabase.write {
                        
                        firstTheme.authors.append(objectsIn: [firstAuthor, secondAuthor])
                        
                        authorDatabase.add([firstTheme, secondTheme], update: .all)
                        authorDatabase.add(thirdAuthor)
                        
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthors(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Author by idPresentation") {
            context("Found") {
                it("Author is returned") {
                    let presentation = CachedPresentation.testPresentation()
                    try? authorDatabase.write {
                        firstAuthor.presentation = presentation
                        authorDatabase.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let presentation = CachedPresentation.testPresentation()
                    try? authorDatabase.write {
                        authorDatabase.add(presentation)
                        authorDatabase.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Author by idPicture") {
            context("Found") {
                it("Author is returned") {
                    let picture = CachedPicture.testPicture()
                    try? authorDatabase.write {
                        firstAuthor.pictures.append(picture)
                        authorDatabase.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let picture = CachedPicture.testPicture()
                    try? authorDatabase.write {
                        authorDatabase.add(picture)
                        authorDatabase.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Authors") {
            context("Found") {
                it("All Authors are returned") {
                    try? authorDatabase.write {
                        authorDatabase.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                        try? authorDatabase.commitWrite()
                    }
                    
                    expect { try authorDao.findAllAuthors().waitingCompletion().first }.to(equal([firstAuthor, secondAuthor, thirdAuthor]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try authorDao.findAllAuthors().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedAuthor {
    
    static func testAuthor() -> CachedAuthor {
        CachedAuthor(idAuthor: DataFactory.randomInt(),
                     language: .none,
                     name: DataFactory.randomString(),
                     idRelatedAuthors: List<Int>(),
                     century: CachedCentury.testCentury(),
                     surname: DataFactory.randomString(),
                     details: DataFactory.randomString(),
                     period: DataFactory.randomString(),
                     idMovement: DataFactory.randomInt(),
                     bibliography: DataFactory.randomString(),
                     presentation: CachedPresentation.testPresentation(),
                     mainPicture: DataFactory.randomInt(),
                     mcc1: DataFactory.randomString(),
                     quotes: List<CachedQuote>(),
                     pictures: List<CachedPicture>(),
                     urls: List<CachedUrl>())
    }
}
