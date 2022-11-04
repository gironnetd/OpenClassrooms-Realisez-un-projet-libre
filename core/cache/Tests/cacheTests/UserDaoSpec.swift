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
import RealmException

@testable import cache

class UserDaoSpec: QuickSpec {

    override func spec() {
        var userDatabase: Realm!
        var userDao: UserDao!
        
        var currentUser: CachedUser!
        
        var validConfiguration: Realm.Configuration!
        var invalidConfiguration: Realm.Configuration!
        
        beforeSuite {
            validConfiguration = Realm.Configuration(inMemoryIdentifier: "cached-user-dao-testing")
            
            let file = Bundle.module.url(forResource: "default", withExtension: "realm")
            invalidConfiguration = Realm.Configuration(fileURL: file?.absoluteURL, readOnly: true, schemaVersion: 1)
        }
        
        beforeEach {
            currentUser = CachedUser.testUser()
        }
        
        afterEach {
            if let userDatabase = userDatabase {
                autoreleasepool {
                    if !userDatabase.configuration.readOnly {
                        try! userDatabase.write {
                            userDatabase.deleteAll()
                            try? userDatabase.commitWrite()
                        }
                    }
                }
            }
        }
        
        describe("Find current user") {
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                userDatabase = try? Realm()
                userDao = DefaultUserDao(realm: userDatabase)
            }

            context("Found") {
                it("User is returned") {
                    try? userDatabase.write {
                        userDatabase.add(currentUser)
                        try? userDatabase.commitWrite()
                    }

                    expect { try userDao.findCurrentUser().waitingCompletion().first }.to(equal(currentUser))
                }
            }

            context("Not found") {
                it("Return nil value") {
                    expect { try userDao.findCurrentUser().waitingCompletion() }.to(throwError())
                }
            }
        }

        describe("Delete current user") {
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                userDatabase = try? Realm()
                userDao = DefaultUserDao(realm: userDatabase)
            }

            context("Found") {
                it("Return deletion succeeded") {
                    try? userDatabase.write {
                        userDatabase.add(currentUser)
                        try? userDatabase.commitWrite()
                    }

                    expect { try userDao.deleteCurrentUser().waitingCompletion().first }.to(beVoid())

                    expect { currentUser.isInvalidated }.to(beTrue())
                }
            }

