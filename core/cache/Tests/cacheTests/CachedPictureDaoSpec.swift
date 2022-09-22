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

class CachedPictureDaoSpec: QuickSpec {
    
    override func spec() {
       
        var pictureDatabase : Realm!
        var cachedPictureDao : CachedPictureDao!
        
        var firstPicture: CachedPicture!
        var secondPicture: CachedPicture!
        var thirdPicture: CachedPicture!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-picture-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            pictureDatabase = try? Realm()
            cachedPictureDao = CachedPictureDaoImpl()
            
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
        
        
            describe("Find Picture by idPicture") {
                context("Found") {
                    it("Picture is returned") {
                        try? pictureDatabase.write {
                            pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                            try? pictureDatabase.commitWrite()
                        }
                        
                        expect { try cachedPictureDao.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(equal(firstPicture))
                    }
                }
                
                context("Not Found") {
                    it("Error is thrown") {
                        try? pictureDatabase.write {
                            pictureDatabase.add([secondPicture, thirdPicture])
                            try? pictureDatabase.commitWrite()
                        }
                        
                        expect { try cachedPictureDao.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(throwError())
                    }
                }
            }
            
        describe("Find Pictures by idAuthor") {
            context("Found") {
                it("Pictures are returned") {
                    let author = CachedAuthor.testAuthor()
                    author.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(author)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.pictures.toArray()))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()
                    try? pictureDatabase.write {
                        pictureDatabase.add(author)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Pictures by idBook") {
            context("Found") {
                it("Pictures are returned") {
                    let book = CachedBook.testBook()
                    book.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(book)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.pictures.toArray()))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let book = CachedBook.testBook()
                    try? pictureDatabase.write {
                        pictureDatabase.add(book)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Pictures by idMovement") {
            context("Pictures are found") {
                it("") {
                    let movement = CachedMovement.testMovement()
                    movement.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(movement)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.pictures.toArray()))
                }
            }
            
            context("Not Found") {
                it("An Error is thrown") {
                    let movement = CachedMovement.testMovement()
                    try? pictureDatabase.write {
                        pictureDatabase.add(movement)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Pictures by idTheme") {
            context("Pictures are found") {
                it("") {
                    let theme = CachedTheme.testTheme()
                    theme.pictures.append(objectsIn: [firstPicture, secondPicture])
                    try? pictureDatabase.write {
                        pictureDatabase.add(theme)
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal(theme.pictures.toArray()))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let theme = CachedTheme.testTheme()
                    try? pictureDatabase.write {
                        pictureDatabase.add(theme)
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Pictures by nameSmall") {
            context("Found") {
                it("Picture is returned") {
                    secondPicture.nameSmall = firstPicture.nameSmall
                    try? pictureDatabase.write {
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byNameSmall: firstPicture.nameSmall).waitingCompletion().first }.to(equal([firstPicture, secondPicture]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? pictureDatabase.write {
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findPictures(byNameSmall: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find all Pictures") {
            context("Found") {
                it("All Pictures are returned") {
                    try? pictureDatabase.write {
                        pictureDatabase.add([firstPicture, secondPicture, thirdPicture])
                        try? pictureDatabase.commitWrite()
                    }
                    
                    expect { try cachedPictureDao.findAllPictures().waitingCompletion().first }.to(equal([firstPicture, secondPicture, thirdPicture]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try cachedPictureDao.findAllPictures().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedPicture {
    
    static func testPicture() -> CachedPicture {
        CachedPicture(idPicture: DataFactory.randomInt(),
                      nameSmall: DataFactory.randomString(),
                      extension: DataFactory.randomString(),
                      comments: Map<String, String>(),
                      width: DataFactory.randomInt(),
                      height: DataFactory.randomInt())
    }
}
