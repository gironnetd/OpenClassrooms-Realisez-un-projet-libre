//
//  CachedTheme.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a theme
 */
public class CachedTheme: Object {
    
    @Persisted(primaryKey: true) var idTheme: Int
    @Persisted var idParentTheme: Int?
    @Persisted var name: String
    @Persisted var language: CachedLanguage
    @Persisted var idRelatedThemes: List<Int>
    @Persisted var presentation: String?
    @Persisted var sourcePresentation: String?
    @Persisted var nbQuotes: Int
    @Persisted var authors: List<CachedAuthor>
    @Persisted var books: List<CachedBook>
    @Persisted var themes: List<CachedTheme>
    @Persisted var pictures: List<CachedPicture>
    @Persisted var quotes: List<CachedQuote>
    @Persisted var urls: List<CachedUrl>
    
    public override init() {}
    
    public init(idTheme : Int,
                idParentTheme: Int? = nil,
                name: String,
                language: CachedLanguage,
                idRelatedThemes: List<Int>,
                presentation: String? = nil,
                sourcePresentation: String? = nil,
                nbQuotes: Int = 0,
                authors: List<CachedAuthor>,
                books : List<CachedBook>,
                themes: List<CachedTheme>,
                pictures: List<CachedPicture>,
                quotes: List<CachedQuote>,
                urls: List<CachedUrl>) {
        super.init()
        self.idTheme = idTheme
        self.idParentTheme = idParentTheme
        self.name = name
        self.language = language
        self.idRelatedThemes = idRelatedThemes
        self.presentation = presentation
        self.sourcePresentation = sourcePresentation
        self.nbQuotes = nbQuotes
        self.authors = authors
        self.books = books
        self.themes = themes
        self.pictures = pictures
        self.quotes = quotes
        self.urls = urls
    }
}

extension CachedTheme {
    
    public func asExternalModel() -> Theme {
        Theme(idTheme : self.idTheme,
              idParentTheme: self.idParentTheme,
              name: self.name,
              language: self.language.rawValue,
              idRelatedThemes: !self.idRelatedThemes.isEmpty ? self.idRelatedThemes.toArray() : nil,
              presentation: self.presentation,
              sourcePresentation: self.sourcePresentation,
              nbQuotes : self.nbQuotes,
              authors : !self.authors.isEmpty ? self.authors.map { author in author.asExternalModel()} : nil,
              books : !self.books.isEmpty ? self.books.map { book in book.asExternalModel()} : nil,
              themes : !self.themes.isEmpty ? self.themes.map { theme in theme.asExternalModel()} : nil,
              pictures : !self.pictures.isEmpty ? self.pictures.map { picture in picture.asExternalModel()} : nil,
              quotes: self.quotes.map { quote in quote.asExternalModel()},
              urls: !self.urls.isEmpty ? self.urls.map { url in url.asExternalModel()} : nil)
    }
}

extension Theme {
    
    public func asCached() -> CachedTheme {
        CachedTheme(idTheme : self.idTheme,
                    idParentTheme: self.idParentTheme,
                    name: self.name,
                    language: CachedLanguage(rawValue: self.language) ?? .none,
                    idRelatedThemes: self.idRelatedThemes != nil ? self.idRelatedThemes!.toList() : List<Int>(),
                    presentation: self.presentation,
                    sourcePresentation: self.sourcePresentation,
                    nbQuotes : self.nbQuotes,
                    authors : self.authors != nil ? self.authors!.map { author in author.asCached()}.toList() : List<CachedAuthor>(),
                    books : self.books != nil ? self.books!.map { book in book.asCached()}.toList() : List<CachedBook>(),
                    themes : self.themes != nil ? self.themes!.map { theme in theme.asCached()}.toList() : List<CachedTheme>(),
                    pictures : self.pictures != nil ? self.pictures!.map { picture in picture.asCached()}.toList() : List<CachedPicture>(),
                    quotes: self.quotes!.map { quote in quote.asCached()}.toList(),
                    urls: self.urls != nil ? self.urls!.map { url in url.asCached()}.toList() : List<CachedUrl>())
    }
}
