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

class AuthorRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var authorRepository: DefaultAuthorRepository!
        var authorDao: AuthorDao!
        
        var firstAuthor: Author!
        var secondAuthor: Author!
        var thirdAuthor: Author!
        
        beforeEach {
            authorDao = TestAuthorDao()
            authorRepository = DefaultAuthorRepository(authorDao: authorDao)
            
            firstAuthor = Author.testAuthor()
            secondAuthor = Author.testAuthor()
            thirdAuthor = Author.testAuthor()
        }
        
        afterEach {
            (authorDao as? TestAuthorDao)?.authors = []
            (authorDao as? TestAuthorDao)?.themes = []
        }
        
        describe("Find author by idAuthor") {
            
            context("Found") {
                it("Author is returned") {
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by name") {
            context("Found") {
                it("Authors are returned") {
                    secondAuthor.name = firstAuthor.name
                    
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Found with idRelatedAuthors") {
                it("Authors are returned") {
                    firstAuthor.idRelatedAuthors?.append(secondAuthor.idAuthor)
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by idMovement") {
            context("Found") {
                it("Authors are returned") {
                    let movement = Movement.testMovement()
                    
                    firstAuthor.idMovement = movement.idMovement
                    secondAuthor.idMovement = movement.idMovement
                    
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthors(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let movement = Movement.testMovement()
                    firstAuthor.idMovement = movement.idMovement
                    secondAuthor.idMovement = movement.idMovement
                    
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthors(byIdMovement: thirdAuthor.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by idTheme") {
            context("Found") {
                it("Authors are returned") {
                    let theme = CachedTheme.testTheme()
                    theme.authors.removeAll()
                    
                    theme.authors.append(objectsIn: [firstAuthor.asCached(), secondAuthor.asCached()])
                    
                    (authorDao as? TestAuthorDao)?.themes.append(theme)
                    
                    expect { try authorRepository.findAuthors(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    
                    firstTheme.authors.removeAll()
                    secondTheme.authors.removeAll()
                    
                    firstTheme.authors.append(objectsIn: [firstAuthor.asCached(), secondAuthor.asCached()])
                    
                    (authorDao as? TestAuthorDao)?.themes.append(contentsOf: [firstTheme, secondTheme])
                    (authorDao as? TestAuthorDao)?.authors.append(thirdAuthor.asCached())
                    
                    expect { try authorRepository.findAuthors(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find author by idPresentation") {
            context("Found") {
                it("Author is returned") {
                    let presentation = Presentation.testPresentation()
                    firstAuthor.presentation = presentation
                    
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let presentation = CachedPresentation.testPresentation()
                    
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find author by idPicture") {
            context("Found") {
                it("Author is returned") {
                    let picture = CachedPicture.testPicture()
                    firstAuthor.pictures?.append(picture.asExternalModel())
                    
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let picture = CachedPicture.testPicture()
                    
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all authors") {
            context("Found") {
                it("All Authors are returned") {
                    (authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAllAuthors().waitingCompletion().first }.to(equal([firstAuthor, secondAuthor, thirdAuthor]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try authorRepository.findAllAuthors().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
