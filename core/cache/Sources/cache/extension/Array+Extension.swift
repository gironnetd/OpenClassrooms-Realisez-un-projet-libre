//
//  File.swift
//  
//
//  Created by damien on 09/09/2022.
//

import Foundation
import RealmSwift

extension Array where Element: Object {
    
    /**
     * Return the Array into a RealmList
     */
    func toList() -> List<Element>  {
        let result = List<Element>()
        self.forEach { element in result.append(element) }
        return result
    }
}

extension Array where Element == Int {
    
    /**
     * Return the Array into a RealmList
     */
    func toList() -> List<Element>  {
        let result = List<Element>()
        self.forEach { element in result.append(element) }
        return result
    }
}
