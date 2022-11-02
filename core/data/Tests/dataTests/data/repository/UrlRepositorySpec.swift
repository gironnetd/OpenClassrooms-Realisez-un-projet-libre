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

class UrlRepositorySpec: QuickSpec {
    
    override func spec() {
        
        var urlRepository: DefaultUrlRepository!
        var urlDao: UrlDao!
        
        var firstUrl: Url!
        var secondUrl: Url!
        var thirdUrl: Url!
        
        beforeEach {
            urlDao = TestUrlDao()
            urlRepository = DefaultUrlRepository(urlDao: urlDao)
            
            firstUrl = Url.testUrl()
            secondUrl = Url.testUrl()
            thirdUrl = Url.testUrl()
        }
        
        describe("Find url by idUrl") {
            context("Found") {
                it("Url is returned") {
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(equal(firstUrl))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idAuthor") {
            context("Found") {
                it("Urls are returned") {
                    var author = Author.testAuthor()
                    author.urls?.removeAll()
                    author.urls?.append(contentsOf: [firstUrl, secondUrl])
                    
                    (urlDao as? TestUrlDao)?.authors.append(author.asCached())
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.urls))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var author = Author.testAuthor()
                    author.urls?.removeAll()

                    (urlDao as? TestUrlDao)?.authors.append(author.asCached())
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idBook") {
            context("Found") {
                it("Urls are returned") {
                    var book = Book.testBook()
                    book.urls?.removeAll()
                    book.urls?.append(contentsOf: [firstUrl, secondUrl])

                    (urlDao as? TestUrlDao)?.books.append(book.asCached())
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.urls))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var book = Book.testBook()
                    book.urls?.removeAll()

                    (urlDao as? TestUrlDao)?.books.append(book.asCached())
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idMovement") {
            context("Found") {
                it("Urls are returned") {
                    var movement = Movement.testMovement()
                    
                    movement.urls = [firstUrl, secondUrl]

                    (urlDao as? TestUrlDao)?.movements.append(movement.asCached())
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.urls))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    var movement = Movement.testMovement()
                    movement.urls?.removeAll()

                    (urlDao as? TestUrlDao)?.movements.append(movement.asCached())
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idSource") {
            context("Found") {
                it("Urls are returned") {
                    secondUrl.idSource = firstUrl.idSource
                    secondUrl.sourceType = firstUrl.sourceType

                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdSource: firstUrl.idSource, sourceType: firstUrl.sourceType).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdSource: DataFactory.randomInt(), sourceType: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by sourceType") {
            context("Found") {
                it("Urls are returned") {
                    secondUrl.sourceType = firstUrl.sourceType

                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(bySourceType: firstUrl.sourceType).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(bySourceType: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all urls") {
            context("Found") {
                it("All Urls are returned") {
                    (urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findAllUrls().waitingCompletion().first }.to(equal([firstUrl, secondUrl, thirdUrl]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    expect { try urlRepository.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
