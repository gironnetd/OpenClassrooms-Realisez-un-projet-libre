//
//  File.swift
//  
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import testing
import remote
import cache
import model

@testable import data

class QuoteRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var quoteRepository: DefaultQuoteRepository!
        var quoteDao: QuoteDao!
        
        var firstQuote: Quote!
        var secondQuote: Quote!
        var thirdQuote: Quote!
        
        beforeEach {
            quoteDao = TestQuoteDao()
            quoteRepository = DefaultQuoteRepository(quoteDao: quoteDao)
            
            firstQuote = Quote.testQuote()
            secondQuote = Quote.testQuote()
            thirdQuote = Quote.testQuote()
        }
        
        describe("Find quote by idQuote") {
            context("Found") {
                it("Quote is returned") {
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuote(byIdQuote: firstQuote.idQuote).waitingCompletion().first }.to(equal(firstQuote))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuote(byIdQuote: firstQuote.idQuote).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idAuthor") {
            context("Found") {
                it("Quotes are returned") {
                    var author = Author.testAuthor()
                    author.quotes = [firstQuote, secondQuote]

                    (quoteDao as? TestQuoteDao)?.authors.append(author.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(thirdQuote.asCached())
                    
                    expect { try quoteRepository.findQuotes(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal([firstQuote, secondQuote]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var author = Author.testAuthor()
                    author.quotes = []

                    (quoteDao as? TestQuoteDao)?.authors.append(author.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by Author name") {
            context("Found") {
                it("Quotes are returned") {
                    var firstAuthor = Author.testAuthor()
                    firstAuthor.quotes = [firstQuote, secondQuote]
                    var secondAuthor = Author.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    secondAuthor.quotes = [thirdQuote]

                    (quoteDao as? TestQuoteDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached()])

                    expect { try quoteRepository.findQuotes(byAuthor: firstAuthor.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found authors without Quotes") {
                it("Error is thrown") {
                    var firstAuthor = Author.testAuthor()
                    firstAuthor.quotes = []
                    var secondAuthor = Author.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    secondAuthor.quotes = []

                    (quoteDao as? TestQuoteDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached()])
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byAuthor: firstAuthor.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var firstAuthor = Author.testAuthor()
                    firstAuthor.quotes = [firstQuote, secondQuote]
                    var secondAuthor = Author.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    secondAuthor.quotes = [thirdQuote]

                    (quoteDao as? TestQuoteDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached()])

                    expect { try quoteRepository.findQuotes(byAuthor: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idBook") {
            context("Found") {
                it("Quotes are returned") {
                    var book = Book.testBook()
                    book.quotes = [firstQuote, secondQuote]

                    (quoteDao as? TestQuoteDao)?.books.append(book.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(thirdQuote.asCached())
                    
                    expect { try quoteRepository.findQuotes(byIdBook: book.idBook).waitingCompletion().first }.to(equal([firstQuote, secondQuote]))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {
                    var book = Book.testBook()
                    book.quotes = []

                    (quoteDao as? TestQuoteDao)?.books.append(book.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by Book name") {
            context("Found") {
                it("Quotes are returned") {
                    var firstBook = Book.testBook()
                    firstBook.quotes = [firstQuote, secondQuote]
                    var secondBook = Book.testBook()
                    secondBook.name = firstBook.name
                    secondBook.quotes = [thirdQuote]

                    (quoteDao as? TestQuoteDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached()])

                    expect { try quoteRepository.findQuotes(byBook: firstBook.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found books without Quotes") {
                it("Error is thrown") {
                    var firstBook = Book.testBook()
                    firstBook.quotes = []
                    var secondBook = Book.testBook()
                    secondBook.name = firstBook.name
                    secondBook.quotes = []

                    (quoteDao as? TestQuoteDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached()])
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byBook: firstBook.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var firstBook = Book.testBook()
                    firstBook.quotes = []
                    firstBook.quotes = [firstQuote, secondQuote]
                    var secondBook = Book.testBook()
                    secondBook.name = firstBook.name
                    secondBook.quotes = [thirdQuote]

                    (quoteDao as? TestQuoteDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached()])

                    expect { try quoteRepository.findQuotes(byBook: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idMovement") {
            context("Found") {
                it("Quotes are returned") {
                    var movement = Movement.testMovement()
                    
                    var author = Author.testAuthor()
                    author.quotes = [firstQuote, secondQuote]
                    movement.authors = [author]
                    
                    var book = Book.testBook()
                    book.quotes = [thirdQuote]
                    movement.books = [book]
                    
                    (quoteDao as? TestQuoteDao)?.movements.append(movement.asCached())

                    expect { try quoteRepository.findQuotes(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let movement = Movement.testMovement()
                    
                    var author = Author.testAuthor()
                    author.quotes = [firstQuote, secondQuote]
                    
                    var book = Book.testBook()
                    book.quotes = [thirdQuote]
                    
                    (quoteDao as? TestQuoteDao)?.movements.append(movement.asCached())
                    (quoteDao as? TestQuoteDao)?.authors.append(author.asCached())
                    (quoteDao as? TestQuoteDao)?.books.append(book.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by movement name") {
            context("Found") {
                it("Quotes are returned") {
                    var firstMovement = Movement.testMovement()
                    var secondMovement = Movement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    var book = Book.testBook()
                    book.quotes = [firstQuote, secondQuote]
                    firstMovement.books = [book]
                    
                    var author = Author.testAuthor()
                    author.quotes = [thirdQuote]
                    secondMovement.authors = [author]
                    
                    (quoteDao as? TestQuoteDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached()])

                    expect { try quoteRepository.findQuotes(byMovement: firstMovement.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found movements without quotes") {
                it("Error is thrown") {
                    let firstMovement = Movement.testMovement()
                    var secondMovement = Movement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    var book = Book.testBook()
                    book.quotes = [firstQuote, secondQuote]
                    
                    var author = Author.testAuthor()
                    author.quotes = [thirdQuote]
                    
                    (quoteDao as? TestQuoteDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached()])
                    (quoteDao as? TestQuoteDao)?.authors.append(author.asCached())
                    (quoteDao as? TestQuoteDao)?.books.append(book.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byMovement: firstMovement.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var firstMovement = Movement.testMovement()
                    var secondMovement = Movement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    var book = Book.testBook()
                    book.quotes = [firstQuote, secondQuote]
                    firstMovement.books = [book]
                    
                    var author = Author.testAuthor()
                    author.quotes = [thirdQuote]
                    secondMovement.authors = [author]
                    
                    (quoteDao as? TestQuoteDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached()])

                    expect { try quoteRepository.findQuotes(byMovement: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idTheme") {
            context("Found") {
                it("Quotes are returned") {
                    var theme = Theme.testTheme()
                    
                    var author = Author.testAuthor()
                    author.quotes = [firstQuote, secondQuote]
                    theme.authors = [author]
                    
                    var book = Book.testBook()
                    book.quotes = [thirdQuote]
                    theme.books = [book]
                    
                    (quoteDao as? TestQuoteDao)?.themes.append(theme.asCached())

                    expect { try quoteRepository.findQuotes(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let theme = Theme.testTheme()
                    
                    var author = Author.testAuthor()
                    author.quotes = [firstQuote, secondQuote]
                    
                    var book = Book.testBook()
                    book.quotes = [thirdQuote]
                    
                    (quoteDao as? TestQuoteDao)?.themes.append(theme.asCached())
                    (quoteDao as? TestQuoteDao)?.authors.append(author.asCached())
                    (quoteDao as? TestQuoteDao)?.books.append(book.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by theme name") {
            context("Found") {
                it("Quotes are returned") {
                    var firstTheme = Theme.testTheme()
                    var secondTheme = Theme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    var book = Book.testBook()
                    book.quotes = [firstQuote, secondQuote]
                    firstTheme.books = [book]
                    
                    var author = Author.testAuthor()
                    author.quotes = [thirdQuote]
                    secondTheme.authors = [author]
                    
                    (quoteDao as? TestQuoteDao)?.themes.append(contentsOf: [firstTheme.asCached(), secondTheme.asCached()])

                    expect { try quoteRepository.findQuotes(byTheme: firstTheme.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found themes without quotes") {
                it("Error is thrown") {
                    let firstTheme = Theme.testTheme()
                    var secondTheme = Theme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    var book = Book.testBook()
                    book.quotes = [firstQuote, secondQuote]
                    
                    var author = Author.testAuthor()
                    author.quotes = [thirdQuote]
                    
                    (quoteDao as? TestQuoteDao)?.themes.append(contentsOf: [firstTheme.asCached(), secondTheme.asCached()])
                    (quoteDao as? TestQuoteDao)?.authors.append(author.asCached())
                    (quoteDao as? TestQuoteDao)?.books.append(book.asCached())
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findQuotes(byTheme: firstTheme.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var firstTheme = Theme.testTheme()
                    var secondTheme = Theme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    var book = Book.testBook()
                    book.quotes.append(contentsOf: [firstQuote, secondQuote])
                    firstTheme.books = [book]
                    
                    var author = Author.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondTheme.authors = [author]
                    
                    (quoteDao as? TestQuoteDao)?.themes.append(contentsOf: [firstTheme.asCached(), secondTheme.asCached()])

                    expect { try quoteRepository.findQuotes(byTheme: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all quotes") {
            context("Found") {
                it("All Quotes are returned") {
                    (quoteDao as? TestQuoteDao)?.quotes.append(contentsOf:[firstQuote.asCached(), secondQuote.asCached(), thirdQuote.asCached()])
                    
                    expect { try quoteRepository.findAllQuotes().waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Database empty") {
                it("An Error is thrown") {
                    expect { try quoteRepository.findAllQuotes().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
