//
//  Favorite.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

/**
 * Representation for a Favorite fetched from an external layer data source
 */
public struct Favourite : Equatable {
    
    public var idDirectory: String
    public var idParentDirectory: String?
    public var directoryName: String?
    public var subDirectories: [Favourite]?
    public var authors: [Author]?
    public var books: [Book]?
    public var movements: [Movement]?
    public var themes: [Theme]?
    public var quotes: [Quote]?
    public var pictures: [Picture]?
    public var presentations: [Presentation]?
    public var urls: [Url]?
    
    public init(idDirectory: String,
                idParentDirectory: String? = nil,
                directoryName: String?,
                subDirectories: [Favourite]? = nil,
                authors: [Author]? = nil,
                books: [Book]? = nil,
                movements: [Movement]? = nil,
                themes: [Theme]? = nil,
                quotes: [Quote]? = nil,
                pictures: [Picture]? = nil,
                presentations: [Presentation]? = nil,
                urls: [Url]? = nil) {
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
