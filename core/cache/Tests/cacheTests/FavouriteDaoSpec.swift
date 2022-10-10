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
import CatchRealmException
import testing

@testable import cache

class FavouriteDaoSpec: QuickSpec {
    
    override func spec() {
        
        var favouriteDatabase : Realm!
        var favouriteDao : FavouriteDao!
        
        var firstFavourite: CachedFavourite!
        var secondFavourite: CachedFavourite!
        var thirdFavourite: CachedFavourite!
        
        var validConfiguration: Realm.Configuration!
        var invalidConfiguration: Realm.Configuration!
        
        beforeSuite {
            validConfiguration = Realm.Configuration(inMemoryIdentifier: "cached-account-dao-testing")
            
            let file = Bundle.module.url(forResource: "default", withExtension: "realm")
            invalidConfiguration = Realm.Configuration(fileURL: file?.absoluteURL, readOnly: true, schemaVersion: 1)
        }
        
        beforeEach {
            firstFavourite = CachedFavourite.testFavourite()
            secondFavourite = CachedFavourite.testFavourite()
            thirdFavourite = CachedFavourite.testFavourite()
        }
        
        afterEach {
            if let favouriteDatabase = favouriteDatabase {
                autoreleasepool {
                    do {
                        try CatchRealmException.catch {
                            try! favouriteDatabase.write {
                                favouriteDatabase.deleteAll()
                            }
                        }
                    } catch { }
                }
            }
        }
        
        describe("Find Favourite by idDirectory") {
            
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                favouriteDatabase = try? Realm()
                favouriteDao = FavouriteDaoImpl()
            }
            
            context("Found") {
                it("Favourite is returned") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([firstFavourite, secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect { try favouriteDao.findFavourite(byIdDirectory: firstFavourite.idDirectory).waitingCompletion().first }.to(equal(firstFavourite))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect { try favouriteDao.findFavourite(byIdDirectory: firstFavourite.idDirectory).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Favourites") {
            
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                favouriteDatabase = try? Realm()
                favouriteDao = FavouriteDaoImpl()
            }
            
            context("Found") {
                it("All Favourites are returned") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([firstFavourite, secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect { try favouriteDao.findAllFavourites().waitingCompletion().first }.to(equal([firstFavourite, secondFavourite, thirdFavourite]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try favouriteDao.findAllFavourites().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Delete Favourite") {
            
            beforeEach {
                Realm.Configuration.defaultConfiguration = validConfiguration
                favouriteDatabase = try? Realm()
                favouriteDao = FavouriteDaoImpl()
            }
            
            context("Found") {
                it("Return deletion succeeded") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([firstFavourite, secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect { try favouriteDao.delete(byIdDirectory: firstFavourite.idDirectory).waitingCompletion().first }.to(beVoid())
                    
                    expect { try favouriteDao.findAllFavourites().waitingCompletion().first }.toNot(contain(firstFavourite))
                }
            }
            
            context("Not Found") {
                it("Error is Thrown") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect {
                        try favouriteDao.delete(byIdDirectory: firstFavourite.idDirectory).waitingCompletion()
                    }.to(throwError())
                }
            }
        }
        
        describe("Save Favourites") {
            context("Saved") {
                it("Return save succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    favouriteDatabase = try? Realm()
                    favouriteDao = FavouriteDaoImpl()
                    
                    expect { try favouriteDao.save(favourites: [firstFavourite, secondFavourite, thirdFavourite]).waitingCompletion().first }.to(beVoid())
                    
                    expect { favouriteDatabase.objects(CachedFavourite.self).toArray() }.to(equal([firstFavourite, secondFavourite, thirdFavourite]))
                }
            }
            
            context("Invalid configuration") {
                it("Error is thrown") {
                    Realm.Configuration.defaultConfiguration = invalidConfiguration
                    favouriteDatabase = try? Realm()
                    favouriteDao = FavouriteDaoImpl()
                    
                    expect { try favouriteDao.save(favourites: [firstFavourite, secondFavourite, thirdFavourite]).waitingCompletion() }.to(throwError())
                }
            }
        }
        
        describe("Save Favourite") {
            context("Saved") {
                it("Return save succeeded") {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    favouriteDatabase = try? Realm()
                    favouriteDao = FavouriteDaoImpl()
                    
                    expect { try favouriteDao.saveOrUpdate(favourite: firstFavourite).waitingCompletion().first }.to(beVoid())
                    
                    expect { favouriteDatabase.objects(CachedFavourite.self).toArray() }.to(equal([firstFavourite]))
                }
            }
            
            context("Invalid configuration") {
                it("Error is thrown") {
                    Realm.Configuration.defaultConfiguration = invalidConfiguration
                    favouriteDatabase = try? Realm()
                    favouriteDao = FavouriteDaoImpl()
                    
                    expect { try favouriteDao.saveOrUpdate(favourite: firstFavourite).waitingCompletion() }.to(throwError())
                }
            }
        }
    }
}

extension CachedFavourite {
    
    static func testFavourite() -> CachedFavourite {
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
                        urls: List<CachedUrl>())
    }
}
