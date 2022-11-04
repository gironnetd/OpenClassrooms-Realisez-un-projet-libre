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

class PictureDaoSpec: QuickSpec {
    
    override func spec() {
        
        var pictureDatabase : Realm!
        var pictureDao : PictureDao!
        
        var firstPicture: CachedPicture!
        var secondPicture: CachedPicture!
        var thirdPicture: CachedPicture!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-picture-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            pictureDatabase = try? Realm()
            pictureDao = DefaultPictureDao(realm: pictureDatabase)
            
            firstPicture = CachedPicture.testPicture()
            secondPicture = CachedPicture.testPicture()
            thirdPicture = CachedPicture.testPicture()
        }
        
        afterEach {
            try? pictureDatabase.write {
                pictureDatabase.deleteAll()
                try? pictureDatabase.commitWrite()
            }
        }
        
        describe("Find picture by idPicture") {
            context("Found") {
                it("Picture is returned") {
                    try? pictureDatabase.write {
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(equal(firstPicture))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    try? pictureDatabase.write {
                        pictureDatabase.add([secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idAuthor") {
            context("Found") {
                it("Pictures are returned") {
                    let author = CachedAuthor.testAuthor()
                    author.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(author)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()
                    try? pictureDatabase.write {
                        pictureDatabase.add(author)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idBook") {
            context("Found") {
                it("Pictures are returned") {
                    let book = CachedBook.testBook()
                    book.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(book)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let book = CachedBook.testBook()
                    try? pictureDatabase.write {
                        pictureDatabase.add(book)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idMovement") {
            context("Pictures are found") {
                it("Pictures are returned") {
                    let movement = CachedMovement.testMovement()
                    movement.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(movement)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {
                    let movement = CachedMovement.testMovement()
                    try? pictureDatabase.write {
                        pictureDatabase.add(movement)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idTheme") {
            context("Pictures are found") {
                it("Pictures are returned") {
                    let theme = CachedTheme.testTheme()
                    theme.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(theme)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal(theme.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let theme = CachedTheme.testTheme()
                    try? pictureDatabase.write {
                        pictureDatabase.add(theme)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by nameSmall") {
            context("Found") {
                it("Picture is returned") {
                    secondPicture.nameSmall = firstPicture.nameSmall
                    try? pictureDatabase.write {
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byNameSmall: firstPicture.nameSmall).waitingCompletion().first }.to(equal([firstPicture, secondPicture]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    try? pictureDatabase.write {
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findPictures(byNameSmall: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all pictures") {
            context("Found") {
                it("All Pictures are returned") {
                    try? pictureDatabase.write {
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try pictureDao.findAllPictures().waitingCompletion().first }.to(equal([firstPicture, secondPicture, thirdPicture]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try pictureDao.findAllPictures().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedPicture {
    
    internal static func testPicture() -> CachedPicture {
        CachedPicture(idPicture: DataFactory.randomInt(),
                      nameSmall: DataFactory.randomString(),
                      extension: DataFactory.randomString(),
                      comments: Map<String, String>(),
                      width: DataFactory.randomInt(),
                      height: DataFactory.randomInt(),
                      picture: DataFactory.randomData())
    }
}
