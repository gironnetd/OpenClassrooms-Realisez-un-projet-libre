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

class CenturyDaoSpec: QuickSpec {
    
    override func spec() {
        
        var centuryDatabase : Realm!
        var centuryDao : CenturyDao!
        
        var firstCentury: CachedCentury!
        var secondCentury: CachedCentury!
        var thirdCentury: CachedCentury!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-century-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            centuryDatabase = try? Realm()
            centuryDao = CenturyDaoImpl()
            
            firstCentury = CachedCentury.testCentury()
            secondCentury = CachedCentury.testCentury()
            thirdCentury = CachedCentury.testCentury()
        }
        
        afterEach {
            try? centuryDatabase.write {
                centuryDatabase.deleteAll()
                try? centuryDatabase.commitWrite()
            }
        }
        
        describe("Find Century by idCentury") {
            context("Found") {
                it("Century is returned") {
                    try? centuryDatabase.write {
                        centuryDatabase.add([firstCentury, secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? centuryDatabase.write {
                        centuryDatabase.add([secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Century by idAuthor") {
            context("Found") {
                it("Century is returned") {
                    let author = CachedAuthor.testAuthor()
                    try? centuryDatabase.write {
                        centuryDatabase.add(author)
                        centuryDatabase.add([firstCentury, secondCentury, thirdCentury])
                        
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.century))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()
                    try? centuryDatabase.write {
                        centuryDatabase.add([firstCentury, secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
            
        }
        
        describe("Find Century by idBook") {
            context("Found") {
                it("Century is returned") {
                    let book = CachedBook.testBook()
                    try? centuryDatabase.write {
                        centuryDatabase.add(book)
                        centuryDatabase.add([firstCentury, secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.century))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let book = CachedBook.testBook()
                    try? centuryDatabase.write {
                        centuryDatabase.add([firstCentury, secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Century by name") {
            context("Found") {
                it("Century is returned") {
                    try? centuryDatabase.write {
                        centuryDatabase.add([firstCentury, secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? centuryDatabase.write {
                        centuryDatabase.add([secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Centuries") {
            context("Found") {
                it("All Centuries are returned") {
                    try? centuryDatabase.write {
                        centuryDatabase.add([firstCentury, secondCentury, thirdCentury])
                        try? centuryDatabase.commitWrite()
                    }
                    
                    expect { try centuryDao.findAllCenturies().waitingCompletion().first }.to(equal([firstCentury, secondCentury, thirdCentury]))
                }
            }
            
            context("Database Empty") {
                it("An Error is thrown") {
                    expect { try centuryDao.findAllCenturies().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedCentury {
    
    static func testCentury() -> CachedCentury {
        CachedCentury(idCentury: DataFactory.randomInt(),
                      century: DataFactory.randomString(),
                      presentations: Map<String, String>())
    }
}

