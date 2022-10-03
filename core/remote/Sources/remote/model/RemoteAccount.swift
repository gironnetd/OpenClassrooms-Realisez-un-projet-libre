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
struct RemoteAccount: Codable, Equatable  {
    
    static func == (lhs: RemoteAccount, rhs: RemoteAccount) -> Bool {
         return lhs.uid == rhs.uid &&
                lhs.providerID == rhs.providerID &&
                lhs.email == rhs.email &&
                lhs.displayName == rhs.displayName &&
                lhs.phoneNumber == rhs.phoneNumber &&
                lhs.photo == rhs.photo
    }
    
    var uid: String
    var providerID: String
    var email: String?
    var displayName: String?
    var phoneNumber: String?
    var photo: Data?
    var favourites: RemoteFavourite?
    
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
