//
//  CachedCentury.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a century
 */
public class CachedCentury: Object {
    
    @Persisted(primaryKey: true) var idCentury: Int
    @Persisted var century: String
    @Persisted var presentations: Map<String, String>

    public override init() {}
    
    public init(idCentury: Int,
                century: String,
                presentations: Map<String, String>) {
        super.init()
        self.idCentury = idCentury
        self.century = century
        self.presentations = presentations
    }
}

extension CachedCentury {
    
    func asExternalModel() -> Century {
        Century(idCentury: idCentury,
                century: century,
                presentations: presentations.count != 0 ? presentations.asKeyValueSequence()
                    .reduce(into: [String: String](), { result, presentation in
                        result[presentation.key] = presentation.value
                    }) : nil)
    }
}
