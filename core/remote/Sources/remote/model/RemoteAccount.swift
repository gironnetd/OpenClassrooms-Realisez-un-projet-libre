//
//  File.swift
//  
//
//  Created by damien on 23/09/2022.
//

import Foundation
import FirebaseAuth

import model
/**
 * Remote Representation for a Account
 */
public struct RemoteAccount: Codable, Equatable  {
    
    public static func == (lhs: RemoteAccount, rhs: RemoteAccount) -> Bool {
         return lhs.uid == rhs.uid &&
                lhs.providerID == rhs.providerID &&
                lhs.email == rhs.email &&
                lhs.displayName == rhs.displayName &&
                lhs.phoneNumber == rhs.phoneNumber &&
                lhs.photo == rhs.photo
    }
    
    public var uid: String
    public var providerID: String
    public var email: String?
    public var displayName: String?
    public var phoneNumber: String?
    public var photo: Data?
    public var favourites: RemoteFavourite?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case providerID
        case email
        case displayName
        case phoneNumber
    }
    
    var dictionary: [String: Any?] {
        return [
            "uid": uid,
            "providerID": providerID,
            "email": email,
            "displayName": displayName,
            "phoneNumber": phoneNumber
        ]
    }
}
