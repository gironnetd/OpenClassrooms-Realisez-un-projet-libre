//
//  File.swift
//  
//
//  Created by damien on 15/09/2022.
//

import Foundation

public class DataFactory {
    
    public static func randomEmail() -> String {
        let nameLength = randomInt(from: 5, to: 10)
        let domainLength = randomInt(from: 5, to: 10)
        let domainSuffixes = ["com", "net", "org", "io", "co.uk"]
        let name = randomText(length: nameLength, justLowerCase: true)
        let domain = randomText(length: domainLength, justLowerCase: true)
        let randomDomainSuffixIndex = Int(arc4random_uniform(UInt32(domainSuffixes.count)))
        let domainSuffix = domainSuffixes[randomDomainSuffixIndex]
        let text = name + "@" + domain + "." + domainSuffix
        return text
    }
    
    private static func randomInt(from: Int, to: Int) -> Int {
        let range = UInt32(to - from)
        let rndInt = Int(arc4random_uniform(range + 1)) + from
        return rndInt
    }
    
    private static func randomText(length: Int, justLowerCase: Bool = false) -> String {
        var text = ""
        for _ in 1...length {
            var decValue = 0  // ascii decimal value of a character
            var charType = 3  // default is lowercase
            if justLowerCase == false {
                // randomize the character type
                charType =  Int(arc4random_uniform(4))
            }
            switch charType {
            case 1:  // digit: random Int between 48 and 57
                decValue = Int(arc4random_uniform(10)) + 48
            case 2:  // uppercase letter
                decValue = Int(arc4random_uniform(26)) + 65
            case 3:  // lowercase letter
                decValue = Int(arc4random_uniform(26)) + 97
            default:  // space character
                decValue = 32
            }
            // get ASCII character from random decimal value
            let char = String(UnicodeScalar(decValue)!)
            text = text + char
            // remove double spaces
            text = text.replacingOccurrences(of: "  ", with: " ")
        }
        return text
    }
    
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
}
