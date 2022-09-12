//
//  File.swift
//  
//
//  Created by damien on 09/09/2022.
//

import Foundation
import RealmSwift

extension Dictionary where Key: _MapKey, Value: RealmCollectionValue {
    
    /**
     * Return the Dictionary into a RealmMap
     */
    func toMap() -> Map<Key, Value> {
        let result = Map<Key, Value>()
        self.forEach { key, value in
            result[key] = value
        }
        return result
    }
}
