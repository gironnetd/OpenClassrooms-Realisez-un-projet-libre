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

class ThemeDaoSpec: QuickSpec {
    
    override func spec() {
        
        var themeDatabase : Realm!
        var themeDao : ThemeDao!
        
        var firstTheme: CachedTheme!
        var secondTheme: CachedTheme!
        var thirdTheme: CachedTheme!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-theme-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            themeDatabase = try? Realm()
            themeDao = DefaultThemeDao(realm: themeDatabase)
            
            firstTheme = CachedTheme.testTheme()
            secondTheme = CachedTheme.testTheme()
            thirdTheme = CachedTheme.testTheme()
        }
        
        afterEach {
            try? themeDatabase.write {
                themeDatabase.deleteAll()
                try? themeDatabase.commitWrite()
            }
        }
        
        describe("Find theme by idTheme") {
            context("Found") {
                it("Theme is returned") {
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findTheme(byIdTheme: firstTheme.idTheme).waitingCompletion().first }.to(equal(firstTheme))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    try? themeDatabase.write {
                        themeDatabase.add([secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findTheme(byIdTheme: firstTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find themes by name") {
            context("Found") {
                it("Themes are returned") {
                    secondTheme.name = firstTheme.name
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Found themes with idRelatedThemes") {
                it("Themes are returned") {
                    firstTheme.idRelatedThemes.append(secondTheme.idTheme)
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    secondTheme.name = firstTheme.name
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findThemes(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find themes by idParent") {
            context("Found") {
                it("Themes are returned") {
                    firstTheme.themes.append(objectsIn: [secondTheme, thirdTheme])
                    
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findThemes(byIdParent: firstTheme.idTheme).waitingCompletion().first }.to(equal([secondTheme, thirdTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findThemes(byIdParent: DataFactory.randomInt()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find main Themes") {
            context("Found") {
                it("Main themes are returned") {
                    firstTheme.idParentTheme = nil
                    secondTheme.idParentTheme = nil
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findMainThemes().waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findMainThemes().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all themes") {
            context("Found") {
                it("All themes are returned") {
                    try? themeDatabase.write {
                        themeDatabase.add([firstTheme, secondTheme, thirdTheme])
                        try? themeDatabase.commitWrite()
                    }
                    
                    expect { try themeDao.findAllThemes().waitingCompletion().first }.to(equal([firstTheme, secondTheme, thirdTheme]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try themeDao.findAllThemes().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedTheme {
    
    internal static func testTheme() -> CachedTheme {
        CachedTheme(idTheme: DataFactory.randomInt(),
                    idParentTheme: DataFactory.randomInt(),
                    name: DataFactory.randomString(),
                    language: .none,
                    idRelatedThemes: List<Int>(),
                    presentation: DataFactory.randomString(),
                    sourcePresentation: DataFactory.randomString(),
                    nbQuotes: DataFactory.randomInt(),
                    authors: List<CachedAuthor>(),
                    books: List<CachedBook>(),
                    themes: List<CachedTheme>(),
                    pictures: List<CachedPicture>(),
                    quotes: List<CachedQuote>(),
                    urls: List<CachedUrl>())
    }
}