            context("Not found") {
                it("Error is thrown") {
                    expect {
                        try userDao.deleteCurrentUser().waitingCompletion()
                    }.to(throwError())
                }
            }
        }
        
        describe("Save or update current user") {
            context("Saved") {
                it("Return save succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    userDatabase = try? Realm()
                    userDao = DefaultUserDao(realm: userDatabase)

                    expect { try userDao.saveOrUpdate(currentUser: currentUser).waitingCompletion().first }.to(beVoid())

                    expect { userDatabase.objects(CachedUser.self).toArray() }.to(equal([currentUser]))
                }
            }
            
            context("Updated") {
                it("Return updated succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    userDatabase = try? Realm()
                    userDao = DefaultUserDao(realm: userDatabase)

                    expect { try userDao.saveOrUpdate(currentUser: currentUser).waitingCompletion().first }.to(beVoid())

                    try userDatabase.write {
                        currentUser.email = DataFactory.randomEmail()
                    }
                    
                    expect { try userDao.saveOrUpdate(currentUser: currentUser).waitingCompletion().first }.to(beVoid())
                    
                    expect { userDatabase.objects(CachedUser.self).toArray() }.to(equal([currentUser]))
                }
            }

            context("Invalid configuration") {
                it("Error is thrown") {
                    Realm.Configuration.defaultConfiguration = invalidConfiguration
                    userDatabase = try? Realm()
                    userDao = DefaultUserDao(realm: userDatabase)

                    expect { try userDao.saveOrUpdate(currentUser: currentUser).waitingCompletion() }.to(throwError())
                }
            }
        }
        
        describe("Save or update favourite") {
            context("Saved") {
                it("Return saved succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    userDatabase = try? Realm()
                    userDao = DefaultUserDao(realm: userDatabase)
                    
                    let newFavourite = CachedFavourite.testFavourite()
                    newFavourite.idParentDirectory = currentUser.favourites?.idDirectory
                    currentUser.favourites?.subDirectories.append(newFavourite)
                    
                    try? userDatabase.write {
                        userDatabase.add(currentUser)
                        try? userDatabase.commitWrite()
                    }
                    
                    expect { try userDao.saveOrUpdate(favourite: newFavourite).waitingCompletion().first }.to(beVoid())
                    
                    expect { userDatabase.objects(CachedFavourite.self).toArray() }.to(contain(newFavourite))
                    
                    guard let actualUser = try userDao.findCurrentUser().waitingCompletion().first else { return }
                    
                    expect { actualUser.favourites?.subDirectories }.to(contain(newFavourite))
                }
            }
            
            context("Updated") {
                it("Return updated succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    userDatabase = try? Realm()
                    userDao = DefaultUserDao(realm: userDatabase)
                    
                    let newFavourite = CachedFavourite.testFavourite()
                    newFavourite.idParentDirectory = currentUser.favourites?.idDirectory
                    currentUser.favourites?.subDirectories.append(newFavourite)
                    
                    try? userDatabase.write {
                        userDatabase.add(currentUser)
                        try? userDatabase.commitWrite()
                    }
                    
                    expect { try userDao.saveOrUpdate(favourite: newFavourite).waitingCompletion().first }.to(beVoid())
                    
                    try userDatabase.write {
                        newFavourite.authors.append(CachedAuthor.testAuthor())
                    }
                    
                    expect { try userDao.saveOrUpdate(favourite: newFavourite).waitingCompletion().first }.to(beVoid())
                    
                    guard let actualUser = try userDao.findCurrentUser().waitingCompletion().first else { return }
                    
                    expect { actualUser.favourites?.subDirectories.where({ favourite in favourite.idDirectory == newFavourite.idDirectory }).first  }.to(equal(newFavourite))
                }
            }
            
            context("Invalid configuration") {
                it("Error is thrown") {
                    Realm.Configuration.defaultConfiguration = invalidConfiguration
                    userDatabase = try? Realm()
                    userDao = DefaultUserDao(realm: userDatabase)
                    
                    let newFavourite = CachedFavourite.testFavourite()
                    
                    expect { try userDao.saveOrUpdate(favourite: newFavourite).waitingCompletion() }.to(throwError())
                }
            }
        }
        
        describe("Delete favourite") {
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                userDatabase = try? Realm()
                userDao = DefaultUserDao(realm: userDatabase)
            }

            context("Found") {
                it("Return deletion succeeded") {
                    let newFavourite = CachedFavourite.testFavourite()
                    
                    newFavourite.subDirectories.append(CachedFavourite.testFavourite())
                    newFavourite.idParentDirectory = currentUser.favourites?.idDirectory
                    currentUser.favourites?.subDirectories.append(newFavourite)

                    try? userDatabase.write {
                        userDatabase.add(currentUser)
                        try? userDatabase.commitWrite()
                    }
                    let idDirectory = newFavourite.idDirectory
                    
                    expect { try userDao.deleteFavourite(byIdDirectory: idDirectory).waitingCompletion().first }.to(beVoid())

                    expect { newFavourite.isInvalidated }.to(beTrue())

                    expect { userDatabase.objects(CachedFavourite.self).toArray().map { favourite in favourite.idDirectory }}.notTo(contain(idDirectory))

                    guard let actualUser = try userDao.findCurrentUser().waitingCompletion().first else { return }

                    expect { actualUser.favourites?.subDirectories.toArray().map { favourite in favourite.idDirectory } }.notTo(contain(idDirectory))
                }
            }

            context("Not found") {
                it("Error is Thrown") {
                    let newFavourite = CachedFavourite.testFavourite()

                    try? userDatabase.write {
                        userDatabase.add(currentUser)
                        try? userDatabase.commitWrite()
                    }

                    expect {
                        try userDao.deleteFavourite(byIdDirectory: newFavourite.idDirectory).waitingCompletion().first
                    }.to(throwError())
                }
            }
        }
    }
}

extension CachedUser {
    
    internal static func testUser() -> CachedUser {
        return CachedUser(uid: DataFactory.randomString(),
                             providerID: DataFactory.randomString(),
                             email: DataFactory.randomString(),
                             displayName: DataFactory.randomString(),
                             phoneNumber: DataFactory.randomString(),
                             photo: DataFactory.randomData(),
                             favourites: CachedFavourite.testFavourite())
    }
}

extension CachedFavourite {
    
    static func testFavourite() -> CachedFavourite {
        let favourite = CachedFavourite(idDirectory: DataFactory.randomString(),
                                        idParentDirectory: DataFactory.randomString(),
                                        directoryName: DataFactory.randomString(),
                                        subDirectories: List<CachedFavourite>(),
                                        authors: [CachedAuthor.testAuthor()].toList(),
                                        books: [CachedBook.testBook()].toList(),
                                        movements: [CachedMovement.testMovement()].toList(),
                                        themes: [CachedTheme.testTheme()].toList(),
                                        quotes: [CachedQuote.testQuote()].toList(),
                                        pictures: [CachedPicture.testPicture()].toList(),
                                        presentations: [CachedPresentation.testPresentation()].toList(),
                                        urls: [CachedUrl.testUrl()].toList()
        )
        
        favourite.subDirectories.append(
            CachedFavourite(idDirectory: DataFactory.randomString(),
                            idParentDirectory: DataFactory.randomString(),
                            directoryName: DataFactory.randomString(),
                            subDirectories: List<CachedFavourite>(),
                            authors: List<CachedAuthor>(),
                            books: List<CachedBook>(),
                            movements: List<CachedMovement>(),
                            themes: List<CachedTheme>(),
                            quotes: List<CachedQuote>(),
                            pictures: List<CachedPicture>(),
                            presentations: List<CachedPresentation>(),
                            urls: List<CachedUrl>()
            )
        )
        
        return favourite
    }
}
