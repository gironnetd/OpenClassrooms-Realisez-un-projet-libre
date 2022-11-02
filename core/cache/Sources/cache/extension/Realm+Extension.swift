//
//  File.swift
//  
//
//  Created by damien on 18/10/2022.
//

import Foundation
import RealmSwift

extension Array where Element: Object {
    
    /**
     * Return the Array into a RealmList
     */
    public func toList() -> List<Element>  {
        let result = List<Element>()
        self.forEach { element in result.append(element) }
        return result
    }
}

extension Array where Element == Int {
    
    /**
     * Return the Array into a RealmList
     */
    public func toList() -> List<Element>  {
        let result = List<Element>()
        self.forEach { element in result.append(element) }
        return result
    }
}

extension Dictionary where Key: _MapKey, Value: RealmCollectionValue {
    
    /**
     * Return the Dictionary into a RealmMap
     */
    public func toMap() -> Map<Key, Value> {
        let result = Map<Key, Value>()
        self.forEach { key, value in
            result[key] = value
        }
        
        return result
    }
}

extension Map where Key: _MapKey, Value: RealmCollectionValue {
    
    /**
     * Return the RealmMap into a Dictionary
     */
    public func toDictionary() -> Dictionary<Key, Value> {
        var result: [Key : Value] = [:]
        
        self.forEach { element in  result[element.key] = element.value }
        return result
    }
}

extension RealmCollection where Element: Object {

    /**
     * Return the RealmCollection into a Swift Array
     */
    public func toArray() -> [Element] {
        return self.compactMap { $0 }
    }
}

extension RealmCollection where Element == Int {

    /**
     * Return the RealmCollection into a Swift Array
     */
    public func toArray() -> [Element] {
        return self.compactMap { $0 }
    }
}
