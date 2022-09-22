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
    
    func asExternalModel() -> Theme {
        Theme(idTheme : idTheme,
              idParentTheme: idParentTheme,
              name: name,
              language: language.rawValue,
              idRelatedThemes: !idRelatedThemes.isEmpty ? idRelatedThemes.toArray() : nil,
              presentation: presentation,
              sourcePresentation: sourcePresentation,
              nbQuotes : nbQuotes,
              authors : !authors.isEmpty ? authors.map { author in author.asExternalModel()} : nil,
              books : !books.isEmpty ? books.map { book in book.asExternalModel()} : nil,
              themes : !themes.isEmpty ? themes.map { theme in theme.asExternalModel()} : nil,
              pictures : !pictures.isEmpty ? pictures.map { picture in picture.asExternalModel()} : nil,
              quotes: quotes.map { quote in quote.asExternalModel()},
              urls: !urls.isEmpty ? urls.map { url in url.asExternalModel()} : nil)
    }
}
