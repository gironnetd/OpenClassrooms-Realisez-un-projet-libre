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
    
    @Persisted(primaryKey: true) public var idTheme: Int
    @Persisted public var idParentTheme: Int?
    @Persisted public var name: String
    @Persisted public var language: CachedLanguage
    @Persisted public var idRelatedThemes: List<Int>
    @Persisted public var presentation: String?
    @Persisted public var sourcePresentation: String?
    @Persisted public var nbQuotes: Int
    @Persisted public var authors: List<CachedAuthor>
    @Persisted public var books: List<CachedBook>
    @Persisted public var themes: List<CachedTheme>
    @Persisted public var pictures: List<CachedPicture>
    @Persisted public var quotes: List<CachedQuote>
    @Persisted public var urls: List<CachedUrl>
    
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
                books: List<CachedBook>,
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
    
    public convenience init?(idTheme: Int) {
        guard let theme = try? Realm().objects(CachedTheme.self).where({ theme in theme.idTheme == idTheme }).first else { return nil }
        
        self.init(idTheme : theme.idTheme,
                  idParentTheme: theme.idParentTheme,
                  name: theme.name,
                  language: theme.language,
                  idRelatedThemes: theme.idRelatedThemes,
                  presentation: theme.presentation,
                  sourcePresentation: theme.sourcePresentation,
                  nbQuotes: theme.nbQuotes,
                  authors: theme.authors,
                  books: theme.books,
                  themes: theme.themes,
                  pictures: theme.pictures,
                  quotes: theme.quotes,
                  urls: theme.urls)
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
              authors : !self.authors.isEmpty ? self.authors.map { author in author.asExternalModel() } : nil,
              books : !self.books.isEmpty ? self.books.map { book in book.asExternalModel() } : nil,
              themes : !self.themes.isEmpty ? self.themes.map { theme in theme.asExternalModel() } : nil,
              pictures : !self.pictures.isEmpty ? self.pictures.map { picture in picture.asExternalModel()} : nil,
              quotes: !self.quotes.isEmpty ? self.quotes.map { quote in quote.asExternalModel() } : nil,
              urls: !self.urls.isEmpty ? self.urls.map { url in url.asExternalModel() } : nil)
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
                    quotes: self.quotes != nil ? self.quotes!.map { quote in quote.asCached()}.toList() : List<CachedQuote>(),
                    urls: self.urls != nil ? self.urls!.map { url in url.asCached()}.toList() : List<CachedUrl>())
    }
}
