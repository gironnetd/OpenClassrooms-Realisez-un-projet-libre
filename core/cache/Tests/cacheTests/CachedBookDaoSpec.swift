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

class CachedBookDaoSpec: QuickSpec {
    
    override func spec() {
        
        var bookDatabase : Realm!
        var cachedBookDao : CachedBookDao!
        
        var firstBook: CachedBook!
        var secondBook: CachedBook!
        var thirdBook: CachedBook!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-book-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            bookDatabase = try? Realm()
            cachedBookDao = CachedBookDaoImpl()
            
            firstBook = CachedBook.testBook()
            secondBook = CachedBook.testBook()
            thirdBook = CachedBook.testBook()
        }
        
        afterEach {
            try? bookDatabase.write {
                bookDatabase.deleteAll()
                try? bookDatabase.commitWrite()
            }
        }
        
        describe("Find Book by idBook") {
            context("Found") {
                it("Book is returned") {
                    try? bookDatabase.write {
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBook(byIdBook: firstBook.idBook).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? bookDatabase.write {
                        bookDatabase.add([secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBook(byIdBook: firstBook.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Books by name") {
            context("Found") {
                it("Books are returned") {
                    try? bookDatabase.write {
                        secondBook.name = firstBook.name
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Found with idRelatedBooks") {
                it("Books are returned") {
                    try? bookDatabase.write {
                        firstBook.idRelatedBooks.append(secondBook.idBook)
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? bookDatabase.write {
                        bookDatabase.add([secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBooks(byName: firstBook.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Books by idMovement") {
            context("Found") {
                it("Books are returned") {
                    let movement = CachedMovement.testMovement()
                    try? bookDatabase.write {
                        firstBook.idMovement = movement.idMovement
                        secondBook.idMovement = movement.idMovement
                        
                        movement.books.append(objectsIn: [firstBook, secondBook])
                        
                        bookDatabase.add(movement)
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBooks(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? bookDatabase.write {
                        let movement = CachedMovement.testMovement()
                        firstBook.idMovement = movement.idMovement
                        secondBook.idMovement = movement.idMovement
                        
                        movement.books.append(objectsIn: [firstBook, secondBook])
                        
                        bookDatabase.add(movement)
                        bookDatabase.add(thirdBook)
                        
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBooks(byIdMovement: thirdBook.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Books by idTheme") {
            context("Found") {
                it("Books are returned") {
                    let theme = CachedTheme.testTheme()
                    try? bookDatabase.write {
                        theme.books.append(objectsIn: [firstBook, secondBook])
                        bookDatabase.add(theme)
                        
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBooks(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    try? bookDatabase.write {
                        
                        firstTheme.books.append(objectsIn: [firstBook, secondBook])
                        
                        bookDatabase.add([firstTheme, secondTheme])
                        bookDatabase.add(thirdBook)
                        
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBooks(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Book by idPresentation") {
            context("Found") {
                it("Book is returned") {
                    let presentation = CachedPresentation.testPresentation()
                    try? bookDatabase.write {
                        firstBook.presentation = presentation
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let presentation = CachedPresentation.testPresentation()
                    try? bookDatabase.write {
                        bookDatabase.add(presentation)
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Book by idPicture") {
            context("Found") {
                it("Book is returned") {
                    let picture = CachedPicture.testPicture()
                    try? bookDatabase.write {
                        firstBook.pictures.append(picture)
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let picture = CachedPicture.testPicture()
                    try? bookDatabase.write {
                        bookDatabase.add(picture)
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Books") {
            context("Found") {
                it("All Books are returned") {
                    try? bookDatabase.write {
                        bookDatabase.add([firstBook, secondBook, thirdBook])
                        try? bookDatabase.commitWrite()
                    }
                    
                    expect { try cachedBookDao.findAllBooks().waitingCompletion().first }.to(equal([firstBook, secondBook, thirdBook]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try cachedBookDao.findAllBooks().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedBook {
    
    static func testBook() -> CachedBook {
        CachedBook(idBook: DataFactory.randomInt(),
                   name: DataFactory.randomString(),
                   language: .none,
                   idRelatedBooks: List<Int>(),
                   century: CachedCentury.testCentury(),
                   details: DataFactory.randomString(),
                   period: DataFactory.randomString(),
                   idMovement: DataFactory.randomInt(),
                   presentation: CachedPresentation.testPresentation(),
                   mcc1: DataFactory.randomString(),
                   quotes: List<CachedQuote>(),
                   pictures: List<CachedPicture>(),
                   urls: List<CachedUrl>())
    }
}
