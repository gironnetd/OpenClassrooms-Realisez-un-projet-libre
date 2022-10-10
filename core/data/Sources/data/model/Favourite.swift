//
//  File.swift
//  
//
//  Created by damien on 04/10/2022.
//

import Foundation
import cache
import remote
import RealmSwift

extension RemoteFavourite {
    
    func asCached() -> CachedFavourite {
        CachedFavourite(idDirectory: self.idDirectory,
                        idParentDirectory: self.idParentDirectory,
                        directoryName: self.directoryName,
                        subDirectories: !self.subDirectories.isEmpty ? self.subDirectories.reduce(
                            into: [CachedFavourite](), { result, favourite in
                                result.append(favourite.asCached())
                            }
                        ) : nil,
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
