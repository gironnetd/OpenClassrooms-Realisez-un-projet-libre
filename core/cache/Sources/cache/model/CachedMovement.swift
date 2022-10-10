//
//  CachedMovement.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a movement
 */
public class CachedMovement: Object {
    
    @Persisted(primaryKey: true) var idMovement: Int
    @Persisted var idParentMovement: Int?
    @Persisted var name: String
    @Persisted var language: CachedLanguage
    @Persisted var idRelatedMovements: List<Int>
    @Persisted var mcc1: String?
    @Persisted var mcc2: String?
    @Persisted var presentation: CachedPresentation?
    @Persisted var mcc3: String?
    @Persisted var nbQuotes: Int
    @Persisted var nbAuthors: Int
    @Persisted var nbAuthorsQuotes: Int
    @Persisted var nbBooks: Int
    @Persisted var nbBooksQuotes: Int
    @Persisted var selected: Bool = false
    @Persisted var nbTotalQuotes: Int
    @Persisted var nbTotalAuthors: Int
    @Persisted var nbTotalBooks: Int
    @Persisted var nbSubcourants: Int
    @Persisted var nbAuthorsSubcourants: Int
    @Persisted var nbBooksSubcourants: Int
    @Persisted var authors: List<CachedAuthor>
    @Persisted var books: List<CachedBook>
    @Persisted var movements: List<CachedMovement>
    @Persisted var pictures: List<CachedPicture>
    @Persisted var urls: List<CachedUrl>
    
    public override init() {}
    
    public init(idMovement : Int,
                idParentMovement: Int? = nil,
                name: String,
                language: CachedLanguage,
                idRelatedMovements: List<Int>,
                mcc1: String? = nil,
                mcc2: String? = nil,
                presentation: CachedPresentation? = nil,
                mcc3: String? = nil,
                nbQuotes: Int? = nil,
                nbAuthors: Int? = nil,
                nbAuthorsQuotes: Int? = nil,
                nbBooks: Int? = nil,
                nbBooksQuotes: Int? = nil,
                selected: Bool = false,
                nbTotalQuotes: Int? = nil,
                nbTotalAuthors: Int? = nil,
                nbTotalBooks: Int? = nil,
                nbSubcourants: Int? = nil,
                nbAuthorsSubcourants: Int? = nil,
                nbBooksSubcourants : Int? = nil,
                authors: List<CachedAuthor>,
                books: List<CachedBook>,
                movements: List<CachedMovement>,
                pictures: List<CachedPicture>,
                urls: List<CachedUrl>) {
        super.init()
        self.idMovement = idMovement
        self.idParentMovement = idParentMovement
        self.name = name
        self.language = language
        self.idRelatedMovements = idRelatedMovements
        self.mcc1 = mcc1
        self.mcc2 = mcc2
        self.presentation = presentation
        self.mcc3 = mcc3
        self.nbQuotes = nbQuotes ?? 0
        self.nbAuthors = nbAuthors ?? 0
        self.nbAuthorsQuotes = nbAuthorsQuotes ?? 0
        self.nbBooks = nbBooks ?? 0
        self.nbBooksQuotes = nbBooksQuotes ?? 0
        self.selected = selected
        self.nbTotalQuotes = nbTotalQuotes ?? 0
        self.nbTotalAuthors = nbTotalAuthors ?? 0
        self.nbTotalBooks = nbTotalBooks ?? 0
        self.nbSubcourants = nbSubcourants ?? 0
        self.nbAuthorsSubcourants = nbAuthorsSubcourants ?? 0
        self.nbBooksSubcourants = nbBooksSubcourants ?? 0
        self.authors = authors
        self.books = books
        self.movements = movements
        self.pictures = pictures
        self.urls = urls
    }
}

extension CachedMovement {
    
    public func asExternalModel() -> Movement {
        Movement(idMovement : self.idMovement,
                 idParentMovement: self.idParentMovement,
                 name: self.name,
                 language: self.language.rawValue,
                 idRelatedMovements: !self.idRelatedMovements.isEmpty ? self.idRelatedMovements.toArray() : nil,
                 mcc1: self.mcc1,
                 mcc2: self.mcc2,
                 presentation: self.presentation?.asExternalModel(),
                 mcc3: self.mcc3,
                 nbQuotes: self.nbQuotes,
                 nbAuthors: self.nbAuthors,
                 nbAuthorsQuotes: self.nbAuthorsQuotes,
                 nbBooks: self.nbBooks,
                 nbBooksQuotes: self.nbBooksQuotes,
                 selected: self.selected,
                 nbTotalQuotes: self.nbTotalQuotes,
                 nbTotalAuthors: self.nbTotalAuthors,
                 nbTotalBooks: self.nbTotalBooks,
                 nbSubcourants: self.nbSubcourants,
                 nbAuthorsSubcourants: self.nbAuthorsSubcourants,
                 nbBooksSubcourants : self.nbBooksSubcourants,
                 authors : !self.authors.isEmpty ? self.authors.map { author in author.asExternalModel()} : nil,
                 books : !self.books.isEmpty ? self.books.map { book in book.asExternalModel()} : nil,
                 movements : !self.movements.isEmpty ? self.movements.map { movement in movement.asExternalModel()} : nil,
                 pictures : !self.pictures.isEmpty ? self.pictures.map { picture in picture.asExternalModel()} : nil,
                 urls: !self.urls.isEmpty ? self.urls.map { url in url.asExternalModel()} : nil)
    }
}

extension Movement {
    
    public func asCached() -> CachedMovement {
        
        CachedMovement(idMovement : self.idMovement,
                       idParentMovement: self.idParentMovement,
                       name: self.name,
                       language: CachedLanguage(rawValue: self.language) ?? .none,
                       idRelatedMovements: self.idRelatedMovements != nil ? self.idRelatedMovements!.toList() : List<Int>(),
                       mcc1: self.mcc1,
                       mcc2: self.mcc2,
                       presentation: self.presentation?.asCached(),
                       mcc3: self.mcc3,
                       nbQuotes: self.nbQuotes,
                       nbAuthors: self.nbAuthors,
                       nbAuthorsQuotes: self.nbAuthorsQuotes,
                       nbBooks: self.nbBooks,
                       nbBooksQuotes: self.nbBooksQuotes,
                       selected: self.selected,
                       nbTotalQuotes: self.nbTotalQuotes,
                       nbTotalAuthors: self.nbTotalAuthors,
                       nbTotalBooks: self.nbTotalBooks,
                       nbSubcourants: self.nbSubcourants,
                       nbAuthorsSubcourants: self.nbAuthorsSubcourants,
                       nbBooksSubcourants : self.nbBooksSubcourants,
                       authors : self.authors != nil ? self.authors!.map { author in author.asCached()}.toList() : List<CachedAuthor>(),
                       books : self.books != nil ? self.books!.map { book in book.asCached()}.toList() : List<CachedBook>(),
                       movements : self.movements != nil ? self.movements!.map { movement in movement.asCached()}.toList() : List<CachedMovement>(),
                       pictures : self.pictures != nil ? self.pictures!.map { picture in picture.asCached()}.toList() : List<CachedPicture>(),
                       urls: self.urls != nil ? self.urls!.map { url in url.asCached()}.toList() : List<CachedUrl>())
    }
}

