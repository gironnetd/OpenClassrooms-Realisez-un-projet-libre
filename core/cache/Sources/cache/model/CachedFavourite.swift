//
//  CachedFavorite.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a favorite
 */
public class CachedFavourite: Object {
    
    @Persisted(primaryKey: true) public var idDirectory: String
    @Persisted public var idParentDirectory: String?
    @Persisted public var directoryName: String?
    @Persisted public var subDirectories: List<CachedFavourite>
    @Persisted public var authors: List<CachedAuthor>
    @Persisted public var books: List<CachedBook>
    @Persisted public var movements: List<CachedMovement>
    @Persisted public var themes: List<CachedTheme>
    @Persisted public var quotes: List<CachedQuote>
    @Persisted public var pictures: List<CachedPicture>
    @Persisted public var presentations: List<CachedPresentation>
    @Persisted public var urls: List<CachedUrl>
    
    public override init() {}

    public init(idDirectory: String,
                idParentDirectory: String?,
                directoryName: String?,
                subDirectories: List<CachedFavourite>,
                authors: List<CachedAuthor>,
                books: List<CachedBook>,
                movements: List<CachedMovement>,
                themes: List<CachedTheme>,
                quotes: List<CachedQuote>,
                pictures: List<CachedPicture>,
                presentations: List<CachedPresentation>,
                urls: List<CachedUrl>) {
        super.init()
        self.idDirectory = idDirectory
        self.idParentDirectory = idParentDirectory
        self.directoryName = directoryName
        self.subDirectories = subDirectories
        self.authors = authors
        self.books = books
        self.movements = movements
        self.themes = themes
        self.quotes = quotes
        self.pictures = pictures
        self.presentations = presentations
        self.urls = urls
    }
    
    public init(idDirectory: String,
         idParentDirectory: String?,
         directoryName: String?,
         subDirectories: [CachedFavourite]?,
         idAuthors: [Int]?,
         idBooks: [Int]?,
         idMovements: [Int]?,
         idThemes: [Int]?,
         idQuotes: [Int]?,
         idPictures: [Int]?,
         idPresentations: [Int]?,
         idUrls: [Int]?) {
        super.init()
        self.idDirectory = idDirectory
        if let subDirectories = subDirectories {
            self.subDirectories = subDirectories.reduce(into: List<CachedFavourite>(), { result, favourite in
                    result.append(favourite)
                }
            )
        }
        self.idParentDirectory = idParentDirectory
        self.directoryName = directoryName
        
        if let idAuthors = idAuthors {
            self.authors = idAuthors.reduce(into: List<CachedAuthor>()) { result, idAuthor in
                if let author = try? Realm().objects(CachedAuthor.self).where({ author in author.idAuthor == idAuthor }).first {
                    result.append(author)
                }
            }
        }
        
        if let idBooks = idBooks {
            self.books = idBooks.reduce(into: List<CachedBook>()) { result, idBook in
                if let book = try? Realm().objects(CachedBook.self).where({ book in book.idBook == idBook }).first {
                    result.append(book)
                }
            }
        }
        
        if let idMovements = idMovements {
            self.movements = idMovements.reduce(into: List<CachedMovement>()) { result, idMovement in
                if let movement = try? Realm().objects(CachedMovement.self).where({ movement in movement.idMovement == idMovement }).first {
                    result.append(movement)
                }
            }
        }
        
        if let idThemes = idThemes {
            self.themes = idThemes.reduce(into: List<CachedTheme>()) { result, idTheme in
                if let theme = try? Realm().objects(CachedTheme.self).where({ theme in theme.idTheme == idTheme }).first {
                    result.append(theme)
                }
            }
        }
        
        if let idQuotes = idQuotes {
            self.quotes = idQuotes.reduce(into: List<CachedQuote>()) { result, idQuote in
                if let quote = try? Realm().objects(CachedQuote.self).where({ quote in quote.idQuote == idQuote }).first {
                    result.append(quote)
                }
            }
        }
        
        if let idPictures = idPictures {
            self.pictures = idPictures.reduce(into: List<CachedPicture>()) { result, idPicture in
                if let picture = try? Realm().objects(CachedPicture.self).where({ picture in picture.idPicture == idPicture }).first {
                    result.append(picture)
                }
            }
        }
        
        if let idPresentations = idPresentations {
            self.presentations = idPresentations.reduce(into: List<CachedPresentation>()) { result, idPresentation in
                if let presentation = try? Realm().objects(CachedPresentation.self).where({ presentation in presentation.idPresentation == idPresentation }).first {
                    result.append(presentation)
                }
            }
        }
        
        if let idUrls = idUrls {
            self.urls = idUrls.reduce(into: List<CachedUrl>()) { result, idUrl in
                if let url = try? Realm().objects(CachedUrl.self).where({ url in url.idUrl == idUrl }).first {
                    result.append(url)
                }
            }
        }
    }
}

