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

class BookRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var bookRepository: DefaultBookRepository!
        var bookDao: BookDao!
        
        var firstBook: Book!
        var secondBook: Book!
        var thirdBook: Book!
        
        beforeEach {
            bookDao = TestBookDao()
            bookRepository = DefaultBookRepository(bookDao: bookDao)
            
            firstBook = Book.testBook()
            secondBook = Book.testBook()
            thirdBook = Book.testBook()
        }
        
        afterEach {
            (bookDao as? TestBookDao)?.books = []
            (bookDao as? TestBookDao)?.themes = []
        }
        
        describe("Find book by idBook") {
            context("Found") {
                it("Book is returned") {
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdBook: firstBook.idBook).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdBook: firstBook.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by name") {
            context("Found") {
                it("Books are returned") {
                    secondBook.name = firstBook.name
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Found with idRelatedBooks") {
                it("Books are returned") {
                    firstBook.idRelatedBooks?.append(secondBook.idBook)
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byName: firstBook.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by idMovement") {
            context("Found") {
                it("Books are returned") {
                    let movement = Movement.testMovement()
                    firstBook.idMovement = movement.idMovement
                    secondBook.idMovement = movement.idMovement
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let movement = Movement.testMovement()
                    firstBook.idMovement = movement.idMovement
                    secondBook.idMovement = movement.idMovement
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byIdMovement: thirdBook.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by idTheme") {
            context("Found") {
                it("Books are returned") {
                    let theme = CachedTheme.testTheme()
                    theme.books.removeAll()
                    
                    theme.books.append(objectsIn: [firstBook.asCached(), secondBook.asCached()])
                    
                    (bookDao as? TestBookDao)?.themes.append(theme)
                    
                    expect { try bookRepository.findBooks(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    
                    firstTheme.books.removeAll()
                    secondTheme.books.removeAll()
                    
                    firstTheme.books.append(objectsIn: [firstBook.asCached(), secondBook.asCached()])
                    
                    (bookDao as? TestBookDao)?.themes.append(contentsOf: [firstTheme, secondTheme])
                    (bookDao as? TestBookDao)?.books.append(thirdBook.asCached())
                    
                    expect { try bookRepository.findBooks(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find book by idPresentation") {
            context("Found") {
                it("Book is returned") {
                    let presentation = Presentation.testPresentation()
                    
                    firstBook.presentation = presentation
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let presentation = Presentation.testPresentation()
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find book by idPicture") {
            context("Found") {
                it("Book is returned") {
                    let picture = Picture.testPicture()
                    firstBook.pictures?.append(picture)
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let picture = CachedPicture.testPicture()
                    
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all books") {
            context("Found") {
                it("All Books are returned") {
                    (bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findAllBooks().waitingCompletion().first }.to(equal([firstBook, secondBook, thirdBook]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try bookRepository.findAllBooks().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
