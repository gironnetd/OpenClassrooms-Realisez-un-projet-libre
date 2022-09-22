//
//  File.swift
//  
//
//  Created by damien on 15/09/2022.
//

import Foundation

public class DataFactory {
    
    public static func randomInt() -> Int {
        return Int.random(in: 0...Int.max)
    }
    
    public static func randomLong() -> UInt64 {
        return UInt64(randomInt())
    }
    
    public static func randomString() -> String {
        return UUID().uuidString
    }
    
    public static func randomBoolean() -> Bool {
        return Bool.random()
    }
    
    public static func makeStringList(count: Int) -> [String] {
        
        var items =  [String]()
        for _ in 0 ... count {
            items.append(randomString())
        }
        return items
    }
}
