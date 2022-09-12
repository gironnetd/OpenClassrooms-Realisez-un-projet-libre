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
    
    @Persisted(primaryKey: true) var idDirectory: Int
    @Persisted var idParentDirectory: Int?
    @Persisted var directoryName: String?
    @Persisted var subDirectories: List<CachedFavourite>
    @Persisted var authors: List<CachedAuthor>
    @Persisted var books: List<CachedBook>
    @Persisted var movements: List<CachedMovement>
    @Persisted var themes: List<CachedTheme>
    @Persisted var quotes: List<CachedQuote>
    @Persisted var pictures: List<CachedPicture>
    @Persisted var presentations: List<CachedPresentation>
    @Persisted var urls: List<CachedUrl>

    public init(idDirectory: Int,
                idParentDirectory: Int?,
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
}

extension CachedFavourite {
    
    func asExternalModel() -> Favourite {
        var favorite = Favourite(idDirectory: idDirectory,
                              idParentDirectory: idParentDirectory,
                              directoryName: directoryName)
        
        if !subDirectories.isEmpty {
            favorite.subDirectories = subDirectories.reduce(
                into: [Favourite](), { result, favourite in
                    result.append(favourite.asExternalModel())
            })
        }
        
        if !authors.isEmpty {
            favorite.authors = authors.reduce(
                into: [Author](), { result, author in
                    result.append(author.asExternalModel())
            })
        }

        if !books.isEmpty {
            favorite.books = books.reduce(
                into: [Book](), { result, book in
                    result.append(book.asExternalModel())
            })
        }

        if !movements.isEmpty {
            favorite.movements = movements.reduce(
                into: [Movement](), { result, movement in
                    result.append(movement.asExternalModel())
            })
        }

        if !themes.isEmpty {
            favorite.themes = themes.reduce(
                into: [Theme](), { result, theme in
                    result.append(theme.asExternalModel())
            })
        }

        if !quotes.isEmpty {
            favorite.quotes = quotes.reduce(
                into: [Quote](), { result, quote in
                    result.append(quote.asExternalModel())
            })
        }

        if !pictures.isEmpty {
            favorite.pictures = pictures.reduce(
                into: [Picture](), { result, picture in
                    result.append(picture.asExternalModel())
            })
        }

        if !presentations.isEmpty {
            favorite.presentations = presentations.reduce(
                into: [Presentation](), { result, presentation in
                    result.append(presentation.asExternalModel())
            })
        }

        if !urls.isEmpty {
            favorite.urls = urls.reduce(
                into: [Url](), { result, url in
                    result.append(url.asExternalModel())
            })
        }
        
        return favorite
    }
}
