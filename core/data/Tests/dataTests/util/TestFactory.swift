//
//  File.swift
//  
//
//  Created by damien on 13/10/2022.
//

import Foundation
import testing
import remote
import cache
import model
import RealmSwift

extension RemoteUser {
    
    static func testUser() -> RemoteUser {
        RemoteUser(uid: DataFactory.randomString(),
                      providerID: DataFactory.randomString(),
                      email: DataFactory.randomEmail(),
                      displayName: DataFactory.randomString(),
                      phoneNumber: DataFactory.randomString(),
                      photo: DataFactory.randomData(),
                      favourites: RemoteFavourite.testFavourite())
    }
}

extension RemoteFavourite {
    
    static func testFavourite() -> RemoteFavourite {
        let favourite = RemoteFavourite(idDirectory: DataFactory.randomString(),
                                        uidUser: DataFactory.randomString(),
                                        idParentDirectory: DataFactory.randomString(),
                                        directoryName: DataFactory.randomString(),
                                        idAuthors: [DataFactory.randomInt(), DataFactory.randomInt()],
                                        idBooks: [DataFactory.randomInt(), DataFactory.randomInt()],
                                        idMovements: [DataFactory.randomInt(), DataFactory.randomInt()],
                                        idThemes: [DataFactory.randomInt(), DataFactory.randomInt()],
                                        idQuotes: [DataFactory.randomInt(), DataFactory.randomInt()],
                                        idPictures: [DataFactory.randomInt(), DataFactory.randomInt()],
                                        idPresentations: [DataFactory.randomInt(), DataFactory.randomInt()],
                                        idUrls: [DataFactory.randomInt(), DataFactory.randomInt()])
        
        favourite.subDirectories = [
            RemoteFavourite(idDirectory: DataFactory.randomString(),
                            uidUser: DataFactory.randomString(),
                            idParentDirectory: DataFactory.randomString(),
                            directoryName: DataFactory.randomString(),
                            idAuthors: [DataFactory.randomInt(), DataFactory.randomInt()],
                            idBooks: [DataFactory.randomInt(), DataFactory.randomInt()],
                            idMovements: [DataFactory.randomInt(), DataFactory.randomInt()],
                            idThemes: [DataFactory.randomInt(), DataFactory.randomInt()],
                            idQuotes: [DataFactory.randomInt(), DataFactory.randomInt()],
                            idPictures: [DataFactory.randomInt(), DataFactory.randomInt()],
                            idPresentations: [DataFactory.randomInt(), DataFactory.randomInt()],
                            idUrls: [DataFactory.randomInt(), DataFactory.randomInt()])
        ]
        
        return favourite
    }
}

extension CachedUser {
    
    static func testUser() -> CachedUser {
        return CachedUser(uid: DataFactory.randomString(),
                             providerID: DataFactory.randomString(),
                             email: DataFactory.randomString(),
                             displayName: DataFactory.randomString(),
                             phoneNumber: DataFactory.randomString(),
                             photo: DataFactory.randomData(),
                             favourites: CachedFavourite.testFavourite())
    }
}

extension CachedAuthor {
    
    static func testAuthor() -> CachedAuthor {
        CachedAuthor(idAuthor: DataFactory.randomInt(),
                     language: .none,
                     name: DataFactory.randomString(),
                     idRelatedAuthors: [DataFactory.randomInt(), DataFactory.randomInt()].toList(),
                     century: CachedCentury.testCentury(),
                     surname: DataFactory.randomString(),
                     details: DataFactory.randomString(),
                     period: DataFactory.randomString(),
                     idMovement: DataFactory.randomInt(),
                     bibliography: DataFactory.randomString(),
                     presentation: CachedPresentation.testPresentation(),
                     mainPicture: DataFactory.randomInt(),
                     mcc1: DataFactory.randomString(),
                     quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                     pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                     urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList()
        )
    }
}

extension CachedBook {
    
    static func testBook() -> CachedBook {
        CachedBook(idBook: DataFactory.randomInt(),
                   name: DataFactory.randomString(),
                   language: .none,
                   idRelatedBooks: [DataFactory.randomInt(), DataFactory.randomInt()].toList(),
                   century: CachedCentury.testCentury(),
                   details: DataFactory.randomString(),
                   period: DataFactory.randomString(),
                   idMovement: DataFactory.randomInt(),
                   presentation: CachedPresentation.testPresentation(),
                   mcc1: DataFactory.randomString(),
                   quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                   pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                   urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList()
        )
    }
}

