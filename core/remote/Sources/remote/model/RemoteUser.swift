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
 * Remote Representation for a User
 */
public struct RemoteUser: Codable, Equatable {
    
    public var uid: String
    public var providerID: String
    public var email: String?
    public var displayName: String?
    public var phoneNumber: String?
    public var photo: Data?
    public var favourites: RemoteFavourite?
    
    public init(uid: String,
                providerID: String,
                email: String?,
                displayName: String?,
                phoneNumber: String?,
                photo: Data?,
                favourites: RemoteFavourite?) {
        self.uid = uid
        self.providerID = providerID
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.photo = photo
        self.favourites = favourites
    }
    
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
    
    public static func == (lhs: RemoteUser, rhs: RemoteUser) -> Bool {
         return lhs.uid == rhs.uid &&
                lhs.providerID == rhs.providerID &&
                lhs.email == rhs.email &&
                lhs.displayName == rhs.displayName &&
                lhs.phoneNumber == rhs.phoneNumber
    }
}
