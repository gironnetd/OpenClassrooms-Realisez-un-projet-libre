//
//  File.swift
//  
//
//  Created by damien on 04/10/2022.
//

import Foundation
import cache
import remote
import model
import RealmSwift

extension RemoteFavourite {
    
    public func asCached() -> CachedFavourite {
        CachedFavourite(idDirectory: self.idDirectory,
                        idParentDirectory: self.idParentDirectory,
                        directoryName: self.directoryName,
                        subDirectories: self.subDirectories != nil && !self.subDirectories!.isEmpty ? self.subDirectories!.map { $0.asCached() } : nil,
                        idAuthors: self.idAuthors,
                        idBooks: self.idBooks,
                        idMovements: self.idMovements,
                        idThemes: self.idThemes,
                        idQuotes: self.idQuotes,
                        idPictures: self.idPictures,
                        idPresentations: self.idPresentations,
                        idUrls: self.idUrls)
    }
}

extension Favourite {
    
    public func toRemote() -> RemoteFavourite {

        let favourite = RemoteFavourite(idDirectory: self.idDirectory,
                        uidUser: "",
                        idParentDirectory: self.idParentDirectory,
                        directoryName: self.directoryName,
                        idAuthors: nil,
                        idBooks: nil,
                        idMovements: nil,
                        idThemes: nil,
                        idQuotes: nil,
                        idPictures: nil,
                        idPresentations: nil,
                        idUrls: nil)
        
        if let authors = self.authors {
            favourite.idAuthors = authors.map { $0.idAuthor }
        }
        
        if let books = self.books {
            favourite.idBooks = books.map { $0.idBook }
        }
        
        if let movements = self.movements {
            favourite.idMovements = movements.map { $0.idMovement }
        }
        
        if let themes = self.themes {
            favourite.idThemes = themes.map { $0.idTheme }
        }
        
        if let quotes = self.quotes {
            favourite.idQuotes = quotes.map { $0.idQuote }
        }
        
        if let presentations = self.presentations {
            favourite.idPresentations = presentations.map { $0.idPresentation }
        }
        
        if let pictures = self.pictures {
            favourite.idPictures = pictures.map { $0.idPicture }
        }
        
        if let urls = self.urls {
            favourite.idUrls = urls.map { $0.idUrl }
        }
        
        return favourite
    }
}
