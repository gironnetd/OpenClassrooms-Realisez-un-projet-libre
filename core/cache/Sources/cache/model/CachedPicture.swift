//
//  CachedPicture.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a picture
 */
public class CachedPicture: Object {
    
    @Persisted(primaryKey: true) var idPicture: Int
    @Persisted var nameSmall: String
    @Persisted var `extension`: String
    @Persisted var comments: Map<String, String>
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var portrait: Bool
    @Persisted var picture: Data?
    
    public override init() {}
    
    public init(idPicture: Int,
                nameSmall: String,
                `extension`: String,
                comments: Map<String, String>,
                width: Int,
                height: Int,
                portrait: Bool = false,
                picture: Data? = nil) {
        super.init()
        self.idPicture = idPicture
        self.nameSmall = nameSmall
        self.extension = `extension`
        self.comments = comments
        self.width = width
        self.height = height
        self.portrait = portrait
        self.picture = picture
    }
}

extension CachedPicture {
    
    public func asExternalModel() -> Picture {
        Picture(idPicture: self.idPicture,
                nameSmall: self.nameSmall,
                extension: self.`extension`,
                comments: self.comments.count != 0 ? self.comments.asKeyValueSequence()
                    .reduce(into: [String: String](), { result, comment in
                        result[comment.key] = comment.value
                    }) : nil,
                width: self.width,
                height: self.height,
                portrait: self.portrait,
                picture: self.picture)
    }
}

extension Picture {
    
    public func asCached() -> CachedPicture {
        CachedPicture(idPicture: self.idPicture,
                      nameSmall: self.nameSmall,
                      extension: self.`extension`,
                      comments: self.comments?.reduce(into: Map<String, String>(), { result, comment in
                        result[comment.key] = comment.value
                      }) ?? Map<String, String>(),
                      width: self.width,
                      height: self.height,
                      portrait: self.portrait,
                      picture: self.picture)
    }
}

