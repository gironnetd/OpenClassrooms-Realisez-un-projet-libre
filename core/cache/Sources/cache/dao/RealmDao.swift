//
//  File.swift
//  
//
//  Created by damien on 10/10/2022.
//

import Foundation
import RealmSwift

public protocol RealmDao {}

extension RealmDao {
    
    internal var realm : Realm  {
        try! Realm()
    }
}
