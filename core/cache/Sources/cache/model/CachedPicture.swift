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
    
    @Persisted(primaryKey: true) public var idPicture: Int
    @Persisted public var nameSmall: String
    @Persisted public var `extension`: String
    @Persisted public var comments: Map<String, String>
    @Persisted public var width: Int
    @Persisted public var height: Int
    @Persisted public var portrait: Bool
    @Persisted public var picture: Data?
    
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
    
    public convenience init?(idPicture: Int) {
        guard let picture = try? Realm().objects(CachedPicture.self).where({ picture in picture.idPicture == idPicture }).first else { return nil }
        
        self.init(idPicture: picture.idPicture,
                  nameSmall: picture.nameSmall,
                  extension: picture.extension,
                  comments: picture.comments,
                  width: picture.width,
                  height: picture.height,
                  portrait: picture.portrait,
                  picture: picture.picture)
    }
}

extension CachedPicture {
    
    public func asExternalModel() -> Picture {
        Picture(idPicture: self.idPicture,
                nameSmall: self.nameSmall,
                extension: self.`extension`,
                comments: self.comments.count != 0 ? self.comments.toDictionary() : nil,
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
                      comments: self.comments?.toMap() ?? Map<String, String>(),
                      width: self.width,
                      height: self.height,
                      portrait: self.portrait,
                      picture: self.picture)
    }
}

