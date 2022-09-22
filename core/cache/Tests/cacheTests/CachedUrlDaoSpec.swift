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

class CachedUrlDaoSpec: QuickSpec {
    
    override func spec() {
      
        var urlDatabase : Realm!
        var cachedUrlDao : CachedUrlDao!
        
        var firstUrl: CachedUrl!
        var secondUrl: CachedUrl!
        var thirdUrl: CachedUrl!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-url-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            urlDatabase = try? Realm()
            cachedUrlDao = CachedUrlDaoImpl()
            
            firstUrl = CachedUrl.testUrl()
            secondUrl = CachedUrl.testUrl()
            thirdUrl = CachedUrl.testUrl()
        }
        
        afterEach {
            try? urlDatabase.write {
                urlDatabase.deleteAll()
                try? urlDatabase.commitWrite()
            }
        }
        
            describe("Find Url by idUrl") {
                context("Found") {
                    it("Url is returned") {
                        try? urlDatabase.write {
                            urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                            try? urlDatabase.commitWrite()
                        }
                        
                        expect { try cachedUrlDao.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(equal(firstUrl))
                    }
                }
                
                context("Not Found") {
                    it("An Error is thrown") {
                        try? urlDatabase.write {
                            urlDatabase.add([secondUrl, thirdUrl])
                            try? urlDatabase.commitWrite()
                        }
                        
                        expect { try cachedUrlDao.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                    }
                }
            }
            
        describe("Find Urls by idAuthor") {
            context("Found") {
                it("Urls are returned") {
                    let author = CachedAuthor.testAuthor()
                    author.urls.append(objectsIn: [firstUrl, secondUrl])
                    try? urlDatabase.write {
                        urlDatabase.add(author)
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.urls.toArray()))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()
                    
                    try? urlDatabase.write {
                        urlDatabase.add(author)
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Urls by idBook") {
            context("Found") {
                it("Urls are returned") {
                    let book = CachedBook.testBook()
                    book.urls.append(objectsIn: [firstUrl, secondUrl])
                    try? urlDatabase.write {
                        urlDatabase.add(book)
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.urls.toArray()))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let book = CachedBook.testBook()
                    
                    try? urlDatabase.write {
                        urlDatabase.add(book)
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Urls by idMovement") {
            context("Found") {
                it("Urls are returned") {
                    let movement = CachedMovement.testMovement()
                    movement.urls.append(objectsIn: [firstUrl, secondUrl])
                    try? urlDatabase.write {
                        urlDatabase.add(movement)
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.urls.toArray()))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let movement = CachedMovement.testMovement()
                    
                    try? urlDatabase.write {
                        urlDatabase.add(movement)
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Urls by idSource") {
            context("Found") {
                it("Urls are returned") {
                    secondUrl.idSource = firstUrl.idSource
                    secondUrl.sourceType = firstUrl.sourceType
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdSource: firstUrl.idSource, sourceType: firstUrl.sourceType).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(byIdSource: DataFactory.randomInt(), sourceType: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
        describe("Find Urls by sourceType") {
            context("Found") {
                it("Urls are returned") {
                    secondUrl.sourceType = firstUrl.sourceType
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(bySourceType: firstUrl.sourceType).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findUrls(bySourceType: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
            
            
            
        describe("Find all Urls") {
            context("Found") {
                it("All Urls are returned") {
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try cachedUrlDao.findAllUrls().waitingCompletion().first }.to(equal([firstUrl, secondUrl, thirdUrl]))
                }
            }
            
            context("Database Empty") {
                it("Error is thrown") {
                    expect { try cachedUrlDao.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedUrl {
    
    static func testUrl() -> CachedUrl {
        CachedUrl(idUrl: DataFactory.randomInt(),
                  sourceType: DataFactory.randomString(),
                  idSource: DataFactory.randomInt(),
                  title: DataFactory.randomString(),
                  url: DataFactory.randomString(),
                  presentation: DataFactory.randomString())
    }
}
