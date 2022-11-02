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
        self.idParentDirectory = idParentDirectory
        self.directoryName = directoryName
        
        if let subDirectories = subDirectories {
            self.subDirectories = subDirectories.toList()
        }
        
        if let idAuthors = idAuthors {
            self.authors = idAuthors.compactMap { CachedAuthor(idAuthor: $0) }.toList()
        }
        
        if let idBooks = idBooks {
            self.books = idBooks.compactMap { CachedBook(idBook: $0) }.toList()
        }
        
        if let idMovements = idMovements {
            self.movements = idMovements.compactMap { CachedMovement(idMovement: $0) }.toList()
        }
        
        if let idThemes = idThemes {
            self.themes = idThemes.compactMap { CachedTheme(idTheme: $0) }.toList()
        }
        
        if let idQuotes = idQuotes {
            self.quotes = idQuotes.compactMap { CachedQuote(idQuote: $0) }.toList()
        }
        
        if let idPictures = idPictures {
            self.pictures = idPictures.compactMap { CachedPicture(idPicture: $0) }.toList()
        }
        
        if let idPresentations = idPresentations {
            self.presentations = idPresentations.compactMap { CachedPresentation(idPresentation: $0)
            }.toList()
        }
        
        if let idUrls = idUrls {
            self.urls = idUrls.compactMap { CachedUrl(idUrl: $0)}.toList()
        }
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let favourite = object as? CachedFavourite else {
            return false
        }
        
        return self.idDirectory == favourite.idDirectory &&
            self.idParentDirectory == favourite.idParentDirectory &&
            self.directoryName == favourite.directoryName &&
            self.subDirectories == favourite.subDirectories &&
            self.authors == favourite.authors &&
            self.books == favourite.books &&
            self.movements == favourite.movements &&
            self.themes == favourite.themes &&
            self.quotes == favourite.quotes &&
            self.pictures == favourite.pictures &&
            self.presentations == favourite.presentations &&
            self.urls == favourite.urls
    }
}

extension CachedFavourite {
    
    public func asExternalModel() -> Favourite {
        Favourite(idDirectory: self.idDirectory,
                  idParentDirectory: self.idParentDirectory,
                  directoryName: self.directoryName,
                  subDirectories: !self.subDirectories.isEmpty ? self.subDirectories.toArray().map { $0.asExternalModel() } : nil,
                  authors: !self.authors.isEmpty ? self.authors.toArray().map { $0.asExternalModel() } : nil,
                  books: !self.books.isEmpty ? self.books.toArray().map { $0.asExternalModel() } : nil,
                  movements: !self.movements.isEmpty ? self.movements.toArray().map { $0.asExternalModel() } : nil,
                  themes: !self.themes.isEmpty ? self.themes.toArray().map { $0.asExternalModel() } : nil,
                  quotes: !self.quotes.isEmpty ? self.quotes.toArray().map { $0.asExternalModel() } : nil,
                  pictures: !self.pictures.isEmpty ? self.pictures.toArray().map { $0.asExternalModel() } : nil,
                  presentations: !self.presentations.isEmpty ? self.presentations.toArray().map { $0.asExternalModel() } : nil,
                  urls: !self.urls.isEmpty ? self.urls.toArray().map { $0.asExternalModel() } : nil
        )
    }
}

extension Favourite {
    
    public func asCached() -> CachedFavourite {
        CachedFavourite(idDirectory: self.idDirectory,
                        idParentDirectory: self.idParentDirectory,
                        directoryName: self.directoryName,
                        subDirectories: self.subDirectories != nil ? self.subDirectories!.map { $0.asCached() }.toList()
                            : List<CachedFavourite>(),
                        authors: self.authors != nil ? self.authors!.map { $0.asCached() }.toList() : List<CachedAuthor>(),
                        books: self.books != nil ? self.books!.map { $0.asCached() }.toList() : List<CachedBook>(),
                        movements: self.movements != nil ? self.movements!.map { $0.asCached() }.toList() : List<CachedMovement>(),
                        themes: self.themes != nil ? self.themes!.map { $0.asCached() }.toList() : List<CachedTheme>(),
                        quotes: self.quotes != nil ? self.quotes!.map { $0.asCached() }.toList() : List<CachedQuote>(),
                        pictures: self.pictures != nil ? self.pictures!.map { $0.asCached() }.toList() : List<CachedPicture>(),
                        presentations: self.presentations != nil ? self.presentations!.map { $0.asCached() }.toList() : List<CachedPresentation>(),
                        urls: self.urls != nil ? self.urls!.map { $0.asCached() }.toList() : List<CachedUrl>()
        )
    }
}
