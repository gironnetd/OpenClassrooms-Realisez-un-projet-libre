//
//  File.swift
//  
//
//  Created by damien on 27/08/2022.
//

import Foundation
import RealmSwift

extension RealmCollection {

    /**
     * Return the RealmCollection into a Swift Array
     */
    func toArray<T>() -> [T] {
        return self.compactMap { $0 as? T}
    }
}
