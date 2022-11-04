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

class CenturyRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var centuryRepository: DefaultCenturyRepository!
        var centuryDao: CenturyDao!
        
        var firstCentury: Century!
        var secondCentury: Century!
        var thirdCentury: Century!
        
        beforeEach {
            centuryDao = TestCenturyDao()
            centuryRepository = DefaultCenturyRepository(centuryDao: centuryDao)
            
            firstCentury = Century.testCentury()
            secondCentury = Century.testCentury()
            thirdCentury = Century.testCentury()
        }
        
        describe("Find century by idCentury") {
            context("Found") {
                it("Century is returned") {

                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {

                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find century by idAuthor") {
            context("Found") {
                it("Century is returned") {
                    let author = Author.testAuthor()

                    (centuryDao as? TestCenturyDao)?.authors.append(author.asCached())
                    
                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.century))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let author = CachedAuthor.testAuthor()

                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
            
        }
        
        describe("Find century by idBook") {
            context("Found") {
                it("Century is returned") {
                    let book = Book.testBook()

                    (centuryDao as? TestCenturyDao)?.books.append(book.asCached())
                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.century))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let book = CachedBook.testBook()

                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find century by name") {
            context("Found") {
                it("Century is returned") {
                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all centuries") {
            context("Found") {
                it("All centuries are returned") {
                    (centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findAllCenturies().waitingCompletion().first }.to(equal([firstCentury, secondCentury, thirdCentury]))
                }
            }
            
            context("Database empty") {
                it("An Error is thrown") {
                    expect { try centuryRepository.findAllCenturies().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
