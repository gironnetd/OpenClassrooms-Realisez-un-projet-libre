//
//  Book.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

/**
 * Representation for a Book fetched from an external layer data source
 */
public struct Book : Equatable {
    
    public var idBook: Int
    public var name: String
    public var language: String
    public var idRelatedBooks: [Int]?
    public var century: Century?
    public var surname: String?
    public var details: String?
    public var period: String?
    public var idMovement: Int?
    public var bibliographie: String?
    public var presentation: Presentation?
    public var mainPicture: Int?
    public var mcc1: String?
    public var quotes: [Quote]
    public var pictures: [Picture]?
    public var urls: [Url]?
    
    public init(idBook: Int,
                name: String,
                language: String,
                idRelatedBooks: [Int]? = nil,
                century: Century? = nil,
                details: String? = nil,
                period: String? = nil,
                idMovement: Int? = nil,
                presentation: Presentation? = nil,
                mcc1: String? = nil,
                quotes: [Quote],
                pictures: [Picture]? = nil,
                urls: [Url]? = nil) {
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