extension CachedCentury {
    
    static func testCentury() -> CachedCentury {
        CachedCentury(idCentury: DataFactory.randomInt(),
                      century: DataFactory.randomString(),
                      presentations: [
                        DataFactory.randomString(): DataFactory.randomString(),
                        DataFactory.randomString(): DataFactory.randomString()
                      ].toMap()
        )
    }
}

extension CachedFavourite {
    
    static func testFavourite() -> CachedFavourite {
        let favourite = CachedFavourite(idDirectory: DataFactory.randomString(),
                                        idParentDirectory: DataFactory.randomString(),
                                        directoryName: DataFactory.randomString(),
                                        subDirectories: List<CachedFavourite>(),
                                        authors: [CachedAuthor.testAuthor()].toList(),
                                        books: [CachedBook.testBook()].toList(),
                                        movements: [CachedMovement.testMovement()].toList(),
                                        themes: [CachedTheme.testTheme()].toList(),
                                        quotes: [CachedQuote.testQuote()].toList(),
                                        pictures: [CachedPicture.testPicture()].toList(),
                                        presentations: [CachedPresentation.testPresentation()].toList(),
                                        urls: [CachedUrl.testUrl()].toList()
        )
        
        favourite.subDirectories.append(
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
                            urls: List<CachedUrl>()
            )
        )
        
        return favourite
    }
}

extension CachedMovement {
    
    static func testMovement() -> CachedMovement {
        let movement = CachedMovement(idMovement: DataFactory.randomInt(),
                                      idParentMovement: DataFactory.randomInt(),
                                      name: DataFactory.randomString(),
                                      language: .none,
                                      idRelatedMovements: [DataFactory.randomInt(), DataFactory.randomInt()].toList(),
                                      mcc1: DataFactory.randomString(),
                                      mcc2: DataFactory.randomString(),
                                      presentation: CachedPresentation.testPresentation(),
                                      mcc3: DataFactory.randomString(),
                                      nbQuotes: DataFactory.randomInt(),
                                      nbAuthors: DataFactory.randomInt(),
                                      nbAuthorsQuotes: DataFactory.randomInt(),
                                      nbBooks: DataFactory.randomInt(),
                                      nbBooksQuotes: DataFactory.randomInt(),
                                      selected: DataFactory.randomBoolean(),
                                      nbTotalQuotes: DataFactory.randomInt(),
                                      nbTotalAuthors: DataFactory.randomInt(),
                                      nbTotalBooks: DataFactory.randomInt(),
                                      nbSubcourants: DataFactory.randomInt(),
                                      nbAuthorsSubcourants: DataFactory.randomInt(),
                                      nbBooksSubcourants: DataFactory.randomInt(),
                                      authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                                      books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                                      movements: List<CachedMovement>(),
                                      pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                                      urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList()
        )
        
        movement.movements.append(
            CachedMovement(idMovement: DataFactory.randomInt(),
                           idParentMovement: DataFactory.randomInt(),
                           name: DataFactory.randomString(),
                           language: .none,
                           idRelatedMovements: [DataFactory.randomInt(), DataFactory.randomInt()].toList(),
                           mcc1: DataFactory.randomString(),
                           mcc2: DataFactory.randomString(),
                           presentation: CachedPresentation.testPresentation(),
                           mcc3: DataFactory.randomString(),
                           nbQuotes: DataFactory.randomInt(),
                           nbAuthors: DataFactory.randomInt(),
                           nbAuthorsQuotes: DataFactory.randomInt(),
                           nbBooks: DataFactory.randomInt(),
                           nbBooksQuotes: DataFactory.randomInt(),
                           selected: DataFactory.randomBoolean(),
                           nbTotalQuotes: DataFactory.randomInt(),
                           nbTotalAuthors: DataFactory.randomInt(),
                           nbTotalBooks: DataFactory.randomInt(),
                           nbSubcourants: DataFactory.randomInt(),
                           nbAuthorsSubcourants: DataFactory.randomInt(),
                           nbBooksSubcourants: DataFactory.randomInt(),
                           authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                           books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                           movements: List<CachedMovement>(),
                           pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                           urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList()
            )
        )
        
        return movement
    }
}

extension CachedPicture {
    
