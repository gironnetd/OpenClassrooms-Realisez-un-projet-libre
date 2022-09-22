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

class CachedFavouriteDaoSpec: QuickSpec {
    
    override func spec() {
        
        var favouriteDatabase : Realm!
        var cachedFavouriteDao : CachedFavouriteDao!
        
        var firstFavourite: CachedFavourite!
        var secondFavourite: CachedFavourite!
        var thirdFavourite: CachedFavourite!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-favourite-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            favouriteDatabase = try? Realm()
            cachedFavouriteDao = CachedFavouriteDaoImpl()
            
            firstFavourite = CachedFavourite.testFavourite()
            secondFavourite = CachedFavourite.testFavourite()
            thirdFavourite = CachedFavourite.testFavourite()
        }
        
        afterEach {
            try? favouriteDatabase.write {
                favouriteDatabase.deleteAll()
                try? favouriteDatabase.commitWrite()
            }
        }
        
        describe("Find Favourite by idDirectory") {
            context("Found") {
                it("Favourite is returned") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([firstFavourite, secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect { try cachedFavouriteDao.findFavourite(byIdDirectory: firstFavourite.idDirectory).waitingCompletion().first }.to(equal(firstFavourite))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect { try cachedFavouriteDao.findFavourite(byIdDirectory: firstFavourite.idDirectory).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Favourites") {
            context("Found") {
                it("All Favourites are returned") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([firstFavourite, secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect { try cachedFavouriteDao.findAllFavourites().waitingCompletion().first }.to(equal([firstFavourite, secondFavourite, thirdFavourite]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try cachedFavouriteDao.findAllFavourites().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Delete Favourite") {
            context("Found") {
                it("Return deletion succeeded") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([firstFavourite, secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    cachedFavouriteDao.delete(byIdDirectory: firstFavourite.idDirectory)
                    
                    expect { try cachedFavouriteDao.findAllFavourites().waitingCompletion().first }.toNot(contain(firstFavourite))
                }
            }
            
            context("Not Found") {
                it("Error is Thrown") {
                    try? favouriteDatabase.write {
                        favouriteDatabase.add([secondFavourite, thirdFavourite])
                        try? favouriteDatabase.commitWrite()
                    }
                    
                    expect {
                        try cachedFavouriteDao.delete(byIdDirectory: firstFavourite.idDirectory).waitingCompletion()
                    }.to(throwError())
                }
            }
        }
        
        describe("Save Favourites") {
            context("Saved") {
                it("Return save succeeded") {
                    cachedFavouriteDao.save(favourites: [firstFavourite, secondFavourite, thirdFavourite])
                    
                    expect { favouriteDatabase.objects(CachedFavourite.self).toArray() }.to(equal([firstFavourite, secondFavourite, thirdFavourite]))
                }
            }
        }
        
        describe("Save Favourite") {
            context("Saved") {
                it("Return save succeeded") {
                    cachedFavouriteDao.saveOrUpdate(favourite: firstFavourite)
                    
                    expect { favouriteDatabase.objects(CachedFavourite.self).toArray() }.to(equal([firstFavourite]))
                }
            }
        }
    }
}

extension CachedFavourite {
    
    static func testFavourite() -> CachedFavourite {
        CachedFavourite(idDirectory: DataFactory.randomInt(),
                        idParentDirectory: DataFactory.randomInt(),
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
