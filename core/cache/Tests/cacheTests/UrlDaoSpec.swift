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

class UrlDaoSpec: QuickSpec {
    
    override func spec() {
        
        var urlDatabase : Realm!
        var urlDao : UrlDao!
        
        var firstUrl: CachedUrl!
        var secondUrl: CachedUrl!
        var thirdUrl: CachedUrl!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-url-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            urlDatabase = try? Realm()
            urlDao = DefaultUrlDao(realm: urlDatabase)
            
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
        
        describe("Find url by idUrl") {
            context("Found") {
                it("Url is returned") {
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(equal(firstUrl))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {
                    try? urlDatabase.write {
                        urlDatabase.add([secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idAuthor") {
            context("Found") {
                it("Urls are returned") {
                    let author = CachedAuthor.testAuthor()
                    author.urls.append(objectsIn: [firstUrl, secondUrl])
                    try? urlDatabase.write {
                        urlDatabase.add(author)
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.urls.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()
                    
                    try? urlDatabase.write {
                        urlDatabase.add(author)
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idBook") {
            context("Found") {
                it("Urls are returned") {
                    let book = CachedBook.testBook()
                    book.urls.append(objectsIn: [firstUrl, secondUrl])
                    try? urlDatabase.write {
                        urlDatabase.add(book)
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.urls.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let book = CachedBook.testBook()
                    
                    try? urlDatabase.write {
                        urlDatabase.add(book)
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idMovement") {
            context("Found") {
                it("Urls are returned") {
                    let movement = CachedMovement.testMovement()
                    movement.urls.append(objectsIn: [firstUrl, secondUrl])
                    try? urlDatabase.write {
                        urlDatabase.add(movement)
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.urls.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let movement = CachedMovement.testMovement()
                    
                    try? urlDatabase.write {
                        urlDatabase.add(movement)
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idSource") {
            context("Found") {
                it("Urls are returned") {
                    secondUrl.idSource = firstUrl.idSource
                    secondUrl.sourceType = firstUrl.sourceType
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdSource: firstUrl.idSource, sourceType: firstUrl.sourceType).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(byIdSource: DataFactory.randomInt(), sourceType: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by sourceType") {
            context("Found") {
                it("Urls are returned") {
                    secondUrl.sourceType = firstUrl.sourceType
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(bySourceType: firstUrl.sourceType).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findUrls(bySourceType: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all urls") {
            context("Found") {
                it("All Urls are returned") {
                    try? urlDatabase.write {
                        urlDatabase.add([firstUrl, secondUrl, thirdUrl])
                        try? urlDatabase.commitWrite()
                    }
                    
                    expect { try urlDao.findAllUrls().waitingCompletion().first }.to(equal([firstUrl, secondUrl, thirdUrl]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try urlDao.findAllUrls().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedUrl {
    
    internal static func testUrl() -> CachedUrl {
        CachedUrl(idUrl: DataFactory.randomInt(),
                  sourceType: DataFactory.randomString(),
                  idSource: DataFactory.randomInt(),
                  title: DataFactory.randomString(),
                  url: DataFactory.randomString(),
                  presentation: DataFactory.randomString())
    }
}
