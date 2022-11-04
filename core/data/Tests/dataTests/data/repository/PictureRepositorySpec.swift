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

class PictureRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var pictureRepository: DefaultPictureRepository!
        var pictureDao: PictureDao!
        
        var firstPicture: Picture!
        var secondPicture: Picture!
        var thirdPicture: Picture!
        
        beforeEach {
            pictureDao = TestPictureDao()
            pictureRepository = DefaultPictureRepository(pictureDao: pictureDao)
            
            firstPicture = Picture.testPicture()
            secondPicture = Picture.testPicture()
            thirdPicture = Picture.testPicture()
        }
        
        describe("Find picture by idPicture") {
            context("Found") {
                it("Picture is returned") {
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(equal(firstPicture))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idAuthor") {
            context("Found") {
                it("Pictures are returned") {
                    var author = Author.testAuthor()
                    author.pictures?.append(contentsOf: [firstPicture, secondPicture])

                    (pictureDao as? TestPictureDao)?.author = author.asCached()
                    
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.pictures))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var author = Author.testAuthor()
                    author.pictures?.removeAll()

                    (pictureDao as? TestPictureDao)?.author = author.asCached()
                    
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idBook") {
            context("Found") {
                it("Pictures are returned") {
                    var book = Book.testBook()
                    book.pictures?.append(contentsOf: [firstPicture, secondPicture])

                    (pictureDao as? TestPictureDao)?.book = book.asCached()
                    
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.pictures))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var book = Book.testBook()
                    book.pictures?.removeAll()

                    (pictureDao as? TestPictureDao)?.book = book.asCached()
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idMovement") {
            context("Pictures are found") {
                it("Pictures are returned") {
                    var movement = Movement.testMovement()
                    movement.pictures = [firstPicture, secondPicture]

                    (pictureDao as? TestPictureDao)?.movement = movement.asCached()
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.pictures))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {
                    var movement = Movement.testMovement()
                    movement.pictures?.removeAll()
                    
                    (pictureDao as? TestPictureDao)?.movement = movement.asCached()
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idTheme") {
            context("Pictures are found") {
                it("Pictures are returned") {
                    var theme = Theme.testTheme()
                    theme.pictures = [firstPicture, secondPicture]

                    (pictureDao as? TestPictureDao)?.theme = theme.asCached()
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal(theme.pictures))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let theme = Theme.testTheme()

                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by nameSmall") {
            context("Found") {
                it("Picture is returned") {
                    secondPicture.nameSmall = firstPicture.nameSmall

                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byNameSmall: firstPicture.nameSmall).waitingCompletion().first }.to(equal([firstPicture, secondPicture]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byNameSmall: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all pictures") {
            context("Found") {
                it("All Pictures are returned") {
                    (pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findAllPictures().waitingCompletion().first }.to(equal([firstPicture, secondPicture, thirdPicture]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try pictureRepository.findAllPictures().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