    static func testPicture() -> CachedPicture {
        CachedPicture(idPicture: DataFactory.randomInt(),
                      nameSmall: DataFactory.randomString(),
                      extension: DataFactory.randomString(),
                      comments: [
                        DataFactory.randomString(): DataFactory.randomString(),
                        DataFactory.randomString(): DataFactory.randomString()
                      ].toMap(),
                      width: DataFactory.randomInt(),
                      height: DataFactory.randomInt(),
                      picture: DataFactory.randomData()
        )
    }
}

extension CachedPresentation {
    
    static func testPresentation() -> CachedPresentation {
        CachedPresentation(idPresentation: DataFactory.randomInt(),
                           presentation: DataFactory.randomString(),
                           presentationTitle1: DataFactory.randomString(),
                           presentation1: DataFactory.randomString(),
                           presentationTitle2: DataFactory.randomString(),
                           presentation2: DataFactory.randomString(),
                           presentationTitle3: DataFactory.randomString(),
                           presentation3: DataFactory.randomString(),
                           presentationTitle4: DataFactory.randomString(),
                           presentation4: DataFactory.randomString(),
                           sourcePresentation: DataFactory.randomString())
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

extension CachedTheme {
    
    static func testTheme() -> CachedTheme {
        let theme = CachedTheme(idTheme: DataFactory.randomInt(),
                                idParentTheme: DataFactory.randomInt(),
                                name: DataFactory.randomString(),
                                language: .none,
                                idRelatedThemes: [DataFactory.randomInt(), DataFactory.randomInt()].toList(),
                                presentation: DataFactory.randomString(),
                                sourcePresentation: DataFactory.randomString(),
                                nbQuotes: DataFactory.randomInt(),
                                authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                                books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                                themes: List<CachedTheme>(),
                                pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                                quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                                urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList()
        )
        
        theme.themes.append(
            CachedTheme(idTheme: DataFactory.randomInt(),
                        idParentTheme: DataFactory.randomInt(),
                        name: DataFactory.randomString(),
                        language: .none,
                        idRelatedThemes: [DataFactory.randomInt(), DataFactory.randomInt()].toList(),
                        presentation: DataFactory.randomString(),
                        sourcePresentation: DataFactory.randomString(),
                        nbQuotes: DataFactory.randomInt(),
                        authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                        books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                        themes: List<CachedTheme>(),
                        pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                        quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                        urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList()
            )
        )
        
        return theme
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

extension model.User {
    
    static func testUser() -> model.User {
        return User(uid: DataFactory.randomString(),
                       providerID: DataFactory.randomString(),
                       email: DataFactory.randomString(),
                       displayName: DataFactory.randomString(),
                       phoneNumber: DataFactory.randomString(),
                       photo: DataFactory.randomData(),
                       favourites: nil)
    }
}

extension Author {
    
    static func testAuthor() -> Author {
        Author(idAuthor: DataFactory.randomInt(),
               language: CachedLanguage.none.rawValue,
               name: DataFactory.randomString(),
               idRelatedAuthors: [DataFactory.randomInt(), DataFactory.randomInt()],
               century: Century.testCentury(),
               surname: DataFactory.randomString(),
               details: DataFactory.randomString(),
               period: DataFactory.randomString(),
               idMovement: DataFactory.randomInt(),
               bibliography: DataFactory.randomString(),
               presentation: Presentation.testPresentation(),
               mainPicture: DataFactory.randomInt(),
               mcc1: DataFactory.randomString(),
               quotes: [Quote.testQuote(), Quote.testQuote()],
               pictures: [Picture.testPicture(), Picture.testPicture()],
               urls: [Url.testUrl(), Url.testUrl()]
        )
    }
}

extension Book {
    
    static func testBook() -> Book {
        Book(idBook: DataFactory.randomInt(),
             name: DataFactory.randomString(),
             language: CachedLanguage.none.rawValue,
             idRelatedBooks: [DataFactory.randomInt(), DataFactory.randomInt()],
             century: Century.testCentury(),
             details: DataFactory.randomString(),
             period: DataFactory.randomString(),
             idMovement: DataFactory.randomInt(),
             presentation: Presentation.testPresentation(),
             mcc1: DataFactory.randomString(),
             quotes: [Quote.testQuote(), Quote.testQuote()],
             pictures: [Picture.testPicture(), Picture.testPicture()],
             urls: [Url.testUrl(), Url.testUrl()]
        )
    }
}

extension Century {
    
    static func testCentury() -> Century {
        Century(idCentury: DataFactory.randomInt(),
                century: DataFactory.randomString(),
                presentations: [
                    DataFactory.randomString(): DataFactory.randomString(),
                    DataFactory.randomString(): DataFactory.randomString()
                ]
        )
    }
}

extension Favourite {
    
    static func testFavourite() -> Favourite {
        return Favourite(idDirectory: DataFactory.randomString(),
                         idParentDirectory: DataFactory.randomString(),
                         directoryName: DataFactory.randomString(),
                         subDirectories: nil,
                         authors: [Author.testAuthor()],
                         books: [Book.testBook()],
                         movements: [Movement.testMovement()],
                         themes: [Theme.testTheme()],
                         quotes: [Quote.testQuote()],
                         pictures: [Picture.testPicture()],
                         presentations: [Presentation.testPresentation()],
                         urls: [Url.testUrl()]
        )
    }
}

extension Movement {
    
    static func testMovement() -> Movement {
        return Movement(idMovement: DataFactory.randomInt(),
                        idParentMovement: DataFactory.randomInt(),
                        name: DataFactory.randomString(),
                        language: CachedLanguage.none.rawValue,
                        idRelatedMovements: [DataFactory.randomInt(), DataFactory.randomInt()],
                        mcc1: DataFactory.randomString(),
                        mcc2: DataFactory.randomString(),
                        presentation: Presentation.testPresentation(),
                        mcc3: DataFactory.randomString(),
                        nbQuotes: DataFactory.randomInt(),
                        nbAuthors: DataFactory.randomInt(),
                        nbAuthorsQuotes: DataFactory.randomInt(),
                        nbBooks: DataFactory.randomInt(),
                        nbBooksQuotes: DataFactory.randomInt(),
                        selected: DataFactory.randomBoolean(),
                        nbTotalQuotes: DataFactory.randomInt(),
                        nbTotalAuthors: DataFactory.randomInt(),
                        nbTotalBooks: DataFactory.randomInt(),
                        nbSubcourants: DataFactory.randomInt(),
                        nbAuthorsSubcourants: DataFactory.randomInt(),
                        nbBooksSubcourants: DataFactory.randomInt(),
                        authors: nil,
                        books: nil,
                        movements: nil,
                        pictures: nil,
                        urls: nil
        )
    }
}

extension Picture {
    
    static func testPicture() -> Picture {
        Picture(idPicture: DataFactory.randomInt(),
                nameSmall: DataFactory.randomString(),
                extension: DataFactory.randomString(),
                comments: [
                    DataFactory.randomString(): DataFactory.randomString(),
                    DataFactory.randomString(): DataFactory.randomString()
                ],
                width: DataFactory.randomInt(),
                height: DataFactory.randomInt(),
                picture: DataFactory.randomData()
        )
    }
}

extension Presentation {
    
    static func testPresentation() -> Presentation {
        Presentation(idPresentation: DataFactory.randomInt(),
                     presentation: DataFactory.randomString(),
                     presentationTitle1: DataFactory.randomString(),
                     presentation1: DataFactory.randomString(),
                     presentationTitle2: DataFactory.randomString(),
                     presentation2: DataFactory.randomString(),
                     presentationTitle3: DataFactory.randomString(),
                     presentation3: DataFactory.randomString(),
                     presentationTitle4: DataFactory.randomString(),
                     presentation4: DataFactory.randomString(),
                     sourcePresentation: DataFactory.randomString())
    }
}

extension Quote {
    
    static func testQuote() -> Quote {
        Quote(idQuote: DataFactory.randomInt(),
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

extension Theme {
    
    static func testTheme() -> Theme {
        return Theme(idTheme: DataFactory.randomInt(),
                     idParentTheme: DataFactory.randomInt(),
                     name: DataFactory.randomString(),
                     language: CachedLanguage.none.rawValue,
                     idRelatedThemes: [DataFactory.randomInt(), DataFactory.randomInt()],
                     presentation: DataFactory.randomString(),
                     sourcePresentation: DataFactory.randomString(),
                     nbQuotes: DataFactory.randomInt(),
                     authors: nil,
                     books: nil,
                     themes: nil,
                     pictures: nil,
                     quotes: nil,
                     urls: nil
        )
    }
}

extension Url {
    
    static func testUrl() -> Url {
        Url(idUrl: DataFactory.randomInt(),
            sourceType: DataFactory.randomString(),
            idSource: DataFactory.randomInt(),
            title: DataFactory.randomString(),
            url: DataFactory.randomString(),
            presentation: DataFactory.randomString())
    }
}


