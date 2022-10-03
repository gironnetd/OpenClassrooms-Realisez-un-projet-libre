//
//  File.swift
//  
//
//  Created by damien on 24/09/2022.
//

import Foundation
import FirebaseFirestoreSwift

/**
 * Remote Representation for a Favorite
 */
public class RemoteFavourite: Codable, Equatable {
    
    public static func == (lhs: RemoteFavourite, rhs: RemoteFavourite) -> Bool {
         return lhs.idDirectory == rhs.idDirectory &&
                lhs.uuidAccount == rhs.uuidAccount &&
                lhs.idParentDirectory == rhs.idParentDirectory &&
                lhs.directoryName == rhs.directoryName &&
                lhs.subDirectories == rhs.subDirectories &&
                lhs.authors == rhs.authors &&
                lhs.books == rhs.books &&
                lhs.movements == rhs.movements &&
                lhs.themes == rhs.themes &&
                lhs.quotes == rhs.quotes &&
                lhs.pictures == rhs.pictures &&
                lhs.presentations == rhs.presentations &&
                lhs.urls == rhs.urls
    }
    
    
    var idDirectory: String
    var uuidAccount: String
    var idParentDirectory: String?
    var directoryName: String?
    lazy var subDirectories: [RemoteFavourite] = {
        [RemoteFavourite]()
    }()
    var authors: [Int]?
    var books: [Int]?
    var movements: [Int]?
    var themes: [Int]?
    var quotes: [Int]?
    var pictures: [Int]?
    var presentations: [Int]?
    var urls: [Int]?
    
    init(idDirectory: String,
         uuidAccount: String,
         idParentDirectory: String?,
         directoryName: String?,
         //subDirectories: [RemoteFavourite],
         authors: [Int]?,
         books: [Int]?,
         movements: [Int]?,
         themes: [Int]?,
         quotes: [Int]?,
         pictures: [Int]?,
         presentations: [Int]?,
         urls: [Int]?) {
        self.idDirectory = idDirectory
        self.uuidAccount = uuidAccount
        self.idParentDirectory = idParentDirectory
        self.directoryName = directoryName
        //self.subDirectories = subDirectories
        self.authors = authors
        self.books = books
        self.movements = movements
        self.themes = themes
        self.quotes = quotes
        self.pictures = pictures
        self.presentations = presentations
        self.urls = urls
    }

    enum CodingKeys: String, CodingKey {
        case idDirectory
        case uuidAccount
        case idParentDirectory
        case directoryName
        case authors
        case books
        case movements
        case themes
        case quotes
        case pictures
        case presentations
        case urls
    }
    
    var dictionary: [String: Any?] {
        return [
            "idDirectory": idDirectory,
            "uuidAccount": uuidAccount,
            "idParentDirectory": idParentDirectory,
            "directoryName": directoryName,
            "authors": authors,
            "books": books,
            "movements": movements,
            "themes": themes,
            "quotes": quotes,
            "pictures": pictures,
            "presentations": presentations,
            "urls": urls
        ]
    }
}


