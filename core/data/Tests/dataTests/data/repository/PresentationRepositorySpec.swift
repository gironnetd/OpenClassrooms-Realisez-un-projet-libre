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

class PresentationRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var presentationRepository: DefaultPresentationRepository!
        var presentationDao: PresentationDao!
        
        var firstPresentation: Presentation!
        var secondPresentation: Presentation!
        var thirdPresentation: Presentation!
        
        beforeEach {
            presentationDao = TestPresentationDao()
            presentationRepository = DefaultPresentationRepository(presentationDao: presentationDao)
            
            firstPresentation = Presentation.testPresentation()
            secondPresentation = Presentation.testPresentation()
            thirdPresentation = Presentation.testPresentation()
        }
        
        describe("Find presentation by idPresentation") {
            context("Found") {
                it("Presentation is returned") {
                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdPresentation: firstPresentation.idPresentation).waitingCompletion().first }.to(equal(firstPresentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[ secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdPresentation: firstPresentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idAuthor") {
            context("Found") {
                it("Presentation is returned") {
                    let author = Author.testAuthor()
                    (presentationDao as? TestPresentationDao)?.authors.append(author.asCached())
                    
                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let author = Author.testAuthor()

                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        
        
        describe("Find presentation by idBook") {
            context("Found") {
                it("Presentation is returned") {
                    let book = Book.testBook()

                    (presentationDao as? TestPresentationDao)?.books.append(book.asCached())
                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let book = Book.testBook()

                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idMovement") {
            context("Found") {
                it("Presentation is returned") {
                    let movement = Movement.testMovement()

                    (presentationDao as? TestPresentationDao)?.movements.append(movement.asCached())
                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let movement = Movement.testMovement()

                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all presentations") {
            context("Found") {
                it("All presentations are returned") {
                    (presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findAllPresentations().waitingCompletion().first }.to(equal([firstPresentation, secondPresentation, thirdPresentation]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try presentationRepository.findAllPresentations().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