extension CachedFavourite {
    
    public func asExternalModel() -> Favourite {
        var favourite = Favourite(idDirectory: self.idDirectory,
                                 idParentDirectory: self.idParentDirectory,
                                 directoryName: self.directoryName)
        
        if !self.subDirectories.isEmpty {
            favourite.subDirectories = self.subDirectories.reduce(
                into: [Favourite](), { result, favourite in
                    result.append(favourite.asExternalModel())
            })
        }
        
        if !self.authors.isEmpty {
            favourite.authors = self.authors.reduce(
                into: [Author](), { result, author in
                    result.append(author.asExternalModel())
            })
        }

        if !self.books.isEmpty {
            favourite.books = self.books.reduce(
                into: [Book](), { result, book in
                    result.append(book.asExternalModel())
            })
        }

        if !self.movements.isEmpty {
            favourite.movements = self.movements.reduce(
                into: [Movement](), { result, movement in
                    result.append(movement.asExternalModel())
            })
        }

        if !self.themes.isEmpty {
            favourite.themes = self.themes.reduce(
                into: [Theme](), { result, theme in
                    result.append(theme.asExternalModel())
            })
        }

        if !self.quotes.isEmpty {
            favourite.quotes = self.quotes.reduce(
                into: [Quote](), { result, quote in
                    result.append(quote.asExternalModel())
            })
        }

        if !self.pictures.isEmpty {
            favourite.pictures = self.pictures.reduce(
                into: [Picture](), { result, picture in
                    result.append(picture.asExternalModel())
            })
        }

        if !self.presentations.isEmpty {
            favourite.presentations = self.presentations.reduce(
                into: [Presentation](), { result, presentation in
                    result.append(presentation.asExternalModel())
            })
        }

        if !self.urls.isEmpty {
            favourite.urls = self.urls.reduce(
                into: [Url](), { result, url in
                    result.append(url.asExternalModel())
            })
        }
        
        return favourite
    }
}

extension Favourite {
    
    public func asCached() -> CachedFavourite {
        let favourite = CachedFavourite()
        
        favourite.idDirectory = self.idDirectory
        favourite.idParentDirectory = self.idParentDirectory
        favourite.directoryName = self.directoryName
        
        if let subDirectories = self.subDirectories {
            favourite.subDirectories = subDirectories.reduce(
                into: List<CachedFavourite>(), { result, favourite in
                    result.append(favourite.asCached())
            })
        }
        
        if let authors = self.authors {
            favourite.authors = authors.reduce(
                into: List<CachedAuthor>(), { result, author in
                    result.append(author.asCached())
            })
        }

        if let books = self.books {
            favourite.books = books.reduce(
                into: List<CachedBook>(), { result, book in
                    result.append(book.asCached())
            })
        }

        if let movements = self.movements {
            favourite.movements = movements.reduce(
                into: List<CachedMovement>(), { result, movement in
                    result.append(movement.asCached())
            })
        }

        if let themes = self.themes {
            favourite.themes = themes.reduce(
                into: List<CachedTheme>(), { result, theme in
                    result.append(theme.asCached())
            })
        }

        if let quotes = self.quotes {
            favourite.quotes = quotes.reduce(
                into: List<CachedQuote>(), { result, quote in
                    result.append(quote.asCached())
            })
        }

        if let pictures = self.pictures {
            favourite.pictures = pictures.reduce(
                into: List<CachedPicture>(), { result, picture in
                    result.append(picture.asCached())
            })
        }

        if let presentations = self.presentations {
            favourite.presentations = presentations.reduce(
                into: List<CachedPresentation>(), { result, presentation in
                    result.append(presentation.asCached())
            })
        }

        if let urls = self.urls {
            favourite.urls = urls.reduce(
                into: List<CachedUrl>(), { result, url in
                    result.append(url.asCached())
            })
        }
        
        return favourite
    }
}
