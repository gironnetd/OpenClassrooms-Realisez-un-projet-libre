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

class CachedQuoteDaoSpec: QuickSpec {
    
    override func spec() {
        
        var quoteDatabase : Realm!
        var cachedQuoteDao : CachedQuoteDao!
        
        var firstQuote: CachedQuote!
        var secondQuote: CachedQuote!
        var thirdQuote: CachedQuote!
        
        beforeEach {
            let configuration = Realm.Configuration(inMemoryIdentifier: "cached-quote-dao-testing")
            Realm.Configuration.defaultConfiguration = configuration
            quoteDatabase = try? Realm()
            cachedQuoteDao = CachedQuoteDaoImpl()
            
            firstQuote = CachedQuote.testQuote()
            secondQuote = CachedQuote.testQuote()
            thirdQuote = CachedQuote.testQuote()
        }
        
        afterEach {
            try? quoteDatabase.write {
                quoteDatabase.deleteAll()
                try? quoteDatabase.commitWrite()
            }
        }
        
        
        describe("Find Quote by idQuote") {
            context("Found") {
                it("Quote is returned") {
                    try? quoteDatabase.write {
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuote(byIdQuote: firstQuote.idQuote).waitingCompletion().first }.to(equal(firstQuote))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    try? quoteDatabase.write {
                        quoteDatabase.add([secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuote(byIdQuote: firstQuote.idQuote).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Quotes by idAuthor") {
            context("Found") {
                it("Quotes are returned") {
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    try? quoteDatabase.write {
                        quoteDatabase.add(author)
                        quoteDatabase.add( thirdQuote)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal([firstQuote, secondQuote]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()
                    try? quoteDatabase.write {
                        quoteDatabase.add(author)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Quotes by Author name") {
            context("Found") {
                it("Quotes are returned") {
                    let firstAuthor = CachedAuthor.testAuthor()
                    firstAuthor.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondAuthor = CachedAuthor.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    secondAuthor.quotes.append(thirdQuote)
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstAuthor)
                        quoteDatabase.add(secondAuthor)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byAuthor: firstAuthor.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found Authors without Quotes") {
                it("Error is thrown") {
                    let firstAuthor = CachedAuthor.testAuthor()
                    let secondAuthor = CachedAuthor.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstAuthor)
                        quoteDatabase.add(secondAuthor)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byAuthor: firstAuthor.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let firstAuthor = CachedAuthor.testAuthor()
                    firstAuthor.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondAuthor = CachedAuthor.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    secondAuthor.quotes.append(thirdQuote)
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstAuthor)
                        quoteDatabase.add(secondAuthor)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byAuthor: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Quotes by idBook") {
            context("Found") {
                it("Quotes are returned") {
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    try? quoteDatabase.write {
                        quoteDatabase.add(book)
                        quoteDatabase.add( thirdQuote)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdBook: book.idBook).waitingCompletion().first }.to(equal([firstQuote, secondQuote]))
                }
            }
            
            context("Not Found") {
                it("An Error is thrown") {
                    let book = CachedBook.testBook()
                    try? quoteDatabase.write {
                        quoteDatabase.add(book)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Quotes by Book name") {
            context("Found") {
                it("Quotes are returned ") {
                    let firstBook = CachedBook.testBook()
                    firstBook.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondBook = CachedBook.testBook()
                    secondBook.name = firstBook.name
                    secondBook.quotes.append(thirdQuote)
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstBook)
                        quoteDatabase.add(secondBook)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byBook: firstBook.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found Books without Quotes") {
                it("Error is thrown") {
                    let firstBook = CachedBook.testBook()
                    let secondBook = CachedBook.testBook()
                    secondBook.name = firstBook.name
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstBook)
                        quoteDatabase.add(secondBook)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byBook: firstBook.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let firstBook = CachedBook.testBook()
                    firstBook.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondBook = CachedBook.testBook()
                    secondBook.name = firstBook.name
                    secondBook.quotes.append(thirdQuote)
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstBook)
                        quoteDatabase.add(secondBook)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byBook: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Quotes by idMovement") {
            context("Found") {
                it("Quotes are returned") {
                    let movement = CachedMovement.testMovement()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    movement.authors.append(author)
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    movement.books.append(book)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(movement)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let movement = CachedMovement.testMovement()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(movement)
                        quoteDatabase.add(author)
                        quoteDatabase.add(book)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        
        
        describe("Find Quotes by Movement name") {
            context("Found") {
                it("Quotes are returned") {
                    let firstMovement = CachedMovement.testMovement()
                    let secondMovement = CachedMovement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstMovement.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondMovement.authors.append(author)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstMovement)
                        quoteDatabase.add(secondMovement)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byMovement: firstMovement.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found Movements without Quotes") {
                it("Error is thrown") {
                    let firstMovement = CachedMovement.testMovement()
                    let secondMovement = CachedMovement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstMovement)
                        quoteDatabase.add(secondMovement)
                        quoteDatabase.add(book)
                        quoteDatabase.add(author)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byMovement: firstMovement.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let firstMovement = CachedMovement.testMovement()
                    let secondMovement = CachedMovement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstMovement.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondMovement.authors.append(author)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstMovement)
                        quoteDatabase.add(secondMovement)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byMovement: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Quotes by idTheme") {
            context("Found") {
                it("Quotes are returned") {
                    let theme = CachedTheme.testTheme()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    theme.authors.append(author)
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    theme.books.append(book)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(theme)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let theme = CachedTheme.testTheme()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(theme)
                        quoteDatabase.add(author)
                        quoteDatabase.add(book)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find Quotes by Theme name") {
            context("Found") {
                it("Quotes are returned") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstTheme.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondTheme.authors.append(author)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstTheme)
                        quoteDatabase.add(secondTheme)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byTheme: firstTheme.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found Themes without Quotes") {
                it("Error is thrown") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstTheme)
                        quoteDatabase.add(secondTheme)
                        quoteDatabase.add(book)
                        quoteDatabase.add(author)
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byTheme: firstTheme.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not Found") {
                it("Error is thrown") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstTheme.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondTheme.authors.append(author)
                    
                    try? quoteDatabase.write {
                        quoteDatabase.add(firstTheme)
                        quoteDatabase.add(secondTheme)
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findQuotes(byTheme: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all Quotes") {
            context("Found") {
                it("All Quotes are returned") {
                    try? quoteDatabase.write {
                        quoteDatabase.add([firstQuote, secondQuote, thirdQuote])
                        try? quoteDatabase.commitWrite()
                    }
                    
                    expect { try cachedQuoteDao.findAllQuotes().waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Database Empty") {
                it("An Error is thrown") {
                    expect { try cachedQuoteDao.findAllQuotes().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedQuote {
    
    static func testQuote() -> CachedQuote {
        CachedQuote(idQuote: DataFactory.randomInt(),
                    idAuthor: DataFactory.randomInt(),
                    idBook: DataFactory.randomInt(),
                    quote: DataFactory.randomString(),
                    source: DataFactory.randomString(),
                    reference: DataFactory.randomString(),
                    remarque: DataFactory.randomString(),
                    comment: DataFactory.randomString(),
                    commentName: DataFactory.randomString())
    }
}
