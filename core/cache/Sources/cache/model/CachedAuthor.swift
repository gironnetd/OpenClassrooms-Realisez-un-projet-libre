//
//  CachedAuthor.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of an author
 */
public class CachedAuthor: Object {
    
    @Persisted(primaryKey: true) var idAuthor: Int
    @Persisted var name: String
    @Persisted var language: CachedLanguage
    @Persisted var idRelatedAuthors: List<Int>
    @Persisted var century: CachedCentury?
    @Persisted var surname: String?
    @Persisted var details: String?
    @Persisted var period: String?
    @Persisted var idMovement: Int?
    @Persisted var bibliography: String?
    @Persisted var presentation: CachedPresentation?
    @Persisted var mainPicture: Int?
    @Persisted var mcc1: String?
    @Persisted var quotes: List<CachedQuote>
    @Persisted var pictures: List<CachedPicture>
    @Persisted var urls: List<CachedUrl>
    
    public override init() {}
    
    public init(idAuthor: Int,
                language: CachedLanguage,
                name: String,
                idRelatedAuthors: List<Int>,
                century: CachedCentury? = nil,
                surname: String? = nil,
                details: String? = nil,
                period: String? = nil,
                idMovement: Int? = nil,
                bibliography: String? = nil,
                presentation: CachedPresentation? = nil,
                mainPicture: Int? = nil,
                mcc1: String? = nil,
                quotes: List<CachedQuote>,
                pictures: List<CachedPicture>,
                urls: List<CachedUrl>) {
        super.init()
        self.idAuthor = idAuthor
        self.name = name
        self.language = language
        self.idRelatedAuthors = idRelatedAuthors
        self.century = century
        self.surname = surname
        self.details = details
        self.period = period
        self.idMovement = idMovement
        self.bibliography = bibliography
        self.presentation = presentation
        self.mainPicture = mainPicture
        self.mcc1 = mcc1
        self.quotes = quotes
        self.pictures = pictures
        self.urls = urls
    }
}

extension CachedAuthor {
    
    public func asExternalModel() -> Author {
        Author(idAuthor: self.idAuthor,
               language: self.language.rawValue,
               name: self.name,
               idRelatedAuthors: !self.idRelatedAuthors.isEmpty ? self.idRelatedAuthors.toArray() : nil,
               century: self.century?.asExternalModel(),
               surname: self.surname,
               details: self.details,
               period:  self.period,
               idMovement: self.idMovement,
               bibliography:  self.bibliography,
               presentation: self.presentation?.asExternalModel(),
               mainPicture:  self.mainPicture,
               mcc1:  self.mcc1,
               quotes: self.quotes.map { quote in quote.asExternalModel() },
               pictures : !self.pictures.isEmpty ? self.pictures.map { picture in picture.asExternalModel()} : nil,
               urls: !self.urls.isEmpty ? urls.map { url in url.asExternalModel()} : nil)
    }
}

extension Author {
    
    public func asCached() -> CachedAuthor {
        
        CachedAuthor(idAuthor: self.idAuthor,
                     language: CachedLanguage(rawValue: self.language) ?? .none,
                     name: self.name,
                     idRelatedAuthors: self.idRelatedAuthors != nil ? self.idRelatedAuthors!.toList() : List<Int>(),
                     century: self.century?.asCached(),
                     surname: self.surname,
                     details: self.details,
                     period:  self.period,
                     idMovement: self.idMovement,
                     bibliography:  self.bibliography,
                     presentation: self.presentation?.asCached(),
                     mainPicture:  self.mainPicture,
                     mcc1:  self.mcc1,
                     quotes: self.quotes.map { quote in quote.asCached()}.toList(),
                     pictures : self.pictures != nil ? self.pictures!.map { picture in picture.asCached()}.toList() : List<CachedPicture>(),
                     urls: self.urls != nil ? self.urls!.map { url in url.asCached()}.toList() : List<CachedUrl>()
        )
    }
}



