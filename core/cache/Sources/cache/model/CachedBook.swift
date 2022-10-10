//
//  CachedBook.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a book
 */
public class CachedBook: Object {
    
    @Persisted(primaryKey: true) var idBook: Int
    @Persisted var name: String
    @Persisted var language: CachedLanguage
    @Persisted var idRelatedBooks: List<Int>
    @Persisted var century: CachedCentury?
    @Persisted var details: String?
    @Persisted var period: String?
    @Persisted var idMovement: Int?
    @Persisted var presentation: CachedPresentation?
    @Persisted var mcc1: String?
    @Persisted var quotes: List<CachedQuote>
    @Persisted var pictures: List<CachedPicture>
    @Persisted var urls: List<CachedUrl>
    
    public override init() {}
    
    public init(idBook: Int,
                name: String,
                language: CachedLanguage,
                idRelatedBooks: List<Int>,
                century: CachedCentury? = nil,
                details: String? = nil,
                period: String? = nil,
                idMovement: Int? = nil,
                presentation: CachedPresentation? = nil,
                mcc1: String? = nil,
                quotes: List<CachedQuote>,
                pictures: List<CachedPicture>,
                urls: List<CachedUrl>) {
        super.init()
        self.idBook = idBook
        self.name = name
        self.language = language
        self.idRelatedBooks = idRelatedBooks
        self.century = century
        self.details = details
        self.period = period
        self.idMovement = idMovement
        self.presentation = presentation
        self.mcc1 = mcc1
        self.quotes = quotes
        self.pictures = pictures
        self.urls = urls
    }
}

extension CachedBook {
    
    public func asExternalModel() -> Book {
        Book(idBook:  self.idBook,
             name: self.name,
             language: self.language.rawValue,
             idRelatedBooks: !self.idRelatedBooks.isEmpty ? self.idRelatedBooks.toArray() : nil,
             century: self.century?.asExternalModel(),
             details: self.details,
             period:  self.period,
             idMovement: self.idMovement,
             presentation: self.presentation?.asExternalModel(),
             mcc1: self.mcc1,
             quotes: self.quotes.map { quote in quote.asExternalModel()},
             pictures : !self.pictures.isEmpty ? self.pictures.map { picture in picture.asExternalModel()} : nil,
             urls: !self.urls.isEmpty ? self.urls.map { url in url.asExternalModel()} : nil)
    }
}

extension Book {
    
    public func asCached() -> CachedBook {
        CachedBook(idBook:  self.idBook,
                   name: self.name,
                   language: CachedLanguage(rawValue: self.language) ?? .none,
                   idRelatedBooks: self.idRelatedBooks != nil ? self.idRelatedBooks!.toList() : List<Int>(),
                   century: self.century?.asCached(),
                   details: self.details,
                   period:  self.period,
                   idMovement: self.idMovement,
                   presentation: self.presentation?.asCached(),
                   mcc1: self.mcc1,
                   quotes: self.quotes.map { quote in quote.asCached()}.toList(),
                   pictures : self.pictures != nil ? self.pictures!.map { picture in picture.asCached()}.toList() : List<CachedPicture>(),
                   urls: self.urls != nil ? self.urls!.map { url in url.asCached()}.toList() : List<CachedUrl>())
    }
}

