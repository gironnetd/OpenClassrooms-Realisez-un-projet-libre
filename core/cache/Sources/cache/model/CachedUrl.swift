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
    
    @Persisted(primaryKey: true) public var idUrl: Int
    @Persisted public var sourceType: String
    @Persisted public var idSource: Int
    @Persisted public var title: String?
    @Persisted public var url: String
    @Persisted public var presentation: String?
    
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
    
    public convenience init?(idUrl: Int) {
        guard let url = try? Realm().objects(CachedUrl.self).where({ url in url.idUrl == idUrl }).first else { return nil }
        
        self.init(idUrl: url.idUrl,
                  sourceType: url.sourceType,
                  idSource: url.idSource,
                  title: url.title,
                  url: url.url,
                  presentation: url.presentation)
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
