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
    
    func asExternalModel() -> Book {
        Book(idBook:  idBook,
             name: name,
             language: language.rawValue,
             idRelatedBooks: !idRelatedBooks.isEmpty ? idRelatedBooks.toArray() : nil,
             century: century?.asExternalModel(),
             details: details,
             period:  period,
             idMovement: idMovement,
             presentation: presentation?.asExternalModel(),
             mcc1: mcc1,
             quotes: quotes.map { quote in quote.asExternalModel()},
             pictures : !pictures.isEmpty ? pictures.map { picture in picture.asExternalModel()} : nil,
             urls: !urls.isEmpty ? urls.map { url in url.asExternalModel()} : nil)
    }
}

