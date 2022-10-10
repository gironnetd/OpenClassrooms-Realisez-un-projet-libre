//
//  CachedUrl.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of an url
 */
public class CachedUrl: Object {
    
    @Persisted(primaryKey: true) var idUrl: Int
    @Persisted var sourceType: String
    @Persisted var idSource: Int
    @Persisted var title: String?
    @Persisted var url: String
    @Persisted var presentation: String?
    
    public override init() {}
    
    public init(idUrl: Int,
                sourceType: String,
                idSource: Int,
                title: String? = nil,
                url: String,
                presentation: String? = nil) {
        super.init()
        self.idUrl = idUrl
        self.sourceType = sourceType
        self.idSource = idSource
        self.title = title
        self.url = url
        self.presentation = presentation
    }
}

extension CachedUrl {
    
    public func asExternalModel() -> Url {
        Url(idUrl: self.idUrl,
            sourceType: self.sourceType,
            idSource: self.idSource,
            title: self.title,
            url: self.url,
            presentation: self.presentation)
    }
}

extension Url {
    
    public func asCached() -> CachedUrl {
        CachedUrl(idUrl: self.idUrl,
                  sourceType: self.sourceType,
                  idSource: self.idSource,
                  title: self.title,
                  url: self.url,
                  presentation: self.presentation)
    }
}
