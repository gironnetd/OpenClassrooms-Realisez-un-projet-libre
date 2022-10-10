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
                lhs.uidAccount == rhs.uidAccount &&
                lhs.idParentDirectory == rhs.idParentDirectory &&
                lhs.directoryName == rhs.directoryName &&
                lhs.subDirectories == rhs.subDirectories &&
                lhs.idAuthors == rhs.idAuthors &&
                lhs.idBooks == rhs.idBooks &&
                lhs.idMovements == rhs.idMovements &&
                lhs.idThemes == rhs.idThemes &&
                lhs.idQuotes == rhs.idQuotes &&
                lhs.idPictures == rhs.idPictures &&
                lhs.idPresentations == rhs.idPresentations &&
                lhs.idUrls == rhs.idUrls
    }
    
    public var idDirectory: String
    public var uidAccount: String
    public var idParentDirectory: String?
    public var directoryName: String?
    public lazy var subDirectories: [RemoteFavourite] = {
        [RemoteFavourite]()
    }()
    public var idAuthors: [Int]?
    public var idBooks: [Int]?
    public var idMovements: [Int]?
    public var idThemes: [Int]?
    public var idQuotes: [Int]?
    public var idPictures: [Int]?
    public var idPresentations: [Int]?
    public var idUrls: [Int]?
    
    init(idDirectory: String,
         uidAccount: String,
         idParentDirectory: String?,
         directoryName: String?,
         idAuthors: [Int]?,
         idBooks: [Int]?,
         idMovements: [Int]?,
         idThemes: [Int]?,
         idQuotes: [Int]?,
         idPictures: [Int]?,
         idPresentations: [Int]?,
         idUrls: [Int]?) {
        self.idDirectory = idDirectory
        self.uidAccount = uidAccount
        self.idParentDirectory = idParentDirectory
        self.directoryName = directoryName
        self.idAuthors = idAuthors
        self.idBooks = idBooks
        self.idMovements = idMovements
        self.idThemes = idThemes
        self.idQuotes = idQuotes
        self.idPictures = idPictures
        self.idPresentations = idPresentations
        self.idUrls = idUrls
    }

    enum CodingKeys: String, CodingKey {
        case idDirectory
        case uidAccount
        case idParentDirectory
        case directoryName
        case idAuthors
        case idBooks
        case idMovements
        case idThemes
        case idQuotes
        case idPictures
        case idPresentations
        case idUrls
    }
    
    var dictionary: [String: Any?] {
        return [
            "idDirectory": idDirectory,
            "uidAccount": uidAccount,
            "idParentDirectory": idParentDirectory,
            "directoryName": directoryName,
            "idAuthors": idAuthors,
            "idBooks": idBooks,
            "idMovements": idMovements,
            "idThemes": idThemes,
            "idQuotes": idQuotes,
            "idPictures": idPictures,
            "idPresentations": idPresentations,
            "idUrls": idUrls
        ]
    }
}


